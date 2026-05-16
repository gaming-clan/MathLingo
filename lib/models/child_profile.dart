/// Profili i një fëmije brenda familjes.
class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.pseudonym,
    required this.avatarIndex,
    required this.totalPoints,
    required this.totalAccuracy,
    required this.completedSessions,
    required this.moduleHistory,
  });

  /// ID unike (UUID-stil, e gjeneruar me timestamp + random).
  final String id;

  /// Pseudonimi i fëmijës (max 20 karaktere).
  final String pseudonym;

  /// Indeksi i avatarit (0–7) nga lista [ChildAvatars.all].
  final int avatarIndex;

  /// Pikë totale të akumuluara.
  final int totalPoints;

  /// Saktësi mesatare e të gjitha sesioneve (0–100).
  final double totalAccuracy;

  /// Numri total i sesioneve të kryera.
  final int completedSessions;

  /// Historiku sipas modulit: key = moduleKey, value = {sessions, points, totalAccuracy}.
  final Map<String, Map<String, dynamic>> moduleHistory;

  /// Kopja me ndryshime.
  ChildProfile copyWith({
    String? id,
    String? pseudonym,
    int? avatarIndex,
    int? totalPoints,
    double? totalAccuracy,
    int? completedSessions,
    Map<String, Map<String, dynamic>>? moduleHistory,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      pseudonym: pseudonym ?? this.pseudonym,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      totalPoints: totalPoints ?? this.totalPoints,
      totalAccuracy: totalAccuracy ?? this.totalAccuracy,
      completedSessions: completedSessions ?? this.completedSessions,
      moduleHistory: moduleHistory ?? this.moduleHistory,
    );
  }

  /// Kthe profil pas shtimit të sesionit.
  ChildProfile withSession({
    required int points,
    required int accuracy,
    String? moduleKey,
  }) {
    final newSessions = completedSessions + 1;
    final newTotalAccuracy =
        (totalAccuracy * completedSessions + accuracy) / newSessions;

    final newHistory = Map<String, Map<String, dynamic>>.from(
      moduleHistory.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))),
    );
    if (moduleKey != null) {
      final existing = newHistory[moduleKey] ??
          {'sessions': 0, 'points': 0, 'totalAccuracy': 0.0};
      final s = (existing['sessions'] as int? ?? 0) + 1;
      final p = (existing['points'] as int? ?? 0) + points;
      final ta =
          ((existing['totalAccuracy'] as num? ?? 0.0) * (s - 1) + accuracy) /
              s;
      newHistory[moduleKey] = {
        'sessions': s,
        'points': p,
        'totalAccuracy': ta,
      };
    }

    return copyWith(
      totalPoints: totalPoints + points,
      totalAccuracy: newTotalAccuracy,
      completedSessions: newSessions,
      moduleHistory: newHistory,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'pseudonym': pseudonym,
        'avatarIndex': avatarIndex,
        'totalPoints': totalPoints,
        'totalAccuracy': totalAccuracy,
        'completedSessions': completedSessions,
        'moduleHistory': moduleHistory.map(
          (k, v) => MapEntry(k, Map<String, dynamic>.from(v)),
        ),
      };

  factory ChildProfile.fromMap(Map map) {
    final rawHistory = map['moduleHistory'];
    final moduleHistory = <String, Map<String, dynamic>>{};
    if (rawHistory is Map) {
      rawHistory.forEach((k, v) {
        if (k is String && v is Map) {
          moduleHistory[k] = Map<String, dynamic>.from(v);
        }
      });
    }
    return ChildProfile(
      id: map['id'] as String,
      pseudonym: map['pseudonym'] as String,
      avatarIndex: (map['avatarIndex'] as num?)?.toInt() ?? 0,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      totalAccuracy: (map['totalAccuracy'] as num?)?.toDouble() ?? 0.0,
      completedSessions: (map['completedSessions'] as num?)?.toInt() ?? 0,
      moduleHistory: moduleHistory,
    );
  }
}

/// Avatarët e disponueshëm për fëmijë.
abstract final class ChildAvatars {
  static const List<String> all = [
    '🐱', // 0
    '🐶', // 1
    '🦊', // 2
    '🐸', // 3
    '🐺', // 4
    '🦁', // 5
    '🐯', // 6
    '🦄', // 7
  ];

  static String get(int index) => all[index.clamp(0, all.length - 1)];
}
