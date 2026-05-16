import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:math_lingo/shared/painting/fraction_painter.dart';

void main() {
  group('FractionPainter — shouldRepaint', () {
    test('returns false when identical', () {
      const a = FractionPainter(numerator: 1, denominator: 4, isPie: true);
      const b = FractionPainter(numerator: 1, denominator: 4, isPie: true);
      expect(a.shouldRepaint(b), isFalse);
    });

    test('returns true on numerator change', () {
      const a = FractionPainter(numerator: 1, denominator: 4, isPie: true);
      const b = FractionPainter(numerator: 3, denominator: 4, isPie: true);
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true on denominator change', () {
      const a = FractionPainter(numerator: 1, denominator: 4, isPie: false);
      const b = FractionPainter(numerator: 1, denominator: 8, isPie: false);
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true on isPie change', () {
      const a = FractionPainter(numerator: 1, denominator: 2, isPie: true);
      const b = FractionPainter(numerator: 1, denominator: 2, isPie: false);
      expect(a.shouldRepaint(b), isTrue);
    });
  });

  group('FractionPainter — assertion guards', () {
    test('valid: numerator == denominator', () {
      expect(
        () => const FractionPainter(
          numerator: 4,
          denominator: 4,
          isPie: true,
        ),
        returnsNormally,
      );
    });

    test('valid: numerator == 0', () {
      expect(
        () => const FractionPainter(
          numerator: 0,
          denominator: 8,
          isPie: false,
        ),
        returnsNormally,
      );
    });
  });

  group('FractionPainter — paint does not throw', () {
    testWidgets('pie mode paints without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: FractionPainter(
                  numerator: 3,
                  denominator: 4,
                  isPie: true,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('bar mode paints without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 60,
              child: CustomPaint(
                painter: FractionPainter(
                  numerator: 5,
                  denominator: 8,
                  isPie: false,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
