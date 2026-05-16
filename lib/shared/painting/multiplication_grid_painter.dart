import 'package:flutter/material.dart';

import '../../colors.dart';

/// CustomPainter për vizualizimin e shumëzimit me grilë N×M.
///
/// Vizaton [rows] × [cols] qeliza; kolonat 0..[animatedCols)-1 janë të ngjyrosura cyan.
/// Integrohet me `AnimatedBuilder` për animacion gradual.
///
/// Shembull përdorimi:
/// ```dart
/// AnimatedBuilder(
///   animation: _colAnimation, // 0.0 → cols.toDouble()
///   builder: (_, __) => CustomPaint(
///     size: const Size(240, 160),
///     painter: MultiplicationGridPainter(
///       rows: 3,
///       cols: 4,
///       animatedCols: _colAnimation.value.round(),
///     ),
///   ),
/// );
/// ```
class MultiplicationGridPainter extends CustomPainter {
  const MultiplicationGridPainter({
    required this.rows,
    required this.cols,
    required this.animatedCols,
  })  : assert(rows > 0 && cols > 0),
        assert(animatedCols >= 0 && animatedCols <= cols);

  final int rows;
  final int cols;

  /// Sa kolona janë aktive (të ngjyrosura) deri tani.
  final int animatedCols;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 4.0;
    const cellRadius = Radius.circular(5);

    final cellW = (size.width - gap * (cols - 1)) / cols;
    final cellH = (size.height - gap * (rows - 1)) / rows;

    final paintFilled = Paint()
      ..color = CosmicColors.secondaryContainer
      ..style = PaintingStyle.fill;

    final paintEmpty = Paint()
      ..color = CosmicColors.surfaceLow
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = CosmicColors.secondaryContainer.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int c = 0; c < cols; c++) {
      final isFilled = c < animatedCols;
      for (int r = 0; r < rows; r++) {
        final left = c * (cellW + gap);
        final top = r * (cellH + gap);
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, cellW, cellH),
          cellRadius,
        );
        canvas.drawRRect(rect, isFilled ? paintFilled : paintEmpty);
        canvas.drawRRect(rect, paintStroke);
      }
    }
  }

  @override
  bool shouldRepaint(MultiplicationGridPainter old) =>
      old.rows != rows ||
      old.cols != cols ||
      old.animatedCols != animatedCols;
}
