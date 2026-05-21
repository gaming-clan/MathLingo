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

    // D-01: respekto raportin e dimensioneve të pyetjes në forma me gjerësi/lartësi.
    double rectW = shapeWidth;
    double rectH = shapeHeight;
    if ((question.shape == GeometryShape.rectangle ||
            question.shape == GeometryShape.triangle ||
            question.shape == GeometryShape.parallelogram) &&
        question.width > 0 &&
        question.height > 0) {
      final aspectRatio = question.width / question.height;
      if (aspectRatio > shapeWidth / shapeHeight) {
        // gjerësi > lartësi → kufizo sipas gjerësisë
        rectW = shapeWidth;
        rectH = shapeWidth / aspectRatio;
      } else {
        // lartësi > gjerësi (ose e barabartë) → kufizo sipas lartësisë
        rectH = shapeHeight;
        rectW = shapeHeight * aspectRatio;
      }
    }

    final rect = Rect.fromCenter(
      center: center,
      width: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : rectW,
      height: question.shape == GeometryShape.square
          ? min(shapeWidth, shapeHeight)
          : rectH,
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
        final triangleRect = Rect.fromCenter(
          center: center,
          width: rectW,
          height: rectH,
        );
        final path = Path()
          ..moveTo(center.dx, triangleRect.top)
          ..lineTo(triangleRect.right, triangleRect.bottom)
          ..lineTo(triangleRect.left, triangleRect.bottom)
          ..close();
        canvas.drawPath(path, glow);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
      case GeometryShape.circle:
        final radius = min(rect.width, rect.height) / 2;
        canvas.drawCircle(center, radius, glow);
        canvas.drawCircle(center, radius, paint);
        canvas.drawCircle(center, radius, stroke);
      case GeometryShape.parallelogram:
        final skew = rect.width * 0.18;
        final path = Path()
          ..moveTo(rect.left + skew, rect.top)
          ..lineTo(rect.right, rect.top)
          ..lineTo(rect.right - skew, rect.bottom)
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
