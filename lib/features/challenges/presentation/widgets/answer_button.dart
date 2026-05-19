import 'package:flutter/material.dart';

import '../../../../colors.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.value,
    required this.color,
    required this.onPressed,
  });

  final num value;
  final Color color;
  final VoidCallback onPressed;

  String get _displayValue {
    if (value is int) return value.toString();
    final d = value.toDouble();
    if (d == d.roundToDouble()) {
      return d.toInt().toString();
    }
    return d.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: CosmicColors.onSurface,
        side: BorderSide(color: color.withValues(alpha: 0.7), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: color.withValues(alpha: 0.14),
      ),
      onPressed: onPressed,
      child: Text(
        _displayValue,
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}