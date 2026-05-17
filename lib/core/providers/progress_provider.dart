import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_progress.dart';
import '../../shared/utils/user_progress_storage.dart';
import 'family_provider.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class ProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  ProgressNotifier(this._ref, this._childId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref _ref;
  final String _childId;

  Future<void> _load() async {
    try {
      final progress = await UserProgressStorage.load(childId: _childId);
      if (mounted) state = AsyncValue.data(progress);
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  Future<void> reload() => _load();

  Future<void> addSession({
    required int points,
    required int accuracy,
    String? moduleKey,
  }) async {
    try {
      // Shkrim per-child te Hive (burimi kryesor i saktësisë)
      final updated = await UserProgressStorage.addSession(
        points: points,
        accuracy: accuracy,
        moduleKey: moduleKey,
        childId: _childId,
      );
      if (mounted) state = AsyncValue.data(updated);
      // Rifresko familyProvider state — izoluar nga gabimet (p.sh. nuk ekziston familje)
      try {
        await _ref.read(familyProvider.notifier).recordSession(
          points: points,
          accuracy: accuracy,
          moduleKey: moduleKey,
        );
      } on Object {
        // familyProvider mund të mos jetë aktiv (p.sh. gjatë testeve) — anashkalo
      }
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Provider per-child — izolim i plotë i progresit.
/// Përdor `activeProgressProvider` për lexim në UI.
final progressProvider = StateNotifierProvider
    .family<ProgressNotifier, AsyncValue<UserProgress>, String>(
  (ref, childId) => ProgressNotifier(ref, childId),
);

/// Provider i lehtë — gjithmonë kthen progresin e fëmijës aktiv.
final activeProgressProvider = Provider<AsyncValue<UserProgress>>((ref) {
  final childId = ref.watch(activeChildProvider)?.id ?? 'global';
  return ref.watch(progressProvider(childId));
});

/// Notifier i fëmijës aktiv për shkrim (p.sh. nga ResultsScreen).
final activeProgressNotifierProvider =
    Provider<ProgressNotifier?>((ref) {
  final childId = ref.watch(activeChildProvider)?.id ?? 'global';
  return ref.watch(progressProvider(childId).notifier);
});

