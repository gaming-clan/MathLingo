import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/firebase_init_service.dart';
import '../models/parent_account.dart';

// ---------------------------------------------------------------------------
// Rezultati i operacioneve Auth
// ---------------------------------------------------------------------------

/// Rezultati i thirrjeve async të AuthService.
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  const AuthSuccess(this.account);
  final ParentAccount account;
}

class AuthFailure extends AuthResult {
  const AuthFailure(this.messageKey);
  final String messageKey; // çelës ARB — mesazhi shqip tregohet në UI
}

// ---------------------------------------------------------------------------
// AuthService
// ---------------------------------------------------------------------------

/// Shërbimi kryesor i autentifikimit prindëror.
///
/// Rregull themelore: Fëmija nuk krijon llogari.
/// Vetëm prindi krijon llogari; fëmija luan nën profilin familjar lokal.
///
/// Hive box `parent_account` ruhet me serialiazim manual (pa codegen).
abstract final class AuthService {
  static const String _boxName = 'parent_account';
  static const String _accountKey = 'current';

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  // ─── Regjistrim ──────────────────────────────────────────────────────────

  /// Regjistrim i prindit me email dhe fjalëkalim.
  static Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    if (!FirebaseInitService.isInitialized) {
      return const AuthFailure('authErrorFirebaseNotReady');
    }
    if (!_isValidEmail(email)) {
      return const AuthFailure('authErrorInvalidEmail');
    }
    if (!_isValidPassword(password)) {
      return const AuthFailure('authErrorWeakPassword');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final account = ParentAccount(
        uid: user.uid,
        email: user.email ?? email.trim(),
        createdAt: DateTime.now(),
        cloudSyncEnabled: true,
      );
      await _saveAccountLocally(account);
      debugPrint('[Auth] Prindi u regjistrua: ${user.uid}');
      return AuthSuccess(account);
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] FirebaseAuthException signUp: ${e.code}');
      return AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('[Auth] Gabim i papritur signUp: $e');
      return const AuthFailure('authErrorUnknown');
    }
  }

  // ─── Hyrje ───────────────────────────────────────────────────────────────

  /// Hyrje e prindit me email dhe fjalëkalim.
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    if (!FirebaseInitService.isInitialized) {
      return const AuthFailure('authErrorFirebaseNotReady');
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      var account = await _loadAccountLocally();
      account ??= ParentAccount(
        uid: user.uid,
        email: user.email ?? email.trim(),
        createdAt: DateTime.now(),
        cloudSyncEnabled: true,
      );
      await _saveAccountLocally(account);
      debugPrint('[Auth] Prindi hyri: ${user.uid}');
      return AuthSuccess(account);
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] FirebaseAuthException signIn: ${e.code}');
      return AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('[Auth] Gabim i papritur signIn: $e');
      return const AuthFailure('authErrorUnknown');
    }
  }

  // ─── Dalje ───────────────────────────────────────────────────────────────

  /// Dalje nga llogaria. Të dhënat lokale mbeten.
  static Future<void> signOut() async {
    if (!FirebaseInitService.isInitialized) return;
    await _auth.signOut();
    await _clearAccountLocally();
    debugPrint('[Auth] Prindi doli nga llogaria.');
  }

  // ─── Fshirje llogarie ─────────────────────────────────────────────────────

  /// Fshin llogarinë Firebase dhe të dhënat lokale.
  /// Zbaton GDPR Nenin 17 — e drejta e fshirjes.
  /// Thirrësi duhet të fshijë Firestore DATA veçmas nëpërmjet SyncService.
  static Future<bool> deleteAccount() async {
    if (!FirebaseInitService.isInitialized) return false;

    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      await user.delete();
      await _clearAccountLocally();
      debugPrint('[Auth] Llogaria u fshi: ${user.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] Gabim fshirje llogarie: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('[Auth] Gabim i papritur gjatë fshirjes: $e');
      return false;
    }
  }

  // ─── Akses ───────────────────────────────────────────────────────────────

  /// Kthe llogarinë aktuale ose null.
  static Future<ParentAccount?> getCurrentAccount() async {
    return _loadAccountLocally();
  }

  /// A është prindi i kyçur?
  static bool get isSignedIn =>
      FirebaseInitService.isInitialized && _auth.currentUser != null;

  /// B-02: Përditëso `lastSyncAt` në Hive pas sinkronizimit të suksesshëm.
  static Future<void> updateLastSyncAt(DateTime when) async {
    final account = await _loadAccountLocally();
    if (account == null) return;
    await _saveAccountLocally(account.copyWith(lastSyncAt: when));
  }

  // ─── Helpers private ─────────────────────────────────────────────────────

  static Future<void> _saveAccountLocally(ParentAccount account) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_accountKey, account.toMap());
  }

  static Future<ParentAccount?> _loadAccountLocally() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final data = box.get(_accountKey);
    if (data == null) return null;
    return ParentAccount.fromMap(data as Map<dynamic, dynamic>);
  }

  static Future<void> _clearAccountLocally() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.clear();
  }

  static bool _isValidEmail(String email) =>
      RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$').hasMatch(email.trim());

  static bool _isValidPassword(String password) =>
      password.length >= 8 && password.contains(RegExp(r'\d'));

  static String _mapFirebaseError(String code) => switch (code) {
        'email-already-in-use' => 'authErrorEmailInUse',
        'invalid-email' => 'authErrorInvalidEmail',
        'weak-password' => 'authErrorWeakPassword',
        'user-not-found' => 'authErrorUserNotFound',
        'wrong-password' => 'authErrorWrongPassword',
        'invalid-credential' => 'authErrorWrongPassword',
        'too-many-requests' => 'authErrorTooManyRequests',
        'network-request-failed' => 'authErrorNetwork',
        'user-disabled' => 'authErrorUserDisabled',
        _ => 'authErrorUnknown',
      };
}
