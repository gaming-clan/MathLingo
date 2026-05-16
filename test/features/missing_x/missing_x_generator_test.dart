// C-01/C-02: Unit tests për MissingXGenerator
// Verifikon: pyetje të vlefshme matematikisht, opsione plausible,
// mbulim i të gjitha llojeve.

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/missing_x/domain/missing_x_generator.dart';
import 'package:math_lingo/models/missing_x_question.dart';

void main() {
  const generator = MissingXGenerator();

  group('MissingXGenerator — kontrakta bazë', () {
    test('gjeneron pyetje me 4 opsione unike dhe përgjigjen korrekte', () {
      for (var i = 0; i < 100; i++) {
        final q = generator.generate(Random(i));
        expect(q.options.length, 4, reason: 'seed $i: options.length != 4');
        expect(q.options.toSet().length, 4,
            reason: 'seed $i: duplicates found');
        expect(q.options, contains(q.answer),
            reason: 'seed $i: correct answer not in options');
        expect(q.options.every((o) => o > 0), isTrue,
            reason: 'seed $i: non-positive option found');
      }
    });

    test('answer > 0 gjithmonë', () {
      for (var i = 0; i < 200; i++) {
        final q = generator.generate(Random(i + 50));
        expect(q.answer, greaterThan(0), reason: 'seed ${i + 50}');
      }
    });

    test('result > 0 gjithmonë', () {
      for (var i = 0; i < 200; i++) {
        final q = generator.generate(Random(i + 100));
        expect(q.result, greaterThan(0));
      }
    });
  });

  group('MissingXGenerator — saktësia matematikore', () {
    test('addMissingAddend: knownNum + answer == result', () {
      for (var i = 0; i < 300; i++) {
        final q = generator.generate(Random(i));
        if (q.type == MissingXType.addMissingAddend) {
          expect(q.knownNum + q.answer, q.result,
              reason: 'seed $i: ${q.knownNum} + ${q.answer} != ${q.result}');
        }
      }
    });

    test('multMissingFactor: answer × knownNum == result', () {
      for (var i = 0; i < 300; i++) {
        final q = generator.generate(Random(i));
        if (q.type == MissingXType.multMissingFactor) {
          expect(q.answer * q.knownNum, q.result,
              reason:
                  'seed $i: ${q.answer} × ${q.knownNum} != ${q.result}');
        }
      }
    });

    test('subMissingSubtrahend: knownNum - answer == result', () {
      for (var i = 0; i < 300; i++) {
        final q = generator.generate(Random(i));
        if (q.type == MissingXType.subMissingSubtrahend) {
          expect(q.knownNum - q.answer, q.result,
              reason: 'seed $i: ${q.knownNum} - ${q.answer} != ${q.result}');
          // Pa rezultat negativ
          expect(q.result, greaterThan(0));
        }
      }
    });
  });

  group('MissingXGenerator — mbulim i tipeve', () {
    test('të gjitha 3 llojet shfaqen në 300 pyetje', () {
      final seen = <MissingXType>{};
      for (var i = 0; i < 300; i++) {
        seen.add(generator.generate(Random(i + 200)).type);
      }
      expect(seen, contains(MissingXType.addMissingAddend));
      expect(seen, contains(MissingXType.multMissingFactor));
      expect(seen, contains(MissingXType.subMissingSubtrahend));
    });
  });

  group('MissingXQuestion — leftDisplay/rightDisplay', () {
    test('addMissingAddend shfaq formatin korrekt', () {
      final q = MissingXQuestion(
        type: MissingXType.addMissingAddend,
        knownNum: 5,
        result: 12,
        answer: 7,
        options: [7, 4, 8, 6],
      );
      expect(q.leftDisplay, '5 + ');
      expect(q.rightDisplay, ' = 12');
    });

    test('multMissingFactor shfaq formatin korrekt', () {
      final q = MissingXQuestion(
        type: MissingXType.multMissingFactor,
        knownNum: 4,
        result: 20,
        answer: 5,
        options: [5, 4, 6, 3],
      );
      expect(q.leftDisplay, '');
      expect(q.rightDisplay, ' × 4 = 20');
    });
  });
}
