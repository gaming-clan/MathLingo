import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_progress.dart';

class UserProgressStorage {
  UserProgressStorage._();

  static const String _boxName = 'user_progress';
  static const String _totalPointsKey = 'total_points';
  static const String _averageAccuracyKey = 'average_accuracy';
  static const String _completedSessionsKey = 'completed_sessions';
  static const String _moduleSessionsKey = 'module_sessions';
  static const String _recentSessionsKey = 'recent_sessions';
  static const int _maxRecentSessions = 10;

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
    final rawModules = box.get(_moduleSessionsKey);
    final moduleSessions = <String, int>{};
    if (rawModules is Map) {
      rawModules.forEach((k, v) {
        if (k is String && v is int) moduleSessions[k] = v;
      });
    }

    final rawSessions = box.get(_recentSessionsKey);
    final recentSessions = <SessionRecord>[];
    if (rawSessions is List) {
      for (final item in rawSessions) {
        if (item is Map) {
          try {
            recentSessions.add(SessionRecord.fromMap(item));
          } on Object {
            // ignore malformed records
          }
        }
      }
    }

    return UserProgress(
      totalPoints: box.get(_totalPointsKey, defaultValue: 0) as int,
      averageAccuracy:
          (box.get(_averageAccuracyKey, defaultValue: 0.0) as num).toDouble(),
      moduleSessions: moduleSessions,
      recentSessions: recentSessions,
    );
  }

  static Future<UserProgress> addSession({
    required int points,
    required int accuracy,
    String? moduleKey,
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

    // Per-module sessions
    final rawModules = box.get(_moduleSessionsKey);
    final moduleSessions = <String, int>{};
    if (rawModules is Map) {
      rawModules.forEach((k, v) {
        if (k is String && v is int) moduleSessions[k] = v;
      });
    }
    if (moduleKey != null) {
      moduleSessions[moduleKey] = (moduleSessions[moduleKey] ?? 0) + 1;
      await box.put(_moduleSessionsKey, moduleSessions);
    }

    // Recent session history (max 10)
    final rawSessions = box.get(_recentSessionsKey);
    final recentList = <Map<String, dynamic>>[];
    if (rawSessions is List) {
      for (final item in rawSessions) {
        if (item is Map) recentList.add(Map<String, dynamic>.from(item));
      }
    }
    final newRecord = SessionRecord(
      timestamp: DateTime.now(),
      points: points,
      accuracy: accuracy,
      moduleKey: moduleKey,
    );
    recentList.add(newRecord.toMap());
    if (recentList.length > _maxRecentSessions) {
      recentList.removeRange(0, recentList.length - _maxRecentSessions);
    }
    await box.put(_recentSessionsKey, recentList);

    // Build updated recentSessions list
    final recentSessions =
        recentList.map((m) => SessionRecord.fromMap(m)).toList();

    return UserProgress(
      totalPoints: updatedPoints,
      averageAccuracy: updatedAverage,
      moduleSessions: moduleSessions,
      recentSessions: recentSessions,
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