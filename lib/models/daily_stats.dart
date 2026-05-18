/// Agregati ditor i statistikave të fëmijës.
///
/// Pasqyron saktësisht strukturën e dokumentit Firestore
/// `users/{uid}/children/{childId}/daily_stats/{yyyy-MM-dd}`.
///
/// Fushë `modules` është opsionale — mund të mungojë në dokumente
/// të vjetra ose kur nuk transmetohet moduleKey gjatë sesionit.
class DailyStats {
  const DailyStats({
    required this.date,
    required this.totalPoints,
    required this.sessionsCount,
    required this.avgAccuracy,
    required this.modules,
  });

  /// Data e ditës në formatin `yyyy-MM-dd`.
  final String date;

  /// Pikët totale të grumbulluara këtë ditë.
  final int totalPoints;

  /// Numri i sesioneve të luajtura.
  final int sessionsCount;

  /// Saktësia mesatare e ditës (0.0 – 1.0).
  final double avgAccuracy;

  /// Breakdown i pikëve sipas modulit.
  /// key = moduleKey (p.sh. 'addition'), value = pikë të grumbulluara.
  final Map<String, int> modules;

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    final rawModules = map['modules'] as Map<String, dynamic>? ?? {};
    return DailyStats(
      date: (map['date'] as String?) ?? '',
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      sessionsCount: (map['sessionsCount'] as num?)?.toInt() ?? 0,
      avgAccuracy: (map['avgAccuracy'] as num?)?.toDouble() ?? 0.0,
      modules: rawModules.map(
        (k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'totalPoints': totalPoints,
        'sessionsCount': sessionsCount,
        'avgAccuracy': avgAccuracy,
        'modules': modules,
      };
}
