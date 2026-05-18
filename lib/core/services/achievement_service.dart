import 'package:hive_flutter/hive_flutter.dart';

import '../../models/achievement.dart';
import '../../models/child_profile.dart';

/// Shërbimi i arritjeve (badge-ve) — G-01 / G-02.
///
/// Ruan listën e badge-ve të deblokuara per-child në Hive.
/// Nuk ka codegen — map-et ruhen si List<String> (IDs).
abstract final class AchievementService {
  static const String _boxName = 'achievements';

  /// Inicializo boxin Hive. Thirret nga [main()].
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  // ── 15 badge të definuara ────────────────────────────────────────────────

  static const List<Achievement> all = [
    Achievement(
      id: 'first_session',
      emoji: '⭐',
      name: 'Fillestari',
      description: 'Kryo sesionin e parë matematikor.',
    ),
    Achievement(
      id: 'five_sessions',
      emoji: '💪',
      name: 'I Qëndrueshëm',
      description: 'Kryeje 5 sesione.',
    ),
    Achievement(
      id: 'ten_sessions',
      emoji: '🔥',
      name: 'I Dedicuar',
      description: 'Kryeje 10 sesione.',
    ),
    Achievement(
      id: 'perfect_score',
      emoji: '🎯',
      name: 'Shënjestari',
      description: 'Perfundo sesion me saktësi 100%.',
    ),
    Achievement(
      id: 'fifty_points',
      emoji: '💰',
      name: 'Mbledhës Pikësh',
      description: 'Grumbulllo 50 pikë.',
    ),
    Achievement(
      id: 'two_hundred_points',
      emoji: '👑',
      name: 'Kampion',
      description: 'Grumbulllo 200 pikë.',
    ),
    Achievement(
      id: 'addition_starter',
      emoji: '➕',
      name: 'Mbledhësi',
      description: 'Fillo modulin e mbledhjes.',
    ),
    Achievement(
      id: 'addition_master',
      emoji: '🧮',
      name: 'Maestro i Mbledhjes',
      description: 'Kryeje 5 sesione mbledhje.',
    ),
    Achievement(
      id: 'multiplication_master',
      emoji: '✖️',
      name: 'Zoti i Shumëzimit',
      description: 'Kryeje 5 sesione shumëzim.',
    ),
    Achievement(
      id: 'geometry_starter',
      emoji: '📐',
      name: 'Gjeometri Fillestar',
      description: 'Provo modulin e gjeometrisë.',
    ),
    Achievement(
      id: 'geometry_scientist',
      emoji: '🔬',
      name: 'Shkencëtar i Gjeometrisë',
      description: 'Kryeje 5 sesione gjeometri.',
    ),
    Achievement(
      id: 'missing_x_starter',
      emoji: '🔍',
      name: 'Gjuetari X',
      description: 'Provo modulin "Gjej X-in".',
    ),
    Achievement(
      id: 'missing_x_hunter',
      emoji: '🧮',
      name: 'Zgjidh Ekuacione',
      description: 'Kryeje 5 sesione "Gjej X-in".',
    ),
    Achievement(
      id: 'fraction_starter',
      emoji: '🍕',
      name: 'Fraksionisti',
      description: 'Provo modulin e fraksioneve.',
    ),
    Achievement(
      id: 'adventurer',
      emoji: '🗺️',
      name: 'Aventurieri',
      description: 'Provo 4 ose më shumë module të ndryshme.',
    ),
  ];

  // ── Lexim ─────────────────────────────────────────────────────────────────

  static String _key(String childId) => 'unlocked_$childId';

  static Future<List<String>> getUnlockedIds(String childId) async {
    if (!Hive.isBoxOpen(_boxName)) await init();
    final raw = Hive.box<dynamic>(_boxName).get(_key(childId));
    if (raw is List) return List<String>.from(raw);
    return [];
  }

  static Future<List<Achievement>> getUnlocked(String childId) async {
    final ids = await getUnlockedIds(childId);
    return all.where((a) => ids.contains(a.id)).toList();
  }

  // ── Verifikim pas sesionit ────────────────────────────────────────────────

  /// Kontrollo arritjet e reja kundrejt profilit të përditësuar të fëmijës.
  ///
  /// [lastAccuracy] — saktësia e sesionit të fundit (0–100), për 'perfect_score'.
  /// Kthen vetëm arritjet e reja (jo ato tashmë të deblokuara).
  static Future<List<Achievement>> checkNewAchievements({
    required String childId,
    required ChildProfile child,
    int? lastAccuracy,
  }) async {
    if (!Hive.isBoxOpen(_boxName)) await init();
    final unlocked = await getUnlockedIds(childId);
    final newOnes = <Achievement>[];

    for (final a in all) {
      if (!unlocked.contains(a.id) &&
          _isMet(a.id, child, lastAccuracy)) {
        newOnes.add(a);
        unlocked.add(a.id);
      }
    }

    if (newOnes.isNotEmpty) {
      await Hive.box<dynamic>(_boxName).put(_key(childId), unlocked);
    }
    return newOnes;
  }

  // ── Fshirje GDPR (P-02) ───────────────────────────────────────────────────

  static Future<void> deleteAllData({List<String> childIds = const []}) async {
    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<dynamic>(_boxName);
    for (final id in childIds) {
      await box.delete(_key(id));
    }
  }

  // ── Logjika e kushteve ────────────────────────────────────────────────────

  static bool _isMet(String id, ChildProfile child, int? lastAccuracy) {
    switch (id) {
      case 'first_session':
        return child.completedSessions >= 1;
      case 'five_sessions':
        return child.completedSessions >= 5;
      case 'ten_sessions':
        return child.completedSessions >= 10;
      case 'perfect_score':
        return lastAccuracy == 100;
      case 'fifty_points':
        return child.totalPoints >= 50;
      case 'two_hundred_points':
        return child.totalPoints >= 200;
      case 'addition_starter':
        return _moduleSessions(child, 'Mbledhje') >= 1;
      case 'addition_master':
        return _moduleSessions(child, 'Mbledhje') >= 5;
      case 'multiplication_master':
        return _moduleSessions(child, 'Shumëzim') >= 5;
      case 'geometry_starter':
        return _moduleSessions(child, 'Gjeometri') >= 1;
      case 'geometry_scientist':
        return _moduleSessions(child, 'Gjeometri') >= 5;
      case 'missing_x_starter':
        return _moduleSessions(child, 'Gjej X-in') >= 1;
      case 'missing_x_hunter':
        return _moduleSessions(child, 'Gjej X-in') >= 5;
      case 'fraction_starter':
        return _moduleSessions(child, 'Fraksionet') >= 1;
      case 'adventurer':
        return child.moduleHistory.length >= 4;
      default:
        return false;
    }
  }

  static int _moduleSessions(ChildProfile child, String key) {
    final h = child.moduleHistory[key];
    if (h == null) return 0;
    return (h['sessions'] as int?) ?? 0;
  }
}
