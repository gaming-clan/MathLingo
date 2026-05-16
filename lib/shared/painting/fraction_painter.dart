import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../colors.dart';

/// CustomPainter për vizualizimin e fraksioneve.
///
/// Mbështet dy mënyra:
/// - `pie` — tarte e rrumbullakët me seksion të ngjyrosur.
/// - `bar` — shirit horizontal i ndarë në [denominator] qeliza.
class FractionPainter extends CustomPainter {
  const FractionPainter({
    required this.numerator,
    required this.denominator,
    required this.isPie,
  }) : assert(denominator > 0 && numerator >= 0 && numerator <= denominator);

  final int numerator;
  final int denominator;

  /// `true` → pie, `false` → bar.
  final bool isPie;

  @override
  void paint(Canvas canvas, Size size) {
    if (isPie) {
      _drawPie(canvas, size);
    } else {
      _drawBar(canvas, size);
    }
  }

  void _drawPie(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;

    final paintFilled = Paint()
      ..color = CosmicColors.secondaryContainer
      ..style = PaintingStyle.fill;

    final paintEmpty = Paint()
      ..color = CosmicColors.surfaceLow
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = CosmicColors.secondaryContainer.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const startAngle = -math.pi / 2; // fillon nga lart
    final sweepFilled = 2 * math.pi * numerator / denominator;
    final sweepEmpty = 2 * math.pi - sweepFilled;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Pjesa e zbrazët
    if (sweepEmpty > 0) {
      canvas.drawArc(rect, startAngle + sweepFilled, sweepEmpty, true, paintEmpty);
    }
    // Pjesa e ngjyrosur
    if (sweepFilled > 0) {
      canvas.drawArc(rect, startAngle, sweepFilled, true, paintFilled);
    }
    // Vijat ndarëse
    for (int i = 0; i < denominator; i++) {
      final angle = startAngle + 2 * math.pi * i / denominator;
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(dx, dy), paintStroke);
    }
    // Konturi
    canvas.drawCircle(center, radius, paintStroke);
  }

  void _drawBar(Canvas canvas, Size size) {
    final cellWidth = size.width / denominator;
    final cellHeight = size.height;
    const gap = 3.0;
    const radius = Radius.circular(4);

    final paintFilled = Paint()
      ..color = CosmicColors.secondaryContainer
      ..style = PaintingStyle.fill;

    final paintEmpty = Paint()
      ..color = CosmicColors.surfaceLow
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = CosmicColors.secondaryContainer.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < denominator; i++) {
      final left = i * cellWidth + gap / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, cellWidth - gap, cellHeight),
        radius,
      );
      canvas.drawRRect(rect, i < numerator ? paintFilled : paintEmpty);
      canvas.drawRRect(rect, paintStroke);
    }
  }

  @override
  bool shouldRepaint(FractionPainter old) =>
      old.numerator != numerator ||
      old.denominator != denominator ||
      old.isPie != isPie;
}
