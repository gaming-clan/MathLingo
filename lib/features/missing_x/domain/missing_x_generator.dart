import 'dart:math';

import '../../../models/missing_x_question.dart';

/// Gjeneron pyetje "Gjej X-in" pedagogjikisht të vlefshme.
///
/// Rregulla:
///   - Rezultati gjithmonë pozitiv
///   - Numrat brenda diapazonit të nivelit
///   - 4 opsione unike dhe plausible
class MissingXGenerator {
  const MissingXGenerator();

  static const _types = MissingXType.values;

  MissingXQuestion generate(Random random, {int maxNumber = 20}) {
    final type = _types[random.nextInt(_types.length)];
    return _generateForType(type, random, maxNumber: maxNumber);
  }

  MissingXQuestion _generateForType(
    MissingXType type,
    Random random, {
    required int maxNumber,
  }) {
    switch (type) {
      case MissingXType.addMissingAddend:
        // knownNum + ? = result  →  ? = result - knownNum
        final knownNum = random.nextInt(maxNumber - 1) + 1;
        final answer = random.nextInt(maxNumber - 1) + 1;
        final result = knownNum + answer;
        return MissingXQuestion(
          type: type,
          knownNum: knownNum,
          result: result,
          answer: answer,
          options: _buildOptions(answer, random),
        );

      case MissingXType.multMissingFactor:
        // ? × knownNum = result  →  ? = result / knownNum
        final maxFactor =
            maxNumber <= 10 ? 5 : (maxNumber <= 20 ? 10 : 12);
        final answer = random.nextInt(maxFactor - 1) + 1;
        final knownNum = random.nextInt(maxFactor - 1) + 1;
        final result = answer * knownNum;
        return MissingXQuestion(
          type: type,
          knownNum: knownNum,
          result: result,
          answer: answer,
          options: _buildOptions(answer, random),
        );

      case MissingXType.subMissingSubtrahend:
        // knownNum - ? = result  →  ? = knownNum - result
        final result = random.nextInt(maxNumber - 2) + 1;
        final answer = random.nextInt(maxNumber - result - 1) + 1;
        final knownNum = result + answer;
        return MissingXQuestion(
          type: type,
          knownNum: knownNum,
          result: result,
          answer: answer,
          options: _buildOptions(answer, random),
        );
    }
  }

  List<int> _buildOptions(int correctAnswer, Random random) {
    final candidates = <int>{
      if (correctAnswer > 1) correctAnswer - 1,
      correctAnswer + 1,
      if (correctAnswer > 2) correctAnswer - 2,
      correctAnswer + 2,
      if (correctAnswer > 3) correctAnswer - 3,
      correctAnswer + 3,
    };
    candidates.remove(correctAnswer);
    candidates.removeWhere((v) => v <= 0);

    final shuffled = candidates.toList()..shuffle(random);
    return ([correctAnswer, ...shuffled.take(3)])..shuffle(random);
  }
}
