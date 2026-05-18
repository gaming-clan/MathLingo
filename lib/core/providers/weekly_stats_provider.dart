import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/daily_stats.dart';
import '../providers/family_provider.dart';
import '../sync/sync_service.dart';

// ─── State ───────────────────────────────────────────────────────────────────

/// Gjendjeve të mundshme të ngarkimit të statistikave javore.
sealed class WeeklyStatsState {
  const WeeklyStatsState();
}

class WeeklyStatsInitial extends WeeklyStatsState {
  const WeeklyStatsInitial();
}

class WeeklyStatsLoading extends WeeklyStatsState {
  const WeeklyStatsLoading();
}

class WeeklyStatsLoaded extends WeeklyStatsState {
  const WeeklyStatsLoaded(this.stats);
  final List<DailyStats> stats;
}

class WeeklyStatsError extends WeeklyStatsState {
  const WeeklyStatsError(this.message);
  final String message;
}

// ─── Notifier ────────────────────────────────────────────────────────────────

/// Menaxhon statistikat e 7 ditëve të fundit nga Firestore.
///
/// Thirret nga `ParentReportScreen` — nuk ndërhyn asnjëherë automatikisht
/// gjatë lojës. Dështimi i rrjetit reflektohet si `WeeklyStatsError`
/// (nuk hedh exception).
class WeeklyStatsNotifier extends StateNotifier<WeeklyStatsState> {
  WeeklyStatsNotifier(this._ref) : super(const WeeklyStatsInitial());

  final Ref _ref;

  /// Ngarko statistikat për fëmijën aktiv.
  /// Nëse nuk ka fëmijë aktiv ose sync nuk është i disponueshëm,
  /// vendos `WeeklyStatsLoaded([])` pa gabim.
  Future<void> load() async {
    final activeChild = _ref.read(familyProvider).activeChild;
    if (activeChild == null) {
      state = const WeeklyStatsLoaded([]);
      return;
    }

    state = const WeeklyStatsLoading();
    try {
      final rawList = await _ref
          .read(syncServiceProvider)
          .pullWeeklyStats(activeChild.id);

      final stats = rawList
          .map(DailyStats.fromMap)
          .where((s) => s.date.isNotEmpty)
          .toList()
        // Rendisje kronologjike (e vjetër → e re) për grafikun
        ..sort((a, b) => a.date.compareTo(b.date));

      state = WeeklyStatsLoaded(stats);
    } catch (e) {
      state = WeeklyStatsError('$e');
    }
  }

  /// Rifresko të dhënat (pull i ri nga Firestore).
  Future<void> refresh() => load();
}

// ─── Provider ────────────────────────────────────────────────────────────────

/// Provider Riverpod për statistikat javore.
///
/// `autoDispose` — shpëtojmë memorien kur `ParentReportScreen` del nga stack.
final weeklyStatsProvider =
    StateNotifierProvider.autoDispose<WeeklyStatsNotifier, WeeklyStatsState>(
  (ref) => WeeklyStatsNotifier(ref),
);
