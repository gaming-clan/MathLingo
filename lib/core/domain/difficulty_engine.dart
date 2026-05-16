/// Niveli i vështirësisë për sfidat matematikore.
enum DifficultyLevel {
  /// Nivel 1 — numra 1–10.
  level1,

  /// Nivel 2 — numra 1–20.
  level2,

  /// Nivel 3 — numra 1–50.
  level3,
}

/// Kthen kufirin maksimal të numrave për nivelin e dhënë.
extension DifficultyLevelExt on DifficultyLevel {
  int get maxNumber {
    switch (this) {
      case DifficultyLevel.level1:
        return 10;
      case DifficultyLevel.level2:
        return 20;
      case DifficultyLevel.level3:
        return 50;
    }
  }

  String get label {
    switch (this) {
      case DifficultyLevel.level1:
        return 'Niveli 1';
      case DifficultyLevel.level2:
        return 'Niveli 2';
      case DifficultyLevel.level3:
        return 'Niveli 3';
    }
  }
}

/// Motor i pastër Dart për vlerësimin e vështirësisë.
///
/// Logika:
/// - Nëse ≥3 sesionet e fundit kanë saktësi ≥90% → nivel lart.
/// - Nëse ≥3 sesionet e fundit kanë saktësi <50%  → nivel poshtë.
/// - Ndryshe                                        → nivel stabil.
abstract final class DifficultyEngine {
  DifficultyEngine._();

  /// Vlerson nivelin e ri bazuar në historikun e sesioneve.
  ///
  /// [currentLevel]    — niveli aktual i përdoruesit.
  /// [recentAccuracies] — lista e saktësive (0–100) të sesioneve të fundit,
  ///                      renditur nga më i vjetri te më i riu.
  ///                      Duhet të ketë të paktën 3 vlera për ndryshim niveli.
  static DifficultyLevel evaluate({
    required DifficultyLevel currentLevel,
    required List<int> recentAccuracies,
  }) {
    if (recentAccuracies.length < 3) return currentLevel;

    final last3 = recentAccuracies.reversed.take(3).toList();

    final allHigh = last3.every((a) => a >= 90);
    if (allHigh && currentLevel != DifficultyLevel.level3) {
      return _levelUp(currentLevel);
    }

    final allLow = last3.every((a) => a < 50);
    if (allLow && currentLevel != DifficultyLevel.level1) {
      return _levelDown(currentLevel);
    }

    return currentLevel;
  }

  static DifficultyLevel _levelUp(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.level1:
        return DifficultyLevel.level2;
      case DifficultyLevel.level2:
        return DifficultyLevel.level3;
      case DifficultyLevel.level3:
        return DifficultyLevel.level3;
    }
  }

  static DifficultyLevel _levelDown(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.level1:
        return DifficultyLevel.level1;
      case DifficultyLevel.level2:
        return DifficultyLevel.level1;
      case DifficultyLevel.level3:
        return DifficultyLevel.level2;
    }
  }
}
