import 'package:flutter/material.dart';

enum GeometryShape {
  rectangle('Drejtkëndësh', Icons.crop_square),
  triangle('Trekëndësh', Icons.change_history),
  square('Katror', Icons.square_outlined);

  const GeometryShape(this.label, this.icon);

  final String label;
  final IconData icon;
}