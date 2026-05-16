// C-01: Unit tests për DifficultyEngine
// Testohet logjika e ndryshimit të nivelit pa emulator.

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/domain/difficulty_engine.dart';

void main() {
  group('DifficultyEngine.evaluate — stabil (< 3 sesione)', () {
    test('nuk ndryshon nivelin kur ka 0 sesione', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [],
        ),
        DifficultyLevel.level1,
      );
    });

    test('nuk ndryshon nivelin kur ka vetëm 1 sesion', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [95],
        ),
        DifficultyLevel.level1,
      );
    });

    test('nuk ndryshon nivelin kur ka 2 sesione', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [100, 100],
        ),
        DifficultyLevel.level2,
      );
    });
  });

  group('DifficultyEngine.evaluate — level-up', () {
    test('level1 → level2 kur 3 të fundit janë ≥90', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [90, 95, 100],
        ),
        DifficultyLevel.level2,
      );
    });

    test('level2 → level3 kur 3 të fundit janë ≥90', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [91, 92, 90],
        ),
        DifficultyLevel.level3,
      );
    });

    test('level3 qëndron level3 edhe nëse 3 të fundit janë ≥90', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level3,
          recentAccuracies: [100, 100, 100],
        ),
        DifficultyLevel.level3,
      );
    });

    test('level-up ndodh vetëm me 3 TË FUNDIT ≥90, jo nëse e katërta nuk është', () {
      // historiku [50, 90, 95, 100] — 3 të fundit janë [90,95,100] → level-up
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [50, 90, 95, 100],
        ),
        DifficultyLevel.level2,
      );
    });

    test('nuk bën level-up nëse vetëm 2 nga 3 të fundit janë ≥90', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [90, 89, 95],
        ),
        DifficultyLevel.level1,
      );
    });
  });

  group('DifficultyEngine.evaluate — level-down', () {
    test('level2 → level1 kur 3 të fundit janë <50', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [40, 30, 49],
        ),
        DifficultyLevel.level1,
      );
    });

    test('level3 → level2 kur 3 të fundit janë <50', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level3,
          recentAccuracies: [0, 20, 49],
        ),
        DifficultyLevel.level2,
      );
    });

    test('level1 qëndron level1 edhe nëse 3 të fundit janë <50', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [10, 20, 30],
        ),
        DifficultyLevel.level1,
      );
    });

    test('nuk bën level-down nëse vetëm 2 nga 3 të fundit janë <50', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [49, 50, 20],
        ),
        DifficultyLevel.level2,
      );
    });
  });

  group('DifficultyEngine.evaluate — kufijtë e saktësisë', () {
    test('saktësia 50 nuk konsiderohet e ulët (<50 kërkohet)', () {
      // 3 sesione me saktësi 50 — nuk duhet të bëjë level-down
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [50, 50, 50],
        ),
        DifficultyLevel.level2,
      );
    });

    test('saktësia 90 konsiderohet e lartë (≥90 kërkohet)', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level1,
          recentAccuracies: [90, 90, 90],
        ),
        DifficultyLevel.level2,
      );
    });

    test('konflikte: 3 të fundit të larta NOR të ulëta — qëndron stabil', () {
      expect(
        DifficultyEngine.evaluate(
          currentLevel: DifficultyLevel.level2,
          recentAccuracies: [60, 70, 80],
        ),
        DifficultyLevel.level2,
      );
    });
  });

  group('DifficultyLevelExt', () {
    test('level1.maxNumber == 10', () {
      expect(DifficultyLevel.level1.maxNumber, 10);
    });

    test('level2.maxNumber == 20', () {
      expect(DifficultyLevel.level2.maxNumber, 20);
    });

    test('level3.maxNumber == 50', () {
      expect(DifficultyLevel.level3.maxNumber, 50);
    });

    test('label level1 == "Niveli 1"', () {
      expect(DifficultyLevel.level1.label, 'Niveli 1');
    });

    test('label level3 == "Niveli 3"', () {
      expect(DifficultyLevel.level3.label, 'Niveli 3');
    });
  });
}
