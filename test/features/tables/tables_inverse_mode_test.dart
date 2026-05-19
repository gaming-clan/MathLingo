// Sprint 11.5 · Unit tests për logjikën e tabelave inverse (B-01, B-02)
// Verifikon:
//   - formulimet e ekuacioneve klasike vs inverse (string formatting)
//   - vlerat e rrethit (answer) për çdo modalitet
//   - gjenerimin e hyrjeve (_buildVisibleEntries) për inverse mbledhje/pjesëtim
//   - badge symbols klasike vs inverse

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Domain helpers — pasqyrojnë logjikën e simple_tables.dart
// ---------------------------------------------------------------------------

enum _Op { addition, subtraction, multiplication, division }

String equationText({
  required _Op operation,
  required bool isInverseMode,
  required int selectedTable,
  required int num,
  required int result,
}) {
  if (isInverseMode) {
    if (operation == _Op.addition) {
      return '? + $num = $selectedTable';
    }
    if (operation == _Op.subtraction) {
      return '$selectedTable − $num = ?';
    }
    if (operation == _Op.multiplication) {
      return '? × $num = $result';
    }
    if (operation == _Op.division) {
      return '$result ÷ ? = $selectedTable';
    }
  }
  const symbols = {
    _Op.addition: '+',
    _Op.subtraction: '−',
    _Op.multiplication: '×',
    _Op.division: '÷',
  };
  return '$selectedTable ${symbols[operation]} $num';
}

String badgeSymbol({required _Op operation, required bool isInverseMode}) {
  if (isInverseMode) {
    if (operation == _Op.addition) return '+';
    if (operation == _Op.subtraction) return '−';
    if (operation == _Op.multiplication) return '×';
    if (operation == _Op.division) return '÷';
  }
  const symbols = {
    _Op.addition: '+',
    _Op.subtraction: '−',
    _Op.multiplication: '×',
    _Op.division: '÷',
  };
  return symbols[operation]!;
}

int circleValue({
  required _Op operation,
  required bool isInverseMode,
  required int selectedTable,
  required int num,
  required int result,
}) {
  if (isInverseMode) {
    if (operation == _Op.multiplication) return selectedTable;
    if (operation == _Op.division) return num;
    return result; // mbledhje & zbritje: result është përgjigja
  }
  return result;
}

/// Pasqyron _buildVisibleEntries() për mbledhje inverse
List<({int operand, int result})> buildAdditionInverseEntries(int tableNum) {
  return [
    for (var n = 1; n <= tableNum; n++) (operand: n, result: tableNum - n),
  ];
}

/// Pasqyron _buildVisibleEntries() për pjesëtim inverse
List<({int operand, int result})> buildDivisionInverseEntries(int tableNum) {
  return [
    for (var m = 1; m <= 10; m++) (operand: m, result: tableNum * m),
  ];
}

/// Pasqyron _buildVisibleEntries() për zbritje inverse (n=1..tableNum-1)
List<({int operand, int result})> buildSubtractionInverseEntries(int tableNum) {
  return [
    for (var n = 1; n < tableNum; n++) (operand: n, result: tableNum - n),
  ];
}

// ---------------------------------------------------------------------------

