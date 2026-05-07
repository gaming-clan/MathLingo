import 'geometry_shape.dart';

class GeometryQuestion {
  const GeometryQuestion({
    required this.shape,
    required this.prompt,
    required this.measurement,
    required this.answer,
    required this.options,
    required this.width,
    required this.height,
  });

  final GeometryShape shape;
  final String prompt;
  final String measurement;
  final int answer;
  final List<int> options;
  final int width;
  final int height;
}