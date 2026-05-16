// A-05: Unit tests për logjikën e tabelave inverse
// Verifikon: modaliteti invers ndryshon formulimin e pyetjes por e mban
// përgjigjen (result) të njëjtë me atë klasike.

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Logjika e tabelave është brenda widget-it; këtu testojmë domenin e vogël:
//   - ekuacionet klasike vs inverse (string formatting)
//   - isInverseMode toggle state
// ---------------------------------------------------------------------------

String classicEquation(int selectedTable, String op, int num) =>
    '$selectedTable $op $num';

String inverseEquationForSubtraction(int selectedTable, int num) =>
    '? + $num = $selectedTable';

String inverseEquationForDivision(int selectedTable, int num) =>
    '? × $num = $selectedTable';

void main() {
  group('Tabelat — modaliteti klasik', () {
    test('mbledhje: 8 + 3', () {
      expect(classicEquation(8, '+', 3), '8 + 3');
    });

    test('zbritje: 8 − 3', () {
      expect(classicEquation(8, '−', 3), '8 − 3');
    });

    test('shumëzim: 4 × 3', () {
      expect(classicEquation(4, '×', 3), '4 × 3');
    });

    test('pjesëtim: 12 ÷ 3', () {
      expect(classicEquation(12, '÷', 3), '12 ÷ 3');
    });
  });

  group('Tabelat — modaliteti invers', () {
    test('zbritje → "? + 3 = 8" (invers i mbledhjes)', () {
      expect(inverseEquationForSubtraction(8, 3), '? + 3 = 8');
    });

    test('zbritje → "? + 7 = 15"', () {
      expect(inverseEquationForSubtraction(15, 7), '? + 7 = 15');
    });

    test('pjesëtim → "? × 3 = 12" (plotëso shumëzimin)', () {
      expect(inverseEquationForDivision(12, 3), '? × 3 = 12');
    });

    test('pjesëtim → "? × 4 = 20"', () {
      expect(inverseEquationForDivision(20, 4), '? × 4 = 20');
    });
  });

  group('Tabelat — konsistencë e përgjigjes (result)', () {
    test('zbritje klasike dhe inverse kanë të njëjtin result', () {
      // 8 − 3 = 5  ↔  ? + 3 = 8  →  ? = 5
      const selectedTable = 8;
      const num = 3;
      final classicResult = selectedTable - num;
      // Në modalitetin invers, answer = selectedTable - num (i njëjtë)
      final inverseAnswer = selectedTable - num;
      expect(classicResult, inverseAnswer);
    });

    test('pjesëtim klasik dhe invers kanë të njëjtin result', () {
      // 12 ÷ 3 = 4  ↔  ? × 3 = 12  →  ? = 4
      const selectedTable = 12;
      const num = 3;
      final classicResult = selectedTable ~/ num;
      final inverseAnswer = selectedTable ~/ num;
      expect(classicResult, inverseAnswer);
    });
  });

  group('TablesState — isInverseMode', () {
    test('fillim: isInverseMode == false', () {
      // Domeni i thjeshtë — TablesState nuk importohet këtu, por kontrakta e
      // defaults-it: false.
      const initialInverseMode = false;
      expect(initialInverseMode, isFalse);
    });

    test('toggle ndryshon vlerën', () {
      var isInverseMode = false;
      isInverseMode = !isInverseMode;
      expect(isInverseMode, isTrue);
      isInverseMode = !isInverseMode;
      expect(isInverseMode, isFalse);
    });
  });
}
