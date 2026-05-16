import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/distractor_engine.dart';
import '../../models/math_question.dart';
import '../../models/operation.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class ChallengeState {
  const ChallengeState({
    required this.question,
    required this.score,
    required this.answered,
    required this.correct,
    required this.sessionLength,
    this.selectedAnswer,
    this.isAnswerCorrect,
    this.isAdvancing = false,
  });

  final MathQuestion question;
  final int score;
  final int answered;
  final int correct;
  final int sessionLength;
  final int? selectedAnswer;

  /// null = nuk është zgjedhur akoma; true/false = saktë/gabim
  final bool? isAnswerCorrect;
  final bool isAdvancing;

  bool get isComplete => answered >= sessionLength;
  double get progress => sessionLength > 0 ? answered / sessionLength : 0;
  int get accuracy =>
      sessionLength > 0 ? ((correct / sessionLength) * 100).round() : 0;

  ChallengeState copyWith({
    MathQuestion? question,
    int? score,
    int? answered,
    int? correct,
    int? sessionLength,
    int? selectedAnswer,
    bool? clearSelectedAnswer,
    bool? isAnswerCorrect,
    bool? clearIsAnswerCorrect,
    bool? isAdvancing,
  }) {
    return ChallengeState(
      question: question ?? this.question,
      score: score ?? this.score,
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      sessionLength: sessionLength ?? this.sessionLength,
      selectedAnswer:
          clearSelectedAnswer == true ? null : selectedAnswer ?? this.selectedAnswer,
      isAnswerCorrect:
          clearIsAnswerCorrect == true ? null : isAnswerCorrect ?? this.isAnswerCorrect,
      isAdvancing: isAdvancing ?? this.isAdvancing,
    );
  }
}

// ---------------------------------------------------------------------------
// Config (family key)
// ---------------------------------------------------------------------------
class ChallengeConfig {
  const ChallengeConfig({
    required this.operation,
    this.level = 1,
    this.sessionLength = 5,
    required this.random,
  });

  final Operation operation;
  final int level;
  final int sessionLength;
  final Random random;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeConfig &&
          operation == other.operation &&
          level == other.level &&
          sessionLength == other.sessionLength &&
          identical(random, other.random);

  @override
  int get hashCode => Object.hash(operation, level, sessionLength, identityHashCode(random));
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class ChallengeNotifier extends StateNotifier<ChallengeState> {
  ChallengeNotifier(this._config)
      : super(
          ChallengeState(
            question: _buildQuestion(_config),
            score: 0,
            answered: 0,
            correct: 0,
            sessionLength: _config.sessionLength,
          ),
        );

  final ChallengeConfig _config;

  // ----- question generation -----------------------------------------------

  static MathQuestion _buildQuestion(ChallengeConfig cfg) {
    final random = cfg.random;
    final maxNumber =
        cfg.level == 1 ? 10 : (cfg.level == 2 ? 20 : 50);
    late int num1;
    late int num2;
    late int answer;

    switch (cfg.operation) {
      case Operation.addition:
        num1 = random.nextInt(maxNumber) + 1;
        num2 = random.nextInt(maxNumber) + 1;
        answer = num1 + num2;
      case Operation.subtraction:
        num1 = random.nextInt(maxNumber) + 2;
        num2 = random.nextInt(num1 - 1) + 1;
        answer = num1 - num2;
      case Operation.multiplication:
        final multMax =
            cfg.level == 1 ? 5 : (cfg.level == 2 ? 10 : 12);
        num1 = random.nextInt(multMax) + 1;
        num2 = random.nextInt(multMax) + 1;
        answer = num1 * num2;
      case Operation.division:
        final divMax =
            cfg.level == 1 ? 5 : (cfg.level == 2 ? 10 : 12);
        answer = random.nextInt(divMax) + 1;
        num2 = random.nextInt(divMax) + 1;
        num1 = answer * num2;
    }

    return MathQuestion(
      num1: num1,
      num2: num2,
      answer: answer,
      options: DistractorEngine.generateFor(
        operation: cfg.operation,
        correctAnswer: answer,
        num1: num1,
        num2: num2,
        random: random,
      ),
    );
  }

  // ----- actions -----------------------------------------------------------

  void checkAnswer(int answer) {
    if (state.isAdvancing) return;

    final isCorrect = answer == state.question.answer;

    if (isCorrect) {
      state = state.copyWith(
        selectedAnswer: answer,
        isAnswerCorrect: true,
        score: state.score + 10,
        correct: state.correct + 1,
        answered: state.answered + 1,
        isAdvancing: true,
      );
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        isAnswerCorrect: false,
      );
    }
  }

  void advance() {
    if (!state.isComplete) {
      state = state.copyWith(
        question: _buildQuestion(_config),
        clearSelectedAnswer: true,
        clearIsAnswerCorrect: true,
        isAdvancing: false,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final challengeProvider = StateNotifierProvider.autoDispose
    .family<ChallengeNotifier, ChallengeState, ChallengeConfig>(
  (ref, config) => ChallengeNotifier(config),
);
