import 'package:flutter/material.dart';

enum GeometryShape {
  rectangle('Drejtkëndësh', Icons.crop_square),
  triangle('Trekëndësh', Icons.change_history),
  square('Katror', Icons.square_outlined),
  circle('Rreth', Icons.circle_outlined),
  parallelogram('Paralelogram', Icons.polyline);

  const GeometryShape(this.label, this.icon);

  final String label;
  final IconData icon;
}
