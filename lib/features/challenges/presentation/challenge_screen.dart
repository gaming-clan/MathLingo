import 'dart:math';

import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/math_question.dart';
import '../../../models/operation.dart';
import '../../../responsive.dart';
import '../../../shared/utils/default_random.dart';
import '../../../shared/widgets/cosmic_progress.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/section_header.dart';
import 'results_screen.dart';
import 'widgets/answer_button.dart';

class ChallengeScreen extends StatefulWidget {
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
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late MathQuestion _question;
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

  MathQuestion _generateQuestion() {
    final random = widget.random;
    final maxNumber = widget.level == 1 ? 10 : (widget.level == 2 ? 20 : 50);
    late int num1;
    late int num2;
    late int answer;

    switch (widget.operation) {
      case Operation.addition:
        num1 = random.nextInt(maxNumber) + 1;
        num2 = random.nextInt(maxNumber) + 1;
        answer = num1 + num2;
      case Operation.subtraction:
        num1 = random.nextInt(maxNumber) + 2;
        num2 = random.nextInt(num1 - 1) + 1;
        answer = num1 - num2;
      case Operation.multiplication:
        final multMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 12);
        num1 = random.nextInt(multMax) + 1;
        num2 = random.nextInt(multMax) + 1;
        answer = num1 * num2;
      case Operation.division:
        final divMax = widget.level == 1 ? 5 : (widget.level == 2 ? 10 : 12);
        answer = random.nextInt(divMax) + 1;
        num2 = random.nextInt(divMax) + 1;
        num1 = answer * num2;
    }

    return MathQuestion(
      num1: num1,
      num2: num2,
      answer: answer,
      options: _generateOptions(answer),
    );
  }

  List<int> _generateOptions(int correctAnswer) {
    final random = widget.random;
    final options = <int>{correctAnswer};
    while (options.length < 4) {
      var offset = random.nextInt(12) - 6;
      if (offset == 0) offset = 1;
      final wrongAnswer = correctAnswer + offset;
      if (wrongAnswer >= 0) {
        options.add(wrongAnswer);
      }
    }
    final shuffled = options.toList()..shuffle(random);
    return shuffled;
  }

  void _checkAnswer(int answer) {
    if (_isAdvancing) {
      return;
    }

    final isCorrect = answer == _question.answer;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _selectedAnswer = answer;
      _feedback = isCorrect
          ? l10n.challengeCorrectFeedback
          : l10n.challengeIncorrectFeedback;
      if (isCorrect) {
        _score += 10;
        _correct += 1;
        _answered += 1;
        _isAdvancing = true;
      }
    });

    if (!isCorrect) {
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 450), () {
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
    final l10n = AppLocalizations.of(context);

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
              label: l10n.challengeScoreLabel(_score),
              value: progress,
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
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            l10n.challengeEquationPrompt(
                              _question.num1,
                              widget.operation.displaySymbol,
                              _question.num2,
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CosmicColors.secondaryContainer,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
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
                          ? const ValueKey('correct-answer')
                          : ValueKey('answer-$option'),
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