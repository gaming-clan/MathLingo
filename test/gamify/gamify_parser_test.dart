import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/features/gamify/domain/gamify_parser.dart';

void main() {
  group('GamifyParser.normalize', () {
    test('heq fjalet ndihmese dhe e normalizon tekstin', () {
      final normalized = GamifyParser.normalize('Zgjidh sa është 12 + 5');
      expect(normalized, '12 + 5');
    });
  });

  group('GamifyParser.parse', () {
    test('parse mbledhjen', () {
      final parsed = GamifyParser.parse('10 + 4');
      expect(parsed, isNotNull);
      expect(parsed!.left, 10);
      expect(parsed.right, 4);
      expect(parsed.operator, GamifyOperator.addition);
    });

    test('parse zbritjen', () {
      final parsed = GamifyParser.parse('18 - 7');
      expect(parsed, isNotNull);
      expect(parsed!.left, 18);
      expect(parsed.right, 7);
      expect(parsed.operator, GamifyOperator.subtraction);
    });

    test('parse shumezimin me x', () {
      final parsed = GamifyParser.parse('6 x 5');
      expect(parsed, isNotNull);
      expect(parsed!.left, 6);
      expect(parsed.right, 5);
      expect(parsed.operator, GamifyOperator.multiplication);
    });

    test('parse pjestimin me ÷', () {
      final parsed = GamifyParser.parse('20 ÷ 5');
      expect(parsed, isNotNull);
      expect(parsed!.left, 20);
      expect(parsed.right, 5);
      expect(parsed.operator, GamifyOperator.division);
    });

    test('kthehet null kur formati eshte i pavlefshem', () {
      final parsed = GamifyParser.parse('abc + 5');
      expect(parsed, isNull);
    });
  });
}
