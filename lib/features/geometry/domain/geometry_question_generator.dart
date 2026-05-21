import 'dart:math' as math;

import '../../../models/geometry_question.dart';
import '../../../models/geometry_shape.dart';

class GeometryQuestionGenerator {
  const GeometryQuestionGenerator();

  static double _roundToOneDecimal(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  GeometryQuestion generate(math.Random random) {
    final shape =
        GeometryShape.values[random.nextInt(GeometryShape.values.length)];
    late int width;
    late int height;
    late double answer;
    late String prompt;
    late String measurement;
    late GeometryCalculationType calculationType;

    switch (shape) {
      case GeometryShape.rectangle:
        width = random.nextInt(7) + 3;
        height = random.nextInt(6) + 2;
        if (random.nextBool()) {
          calculationType = GeometryCalculationType.area;
          answer = (width * height).toDouble();
          prompt = 'Sa është sipërfaqja e drejtkëndëshit?';
        } else {
          calculationType = GeometryCalculationType.perimeter;
          answer = (2 * (width + height)).toDouble();
          prompt = 'Sa është perimetri i drejtkëndëshit?';
        }
        measurement = 'gjerësi $width, lartësi $height';
      case GeometryShape.triangle:
        // Pedagogjikisht përdorim bazë + lartësi për formulën S = (b * h) / 2.
        width = (random.nextInt(5) + 2) * 2;
        height = random.nextInt(5) + 2;
        calculationType = GeometryCalculationType.area;
        final doubledArea = width * height;
        if (doubledArea.isOdd) {
          throw StateError('Triangle area must be integral for beginner mode');
        }
        answer = (doubledArea / 2).toDouble();
        prompt = 'Sa është sipërfaqja e trekëndëshit?';
        measurement = 'bazë $width, lartësi $height';
      case GeometryShape.square:
        width = random.nextInt(8) + 3;
        height = width;
        if (random.nextBool()) {
          calculationType = GeometryCalculationType.area;
          answer = (width * width).toDouble();
          prompt = 'Sa është sipërfaqja e katrorit?';
        } else {
          calculationType = GeometryCalculationType.perimeter;
          answer = (width * 4).toDouble();
          prompt = 'Sa është perimetri i katrorit?';
        }
        measurement = 'brinja $width';
      case GeometryShape.circle:
        width = random.nextInt(7) + 2; // radius
        height = width;
        calculationType =
            random.nextBool()
                ? GeometryCalculationType.perimeter
                : GeometryCalculationType.area;
        if (calculationType == GeometryCalculationType.perimeter) {
          answer = _roundToOneDecimal(2 * math.pi * width);
          prompt = 'Sa është perimetri i rrethit?';
        } else {
          answer = _roundToOneDecimal(math.pi * math.pow(width, 2));
          prompt = 'Sa është sipërfaqja e rrethit?';
        }
        measurement = 'rrezja $width';
      case GeometryShape.parallelogram:
        width = random.nextInt(8) + 3; // base
        height = random.nextInt(6) + 2; // height
        calculationType = GeometryCalculationType.area;
        answer = (width * height).toDouble();
        prompt = 'Sa është sipërfaqja e paralelogramit?';
        measurement = 'bazë $width, lartësi $height';
    }

    if (width <= 0 || height <= 0) {
      throw StateError('Invalid geometry dimensions generated');
    }

    return GeometryQuestion(
      shape: shape,
      calculationType: calculationType,
      prompt: prompt,
      measurement: measurement,
      answer: answer,
      options: generateOptions(answer, random),
      width: width,
      height: height,
    );
  }

  List<double> generateOptions(double correctAnswer, math.Random random) {
    final options = <double>{correctAnswer};
    while (options.length < 4) {
      var offset = (random.nextInt(14) - 7).toDouble();
      if (offset == 0) {
        offset = 2.0;
      }
      final wrongAnswer = _roundToOneDecimal(correctAnswer + offset);
      if (wrongAnswer > 0) {
        options.add(wrongAnswer);
      }
    }
    return options.toList()..shuffle(random);
  }
}
