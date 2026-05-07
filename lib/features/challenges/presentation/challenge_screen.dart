import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/challenge_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/operation.dart';
import '../../../responsive.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import 'results_screen.dart';
import 'widgets/answer_button.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({
    super.key,
    this.operation = Operation.addition,
    this.level = 1,
    this.sessionLength = 5,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final Operation operation;
  final int level;
  final int sessionLength;
  final Random random;

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  late final ChallengeConfig _config;

  @override
  void initState() {
    super.initState();
    _config = ChallengeConfig(
      operation: widget.operation,
      level: widget.level,
      sessionLength: widget.sessionLength,
      random: widget.random,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeProvider(_config));
    final l10n = AppLocalizations.of(context);

    ref.listen(challengeProvider(_config), (prev, next) {
      if (next.isAdvancing && !(prev?.isAdvancing ?? false)) {
        final navigator = Navigator.of(context);
        Future<void>.delayed(const Duration(milliseconds: 450), () {
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
            ref.read(challengeProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect!
            ? l10n.challengeCorrectFeedback
            : l10n.challengeIncorrectFeedback);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              kicker: l10n.challengeKicker,
              title: l10n.challengeTitle,
            ),
            const SizedBox(height: 18),
            CosmicProgress(
              label: l10n.challengeScoreLabel(state.score),
              value: state.progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 720;
                  final height = isTablet ? 300.0 : 260.0;
                  final fontSize = isTablet ? 52.0 : 44.0;
                  return SizedBox(
                    height: height,
                    child: Center(
                      child: Text(
                        l10n.challengeEquationPrompt(
                          state.question.num1,
                          widget.operation.displaySymbol,
                          state.question.num2,
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CosmicColors.secondaryContainer,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                },
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
                          ? const ValueKey('correct-answer')
                          : ValueKey('answer-$option'),
                      value: option,
                      color: color,
                      onPressed: () => ref
                          .read(challengeProvider(_config).notifier)
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