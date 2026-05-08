import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../models/geometry_shape.dart';
import '../../../shared/widgets/glass_panel.dart';

/// Panel referimi statik me formulat e 3 formave gjeometrike.
/// Karta e formës aktuale theksohet me border magenta.
class FormulaReferencePanel extends StatelessWidget {
  const FormulaReferencePanel({super.key, required this.activeShape});

  final GeometryShape activeShape;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titulli
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CosmicColors.tertiaryContainer.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CosmicColors.tertiaryContainer.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 14,
                    color: CosmicColors.tertiaryContainer,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Formulas',
                    style: TextStyle(
                      color: CosmicColors.tertiaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _FormulaCard(
                shape: GeometryShape.rectangle,
                isActive: activeShape == GeometryShape.rectangle,
              ),
              const SizedBox(height: 12),
              _FormulaCard(
                shape: GeometryShape.triangle,
                isActive: activeShape == GeometryShape.triangle,
              ),
              const SizedBox(height: 12),
              _FormulaCard(
                shape: GeometryShape.square,
                isActive: activeShape == GeometryShape.square,
              ),
              const SizedBox(height: 12),
              _FormulaCard(
                shape: GeometryShape.circle,
                isActive: activeShape == GeometryShape.circle,
              ),
              const SizedBox(height: 12),
              _FormulaCard(
                shape: GeometryShape.parallelogram,
                isActive: activeShape == GeometryShape.parallelogram,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.shape, required this.isActive});

  final GeometryShape shape;
  final bool isActive;

  String get _formula {
    switch (shape) {
      case GeometryShape.rectangle:
        return 'S = g × l';
      case GeometryShape.triangle:
        return 'S = (b × h) ÷ 2';
      case GeometryShape.square:
        return 'P = b × 4';
      case GeometryShape.circle:
        return 'P = 2 × π × r';
      case GeometryShape.parallelogram:
        return 'S = b × h';
    }
  }

  String get _explanation {
    switch (shape) {
      case GeometryShape.rectangle:
        return 'gjerësia × lartësia';
      case GeometryShape.triangle:
        return 'baza × lartësia, pjesëtuar 2';
      case GeometryShape.square:
        return 'baza × 4 (katrori ka 4 anë të barabarta)';
      case GeometryShape.circle:
        return '2 × π × rrezja (në këtë modul, π ≈ 3)';
      case GeometryShape.parallelogram:
        return 'baza × lartësia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? CosmicColors.tertiaryContainer
        : const Color(0x1FEEEBFF);
    final bgColor = isActive
        ? CosmicColors.tertiaryContainer.withValues(alpha: 0.08)
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isActive ? 1.5 : 0.5),
      ),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _ShapeIcon(shape: shape, size: 48, isActive: isActive),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shape.label,
                    style: TextStyle(
                      color: isActive
                          ? CosmicColors.tertiary
                          : CosmicColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formula,
                    style: TextStyle(
                      color: isActive
                          ? CosmicColors.tertiaryContainer
                          : CosmicColors.secondaryContainer,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _explanation,
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vizatim i vogël i formës me CustomPainter.
class _ShapeIcon extends StatelessWidget {
  const _ShapeIcon({
    required this.shape,
    required this.size,
    required this.isActive,
  });

  final GeometryShape shape;
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? CosmicColors.tertiaryContainer
        : CosmicColors.secondaryContainer;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MiniShapePainter(shape: shape, color: color),
      ),
    );
  }
}

class _MiniShapePainter extends CustomPainter {
  _MiniShapePainter({required this.shape, required this.color});

  final GeometryShape shape;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final w = size.width;
    final h = size.height;

    switch (shape) {
      case GeometryShape.rectangle:
        final rect = Rect.fromLTWH(w * 0.1, h * 0.2, w * 0.8, h * 0.6);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, stroke);
      case GeometryShape.triangle:
        final path = Path()
          ..moveTo(w / 2, h * 0.1)
          ..lineTo(w * 0.9, h * 0.85)
          ..lineTo(w * 0.1, h * 0.85)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
      case GeometryShape.square:
        final side = math.min(w, h) * 0.7;
        final rect = Rect.fromCenter(
          center: Offset(w / 2, h / 2),
          width: side,
          height: side,
        );
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, stroke);
      case GeometryShape.circle:
        final radius = math.min(w, h) * 0.35;
        canvas.drawCircle(Offset(w / 2, h / 2), radius, paint);
        canvas.drawCircle(Offset(w / 2, h / 2), radius, stroke);
      case GeometryShape.parallelogram:
        final path = Path()
          ..moveTo(w * 0.25, h * 0.2)
          ..lineTo(w * 0.9, h * 0.2)
          ..lineTo(w * 0.75, h * 0.8)
          ..lineTo(w * 0.1, h * 0.8)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(_MiniShapePainter old) =>
      old.shape != shape || old.color != color;
}
