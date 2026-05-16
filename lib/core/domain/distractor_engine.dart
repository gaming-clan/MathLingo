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
    final candidates = _candidates(operation, correctAnswer, num1, num2);
    candidates
      ..remove(correctAnswer)
      ..removeWhere((v) => v <= 0);

    // Mbush deri në 3 me offsets të vogla nëse kandidatët nuk mjaftojnë
    const fillOffsets = [2, 3, 5, 7, 11, 4, 13, 17];
    var fi = 0;
    while (candidates.length < 3) {
      final v = correctAnswer + fillOffsets[fi % fillOffsets.length];
      if (v > 0 && v != correctAnswer) candidates.add(v);
      fi++;
    }

    final shuffled = candidates.toList()..shuffle(random);
    return ([correctAnswer, ...shuffled.take(3)])..shuffle(random);
  }

  static Set<int> _candidates(
    Operation operation,
    int correctAnswer,
    int num1,
    int num2,
  ) {
    switch (operation) {
      case Operation.addition:
        return {
          // Offset ±1 (gabim i vogël llogaritjeje)
          correctAnswer - 1,
          correctAnswer + 1,
          // Harrim i kalimit: vetëm shifra e njësheve
          if (correctAnswer > 9) correctAnswer % 10,
          // Kali i pasaktë: ±10
          correctAnswer + 10,
          if (correctAnswer > 10) correctAnswer - 10,
        };

      case Operation.subtraction:
        return {
          // Offset ±1
          correctAnswer - 1,
          correctAnswer + 1,
          // Mbledh në vend të zbres (konfuzion me operacionin)
          num1 + num2,
          // Fëmija lë num1 pa ndryshuar
          num1,
        };

      case Operation.multiplication:
        return {
          // Tabela ngjitur: (n-1)×m dhe (n+1)×m
          if (num1 > 1) (num1 - 1) * num2,
          (num1 + 1) * num2,
          // n×(m-1) dhe n×(m+1)
          if (num2 > 1) num1 * (num2 - 1),
          num1 * (num2 + 1),
          // Mbledh në vend të shumëzojë (konfuzion fillestar)
          num1 + num2,
        };

      case Operation.division:
        return {
          // Offset ±1
          if (correctAnswer > 1) correctAnswer - 1,
          correctAnswer + 1,
          // Shumëzon në vend të pjesëton (operacion inversal)
          num1 * num2,
          // Rezultat nga ndarës ngjitur (nëse janë të plota)
          if (num2 > 1 && num1 % (num2 - 1) == 0) num1 ~/ (num2 - 1),
          if (num1 % (num2 + 1) == 0) num1 ~/ (num2 + 1),
        };
    }
  }
}
