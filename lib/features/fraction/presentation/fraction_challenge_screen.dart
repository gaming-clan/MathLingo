import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/fraction_provider.dart';
import '../../../models/fraction_question.dart';
import '../../../responsive.dart';
import '../../../shared/painting/fraction_painter.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import '../../challenges/presentation/results_screen.dart';

class FractionChallengeScreen extends ConsumerStatefulWidget {
  const FractionChallengeScreen({
    super.key,
    this.sessionLength = 4,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final int sessionLength;
  final Random random;

  @override
  ConsumerState<FractionChallengeScreen> createState() =>
      _FractionChallengeScreenState();
}

class _FractionChallengeScreenState
    extends ConsumerState<FractionChallengeScreen> {
  late final FractionConfig _config;

  @override
  void initState() {
    super.initState();
    _config = FractionConfig(
      sessionLength: widget.sessionLength,
      random: widget.random,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fractionProvider(_config));

    ref.listen(fractionProvider(_config), (prev, next) {
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
                  moduleKey: 'Fraksionet',
                ),
              ),
            );
          } else {
            ref.read(fractionProvider(_config).notifier).advance();
          }
        });
      }
    });

    final feedback = state.isAnswerCorrect == null
        ? ''
        : (state.isAnswerCorrect!
            ? 'Saktë! Vazhdon fluturimi.'
            : 'Provo përsëri. Je shumë afër.');

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              kicker: 'FRAKSIONET',
              title: 'Cili fraksion është ky?',
            ),
            const SizedBox(height: 18),
            CosmicProgress(
              label: 'Pikët: ${state.score}',
              value: state.progress,
              color: CosmicColors.secondaryContainer,
            ),
            const SizedBox(height: 24),
            GlassPanel(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: _FractionVisual(question: state.question),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                state.question.prompt,
                style: const TextStyle(
                  color: CosmicColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 720;
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isTablet ? 3.4 : 2.8,
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
                    return _FractionOptionButton(
                      label: option,
                      color: color,
                      onPressed: () => ref
                          .read(fractionProvider(_config).notifier)
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
// _FractionVisual — vizualizimi i fraksionit
// ---------------------------------------------------------------------------
class _FractionVisual extends StatelessWidget {
  const _FractionVisual({required this.question});

  final FractionQuestion question;

  @override
  Widget build(BuildContext context) {
    final isPie = question.visualType == FractionVisualType.pie;
    final size = isPie ? 160.0 : null;

    return Column(
      children: [
        SizedBox(
          width: size ?? double.infinity,
          height: isPie ? 160.0 : 60.0,
          child: CustomPaint(
            painter: FractionPainter(
              numerator: question.numerator,
              denominator: question.denominator,
              isPie: isPie,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _FractionOptionButton
// ---------------------------------------------------------------------------
class _FractionOptionButton extends StatelessWidget {
  const _FractionOptionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color.withValues(alpha: 0.06),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
