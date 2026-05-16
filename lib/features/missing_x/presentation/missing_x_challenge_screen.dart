import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/missing_x_provider.dart';
import '../../../responsive.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import '../../challenges/presentation/results_screen.dart';
import '../../challenges/presentation/widgets/answer_button.dart';

class MissingXChallengeScreen extends ConsumerStatefulWidget {
  const MissingXChallengeScreen({
    super.key,
    this.sessionLength = 4,
    this.maxNumber = 20,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final int sessionLength;
  final int maxNumber;
  final Random random;

  @override
  ConsumerState<MissingXChallengeScreen> createState() =>
      _MissingXChallengeScreenState();
}

class _MissingXChallengeScreenState
    extends ConsumerState<MissingXChallengeScreen> {
  late final MissingXConfig _config;

  @override
  void initState() {
    super.initState();
    _config = MissingXConfig(
      sessionLength: widget.sessionLength,
      maxNumber: widget.maxNumber,
      random: widget.random,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(missingXProvider(_config));

    ref.listen(missingXProvider(_config), (prev, next) {
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
                  moduleKey: 'Gjej X-in',
                ),
              ),
            );
          } else {
            ref.read(missingXProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect! ? 'Saktë! 🎯' : 'Provo sërisht!');

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              kicker: 'Sfida',
              title: 'Gjej X-in',
            ),
            const SizedBox(height: 18),
            CosmicProgress(
              label: 'Pikë: ${state.score}',
              value: state.progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            // Kartë e pyetjes
            GlassPanel(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 720;
                  final screenH = MediaQuery.sizeOf(context).height;
                  final height = isTablet
                      ? (screenH * 0.34).clamp(160.0, 240.0)
                      : (screenH * 0.27).clamp(120.0, 170.0);
                  final fontSize = isTablet ? 52.0 : 42.0;

                  return SizedBox(
                    height: height,
                    child: Center(
                      child: _EquationDisplay(
                        leftPart: state.question.leftDisplay,
                        rightPart: state.question.rightDisplay,
                        fontSize: fontSize,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Grid opsionesh
            LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 720;
                final childAspectRatio = isTablet ? 3.4 : 2.8;

                return GridView.count(
                  crossAxisCount: 2,
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
                          .read(missingXProvider(_config).notifier)
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

// ---------------------------------------------------------------------------
// Widget i ekuacionit me ? të theksuar në cyan
// ---------------------------------------------------------------------------
class _EquationDisplay extends StatelessWidget {
  const _EquationDisplay({
    required this.leftPart,
    required this.rightPart,
    required this.fontSize,
  });

  final String leftPart;
  final String rightPart;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: CosmicColors.onSurface,
        ),
        children: [
          if (leftPart.isNotEmpty) TextSpan(text: leftPart),
          TextSpan(
            text: '?',
            style: TextStyle(
              color: CosmicColors.secondaryContainer,
              fontSize: fontSize * 1.1,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: CosmicColors.secondaryContainer.withValues(alpha: 0.6),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          if (rightPart.isNotEmpty) TextSpan(text: rightPart),
        ],
      ),
    );
  }
}
