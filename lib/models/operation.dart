import 'package:flutter/material.dart';

enum Operation {
  addition('+', 'Mbledhje', Icons.add),
  subtraction('-', 'Zbritje', Icons.remove),
  multiplication('*', 'Shumëzim', Icons.close),
  division('/', 'Pjesëtim', Icons.percent);

  const Operation(this.symbol, this.label, this.icon);

  final String symbol;
  final String label;
  final IconData icon;

  String get displaySymbol {
    if (this == Operation.multiplication) return 'x';
    if (this == Operation.division) return '÷';
    return symbol;
  }
}