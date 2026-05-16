import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../models/geometry_question.dart';
import '../../models/geometry_shape.dart';

/// Chip hint që shfaqet fade-in pas 8 sekondash inaktiviteti.
/// Tregon formulën e formës aktuale. Fade-out pas 4 sekondash.
/// Vetëm 1 hint per pyetje. Nuk ndikon në skor.
class GeometryHintChip extends StatelessWidget {
  const GeometryHintChip({
    super.key,
    required this.shape,
    required this.calculationType,
    required this.visible,
  });

  final GeometryShape shape;
  final GeometryCalculationType calculationType;
  final bool visible;

  String _hintText() {
    switch (shape) {
      case GeometryShape.rectangle:
        switch (calculationType) {
          case GeometryCalculationType.area:
            return 'Këshillë: S = gjerësia × lartësia';
          case GeometryCalculationType.perimeter:
            return 'Këshillë: P = 2 × (gjerësia + lartësia)';
        }
      case GeometryShape.triangle:
        return 'Këshillë: S = baza × lartësia ÷ 2';
      case GeometryShape.square:
        switch (calculationType) {
          case GeometryCalculationType.area:
            return 'Këshillë: S = brinja × brinja';
          case GeometryCalculationType.perimeter:
            return 'Këshillë: P = brinja × 4';
        }
      case GeometryShape.circle:
        return 'Këshillë: Perimetri = 2 × π × r (π ≈ 3)';
      case GeometryShape.parallelogram:
        return 'Këshillë: S = baza × lartësia';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !visible,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: CosmicColors.secondaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: CosmicColors.secondaryContainer.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: CosmicColors.secondaryContainer.withValues(alpha: 0.2),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: CosmicColors.secondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                _hintText(),
                style: const TextStyle(
                  color: CosmicColors.secondaryContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
