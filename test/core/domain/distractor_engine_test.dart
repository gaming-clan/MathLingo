// B-03: Unit tests për DistractorEngine
// Verifikon: 0 opsione duplicate, saktësisht 1 e saktë,
// shpërndarje tipike e gabimeve pedagogjike.

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/domain/distractor_engine.dart';
import 'package:math_lingo/models/operation.dart';

void main() {
  group('DistractorEngine — kontrakta bazë', () {
    for (final op in Operation.values) {
      test('$op → gjithmonë 4 opsione unike, saktësisht 1 e saktë', () {
        final nums = {
          Operation.addition: (num1: 7, num2: 8, ans: 15),
          Operation.subtraction: (num1: 14, num2: 6, ans: 8),
          Operation.multiplication: (num1: 6, num2: 7, ans: 42),
          Operation.division: (num1: 24, num2: 4, ans: 6),
        };
        final n = nums[op]!;
        for (var seed = 0; seed < 50; seed++) {
          final opts = DistractorEngine.generateFor(
            operation: op,
            correctAnswer: n.ans,
            num1: n.num1,
            num2: n.num2,
            random: Random(seed),
          );
          // 4 opsione
          expect(opts.length, 4, reason: '$op seed=$seed');
          // Nuk ka duplikate
          expect(opts.toSet().length, 4, reason: '$op seed=$seed duplicate');
          // Saktësisht 1 e saktë
          expect(opts.where((o) => o == n.ans).length, 1,
              reason: '$op seed=$seed correct count');
          // Të gjitha pozitive
          expect(opts.every((o) => o > 0), isTrue,
              reason: '$op seed=$seed non-positive');
        }
      });
    }
  });

  group('DistractorEngine — 500 pyetje për çdo operacion', () {
    (
      int num1,
      int num2,
      int ans,
    ) _question(Operation op, Random r) {
      switch (op) {
        case Operation.addition:
          final a = r.nextInt(19) + 1;
          final b = r.nextInt(19) + 1;
          return (a, b, a + b);
        case Operation.subtraction:
          final a = r.nextInt(19) + 2;
          final b = r.nextInt(a - 1) + 1;
          return (a, b, a - b);
        case Operation.multiplication:
          final a = r.nextInt(11) + 1;
          final b = r.nextInt(11) + 1;
          return (a, b, a * b);
        case Operation.division:
          final ans = r.nextInt(11) + 1;
          final b = r.nextInt(11) + 1;
          return (ans * b, b, ans);
      }
    }

    for (final op in Operation.values) {
      test('$op — 500 pyetje: 0 duplicate, 1 e saktë, të gjitha pozitive', () {
        final rng = Random(999);
        for (var i = 0; i < 500; i++) {
          final q = _question(op, rng);
          final opts = DistractorEngine.generateFor(
            operation: op,
            correctAnswer: q.$3,
            num1: q.$1,
            num2: q.$2,
            random: rng,
          );
          expect(opts.length, 4,
              reason: '$op i=$i: expected 4 options, got ${opts.length}');
          expect(opts.toSet().length, 4,
              reason: '$op i=$i: duplicates found: $opts');
          expect(opts.where((o) => o == q.$3).length, 1,
              reason: '$op i=$i: correct answer count ≠ 1');
          expect(opts.every((o) => o > 0), isTrue,
              reason: '$op i=$i: non-positive option found: $opts');
        }
      });
    }
  });

  group('DistractorEngine — gabimet tipike pedagogjike janë të pranishme', () {
    test('mbledhja prodhon distractor nga harrim i kalimit', () {
      // 7+9=16 → distractor i pritshëm: 6 (vetëm njëshja)
      final found = <int>{};
      for (var s = 0; s < 200; s++) {
        final opts = DistractorEngine.generateFor(
          operation: Operation.addition,
          correctAnswer: 16,
          num1: 7,
          num2: 9,
          random: Random(s),
        );
        found.addAll(opts.where((o) => o != 16));
      }
      // 6 (njëshja e 16) duhet të shfaqet
      expect(found, contains(6));
    });

    test('shumëzimi prodhon distractor nga tabela ngjitur', () {
      // 7×8=56 → distractors: 7×7=49 ose 7×9=63
      final found = <int>{};
      for (var s = 0; s < 200; s++) {
        final opts = DistractorEngine.generateFor(
          operation: Operation.multiplication,
          correctAnswer: 56,
          num1: 7,
          num2: 8,
          random: Random(s),
        );
        found.addAll(opts.where((o) => o != 56));
      }
      expect(found, anyOf(contains(49), contains(63)));
    });

    test('zbritja prodhon distractor nga mbledhja e operandëve', () {
      // 9-3=6 → distractor: 9+3=12
      final found = <int>{};
      for (var s = 0; s < 200; s++) {
        final opts = DistractorEngine.generateFor(
          operation: Operation.subtraction,
          correctAnswer: 6,
          num1: 9,
          num2: 3,
          random: Random(s),
        );
        found.addAll(opts.where((o) => o != 6));
      }
      expect(found, contains(12));
    });
  });
}
