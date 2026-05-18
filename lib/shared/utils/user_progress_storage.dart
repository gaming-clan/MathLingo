import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_progress.dart';

class UserProgressStorage {
  UserProgressStorage._();

  static const String _defaultBoxName = 'user_progress';
  static const String _totalPointsKey = 'total_points';
  static const String _averageAccuracyKey = 'average_accuracy';
  static const String _completedSessionsKey = 'completed_sessions';
  static const String _moduleSessionsKey = 'module_sessions';
  static const String _recentSessionsKey = 'recent_sessions';
  static const int _maxRecentSessions = 10;

  // -------------------------------------------------------------------------
  // Inicializim
  // -------------------------------------------------------------------------
  static Future<void>? _hiveFuture;

  /// Inicializo Hive (vetëm një herë). Boxet hapen lazily per childId.
  static Future<void> initialize({String? testPath}) {
    _hiveFuture ??= _initHive(testPath: testPath);
    return _hiveFuture!;
  }

  static Future<void> _initHive({String? testPath}) async {
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }
    // Hap box-in default për backward compat
    if (!Hive.isBoxOpen(_defaultBoxName)) {
      await Hive.openBox<dynamic>(_defaultBoxName);
    }
  }

  // -------------------------------------------------------------------------
  // Box name dhe hapje lazy
  // -------------------------------------------------------------------------
  static String _boxName(String childId) =>
      childId == 'global' ? _defaultBoxName : 'user_progress_$childId';

  static Future<Box<dynamic>> _box(String childId) async {
    await initialize();
    final name = _boxName(childId);
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox<dynamic>(name);
    }
    return Hive.box<dynamic>(name);
  }

  // -------------------------------------------------------------------------
  // API
  // -------------------------------------------------------------------------
  static Future<UserProgress> load({String childId = 'global'}) async {
    final box = await _box(childId);
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
    String childId = 'global',
  }) async {
    final box = await _box(childId);
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

    final recentSessions =
        recentList.map((m) => SessionRecord.fromMap(m)).toList();

    return UserProgress(
      totalPoints: updatedPoints,
      averageAccuracy: updatedAverage,
      moduleSessions: moduleSessions,
      recentSessions: recentSessions,
    );
  }

  /// Fshi të gjitha të dhënat e progresit për GDPR (P-02).
  ///
  /// [childIds] — lista e ID-ve të fëmijëve; global box fshihet gjithmonë.
  static Future<void> deleteAllData({List<String> childIds = const []}) async {
    // Box global
    if (Hive.isBoxOpen(_defaultBoxName)) {
      await Hive.box<dynamic>(_defaultBoxName).clear();
    }
    // Boxet per child
    for (final id in childIds) {
      final name = _boxName(id);
      if (Hive.isBoxOpen(name)) {
        await Hive.box<dynamic>(name).clear();
      }
    }
  }

  @visibleForTesting
  static Future<void> clearForTests({String childId = 'global'}) async {
    final box = await _box(childId);
    await box.clear();
  }

  @visibleForTesting
  static Future<void> resetForTests({String? testPath}) async {
    if (Hive.isBoxOpen(_defaultBoxName)) {
      await Hive.box<dynamic>(_defaultBoxName).close();
    }
    _hiveFuture = null;
    await initialize(testPath: testPath);
  }
}
