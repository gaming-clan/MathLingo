import 'geometry_shape.dart';

enum GeometryCalculationType {
  area,
  perimeter,
}

class GeometryQuestion {
  const GeometryQuestion({
    required this.shape,
    required this.calculationType,
    required this.prompt,
    required this.measurement,
    required this.answer,
    required this.options,
    required this.width,
    required this.height,
  });

  final GeometryShape shape;
  final GeometryCalculationType calculationType;
  final String prompt;
  final String measurement;
  final double answer;
  final List<double> options;
  final int width;
  final int height;
}