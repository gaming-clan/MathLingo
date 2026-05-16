import 'dart:math';

import '../../../models/fraction_question.dart';

/// Çifti (numëruesi, emëruesi) i një fraksioni të mbështetur.
typedef _F = ({int n, int d, String label});

/// Gjenerator i pyetjeve fraksionesh për MVP Sprint 9.
///
/// Fraksionet e mbështetura: ½, ⅓, ¼, ¾, ⅔, ⅛, ⅜, ⅝, ⅞.
/// Pyetja: "Cili fraksion tregon pjesën e ngjyrosur?"
/// 4 opsione unike string — 1 e saktë + 3 plausible me emërues të ngjashëm.
abstract final class FractionGenerator {
  FractionGenerator._();

  static const List<_F> _supported = [
    (n: 1, d: 2, label: '½'),
    (n: 1, d: 3, label: '⅓'),
    (n: 1, d: 4, label: '¼'),
    (n: 3, d: 4, label: '¾'),
    (n: 2, d: 3, label: '⅔'),
    (n: 1, d: 8, label: '⅛'),
    (n: 3, d: 8, label: '⅜'),
    (n: 5, d: 8, label: '⅝'),
    (n: 7, d: 8, label: '⅞'),
  ];

  /// Gjeneron një pyetje fraksionesh me [random].
  static FractionQuestion generate(Random random) {
    final correct = _supported[random.nextInt(_supported.length)];
    final visualType =
        random.nextBool() ? FractionVisualType.pie : FractionVisualType.bar;

    final distractors = _buildDistractors(correct, random);

    final options = [correct.label, ...distractors]..shuffle(random);

    return FractionQuestion(
      numerator: correct.n,
      denominator: correct.d,
      answer: correct.label,
      options: options,
      visualType: visualType,
      prompt: 'Cili fraksion tregon pjesën e ngjyrosur?',
    );
  }

  /// Ndërton 3 distractors plausible me emërues të ngjashëm.
  static List<String> _buildDistractors(_F correct, Random random) {
    final pool = _supported
        .where((f) =>
            f.label != correct.label &&
            (f.d == correct.d ||
                (f.d - correct.d).abs() <= 4))
        .toList();

    // Nëse pool i vogël, plotëso me çdo fraksion tjetër
    final fallback = _supported.where((f) => f.label != correct.label).toList();
    if (pool.length < 3) {
      pool.addAll(fallback.where((f) => !pool.contains(f)));
    }

    pool.shuffle(random);
    return pool.take(3).map((f) => f.label).toList();
  }
}
