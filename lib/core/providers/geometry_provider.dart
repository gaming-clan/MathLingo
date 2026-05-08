import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  });

  final GeometryQuestion question;
  final int score;
  final int answered;
  final int correct;
  final int sessionLength;
  final int? selectedAnswer;
  final bool? isAnswerCorrect;
  final bool isAdvancing;

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
    int? selectedAnswer,
    bool? clearSelectedAnswer,
    bool? isAnswerCorrect,
    bool? clearIsAnswerCorrect,
    bool? isAdvancing,
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
          question: _buildQuestion(_config.random),
          score: 0,
          answered: 0,
          correct: 0,
          sessionLength: _config.sessionLength,
        ),
      );

  final GeometryConfig _config;

  static GeometryQuestion _buildQuestion(Random random) {
    final shape =
        GeometryShape.values[random.nextInt(GeometryShape.values.length)];
    late int width;
    late int height;
    late int answer;

    switch (shape) {
      case GeometryShape.rectangle:
        width = random.nextInt(7) + 3;
        height = random.nextInt(6) + 2;
        answer = width * height;
      case GeometryShape.triangle:
        width = (random.nextInt(5) + 3) * 2;
        height = random.nextInt(6) + 2;
        answer = (width * height) ~/ 2;
      case GeometryShape.square:
        width = random.nextInt(8) + 3;
        height = width;
        answer = width * 4;
      case GeometryShape.circle:
        width = random.nextInt(7) + 2; // radius
        height = width;
        answer = width * 6; // 2 * pi * r with pi ~= 3
      case GeometryShape.parallelogram:
        width = random.nextInt(8) + 3;
        height = random.nextInt(6) + 2;
        answer = width * height;
    }

    return GeometryQuestion(
      shape: shape,
      prompt: '',
      measurement: '',
      answer: answer,
      options: _buildOptions(answer, random),
      width: width,
      height: height,
    );
  }

  static List<int> _buildOptions(int correctAnswer, Random random) {
    final options = <int>{correctAnswer};
    while (options.length < 4) {
      var offset = random.nextInt(14) - 7;
      if (offset == 0) offset = 2;
      final wrong = correctAnswer + offset;
      if (wrong > 0) options.add(wrong);
    }
    return options.toList()..shuffle(random);
  }

  void checkAnswer(int answer) {
    if (state.isAdvancing) return;

    final isCorrect = answer == state.question.answer;

    if (isCorrect) {
      state = state.copyWith(
        selectedAnswer: answer,
        isAnswerCorrect: true,
        score: state.score + 15,
        correct: state.correct + 1,
        answered: state.answered + 1,
        isAdvancing: true,
      );
    } else {
      state = state.copyWith(selectedAnswer: answer, isAnswerCorrect: false);
    }
  }

  void advance() {
    if (!state.isComplete) {
      state = state.copyWith(
        question: _buildQuestion(_config.random),
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
final geometryProvider = StateNotifierProvider.autoDispose
    .family<GeometryNotifier, GeometryState, GeometryConfig>(
      (ref, config) => GeometryNotifier(config),
    );
