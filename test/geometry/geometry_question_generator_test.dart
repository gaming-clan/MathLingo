import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/geometry/domain/geometry_question_generator.dart';
import 'package:math_lingo/models/geometry_question.dart';
import 'package:math_lingo/models/geometry_shape.dart';

void main() {
  const generator = GeometryQuestionGenerator();

  int expectedAnswer(
    GeometryShape shape,
    GeometryCalculationType calculationType,
    int width,
    int height,
  ) {
    switch (shape) {
      case GeometryShape.rectangle:
        return calculationType == GeometryCalculationType.area
            ? width * height
            : 2 * (width + height);
      case GeometryShape.triangle:
        return (width * height) ~/ 2;
      case GeometryShape.square:
        return calculationType == GeometryCalculationType.area
            ? width * width
            : width * 4;
      case GeometryShape.circle:
        return width * 6;
      case GeometryShape.parallelogram:
        return width * height;
    }
  }

  test('gjeneron pyetje me 4 opsione dhe pergjigjen korrekte te perfshire', () {
    final q = generator.generate(Random(4));
    expect(q.options.length, 4);
    expect(q.options, contains(q.answer));
    expect(q.options.toSet().length, 4);
  });

  test('opsionet jane gjithmone pozitive', () {
    for (var i = 0; i < 50; i++) {
      final q = generator.generate(Random(i + 1));
      expect(q.options.every((o) => o > 0), isTrue);
    }
  });

  test('formula e pergjigjes eshte korrekte per cdo forme', () {
    for (var i = 0; i < 120; i++) {
      final q = generator.generate(Random(i + 11));
      expect(
        q.answer,
        expectedAnswer(q.shape, q.calculationType, q.width, q.height),
      );
    }
  });

  test('drejtkendeshi dhe katrori mund te dalin si sipërfaqe ose perimeter', () {
    final seenRectangleTypes = <GeometryCalculationType>{};
    final seenSquareTypes = <GeometryCalculationType>{};

    for (var i = 0; i < 400; i++) {
      final q = generator.generate(Random(i + 31));
      if (q.shape == GeometryShape.rectangle) {
        seenRectangleTypes.add(q.calculationType);
      }
      if (q.shape == GeometryShape.square) {
        seenSquareTypes.add(q.calculationType);
      }
    }

    expect(seenRectangleTypes, contains(GeometryCalculationType.area));
    expect(seenRectangleTypes, contains(GeometryCalculationType.perimeter));
    expect(seenSquareTypes, contains(GeometryCalculationType.area));
    expect(seenSquareTypes, contains(GeometryCalculationType.perimeter));
  });
}
