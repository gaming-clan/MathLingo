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
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final horizontalPadding = AdaptiveLayout.pagePadding(context).left;
    final mascotSize = AdaptiveLayout.isLargeTablet(context)
        ? 220.0
        : AdaptiveLayout.isTablet(context)
        ? 180.0
        : (screenHeight * 0.22).clamp(120.0, 160.0);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.resultsTitle,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: CosmicColors.primary,
                                fontSize: 46,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.resultsSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        MascotFrame(size: mascotSize, celebratory: true),
                        const SizedBox(height: 24),
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
                                value: l10n.resultsAccuracyValue(
                                  widget.accuracy,
                                ),
                                label: l10n.commonAccuracyLabel,
                                icon: Icons.my_location,
                                color: CosmicColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    24 + bottomInset,
                  ),
                  child: CosmicButton(
                    label: l10n.commonContinue,
                    icon: Icons.arrow_forward,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await ref
                          .read(activeProgressNotifierProvider)
                          ?.addSession(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
