import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/daily_stats.dart';
import '../repositories/family_profile_repository.dart';
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
  /// Nëse nuk ka fëmijë aktiv,
  /// vendos `WeeklyStatsLoaded([])` pa gabim.
  Future<void> load() async {
    final activeChild = _ref.read(familyProvider).activeChild;
    if (activeChild == null) {
      state = const WeeklyStatsLoaded([]);
      return;
    }

    state = const WeeklyStatsLoading();
    try {
      final syncService = _ref.read(syncServiceProvider);
      final repository = _ref.read(familyProfileRepositoryProvider);
      final rawList = await syncService.pullWeeklyStats(activeChild.id);

      final stats = rawList.isNotEmpty
          ? rawList
            .map(DailyStats.fromMap)
            .where((s) => s.date.isNotEmpty)
            .toList()
          : [...await repository.getLocalWeeklyStats(activeChild.id)]
        // Rendisje kronologjike (e vjetër → e re) për grafikun
        ..sort((a, b) => a.date.compareTo(b.date));

      state = WeeklyStatsLoaded(stats);
    } catch (e) {
      try {
        final fallbackStats = [
          ...await _ref
              .read(familyProfileRepositoryProvider)
              .getLocalWeeklyStats(activeChild.id),
        ]
          ..sort((a, b) => a.date.compareTo(b.date));
        state = WeeklyStatsLoaded(fallbackStats);
      } catch (_) {
        state = WeeklyStatsError('$e');
      }
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
