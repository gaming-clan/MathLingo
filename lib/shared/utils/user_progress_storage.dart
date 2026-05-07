import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_progress.dart';

class UserProgressStorage {
  UserProgressStorage._();

  static const String _boxName = 'user_progress';
  static const String _totalPointsKey = 'total_points';
  static const String _averageAccuracyKey = 'average_accuracy';
  static const String _completedSessionsKey = 'completed_sessions';

  static Future<void>? _initializeFuture;

  static Future<void> initialize({String? testPath}) {
    _initializeFuture ??= _initializeInternal(testPath: testPath);
    return _initializeFuture!;
  }

  static Future<void> _initializeInternal({String? testPath}) async {
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  static Future<UserProgress> load() async {
    final box = await _box();
    return UserProgress(
      totalPoints: box.get(_totalPointsKey, defaultValue: 0) as int,
      averageAccuracy:
          (box.get(_averageAccuracyKey, defaultValue: 0.0) as num).toDouble(),
    );
  }

  static Future<UserProgress> addSession({
    required int points,
    required int accuracy,
  }) async {
    final box = await _box();
    final currentPoints = box.get(_totalPointsKey, defaultValue: 0) as int;
    final currentAverage =
        (box.get(_averageAccuracyKey, defaultValue: 0.0) as num).toDouble();
    final completedSessions =
        box.get(_completedSessionsKey, defaultValue: 0) as int;

    final updatedSessions = completedSessions + 1;
    final updatedAverage =
        ((currentAverage * completedSessions) + accuracy) / updatedSessions;
    final updatedPoints = currentPoints + points;

    await box.put(_totalPointsKey, updatedPoints);
    await box.put(_averageAccuracyKey, updatedAverage);
    await box.put(_completedSessionsKey, updatedSessions);

    return UserProgress(
      totalPoints: updatedPoints,
      averageAccuracy: updatedAverage,
    );
  }

  @visibleForTesting
  static Future<void> clearForTests() async {
    final box = await _box();
    await box.clear();
  }

  @visibleForTesting
  static Future<void> resetForTests({String? testPath}) async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).close();
    }
    _initializeFuture = null;
    await initialize(testPath: testPath);
  }

  static Future<Box<dynamic>> _box() async {
    await initialize();
    return Hive.box<dynamic>(_boxName);
  }
}