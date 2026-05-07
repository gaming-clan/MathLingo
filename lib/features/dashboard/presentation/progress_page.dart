import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/score_card.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(progressProvider);
    return ResponsivePage(
      maxWidth: 820,
      child: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
        data: (progress) => Column(
          children: [
            Text(
              l10n.progressPageTitle,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: CosmicColors.primary,
                fontSize: 42,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.progressPageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const MascotFrame(size: 260),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsPointsValue(progress.totalPoints),
                    label: l10n.progressPageTotalPointsLabel,
                    icon: Icons.workspace_premium,
                    color: CosmicColors.tertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsAccuracyValue(
                      progress.averageAccuracy.round(),
                    ),
                    label: l10n.progressPageAverageAccuracyLabel,
                    icon: Icons.my_location,
                    color: CosmicColors.secondary,
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