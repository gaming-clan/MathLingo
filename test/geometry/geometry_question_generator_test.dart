import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/geometry/domain/geometry_question_generator.dart';
import 'package:math_lingo/models/geometry_question.dart';
import 'package:math_lingo/models/geometry_shape.dart';

void main() {
  const generator = GeometryQuestionGenerator();

  double roundToOneDecimal(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  double expectedAnswer(
    GeometryShape shape,
    GeometryCalculationType calculationType,
    int width,
    int height,
  ) {
    switch (shape) {
      case GeometryShape.rectangle:
        return roundToOneDecimal(
          calculationType == GeometryCalculationType.area
              ? (width * height).toDouble()
              : (2 * (width + height)).toDouble(),
        );
      case GeometryShape.triangle:
        return roundToOneDecimal((width * height) / 2);
      case GeometryShape.square:
        return roundToOneDecimal(
          calculationType == GeometryCalculationType.area
              ? (width * width).toDouble()
              : (width * 4).toDouble(),
        );
      case GeometryShape.circle:
        return roundToOneDecimal(
          calculationType == GeometryCalculationType.perimeter
              ? 2 * pi * width
              : pi * width * width,
        );
      case GeometryShape.parallelogram:
        return roundToOneDecimal((width * height).toDouble());
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
        moreOrLessEquals(
          expectedAnswer(
            q.shape,
            q.calculationType,
            q.width,
            q.height,
          ),
          epsilon: 0.0001,
        ),
      );
    }
  });

  test('trekendeshi gjenerohet me brinje valide sipas pabarazise', () {
    for (var i = 0; i < 250; i++) {
      final q = generator.generate(Random(i + 101));
      if (q.shape != GeometryShape.triangle) continue;

      final numbers = RegExp(r'\d+')
          .allMatches(q.measurement)
          .map((m) => int.parse(m.group(0)!))
          .toList();

      expect(numbers.length, 3);
      final a = numbers[0];
      final b = numbers[1];
      final c = numbers[2];

      expect(a, greaterThan(0));
      expect(b, greaterThan(0));
      expect(c, greaterThan(0));
      expect(a + b > c, isTrue);
      expect(a + c > b, isTrue);
      expect(b + c > a, isTrue);
    }
  });

  test('drejtkendeshi dhe katrori mund te dalin si sipërfaqe ose perimeter', () {
    final seenRectangleTypes = <GeometryCalculationType>{};
    final seenSquareTypes = <GeometryCalculationType>{};
    final seenCircleTypes = <GeometryCalculationType>{};

    for (var i = 0; i < 400; i++) {
      final q = generator.generate(Random(i + 31));
      if (q.shape == GeometryShape.rectangle) {
        seenRectangleTypes.add(q.calculationType);
      }
      if (q.shape == GeometryShape.square) {
        seenSquareTypes.add(q.calculationType);
      }
      if (q.shape == GeometryShape.circle) {
        seenCircleTypes.add(q.calculationType);
      }
    }

    expect(seenRectangleTypes, contains(GeometryCalculationType.area));
    expect(seenRectangleTypes, contains(GeometryCalculationType.perimeter));
    expect(seenSquareTypes, contains(GeometryCalculationType.area));
    expect(seenSquareTypes, contains(GeometryCalculationType.perimeter));
    expect(seenCircleTypes, contains(GeometryCalculationType.area));
    expect(seenCircleTypes, contains(GeometryCalculationType.perimeter));
  });
}
