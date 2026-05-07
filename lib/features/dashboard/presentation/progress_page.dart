import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/score_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      maxWidth: 820,
      child: Column(
        children: [
          Text(
            'Bravo!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: CosmicColors.primary,
              fontSize: 42,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Progresi yt po rritet çdo ditë.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          const MascotFrame(size: 260),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(
                child: ScoreCard(
                  value: '+150',
                  label: 'Pikët',
                  icon: Icons.workspace_premium,
                  color: CosmicColors.tertiary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ScoreCard(
                  value: '95%',
                  label: 'Saktësia',
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