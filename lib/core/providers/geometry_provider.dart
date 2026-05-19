import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/geometry/domain/geometry_question_generator.dart';
import '../../models/geometry_question.dart';
import '../../models/geometry_shape.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class GeometryState {
  const GeometryState({
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

  final GeometryQuestion question;
  final int score;
  final int answered;
  final int correct;
  final int sessionLength;
  final double? selectedAnswer;
  final bool? isAnswerCorrect;
  final bool isAdvancing;
  final bool hadWrongAttemptOnCurrent;

  bool get isComplete => answered >= sessionLength;
  double get progress => sessionLength > 0 ? answered / sessionLength : 0;
  int get accuracy =>
      sessionLength > 0 ? ((correct / sessionLength) * 100).round() : 0;

  GeometryState copyWith({
    GeometryQuestion? question,
    int? score,
    int? answered,
    int? correct,
    int? sessionLength,
    double? selectedAnswer,
    bool? clearSelectedAnswer,
    bool? isAnswerCorrect,
    bool? clearIsAnswerCorrect,
    bool? isAdvancing,
    bool? hadWrongAttemptOnCurrent,
  }) {
    return GeometryState(
      question: question ?? this.question,
      score: score ?? this.score,
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      sessionLength: sessionLength ?? this.sessionLength,
      selectedAnswer: clearSelectedAnswer == true
          ? null
          : selectedAnswer ?? this.selectedAnswer,
      isAnswerCorrect: clearIsAnswerCorrect == true
          ? null
          : isAnswerCorrect ?? this.isAnswerCorrect,
      isAdvancing: isAdvancing ?? this.isAdvancing,
      hadWrongAttemptOnCurrent:
          hadWrongAttemptOnCurrent ?? this.hadWrongAttemptOnCurrent,
    );
  }
}

// ---------------------------------------------------------------------------
// Config (family key)
// ---------------------------------------------------------------------------
class GeometryConfig {
  const GeometryConfig({this.sessionLength = 4, required this.random});

  final int sessionLength;
  final Random random;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeometryConfig &&
          sessionLength == other.sessionLength &&
          identical(random, other.random);

  @override
  int get hashCode => Object.hash(sessionLength, identityHashCode(random));
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class GeometryNotifier extends StateNotifier<GeometryState> {
  GeometryNotifier(this._config)
    : super(
        GeometryState(
          question: _generator.generate(_config.random),
          score: 0,
          answered: 0,
          correct: 0,
          sessionLength: _config.sessionLength,
        ),
      );

  final GeometryConfig _config;
  static const GeometryQuestionGenerator _generator =
      GeometryQuestionGenerator();

  GeometryShape? _lastShape;
  GeometryCalculationType? _lastCalcType;

  GeometryQuestion _nextQuestion() {
    GeometryQuestion q;
    var tries = 0;
    do {
      q = _generator.generate(_config.random);
      tries++;
    } while (
      tries < 10 &&
      q.shape == _lastShape &&
      q.calculationType == _lastCalcType
    );
    _lastShape = q.shape;
    _lastCalcType = q.calculationType;
    return q;
  }

  void checkAnswer(double answer) {
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
        question: _nextQuestion(),
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
final geometryProvider = StateNotifierProvider.autoDispose
    .family<GeometryNotifier, GeometryState, GeometryConfig>(
      (ref, config) => GeometryNotifier(config),
    );
