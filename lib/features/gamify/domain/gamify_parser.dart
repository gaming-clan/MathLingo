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
    final cleaned = input
        .toLowerCase()
        .replaceAll('zgjidh', '')
        .replaceAll('llogarit', '')
        .replaceAll('sa është', '')
        .replaceAll('janë', '')
        // a2 -> a^2 (only where trailing digit follows a letter/closing paren)
        .replaceAllMapped(
          RegExp(r'([a-z\)])(\d+)'),
          (m) => '${m.group(1)}^${m.group(2)}',
        )
        .replaceAllMapped(
          RegExp(r'\s+'),
          (m) => ' ',
        )
        .trim();

    return _hasBalancedBrackets(cleaned) ? cleaned : '';
  }

  static ParsedGamifyExpression? parse(String input) {
    final text = normalize(input);
    if (text.isEmpty) {
      return null;
    }

    return _tryParse(text, '+', GamifyOperator.addition) ??
        _tryParse(text, '-', GamifyOperator.subtraction) ??
        _tryParse(text, '~/', GamifyOperator.division) ??
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

    if (op == GamifyOperator.division && right == 0) {
      throw UnsupportedError('Division by zero');
    }

    return ParsedGamifyExpression(left: left, right: right, operator: op);
  }

  static bool _hasBalancedBrackets(String text) {
    var depth = 0;
    for (final rune in text.runes) {
      if (rune == '('.codeUnitAt(0)) {
        depth++;
      } else if (rune == ')'.codeUnitAt(0)) {
        depth--;
        if (depth < 0) {
          return false;
        }
      }
    }
    return depth == 0;
  }
}
