import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:math_lingo/shared/painting/multiplication_grid_painter.dart';

void main() {
  group('MultiplicationGridPainter — shouldRepaint', () {
    test('returns false when identical', () {
      const a = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 2);
      const b = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 2);
      expect(a.shouldRepaint(b), isFalse);
    });

    test('returns true on rows change', () {
      const a = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 2);
      const b = MultiplicationGridPainter(rows: 5, cols: 4, animatedCols: 2);
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true on cols change', () {
      const a = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 2);
      const b = MultiplicationGridPainter(rows: 3, cols: 6, animatedCols: 2);
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true on animatedCols change', () {
      const a = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 1);
      const b = MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 3);
      expect(a.shouldRepaint(b), isTrue);
    });
  });

  group('MultiplicationGridPainter — assertion guards', () {
    test('animatedCols == 0 is valid', () {
      expect(
        () => const MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 0),
        returnsNormally,
      );
    });

    test('animatedCols == cols is valid', () {
      expect(
        () => const MultiplicationGridPainter(rows: 3, cols: 4, animatedCols: 4),
        returnsNormally,
      );
    });
  });

  group('MultiplicationGridPainter — paint does not throw', () {
    testWidgets('paints 3x4 grid without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 240,
              height: 160,
              child: CustomPaint(
                painter: MultiplicationGridPainter(
                  rows: 3,
                  cols: 4,
                  animatedCols: 2,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('paints fully animated grid', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: CustomPaint(
                painter: MultiplicationGridPainter(
                  rows: 5,
                  cols: 5,
                  animatedCols: 5,
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
