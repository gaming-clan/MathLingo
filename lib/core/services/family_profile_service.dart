import 'package:hive_flutter/hive_flutter.dart';

import '../../models/child_profile.dart';
import '../../models/family_profile.dart';

/// Shërbimi i profilit familjar — i vetmi pikë e shkrimit te Hive.
///
/// Box: `family_data` (dynamic)
/// Keys:
///   - `_familyKey`       → Map (FamilyProfile serialized), ose null nëse nuk ekziston
///   - `_activeChildKey`  → String (ID e fëmijës aktiv), ose null
class FamilyProfileService {
  FamilyProfileService._();

  static const String _boxName = 'family_data';
  static const String _familyKey = 'family';
  static const String _activeChildKey = 'active_child_id';

  static Future<void>? _initFuture;

  static Future<void> init() {
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  static Future<void> _initInternal() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  static Box<dynamic> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'FamilyProfileService: box "$_boxName" nuk është hapur. '
        'Thirr FamilyProfileService.init() në main().',
      );
    }
    return Hive.box<dynamic>(_boxName);
  }

  // --------------------------------------------------------------------------
  // Family CRUD
  // --------------------------------------------------------------------------

  /// Ngarkon profilin familjar ose null nëse nuk ekziston.
  static FamilyProfile? loadFamily() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final raw = _box.get(_familyKey);
    if (raw == null) return null;
    try {
      return FamilyProfile.fromMap(raw as Map);
    } on Object {
      return null;
    }
  }

  /// A ekziston ndonjë familje e konfiguruar.
  static bool get hasFamily => loadFamily() != null;

  /// Krijon familje të re me fëmijën e parë.
  static Future<FamilyProfile> createFamily({
    required String pseudonym,
    required int avatarIndex,
  }) async {
    final child = ChildProfile(
      id: _generateId(),
      pseudonym: pseudonym,
      avatarIndex: avatarIndex,
      totalPoints: 0,
      totalAccuracy: 0.0,
      completedSessions: 0,
      moduleHistory: {},
    );
    final family = FamilyProfile(
      id: _generateId(),
      createdAt: DateTime.now(),
      children: [child],
    );
    await _saveFamily(family);
    await setActiveChild(child.id);
    return family;
  }

  /// Shton fëmijë të ri (max 4).
  static Future<ChildProfile?> addChild({
    required String pseudonym,
    required int avatarIndex,
  }) async {
    final family = loadFamily();
    if (family == null || family.isFull) return null;

    final child = ChildProfile(
      id: _generateId(),
      pseudonym: pseudonym,
      avatarIndex: avatarIndex,
      totalPoints: 0,
      totalAccuracy: 0.0,
      completedSessions: 0,
      moduleHistory: {},
    );
    final updated = family.copyWith(
      children: [...family.children, child],
    );
    await _saveFamily(updated);
    return child;
  }

  /// Fshi fëmijën dhe të gjitha të dhënat e tij.
  static Future<void> deleteChild(String childId) async {
    final family = loadFamily();
    if (family == null) return;

    final updated = family.copyWith(
      children: family.children.where((c) => c.id != childId).toList(),
    );
    await _saveFamily(updated);

    // Nëse fëmija aktiv u fshi, aktivizo të parin tjetër
    if (getActiveChildId() == childId) {
      final newActive =
          updated.children.isNotEmpty ? updated.children.first.id : null;
      if (newActive != null) {
        await setActiveChild(newActive);
      } else {
        await _box.delete(_activeChildKey);
      }
    }
  }

  /// Fshi familjen dhe të gjitha të dhënat (GDPR P-02).
  static Future<void> deleteAllData() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    await _box.clear();
  }

  // --------------------------------------------------------------------------
  // Session update
  // --------------------------------------------------------------------------

  /// Regjistron sesionin për fëmijën aktiv.
  static Future<ChildProfile?> recordSession({
    required int points,
    required int accuracy,
    String? moduleKey,
  }) async {
    final family = loadFamily();
    if (family == null) return null;

    final activeId = getActiveChildId();
    if (activeId == null) return null;

    final idx = family.children.indexWhere((c) => c.id == activeId);
    if (idx < 0) return null;

    final updated = family.children[idx].withSession(
      points: points,
      accuracy: accuracy,
      moduleKey: moduleKey,
    );

    final newChildren = List<ChildProfile>.from(family.children);
    newChildren[idx] = updated;
    await _saveFamily(family.copyWith(children: newChildren));
    return updated;
  }

  // --------------------------------------------------------------------------
  // Active child
  // --------------------------------------------------------------------------

  static String? getActiveChildId() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    return _box.get(_activeChildKey) as String?;
  }

  static Future<void> setActiveChild(String childId) async {
    await _box.put(_activeChildKey, childId);
  }

  static ChildProfile? getActiveChild() {
    final family = loadFamily();
    if (family == null) return null;
    final id = getActiveChildId();
    if (id == null) return family.children.isNotEmpty ? family.children.first : null;
    try {
      return family.children.firstWhere((c) => c.id == id);
    } on StateError {
      return family.children.isNotEmpty ? family.children.first : null;
    }
  }

  // --------------------------------------------------------------------------
  // Helpers
  // --------------------------------------------------------------------------

  static Future<void> _saveFamily(FamilyProfile family) async {
    await _box.put(_familyKey, family.toMap());
  }

  static const String _pinKey = 'parent_pin';

  /// Vendos PIN-in prindëror (4 shifra).
  static Future<void> setParentPin(String pin) async {
    await _box.put(_pinKey, pin);
  }

  /// Kthen `true` nëse PIN-i i vendosur është i saktë.
  static bool verifyParentPin(String pin) {
    final stored = _box.get(_pinKey) as String?;
    if (stored == null) return true; // pa PIN → lejo gjithmonë
    return stored == pin;
  }

  /// A është konfiguruar PIN-i prindëror.
  static bool get hasParentPin {
    if (!Hive.isBoxOpen(_boxName)) return false;
    return _box.get(_pinKey) != null;
  }

  static String _generateId() =>
      '${DateTime.now().millisecondsSinceEpoch}_'
      '${(DateTime.now().microsecondsSinceEpoch % 9999).toString().padLeft(4, '0')}';
}
