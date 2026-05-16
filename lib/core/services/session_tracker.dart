import 'package:hive_flutter/hive_flutter.dart';

import '../domain/difficulty_engine.dart';

/// Shërbimi i ruajtjes së historikut të sesioneve për çdo operacion.
///
/// Ruan deri në [_windowSize] saktësi të fundit (sliding window) për çdo
/// operacion, duke përdorur Hive si persistence lokale.
///
/// Hap boxin me [SessionTracker.init()] para se ta përdorësh.
class SessionTracker {
  static const String _boxName = 'session_history';
  static const String _levelBoxName = 'session_levels';
  static const int _windowSize = 5;

  /// Inicializo (ose hap) boxet Hive.
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<List>(_boxName);
    }
    if (!Hive.isBoxOpen(_levelBoxName)) {
      await Hive.openBox<int>(_levelBoxName);
    }
  }

  /// Regjistro saktësinë e sesionit të ri (0–100) për [operationKey].
  ///
  /// Vlera e re shtohet në fund. Nëse window tejkalon [_windowSize],
  /// vlera më e vjetër hiqet.
  static Future<void> recordSession(
    String operationKey,
    int accuracy,
  ) async {
    assert(accuracy >= 0 && accuracy <= 100,
        'accuracy duhet të jetë ndërmjet 0 dhe 100');
    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<List>(_boxName);
    final existing = List<int>.from(box.get(operationKey) ?? <int>[]);
    existing.add(accuracy);
    if (existing.length > _windowSize) {
      existing.removeRange(0, existing.length - _windowSize);
    }
    await box.put(operationKey, existing);
  }

  /// Kthen listën e saktësive të fundit (deri në 5) për [operationKey].
  ///
  /// Lista është e renditur nga më e vjetra te më e reja.
  /// Kthen listë bosh nëse nuk ka të dhëna.
  static List<int> getRecentAccuracies(String operationKey) {
    if (!Hive.isBoxOpen(_boxName)) return [];
    final box = Hive.box<List>(_boxName);
    return List<int>.from(box.get(operationKey) ?? <int>[]);
  }

  /// Kthen nivelin aktual të ruajtur për [operationKey].
  /// Default: [DifficultyLevel.level1].
  static DifficultyLevel getCurrentLevel(String operationKey) {
    if (!Hive.isBoxOpen(_levelBoxName)) return DifficultyLevel.level1;
    final box = Hive.box<int>(_levelBoxName);
    final idx = box.get(operationKey) ?? 0;
    return DifficultyLevel.values[idx.clamp(0, DifficultyLevel.values.length - 1)];
  }

  /// Ruan nivelin aktual për [operationKey].
  static Future<void> setCurrentLevel(
    String operationKey,
    DifficultyLevel level,
  ) async {
    if (!Hive.isBoxOpen(_levelBoxName)) return;
    final box = Hive.box<int>(_levelBoxName);
    await box.put(operationKey, level.index);
  }

  /// Fshin historikun e [operationKey]. I dobishëm për teste.
  static Future<void> clearOperation(String operationKey) async {
    final box = Hive.box<List>(_boxName);
    await box.delete(operationKey);
    if (Hive.isBoxOpen(_levelBoxName)) {
      await Hive.box<int>(_levelBoxName).delete(operationKey);
    }
  }
}
