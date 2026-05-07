import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/score_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ResponsivePage(
      maxWidth: 820,
      child: Column(
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
                  value: '+150',
                  label: l10n.commonPointsLabel,
                  icon: Icons.workspace_premium,
                  color: CosmicColors.tertiary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ScoreCard(
                  value: '95%',
                  label: l10n.commonAccuracyLabel,
                  icon: Icons.my_location,
                  color: CosmicColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}