import 'dart:math';

import '../../../models/geometry_question.dart';
import '../../../models/geometry_shape.dart';

class GeometryQuestionGenerator {
  const GeometryQuestionGenerator();

  GeometryQuestion generate(Random random) {
    final shape =
        GeometryShape.values[random.nextInt(GeometryShape.values.length)];
    late int width;
    late int height;
    late int answer;
    late String prompt;
    late String measurement;

    switch (shape) {
      case GeometryShape.rectangle:
        width = random.nextInt(7) + 3;
        height = random.nextInt(6) + 2;
        answer = width * height;
        prompt = 'Sa është sipërfaqja e drejtkëndëshit?';
        measurement = 'gjerësi $width, lartësi $height';
      case GeometryShape.triangle:
        width = (random.nextInt(5) + 3) * 2;
        height = random.nextInt(6) + 2;
        answer = (width * height) ~/ 2;
        prompt = 'Sa është sipërfaqja e trekëndëshit?';
        measurement = 'bazë $width, lartësi $height';
      case GeometryShape.square:
        width = random.nextInt(8) + 3;
        height = width;
        answer = width * 4;
        prompt = 'Sa është perimetri i katrorit?';
        measurement = 'brinja $width';
      case GeometryShape.circle:
        width = random.nextInt(7) + 2; // radius
        height = width;
        answer = width * 6; // 2 * pi * r with pi ~= 3
        prompt = 'Sa është perimetri i rrethit? (π ≈ 3)';
        measurement = 'rrezja $width';
      case GeometryShape.parallelogram:
        width = random.nextInt(8) + 3; // base
        height = random.nextInt(6) + 2; // height
        answer = width * height;
        prompt = 'Sa është sipërfaqja e paralelogramit?';
        measurement = 'bazë $width, lartësi $height';
    }

    return GeometryQuestion(
      shape: shape,
      prompt: prompt,
      measurement: measurement,
      answer: answer,
      options: generateOptions(answer, random),
      width: width,
      height: height,
    );
  }

  List<int> generateOptions(int correctAnswer, Random random) {
    final options = <int>{correctAnswer};
    while (options.length < 4) {
      var offset = random.nextInt(14) - 7;
      if (offset == 0) {
        offset = 2;
      }
      final wrongAnswer = correctAnswer + offset;
      if (wrongAnswer > 0) {
        options.add(wrongAnswer);
      }
    }
    return options.toList()..shuffle(random);
  }
}
