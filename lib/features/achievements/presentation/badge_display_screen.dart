import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/achievement_provider.dart';
import '../../../core/services/achievement_service.dart';
import '../../../models/achievement.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';

/// G-02 — Galeria e badge-ve (arritjeve).
///
/// Shfaq të gjitha 15 badge-t në grid 3 kolona:
/// - Të deblokuara: ngjyrë e plotë, emoji, emër.
/// - Të bllokuara: gri, ikonë çelësi, emër i maskuar.
class BadgeDisplayScreen extends ConsumerWidget {
  const BadgeDisplayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedAsync = ref.watch(activeUnlockedAchievementsProvider);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 680,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arritjet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 4),
            unlockedAsync.when(
              data: (unlocked) => Text(
                '${unlocked.length} / ${AchievementService.all.length} të deblokuara',
                style: const TextStyle(
                  color: CosmicColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            unlockedAsync.when(
              data: (unlocked) => _BadgeGrid(unlocked: unlocked),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text(
                'Gabim gjatë ngarkimit: $e',
                style: const TextStyle(color: CosmicColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.unlocked});

  final List<Achievement> unlocked;

  @override
  Widget build(BuildContext context) {
    final all = AchievementService.all;
    final unlockedIds = unlocked.map((a) => a.id).toSet();

    final isTablet = AdaptiveLayout.isTablet(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.0 : 0.9,
      ),
      itemCount: all.length,
      itemBuilder: (context, i) {
        final a = all[i];
        final isUnlocked = unlockedIds.contains(a.id);
        return _BadgeTile(achievement: a, isUnlocked: isUnlocked);
      },
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.achievement,
    required this.isUnlocked,
  });

  final Achievement achievement;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji ose ikonë e bllokuar
          ColorFiltered(
            colorFilter: isUnlocked
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 0.4, 0,
                  ]),
            child: Text(
              isUnlocked ? achievement.emoji : '🔒',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 8),
          // Emri
          Text(
            achievement.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isUnlocked
                  ? CosmicColors.onSurface
                  : CosmicColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isUnlocked) ...[
            const SizedBox(height: 4),
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
