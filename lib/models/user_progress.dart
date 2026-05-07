/// Statistikat e një sesioni të vetëm (ruhet në histori).
class SessionRecord {
  const SessionRecord({
    required this.timestamp,
    required this.points,
    required this.accuracy,
    this.moduleKey,
  });

  final DateTime timestamp;
  final int points;
  final int accuracy;
  final String? moduleKey;

  Map<String, dynamic> toMap() => {
        'ts': timestamp.millisecondsSinceEpoch,
        'pts': points,
        'acc': accuracy,
        'mod': moduleKey,
      };

  factory SessionRecord.fromMap(Map<dynamic, dynamic> map) => SessionRecord(
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['ts'] as int),
        points: map['pts'] as int,
        accuracy: map['acc'] as int,
        moduleKey: map['mod'] as String?,
      );
}

class UserProgress {
  const UserProgress({
    required this.totalPoints,
    required this.averageAccuracy,
    this.moduleSessions = const {},
    this.recentSessions = const [],
  });

  const UserProgress.empty()
      : totalPoints = 0,
        averageAccuracy = 0,
        moduleSessions = const {},
        recentSessions = const [];

  final int totalPoints;
  final double averageAccuracy;

  /// Numri i sesioneve të kompletuar per modul. Key = emri i modulit.
  final Map<String, int> moduleSessions;

  /// Lista e 10 sesioneve të fundit (kronologjike, i fundit i fundit).
  final List<SessionRecord> recentSessions;

  int sessionsForModule(String moduleKey) => moduleSessions[moduleKey] ?? 0;

  /// Progres 0..1 per modul, targetSessions = target i plotë.
  double progressForModule(String moduleKey, {int targetSessions = 10}) {
    return (sessionsForModule(moduleKey) / targetSessions).clamp(0.0, 1.0);
  }

  double totalPointsProgress({int targetPoints = 100}) {
    if (targetPoints <= 0) return 0;
    return (totalPoints / targetPoints).clamp(0.0, 1.0);
  }

  double accuracyProgress() {
    return (averageAccuracy / 100).clamp(0.0, 1.0);
  }
}