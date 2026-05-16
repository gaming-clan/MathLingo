import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/missing_x_question.dart';
import '../../features/missing_x/domain/missing_x_generator.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class MissingXState {
  const MissingXState({
    required this.question,
    required this.score,
    required this.answered,
    required this.correct,
    required this.sessionLength,
    this.selectedAnswer,
    this.isAnswerCorrect,
    this.isAdvancing = false,
  });

  final MissingXQuestion question;
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

  MissingXState copyWith({
    MissingXQuestion? question,
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
    return MissingXState(
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
// Config
// ---------------------------------------------------------------------------
class MissingXConfig {
  const MissingXConfig({
    this.sessionLength = 4,
    this.maxNumber = 20,
    required this.random,
  });

  final int sessionLength;
  final int maxNumber;
  final Random random;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissingXConfig &&
          sessionLength == other.sessionLength &&
          maxNumber == other.maxNumber &&
          identical(random, other.random);

  @override
  int get hashCode =>
      Object.hash(sessionLength, maxNumber, identityHashCode(random));
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class MissingXNotifier extends StateNotifier<MissingXState> {
  MissingXNotifier(this._config)
    : super(
        MissingXState(
          question: _generator.generate(
            _config.random,
            maxNumber: _config.maxNumber,
          ),
          score: 0,
          answered: 0,
          correct: 0,
          sessionLength: _config.sessionLength,
        ),
      );

  final MissingXConfig _config;
  static const _generator = MissingXGenerator();

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
        question: _generator.generate(
          _config.random,
          maxNumber: _config.maxNumber,
        ),
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
final missingXProvider = StateNotifierProvider.autoDispose
    .family<MissingXNotifier, MissingXState, MissingXConfig>(
  (ref, config) => MissingXNotifier(config),
);
