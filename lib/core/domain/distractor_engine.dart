import 'dart:math';

import '../../models/operation.dart';

/// Gjeneron 3 opsione të gabuara pedagogjikisht plausible për çdo operacion.
///
/// Secili distractor:
///   - është unik (nuk ka duplikate)
///   - ndryshon nga [correctAnswer]
///   - është pozitiv (> 0)
///
/// Gabimet tipike sipas operacionit:
///   - Mbledhje:   harrim i kalimit, offset ±1, ±10
///   - Zbritje:    mbledhje në vend të zbritjes, num1 i pandryshuar
///   - Shumëzim:   tabelat ngjitur (n±1)×m, n×(m±1), mbledhje
///   - Pjesëtim:   shumëzim i inversuar, rezultate nga ndarës ngjitur, ±1
class DistractorEngine {
  const DistractorEngine._();

  /// Kthehet si [List] me saktësisht 4 elemente: 1 i saktë + 3 gabime.
  static List<int> generateFor({
    required Operation operation,
    required int correctAnswer,
    required int num1,
    required int num2,
    required Random random,
  }) {
    final options = <int>{correctAnswer};

    // 1) Gabim strukturor klasik: shumëzim ngatërrohet me mbledhje.
    if (operation == Operation.multiplication) {
      options.add(num1 + num2);
    }

    // 2) Off-by-ten error.
    final plusTen = correctAnswer + 10;
    final minusTen = correctAnswer - 10;
    if (plusTen > 0) {
      options.add(plusTen);
    }
    if (minusTen > 0) {
      options.add(minusTen);
    }

    // 3) Inversion/digit swap për përgjigje me 2+ shifra.
    final swapped = _digitSwap(correctAnswer);
    if (swapped != null && swapped > 0) {
      options.add(swapped);
    }

    // Mbështetje shtesë për operacione të tjera.
    options.addAll(_operationSpecificCandidates(operation, correctAnswer, num1, num2));

    options
      ..remove(correctAnswer)
      ..removeWhere((v) => v <= 0);

    final distractors = options.toList()..shuffle(random);
    final picked = <int>[correctAnswer, ...distractors.take(3)];

    // Fallback i kontrolluar derisa të kemi saktësisht 4 unike.
    var offset = 2;
    while (picked.toSet().length < 4) {
      final up = correctAnswer + offset;
      if (up > 0 && !picked.contains(up)) {
        picked.add(up);
      }
      if (picked.toSet().length >= 4) break;

      final down = correctAnswer - offset;
      if (down > 0 && !picked.contains(down)) {
        picked.add(down);
      }
      offset++;
    }

    final unique = picked.toSet().toList()..shuffle(random);
    return unique.take(4).toList();
  }

  static Set<int> _operationSpecificCandidates(
    Operation operation,
    int correctAnswer,
    int num1,
    int num2,
  ) {
    switch (operation) {
      case Operation.addition:
        return {
          // Harrim i kalimit: vetëm shifra e njësheve.
          if (correctAnswer > 9) correctAnswer % 10,
          num1,
          num2,
        };

      case Operation.subtraction:
        return {
          // Mbledh në vend të zbres.
          num1 + num2,
          num1,
        };

      case Operation.multiplication:
        return {
          // Tabela ngjitur.
          if (num1 > 1) (num1 - 1) * num2,
          (num1 + 1) * num2,
          if (num2 > 1) num1 * (num2 - 1),
          num1 * (num2 + 1),
        };

      case Operation.division:
        return {
          // Shumëzon në vend të pjesëton.
          num1 * num2,
          if (num2 > 1 && num1 % (num2 - 1) == 0) num1 ~/ (num2 - 1),
          if (num1 % (num2 + 1) == 0) num1 ~/ (num2 + 1),
        };
    }
  }

  static int? _digitSwap(int value) {
    if (value.abs() < 10) {
      return null;
    }

    final digits = value.toString().split('');
    final reversed = digits.reversed.join();
    final parsed = int.tryParse(reversed);
    if (parsed == null || parsed == value) {
      return null;
    }
    return parsed;
  }
}
