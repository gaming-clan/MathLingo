import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_progress.dart';
import '../../shared/utils/user_progress_storage.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class ProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  ProgressNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final progress = await UserProgressStorage.load();
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
      final updated = await UserProgressStorage.addSession(
        points: points,
        accuracy: accuracy,
        moduleKey: moduleKey,
      );
      if (mounted) state = AsyncValue.data(updated);
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<UserProgress>>(
  (ref) => ProgressNotifier(),
);
