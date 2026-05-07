import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/geometry_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/geometry_shape.dart';
import '../../../responsive.dart';
import '../../../shared/painting/geometry_shape_painter.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import '../../challenges/presentation/results_screen.dart';
import '../../challenges/presentation/widgets/answer_button.dart';

class GeometryChallengeScreen extends ConsumerStatefulWidget {
  const GeometryChallengeScreen({
    super.key,
    this.sessionLength = 4,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final int sessionLength;
  final Random random;

  @override
  ConsumerState<GeometryChallengeScreen> createState() =>
      _GeometryChallengeScreenState();
}

class _GeometryChallengeScreenState
    extends ConsumerState<GeometryChallengeScreen> {
  late final GeometryConfig _config;

  @override
  void initState() {
    super.initState();
    _config = GeometryConfig(
      sessionLength: widget.sessionLength,
      random: widget.random,
    );
  }

  String _promptForShape(GeometryShape shape, AppLocalizations l10n) {
    switch (shape) {
      case GeometryShape.rectangle:
        return l10n.geometryRectanglePrompt;
      case GeometryShape.triangle:
        return l10n.geometryTrianglePrompt;
      case GeometryShape.square:
        return l10n.geometrySquarePrompt;
    }
  }

  String _measurementForShape(GeometryState state, AppLocalizations l10n) {
    final q = state.question;
    switch (q.shape) {
      case GeometryShape.rectangle:
        return l10n.geometryRectangleMeasurement(q.width, q.height);
      case GeometryShape.triangle:
        return l10n.geometryTriangleMeasurement(q.width, q.height);
      case GeometryShape.square:
        return l10n.geometrySquareMeasurement(q.width);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geometryProvider(_config));
    final l10n = AppLocalizations.of(context);

    ref.listen(geometryProvider(_config), (prev, next) {
      if (next.isAdvancing && !(prev?.isAdvancing ?? false)) {
        final navigator = Navigator.of(context);
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          if (next.isComplete) {
            navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => ResultsScreen(
                  points: next.score,
                  accuracy: next.accuracy,
                ),
              ),
            );
          } else {
            ref.read(geometryProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect!
            ? l10n.geometryCorrectFeedback
            : l10n.geometryIncorrectFeedback);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              kicker: l10n.geometryKicker,
              title: l10n.geometryTitle,
            ),
            const SizedBox(height: 18),
            CosmicProgress(
              label: l10n.geometryScoreLabel(state.score),
              value: state.progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth >= 720;
                      final height = isTablet ? 260.0 : 210.0;
                      return SizedBox(
                        height: height,
                        child: CustomPaint(
                          painter: GeometryShapePainter(state.question),
                          child: Center(
                            child: Icon(
                              state.question.shape.icon,
                              color: CosmicColors.secondaryContainer.withValues(
                                alpha: 0.2,
                              ),
                              size: isTablet ? 120 : 96,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _promptForShape(state.question.shape, l10n),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _measurementForShape(state, l10n),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 720;
                final isLargeTablet = width >= 1000;

                late int columns;
                late double childAspectRatio;

                if (isLargeTablet) {
                  columns = 4;
                  childAspectRatio = 1.8;
                } else if (isTablet) {
                  columns = 3;
                  childAspectRatio = 1.7;
                } else {
                  columns = 2;
                  childAspectRatio = 1.9;
                }

                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: childAspectRatio,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: state.question.options.map((option) {
                    final isSelected = state.selectedAnswer == option;
                    final isCorrect = option == state.question.answer;
                    final color = isSelected && isCorrect
                        ? CosmicColors.secondaryContainer
                        : isSelected
                        ? CosmicColors.error
                        : CosmicColors.primaryContainer;
                    return AnswerButton(
                      key: isCorrect
                          ? const ValueKey('correct-geometry-answer')
                          : ValueKey('geometry-answer-$option'),
                      value: option,
                      color: color,
                      onPressed: () => ref
                          .read(geometryProvider(_config).notifier)
                          .checkAnswer(option),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: feedback.isEmpty
                  ? const SizedBox(height: 28)
                  : Text(
                      feedback,
                      key: ValueKey(feedback),
                      style: TextStyle(
                        color: state.isAnswerCorrect == true
                            ? CosmicColors.secondaryContainer
                            : CosmicColors.error,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
