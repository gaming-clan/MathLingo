import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../models/child_profile.dart';
import '../services/firebase_init_service.dart';
import 'firestore_schema.dart';

/// Shërbimi i sinkronizimit të të dhënave me Firestore.
///
/// Zbaton strategjinë "last-write-wins" për përthjeshtësi.
/// Operacionet janë "fire-and-forget" nga pikëpamja e UI-t — gabimet regjistrohen
/// dhe injnorohen me heshtje për të mos ndikuar në eksperiencën e fëmijës.
///
/// Rregull: `_canSync()` duhet të kthehet `true` para çdo shkrim/lexim.
class SyncService {
  SyncService(this._ref);

  final Ref _ref;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Guard ───────────────────────────────────────────────────────────────

  bool _canSync() =>
      FirebaseInitService.isInitialized &&
      _ref.read(authProvider) is AuthStateAuthenticated;

  String? _currentUid() {
    final state = _ref.read(authProvider);
    return state is AuthStateAuthenticated ? state.account.uid : null;
  }

  // ─── Shkrim ──────────────────────────────────────────────────────────────

  /// Sinkronizon info bazë të fëmijës (pseudonim + avatar).
  Future<void> syncChildInfo(ChildProfile child) async {
    if (!_canSync()) return;
    final uid = _currentUid()!;
    try {
      await _db.doc(FirestoreSchema.childInfoDoc(uid, child.id)).set(
        {
          FirestoreSchema.pseudonym: child.pseudonym,
          FirestoreSchema.avatarIndex: child.avatarIndex,
          FirestoreSchema.lastSyncAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      debugPrint('[Sync] Info fëmijës u sinkronizua: ${child.id}');
    } catch (e) {
      debugPrint('[Sync] Gabim syncChildInfo: $e');
    }
  }

  /// Sinkronizon progresin e fëmijës për ditën e sotme.
  Future<void> syncChildProgress(ChildProfile child) async {
    if (!_canSync()) return;
    final uid = _currentUid()!;
    final today = _todayKey();
    try {
      await _db
          .doc(FirestoreSchema.progressDoc(uid, child.id, today))
          .set(
        {
          FirestoreSchema.totalPoints: child.totalPoints,
          FirestoreSchema.accuracy: child.totalAccuracy,
          FirestoreSchema.completedSessions: child.completedSessions,
          FirestoreSchema.moduleScores: child.moduleHistory,
          FirestoreSchema.lastSyncAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      debugPrint('[Sync] Progresi u sinkronizua: ${child.id} ($today)');
    } catch (e) {
      debugPrint('[Sync] Gabim syncChildProgress: $e');
    }
  }

  /// Grumbullon statistikat ditore me Atomic Increment (Daily Aggregate Pattern).
  ///
  /// Thirrja është "fire-and-forget": djeshtësimi i rrjetit nuk bllokon lojën.
  /// Përdor [FieldValue.increment] për pikët dhe numrin e sesioneve,
  /// duke garantuar saktësi edhe me përdorim njëkohësisht nga pajëbi të ndryshme.
  ///
  /// Formula e saktësisë progresive:
  /// `avgNew = ((avgOld * oldSessions) + newAccuracy) / (oldSessions + 1)`
  /// Kjo llogaritet në server-side me transaction nëse nevojitet,
  /// por për thjeshtësi uështruesi kalkulon në app pas leximit atomik.
  Future<void> updateDailyStats({
    required ChildProfile child,
    required int sessionPoints,
    required double sessionAccuracy,
    String? moduleKey,
  }) async {
    if (!_canSync()) return;
    final uid = _currentUid()!;
    final today = _todayKey();
    final docRef = _db.doc(
      FirestoreSchema.dailyStatsDoc(uid, child.id, today),
    );

    try {
      await _db.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        final data = snap.exists ? snap.data()! : <String, dynamic>{};

        final oldSessions = (data[FirestoreSchema.dailySessionsCount] as int?) ?? 0;
        final oldAvg = (data[FirestoreSchema.dailyAvgAccuracy] as num?)?.toDouble() ?? 0.0;

        // Saktësia progresive — nuk kërkon lexim shtesë
        final newAvg = oldSessions == 0
            ? sessionAccuracy
            : ((oldAvg * oldSessions) + sessionAccuracy) / (oldSessions + 1);

        // Ndërtojmë payload-in
        final Map<String, dynamic> payload = {
          FirestoreSchema.date: today,
          FirestoreSchema.dailyTotalPoints: FieldValue.increment(sessionPoints),
          FirestoreSchema.dailySessionsCount: FieldValue.increment(1),
          FirestoreSchema.dailyAvgAccuracy: double.parse(newAvg.toStringAsFixed(4)),
          FirestoreSchema.dailyLastUpdate: FieldValue.serverTimestamp(),
        };

        // Breakdown sipas modulit (opsionale)
        if (moduleKey != null) {
          payload['${FirestoreSchema.dailyModules}.$moduleKey'] =
              FieldValue.increment(sessionPoints);
        }

        tx.set(docRef, payload, SetOptions(merge: true));
      });
      debugPrint('[Sync] DailyStats u përditësua: ${child.id} ($today) +$sessionPoints pts');
    } catch (e) {
      debugPrint('[Sync] Gabim updateDailyStats: $e');
      // Fire-and-forget: gabimi nuk propagohet tek caller
    }
  }

  // ─── Lexim ───────────────────────────────────────────────────────────────

  /// Tërheq të dhënat nga cloud (last-write-wins).
  /// Kthehet null nëse nuk gjenden të dhëna ose nëse ndodh gabim.
  Future<Map<String, dynamic>?> pullChildInfo(String childId) async {
    if (!_canSync()) return null;
    final uid = _currentUid()!;
    try {
      final snap =
          await _db.doc(FirestoreSchema.childInfoDoc(uid, childId)).get();
      return snap.exists ? snap.data() : null;
    } catch (e) {
      debugPrint('[Sync] Gabim pullChildInfo: $e');
      return null;
    }
  }

  /// Tërheq agregatin ditor për 7 ditët e fundit.
  ///
  /// Query-i renditet sipas datës zbritëse dhe kufizon në 7 dokumente.
  /// Kthehet lista boshe nëse nuk ka të dhëna ose ndodh gabim rrjeti.
  Future<List<Map<String, dynamic>>> pullWeeklyStats(String childId) async {
    if (!_canSync()) return [];
    final uid = _currentUid()!;
    try {
      final snap = await _db
          .collection(FirestoreSchema.dailyStatsCollection(uid, childId))
          .orderBy(FirestoreSchema.date, descending: true)
          .limit(7)
          .get();
      return snap.docs.map((d) => d.data()).toList();
    } catch (e) {
      debugPrint('[Sync] Gabim pullWeeklyStats: $e');
      return [];
    }
  }

  // ─── Fshirje GDPR ────────────────────────────────────────────────────────

  /// Fshin të gjitha të dhënat e përdoruesit nga Firestore.
  ///
  /// Zbaton GDPR Nenin 17 — e drejta e fshirjes.
  /// Thirrësi duhet të fshijë llogarinë Firebase Auth veçmas nëpërmjet AuthService.
  Future<void> deleteAllUserData(String uid) async {
    if (!FirebaseInitService.isInitialized) return;
    try {
      // Gjej të gjithë fëmijët e këtij prindi
      final childrenSnap = await _db
          .collection('${FirestoreSchema.users}/$uid/${FirestoreSchema.children}')
          .get();

      for (final childDoc in childrenSnap.docs) {
        final childId = childDoc.id;
        // Fshi daily_stats të çdo fëmijëe
        final dailyStatsSnap = await _db
            .collection(FirestoreSchema.dailyStatsCollection(uid, childId))
            .get();
        for (final ds in dailyStatsSnap.docs) {
          await ds.reference.delete();
        }
        // Fshi progresin e çdo fëmijës
        final progressSnap = await _db
            .collection(
                '${FirestoreSchema.users}/$uid/${FirestoreSchema.children}/$childId/${FirestoreSchema.progress}')
            .get();
        for (final pd in progressSnap.docs) {
          await pd.reference.delete();
        }

        // Fshi info-n e çdo fëmijës
        final infoSnap = await _db
            .collection(
                '${FirestoreSchema.users}/$uid/${FirestoreSchema.children}/$childId/${FirestoreSchema.info}')
            .get();
        for (final id in infoSnap.docs) {
          await id.reference.delete();
        }

        await childDoc.reference.delete();
      }

      // Fshi dokumentin kryesor të prindit
      await _db.doc(FirestoreSchema.userDoc(uid)).delete();

      debugPrint('[Sync] Të gjitha të dhënat u fshinë për uid: $uid');
    } catch (e) {
      debugPrint('[Sync] Gabim deleteAllUserData: $e');
    }
  }

  // ─── Helper private ───────────────────────────────────────────────────────

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────

final syncServiceProvider = Provider<SyncService>((ref) => SyncService(ref));
