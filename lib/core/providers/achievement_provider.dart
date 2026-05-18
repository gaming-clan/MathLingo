import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/achievement.dart';
import '../services/achievement_service.dart';
import 'family_provider.dart';

/// Arritjet e deblokuara për një fëmijë specifik (me ID).
final unlockedAchievementsProvider =
    FutureProvider.family<List<Achievement>, String>((ref, childId) {
  return AchievementService.getUnlocked(childId);
});

/// Arritjet e deblokuara për fëmijën aktivisht aktiv.
final activeUnlockedAchievementsProvider =
    FutureProvider<List<Achievement>>((ref) {
  final childId = ref.watch(activeChildProvider)?.id ?? 'global';
  return AchievementService.getUnlocked(childId);
});