void main() {
  // ── B-01: Shumëzim Invers ─────────────────────────────────────────────────
  group('B-01 · Shumëzim Invers (tabela 4)', () {
    const t = 4;

    test('equationText: ? × n = result (jo ÷)', () {
      // entry: operand=2, result=8
      final txt = equationText(
        operation: _Op.multiplication,
        isInverseMode: true,
        selectedTable: t,
        num: 2,
        result: 8,
      );
      expect(txt, '? × 2 = 8');
      expect(txt.contains('÷'), isFalse,
          reason: 'Nuk duhet të përmbajë ÷ në shumëzim invers');
    });

    test('circle tregon selectedTable (4), jo result', () {
      final cv = circleValue(
        operation: _Op.multiplication,
        isInverseMode: true,
        selectedTable: t,
        num: 3,
        result: 12,
      );
      expect(cv, t);
    });

    test('badgeSymbol: ×, jo ÷', () {
      expect(badgeSymbol(operation: _Op.multiplication, isInverseMode: true),
          '×');
    });
  });

  // ── B-01: Pjesëtim Invers ─────────────────────────────────────────────────
  group('B-01 · Pjesëtim Invers (tabela 4)', () {
    const t = 4;

    test('equationText: dividend ÷ ? = 4 (jo ?×n=4)', () {
      // entry: operand=3, result=12  (4×3=12)
      final txt = equationText(
        operation: _Op.division,
        isInverseMode: true,
        selectedTable: t,
        num: 3,
        result: 12,
      );
      expect(txt, '12 ÷ ? = 4');
    });

    test('circle tregon divisor (num), jo selectedTable', () {
      final cv = circleValue(
        operation: _Op.division,
        isInverseMode: true,
        selectedTable: t,
        num: 3,
        result: 12,
      );
      expect(cv, 3);
    });

    test('badgeSymbol: ÷, jo ×', () {
      expect(
          badgeSymbol(operation: _Op.division, isInverseMode: true), '÷');
    });

    test('buildDivisionInverseEntries gjeneron 10 hyrje', () {
      final entries = buildDivisionInverseEntries(t);
      expect(entries.length, 10);
    });

    test('buildDivisionInverseEntries: entries[0] = (operand:1, result:4)', () {
      final e = buildDivisionInverseEntries(t);
      expect(e[0].operand, 1);
      expect(e[0].result, 4); // 4×1=4
    });

    test('buildDivisionInverseEntries: entries[2] = (operand:3, result:12)', () {
      final e = buildDivisionInverseEntries(t);
      expect(e[2].operand, 3);
      expect(e[2].result, 12); // 4×3=12
    });
  });

  // ── B-02: Mbledhje Invers ─────────────────────────────────────────────────
  group('B-02 · Mbledhje Invers (tabela 4)', () {
    const t = 4;

    test('equationText: ? + n = 4', () {
      final txt = equationText(
        operation: _Op.addition,
        isInverseMode: true,
        selectedTable: t,
        num: 1,
        result: 3,
      );
      expect(txt, '? + 1 = 4');
    });

    test('buildAdditionInverseEntries: entries[0].answer == 3 (?+1=4)', () {
      final e = buildAdditionInverseEntries(t);
      expect(e[0].operand, 1);
      expect(e[0].result, 3); // 4-1=3
    });

    test('buildAdditionInverseEntries: entries[1].answer == 2 (?+2=4)', () {
      final e = buildAdditionInverseEntries(t);
      expect(e[1].operand, 2);
      expect(e[1].result, 2); // 4-2=2
    });

    test('buildAdditionInverseEntries: entries[3].answer == 0 (?+4=4)', () {
      final e = buildAdditionInverseEntries(t);
      expect(e[3].operand, 4);
      expect(e[3].result, 0); // 4-4=0
    });

    test('buildAdditionInverseEntries gjeneron tableNum hyrje', () {
      final e = buildAdditionInverseEntries(t);
      expect(e.length, t); // 4 hyrje (n=1,2,3,4)
    });

    test('badgeSymbol: +', () {
      expect(
          badgeSymbol(operation: _Op.addition, isInverseMode: true), '+');
    });
  });

  // ── Modaliteti klasik (regresion) ─────────────────────────────────────────
  group('Klasik — regresion', () {
    test('shumëzim klasik: 4 × 3 = 12', () {
      final txt = equationText(
        operation: _Op.multiplication,
        isInverseMode: false,
        selectedTable: 4,
        num: 3,
        result: 12,
      );
      expect(txt, '4 × 3');
    });

    test('zbritje klasike: 8 − 3', () {
      final txt = equationText(
        operation: _Op.subtraction,
        isInverseMode: false,
        selectedTable: 8,
        num: 3,
        result: 5,
      );
      expect(txt, '8 − 3');
    });

    test('badge klasik shumëzim: ×', () {
      expect(
          badgeSymbol(operation: _Op.multiplication, isInverseMode: false),
          '×');
    });

    test('badge klasik pjesëtim: ÷', () {
      expect(
          badgeSymbol(operation: _Op.division, isInverseMode: false), '÷');
    });
  });

  // ── B-03: Zbritje Invers ──────────────────────────────────────────────────────
  group('B-03 · Zbritje Invers (tabela 4)', () {
    const t = 4;

    test('equationText: 4 − 2 = ?', () {
      final txt = equationText(
        operation: _Op.subtraction,
        isInverseMode: true,
        selectedTable: t,
        num: 2,
        result: 2,
      );
      expect(txt, '4 − 2 = ?');
      expect(txt.contains('+'), isFalse,
          reason: 'Nuk duhet të përmbajë + në zbritje invers');
    });

    test('buildSubtractionInverseEntries: table-1 hyrje', () {
      final e = buildSubtractionInverseEntries(t);
      expect(e.length, t - 1); // 3 hyrje (n=1,2,3; jo n=4 sepse 4−4=0)
    });

    test('buildSubtractionInverseEntries: entries[0] = (1, 3)', () {
      final e = buildSubtractionInverseEntries(t);
      expect(e[0].operand, 1);
      expect(e[0].result, 3); // 4-1=3
    });

    test('buildSubtractionInverseEntries: entries[2] = (3, 1)', () {
      final e = buildSubtractionInverseEntries(t);
      expect(e[2].operand, 3);
      expect(e[2].result, 1); // 4-3=1
    });

    test('badgeSymbol: − (jo +)', () {
      expect(
          badgeSymbol(operation: _Op.subtraction, isInverseMode: true), '−');
    });
  });
}
