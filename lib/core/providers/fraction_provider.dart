import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/fraction_question.dart';
import '../../features/fraction/domain/fraction_generator.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class FractionState {
  const FractionState({
    required this.question,
    required this.score,
    required this.answered,
    required this.correct,
    required this.sessionLength,
    this.selectedAnswer,
    this.isAnswerCorrect,
    this.isAdvancing = false,
    this.hadWrongAttemptOnCurrent = false,
  });

  final FractionQuestion question;
  final int score;
  final int answered;
  final int correct;
  final int sessionLength;
  final String? selectedAnswer;
  final bool? isAnswerCorrect;
  final bool isAdvancing;
  final bool hadWrongAttemptOnCurrent;

  bool get isComplete => answered >= sessionLength;
  double get progress => sessionLength > 0 ? answered / sessionLength : 0;
  int get accuracy =>
      sessionLength > 0 ? ((correct / sessionLength) * 100).round() : 0;

  FractionState copyWith({
    FractionQuestion? question,
    int? score,
    int? answered,
    int? correct,
    int? sessionLength,
    String? selectedAnswer,
    bool? clearSelectedAnswer,
    bool? isAnswerCorrect,
    bool? clearIsAnswerCorrect,
    bool? isAdvancing,
    bool? hadWrongAttemptOnCurrent,
  }) {
    return FractionState(
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
      hadWrongAttemptOnCurrent:
          hadWrongAttemptOnCurrent ?? this.hadWrongAttemptOnCurrent,
    );
  }
}

// ---------------------------------------------------------------------------
// Config (family key)
// ---------------------------------------------------------------------------
class FractionConfig {
  const FractionConfig({
    this.sessionLength = 4,
    required this.random,
  });

  final int sessionLength;
  final Random random;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FractionConfig &&
          sessionLength == other.sessionLength &&
          identical(random, other.random);

  @override
  int get hashCode => Object.hash(sessionLength, identityHashCode(random));
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class FractionNotifier extends StateNotifier<FractionState> {
  FractionNotifier(this._config)
      : super(FractionState(
          question: FractionGenerator.generate(_config.random),
          score: 0,
          answered: 0,
          correct: 0,
          sessionLength: _config.sessionLength,
        ));

  final FractionConfig _config;

  void checkAnswer(String answer) {
    if (state.isAdvancing) return;
    final isCorrect = answer == state.question.answer;
    if (isCorrect) {
      final countAsCorrect = !state.hadWrongAttemptOnCurrent;
      state = state.copyWith(
        selectedAnswer: answer,
        isAnswerCorrect: true,
        score: state.score + 15,
        correct: countAsCorrect ? state.correct + 1 : state.correct,
        answered: state.answered + 1,
        isAdvancing: true,
      );
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        isAnswerCorrect: false,
        hadWrongAttemptOnCurrent: true,
      );
    }
  }

  void advance() {
    if (!state.isComplete) {
      state = state.copyWith(
        question: FractionGenerator.generate(_config.random),
        clearSelectedAnswer: true,
        clearIsAnswerCorrect: true,
        isAdvancing: false,
        hadWrongAttemptOnCurrent: false,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final fractionProvider = StateNotifierProvider.autoDispose
    .family<FractionNotifier, FractionState, FractionConfig>(
  (ref, config) => FractionNotifier(config),
);
