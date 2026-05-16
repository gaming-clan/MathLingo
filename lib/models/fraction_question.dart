/// Llojet e vizualizimit për fraksionet.
enum FractionVisualType {
  /// Tarte e ndarë (pie chart).
  pie,

  /// Shirit i ndarë (bar).
  bar,
}

/// Modeli i një pyetjeje fraksionesh.
class FractionQuestion {
  const FractionQuestion({
    required this.numerator,
    required this.denominator,
    required this.answer,
    required this.options,
    required this.visualType,
    required this.prompt,
  });

  /// Numëruesi i fraksionit të shfaqur (pjesa e ngjyrosur).
  final int numerator;

  /// Emëruesi i fraksionit (numri i ndarjeve).
  final int denominator;

  /// Fraksioni i saktë si string (p.sh. "½").
  final String answer;

  /// 4 opsione string — 1 e saktë + 3 plausible.
  final List<String> options;

  /// Mënyra e vizualizimit.
  final FractionVisualType visualType;

  /// Teksti i pyetjes.
  final String prompt;
}
