// D1: Unit tests për ChallengeNotifier
// Testojmë logjikën e biznesit pa hapje emulatori.

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/providers/challenge_provider.dart';
import 'package:math_lingo/models/operation.dart';

ChallengeNotifier _makeNotifier({
  Operation operation = Operation.addition,
  int sessionLength = 5,
  Random? random,
}) {
  final cfg = ChallengeConfig(
    operation: operation,
    sessionLength: sessionLength,
    random: random ?? Random(42),
  );
  return ChallengeNotifier(cfg);
}

void main() {
  group('ChallengeState helpers', () {
    test('isComplete false when answered < sessionLength', () {
      final n = _makeNotifier(sessionLength: 3);
      expect(n.state.isComplete, isFalse);
    });

    test('progress is 0 at start', () {
      final n = _makeNotifier(sessionLength: 4);
      expect(n.state.progress, 0.0);
    });

    test('accuracy is 0 at start', () {
      final n = _makeNotifier(sessionLength: 4);
      expect(n.state.accuracy, 0);
    });
  });

  group('checkAnswer — risposta corretta', () {
    test('score aumenta di 10 per risposta corretta', () {
      final n = _makeNotifier();
      final correctAnswer = n.state.question.answer;
      n.checkAnswer(correctAnswer);
      expect(n.state.score, 10);
    });

    test('answered aumenta di 1 per risposta corretta', () {
      final n = _makeNotifier();
      final correctAnswer = n.state.question.answer;
      n.checkAnswer(correctAnswer);
      expect(n.state.answered, 1);
    });

    test('isAnswerCorrect è true per risposta corretta', () {
      final n = _makeNotifier();
      final correctAnswer = n.state.question.answer;
      n.checkAnswer(correctAnswer);
      expect(n.state.isAnswerCorrect, isTrue);
    });

    test('isAdvancing diventa true dopo risposta corretta', () {
      final n = _makeNotifier();
      final correctAnswer = n.state.question.answer;
      n.checkAnswer(correctAnswer);
      expect(n.state.isAdvancing, isTrue);
    });

    test('selectedAnswer viene impostato', () {
      final n = _makeNotifier();
      final correctAnswer = n.state.question.answer;
      n.checkAnswer(correctAnswer);
      expect(n.state.selectedAnswer, correctAnswer);
    });
  });

  group('checkAnswer — risposta sbagliata', () {
    test('score rimane 0 per risposta sbagliata', () {
      final n = _makeNotifier();
      final wrongAnswer = n.state.question.answer + 99;
      n.checkAnswer(wrongAnswer);
      expect(n.state.score, 0);
    });

    test('answered rimane 0 per risposta sbagliata', () {
      final n = _makeNotifier();
      final wrongAnswer = n.state.question.answer + 99;
      n.checkAnswer(wrongAnswer);
      expect(n.state.answered, 0);
    });

    test('isAnswerCorrect è false per risposta sbagliata', () {
      final n = _makeNotifier();
      final wrongAnswer = n.state.question.answer + 99;
      n.checkAnswer(wrongAnswer);
      expect(n.state.isAnswerCorrect, isFalse);
    });

    test('isAdvancing rimane false per risposta sbagliata', () {
      final n = _makeNotifier();
      final wrongAnswer = n.state.question.answer + 99;
      n.checkAnswer(wrongAnswer);
      expect(n.state.isAdvancing, isFalse);
    });
  });

  group('advance()', () {
    test('advance resetta isAdvancing a false', () {
      final n = _makeNotifier();
      n.checkAnswer(n.state.question.answer);
      n.advance();
      expect(n.state.isAdvancing, isFalse);
    });

    test('advance resetta selectedAnswer a null', () {
      final n = _makeNotifier();
      n.checkAnswer(n.state.question.answer);
      n.advance();
      expect(n.state.selectedAnswer, isNull);
    });

    test('advance resetta isAnswerCorrect a null', () {
      final n = _makeNotifier();
      n.checkAnswer(n.state.question.answer);
      n.advance();
      expect(n.state.isAnswerCorrect, isNull);
    });

    test('advance gjeneron pyetje të re', () {
      final n = _makeNotifier();
      final q1 = n.state.question;
      n.checkAnswer(q1.answer);
      n.advance();
      // Pyetja ka të paktën options jo bosh dhe answer valid
      expect(n.state.question.options.length, 4);
      expect(n.state.question.answer, greaterThan(0));
    });
  });

  group('isComplete & accuracy', () {
    test('isComplete true pas sessionLength pyetjeve të sakta', () {
      final n = _makeNotifier(sessionLength: 2);
      for (var i = 0; i < 2; i++) {
        n.checkAnswer(n.state.question.answer);
        if (!n.state.isComplete) n.advance();
      }
      expect(n.state.isComplete, isTrue);
    });

    test('accuracy 100% kur të gjitha janë të sakta', () {
      final n = _makeNotifier(sessionLength: 2);
      for (var i = 0; i < 2; i++) {
        n.checkAnswer(n.state.question.answer);
        if (!n.state.isComplete) n.advance();
      }
      expect(n.state.accuracy, 100);
    });
  });

  group('zbritja — nuk prodhon numra negativë', () {
    test('num1 >= num2 për zbritje', () {
      final n = _makeNotifier(operation: Operation.subtraction, sessionLength: 20);
      // Testo 20 pyetje të gjeneruara
      for (var i = 0; i < 20; i++) {
        expect(
          n.state.question.answer,
          greaterThanOrEqualTo(0),
          reason: 'Zbritja nuk duhet të japë rezultat negativ',
        );
        n.checkAnswer(n.state.question.answer);
        if (!n.state.isComplete) n.advance();
      }
    });
  });

  group('pjesëtimi — i saktë pa mbetje', () {
    test('num1 % num2 == 0 për pjesëtim', () {
      final n = _makeNotifier(operation: Operation.division, sessionLength: 20);
      for (var i = 0; i < 20; i++) {
        final q = n.state.question;
        expect(
          q.num1 % q.num2,
          0,
          reason: 'Pjesëtimi duhet të jetë i saktë (pa mbetje)',
        );
        n.checkAnswer(q.answer);
        if (!n.state.isComplete) n.advance();
      }
    });
  });

  group('checkAnswer ignored kur isAdvancing = true', () {
    test('nuk mbi-shkruan state kur isAdvancing', () {
      final n = _makeNotifier();
      n.checkAnswer(n.state.question.answer); // i saktë → isAdvancing=true
      final scoreAfterFirst = n.state.score;
      n.checkAnswer(n.state.question.answer); // injorohet
      expect(n.state.score, scoreAfterFirst); // nuk ndryshon
    });
  });

  group('Riverpod provider integration', () {
    test('challengeProvider krijon ChallengeState me random të fiksuar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cfg = ChallengeConfig(
        operation: Operation.addition,
        sessionLength: 3,
        random: Random(7),
      );

      final state = container.read(challengeProvider(cfg));
      expect(state.score, 0);
      expect(state.answered, 0);
      expect(state.sessionLength, 3);
      expect(state.question.options.length, 4);
      expect(state.question.options, contains(state.question.answer));
    });

    test('challengeProvider.notifier.checkAnswer azhurnon state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cfg = ChallengeConfig(
        operation: Operation.addition,
        sessionLength: 3,
        random: Random(7),
      );

      final notifier = container.read(challengeProvider(cfg).notifier);
      final correctAnswer = container.read(challengeProvider(cfg)).question.answer;
      notifier.checkAnswer(correctAnswer);

      expect(container.read(challengeProvider(cfg)).score, 10);
    });
  });
}
