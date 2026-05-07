import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_routes.dart';
import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/mascot_frame.dart';
import '../../../shared/widgets/score_card.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({
    super.key,
    required this.points,
    required this.accuracy,
    this.moduleKey,
  });

  final int points;
  final int accuracy;

  /// Çelësi i modulit për statistikat per-modul (p.sh. 'Mbledhje', 'Gjeometri').
  final String? moduleKey;

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(),
      body: ResponsivePage(
        maxWidth: 760,
        child: Column(
          children: [
            Text(
              l10n.resultsTitle,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: CosmicColors.primary,
                fontSize: 46,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.resultsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            const MascotFrame(size: 280, celebratory: true),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsPointsValue(widget.points),
                    label: l10n.commonPointsLabel,
                    icon: Icons.workspace_premium,
                    color: CosmicColors.tertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ScoreCard(
                    value: l10n.resultsAccuracyValue(widget.accuracy),
                    label: l10n.commonAccuracyLabel,
                    icon: Icons.my_location,
                    color: CosmicColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CosmicButton(
              label: l10n.commonContinue,
              icon: Icons.arrow_forward,
              onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(progressProvider.notifier).addSession(
                points: widget.points,
                accuracy: widget.accuracy,
                moduleKey: widget.moduleKey,
              );
              if (!mounted) {
                return;
              }
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.dashboard,
                (_) => false,
              );
            },
            ),
          ],
        ),
      ),
    );
  }
}