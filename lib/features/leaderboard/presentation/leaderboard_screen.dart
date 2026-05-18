import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../models/child_profile.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';

/// G-04 — Klasifikimi familjar.
///
/// Rendit fëmijët e familjes sipas pikëve totale.
/// Nuk kërkon cloud — përdor të dhënat lokale nga [FamilyProfile].
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyState = ref.watch(familyProvider);
    final activeId = familyState.activeChild?.id;
    final children = familyState.family?.children ?? [];

    // Rendit zbritshëm sipas pikëve
    final sorted = [...children]
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Klasifikimi Familjar',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bazuar në pikët totale të grumbulluara.',
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            if (sorted.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Nuk ka fëmijë të regjistruar ende.',
                    style: TextStyle(color: CosmicColors.onSurfaceVariant),
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (int i = 0; i < sorted.length; i++)
                    _LeaderboardRow(
                      rank: i + 1,
                      child: sorted[i],
                      isActive: sorted[i].id == activeId,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.child,
    required this.isActive,
  });

  final int rank;
  final ChildProfile child;
  final bool isActive;

  static const _medalEmojis = ['🥇', '🥈', '🥉'];

  String get _rankDisplay =>
      rank <= 3 ? _medalEmojis[rank - 1] : '$rank.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Vendi (medal ose numër)
            SizedBox(
              width: 40,
              child: Text(
                _rankDisplay,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 12),

            // Avatari
            Text(
              ChildAvatars.get(child.avatarIndex),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),

            // Emri + sesione
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        child.pseudonym,
                        style: TextStyle(
                          color: isActive
                              ? CosmicColors.secondaryContainer
                              : CosmicColors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CosmicColors.secondaryContainer
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            'TI',
                            style: TextStyle(
                              color: CosmicColors.secondaryContainer,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${child.completedSessions} sesione',
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Pikët
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${child.totalPoints}',
                  style: TextStyle(
                    color: isActive
                        ? CosmicColors.secondaryContainer
                        : CosmicColors.tertiaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'pikë',
                  style: TextStyle(
                    color: CosmicColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
