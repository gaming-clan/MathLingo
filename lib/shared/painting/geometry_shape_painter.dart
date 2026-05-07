import 'dart:math';

import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../models/geometry_question.dart';
import '../../models/geometry_shape.dart';

class GeometryShapePainter extends CustomPainter {
  GeometryShapePainter(this.question);

  final GeometryQuestion question;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CosmicColors.secondaryContainer.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = CosmicColors.secondaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = CosmicColors.primaryContainer.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final center = Offset(size.width / 2, size.height / 2);
    final shapeWidth = size.width * 0.62;
    final shapeHeight = size.height * 0.58;
    final rect = Rect.fromCenter(
      center: center,
      width: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : shapeWidth,
      height: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : shapeHeight,
    );

    switch (question.shape) {
      case GeometryShape.rectangle:
      case GeometryShape.square:
        final rounded = RRect.fromRectAndRadius(
          rect,
          const Radius.circular(18),
        );
        canvas.drawRRect(rounded, glow);
        canvas.drawRRect(rounded, paint);
        canvas.drawRRect(rounded, stroke);
      case GeometryShape.triangle:
        final path = Path()
          ..moveTo(center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, glow);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant GeometryShapePainter oldDelegate) {
    return oldDelegate.question != question;
  }
}