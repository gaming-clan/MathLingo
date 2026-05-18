/// Çelësat e koleksioneve dhe fushave Firestore.
///
/// Centralizuar këtu për të shmangur typos dhe për refaktorim të lehtë.
abstract final class FirestoreSchema {
  // ─── Koleksionet ─────────────────────────────────────────────────────────
  static const String users = 'users';
  static const String children = 'children';
  static const String progress = 'progress';
  static const String info = 'info';
  static const String dailyStats = 'daily_stats';

  // ─── Fushat e profilit fëmijës ───────────────────────────────────────────
  static const String pseudonym = 'pseudonym';
  static const String avatarIndex = 'avatarIndex';
  static const String createdAt = 'createdAt';
  static const String lastSyncAt = 'lastSyncAt';

  // ─── Fushat e progresit ──────────────────────────────────────────────────
  static const String totalPoints = 'totalPoints';
  static const String accuracy = 'accuracy';
  static const String completedSessions = 'completedSessions';
  static const String moduleScores = 'moduleScores';

  // ─── Fushat e daily_stats ────────────────────────────────────────────────
  static const String date = 'date';
  static const String dailyTotalPoints = 'totalPoints';
  static const String dailySessionsCount = 'sessionsCount';
  static const String dailyAvgAccuracy = 'avgAccuracy';
  static const String dailyModules = 'modules';
  static const String dailyLastUpdate = 'lastUpdate';

  // ─── Rrugët e dokumenteve ────────────────────────────────────────────────

  /// Dokumenti kryesor i prindit: `users/{uid}`
  static String userDoc(String uid) => '$users/$uid';

  /// Info bazë e fëmijës: `users/{uid}/children/{childId}/info/profile`
  static String childInfoDoc(String uid, String childId) =>
      '$users/$uid/$children/$childId/$info/profile';

  /// Progresi ditor: `users/{uid}/children/{childId}/progress/{date}`
  static String progressDoc(String uid, String childId, String date) =>
      '$users/$uid/$children/$childId/$progress/$date';

  /// Agregati ditor: `users/{uid}/children/{childId}/daily_stats/{yyyy-MM-dd}`
  static String dailyStatsDoc(String uid, String childId, String date) =>
      '$users/$uid/$children/$childId/$dailyStats/$date';

  /// Koleksioni i daily_stats për query-t e leximit (7 ditë):
  /// `users/{uid}/children/{childId}/daily_stats`
  static String dailyStatsCollection(String uid, String childId) =>
      '$users/$uid/$children/$childId/$dailyStats';
}
