import 'dart:math';

import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../domain/geometry_question_generator.dart';
import '../../../models/geometry_question.dart';
import '../../../responsive.dart';
import '../../../shared/painting/geometry_shape_painter.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import '../../challenges/presentation/results_screen.dart';
import '../../challenges/presentation/widgets/answer_button.dart';

class GeometryChallengeScreen extends StatefulWidget {
  const GeometryChallengeScreen({
    super.key,
    this.sessionLength = 4,
    Random? random,
  }) : random = random ?? const DefaultRandom();

  final int sessionLength;
  final Random random;

  @override
  State<GeometryChallengeScreen> createState() =>
      _GeometryChallengeScreenState();
}

class _GeometryChallengeScreenState extends State<GeometryChallengeScreen> {
  static const _questionGenerator = GeometryQuestionGenerator();
  late GeometryQuestion _question;
  int _score = 0;
  int _answered = 0;
  int _correct = 0;
  int? _selectedAnswer;
  String _feedback = '';
  bool _isAdvancing = false;

  @override
  void initState() {
    super.initState();
    _question = _generateQuestion();
  }

  GeometryQuestion _generateQuestion() {
    return _questionGenerator.generate(widget.random);
  }

  void _checkAnswer(int answer) {
    if (_isAdvancing) {
      return;
    }

    final isCorrect = answer == _question.answer;
    setState(() {
      _selectedAnswer = answer;
      _feedback = isCorrect
          ? 'Saktë! Forma u analizua.'
          : 'Jo ende. Shiko matjet dhe provo përsëri.';
      if (isCorrect) {
        _score += 15;
        _correct += 1;
        _answered += 1;
        _isAdvancing = true;
      }
    });

    if (!isCorrect) {
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      if (_answered >= widget.sessionLength) {
        final accuracy = ((_correct / widget.sessionLength) * 100).round();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ResultsScreen(points: _score, accuracy: accuracy),
          ),
        );
        return;
      }
      setState(() {
        _question = _generateQuestion();
        _selectedAnswer = null;
        _feedback = '';
        _isAdvancing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _answered / widget.sessionLength;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              kicker: 'GJEOMETRIA BAZË',
              title: 'Sfida Gjeometrike',
            ),
            const SizedBox(height: 18),
            CosmicProgress(
              label: 'Pikët: $_score',
              value: progress,
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
                          painter: GeometryShapePainter(_question),
                          child: Center(
                            child: Icon(
                              _question.shape.icon,
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
                    _question.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _question.measurement,
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
                  children: _question.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == _question.answer;
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
                      onPressed: () => _checkAnswer(option),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _feedback.isEmpty
                  ? const SizedBox(height: 28)
                  : Text(
                      _feedback,
                      key: ValueKey(_feedback),
                      style: TextStyle(
                        color: _selectedAnswer == _question.answer
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
