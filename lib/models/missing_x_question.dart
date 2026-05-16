enum MissingXType {
  /// 5 + ? = 12  — gjej mbledhorsin e munguar
  addMissingAddend,

  /// ? × 4 = 20  — gjej faktorin e munguar
  multMissingFactor,

  /// 9 - ? = 3   — gjej zbritësin e munguar
  subMissingSubtrahend,
}

class MissingXQuestion {
  const MissingXQuestion({
    required this.type,
    required this.knownNum,
    required this.result,
    required this.answer,
    required this.options,
  });

  /// Numri i njohur (p.sh. 5 në "5 + ? = 12")
  final int knownNum;

  /// Rezultati (p.sh. 12 në "5 + ? = 12")
  final int result;

  /// Vlera e saktë e x-it
  final int answer;

  /// 4 opsione (1 i saktë + 3 gabime pedagogjike)
  final List<int> options;

  final MissingXType type;

  /// Shprehja e formatuar p.sh. "5 + ? = 12" ku ? është shënuesi
  String get leftDisplay {
    switch (type) {
      case MissingXType.addMissingAddend:
        return '$knownNum + ';
      case MissingXType.multMissingFactor:
        return '';
      case MissingXType.subMissingSubtrahend:
        return '$knownNum − ';
    }
  }

  String get rightDisplay {
    switch (type) {
      case MissingXType.addMissingAddend:
        return ' = $result';
      case MissingXType.multMissingFactor:
        return ' × $knownNum = $result';
      case MissingXType.subMissingSubtrahend:
        return ' = $result';
    }
  }
}
