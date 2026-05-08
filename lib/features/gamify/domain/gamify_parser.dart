enum GamifyOperator { addition, subtraction, multiplication, division }

class ParsedGamifyExpression {
  const ParsedGamifyExpression({
    required this.left,
    required this.right,
    required this.operator,
  });

  final int left;
  final int right;
  final GamifyOperator operator;
}

class GamifyParser {
  const GamifyParser._();

  static String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('zgjidh', '')
        .replaceAll('llogarit', '')
        .replaceAll('sa është', '')
        .replaceAll('janë', '')
        .trim();
  }

  static ParsedGamifyExpression? parse(String input) {
    final text = normalize(input);
    return _tryParse(text, '+', GamifyOperator.addition) ??
        _tryParse(text, '-', GamifyOperator.subtraction) ??
        _tryParse(text, '*', GamifyOperator.multiplication) ??
        _tryParse(text, '×', GamifyOperator.multiplication) ??
        _tryParse(text, 'x', GamifyOperator.multiplication) ??
        _tryParse(text, '/', GamifyOperator.division) ??
        _tryParse(text, '÷', GamifyOperator.division);
  }

  static ParsedGamifyExpression? _tryParse(
    String text,
    String delimiter,
    GamifyOperator op,
  ) {
    if (!text.contains(delimiter)) {
      return null;
    }

    final parts = text.split(delimiter);
    if (parts.length != 2) {
      return null;
    }

    final left = int.tryParse(parts[0].trim());
    final right = int.tryParse(parts[1].trim());
    if (left == null || right == null) {
      return null;
    }

    return ParsedGamifyExpression(left: left, right: right, operator: op);
  }
}
