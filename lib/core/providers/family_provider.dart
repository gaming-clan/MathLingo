import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/child_profile.dart';
import '../../models/family_profile.dart';
import '../services/family_profile_service.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class FamilyState {
  const FamilyState({
    required this.family,
    required this.activeChild,
  });

  /// null → nuk ka familje të konfiguruar (shfaq FamilySetupScreen).
  final FamilyProfile? family;

  /// null → nuk ka fëmijë aktiv (rast i rrallë).
  final ChildProfile? activeChild;

  bool get hasFamily => family != null;

  FamilyState copyWith({
    FamilyProfile? family,
    ChildProfile? activeChild,
  }) {
    return FamilyState(
      family: family ?? this.family,
      activeChild: activeChild ?? this.activeChild,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class FamilyNotifier extends StateNotifier<FamilyState> {
  FamilyNotifier()
      : super(const FamilyState(family: null, activeChild: null)) {
    _load();
  }

  void _load() {
    final family = FamilyProfileService.loadFamily();
    final activeChild = FamilyProfileService.getActiveChild();
    state = FamilyState(family: family, activeChild: activeChild);
  }

  /// Krijon familje të re me fëmijën e parë.
  Future<void> createFamily({
    required String pseudonym,
    required int avatarIndex,
  }) async {
    final family = await FamilyProfileService.createFamily(
      pseudonym: pseudonym,
      avatarIndex: avatarIndex,
    );
    state = FamilyState(
      family: family,
      activeChild: family.children.first,
    );
  }

  /// Shton fëmijë të ri.
  Future<ChildProfile?> addChild({
    required String pseudonym,
    required int avatarIndex,
  }) async {
    final child = await FamilyProfileService.addChild(
      pseudonym: pseudonym,
      avatarIndex: avatarIndex,
    );
    if (child != null) _load();
    return child;
  }

  /// Fshi fëmijën.
  Future<void> deleteChild(String childId) async {
    await FamilyProfileService.deleteChild(childId);
    _load();
  }

  /// Ndërro fëmijën aktiv.
  Future<void> switchChild(String childId) async {
    await FamilyProfileService.setActiveChild(childId);
    _load();
  }

  /// Regjistron sesion dhe rifreskron state.
  Future<void> recordSession({
    required int points,
    required int accuracy,
    String? moduleKey,
  }) async {
    await FamilyProfileService.recordSession(
      points: points,
      accuracy: accuracy,
      moduleKey: moduleKey,
    );
    _load();
  }

  /// Fshi të gjitha të dhënat.
  Future<void> deleteAllData() async {
    await FamilyProfileService.deleteAllData();
    state = const FamilyState(family: null, activeChild: null);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------
final familyProvider =
    StateNotifierProvider<FamilyNotifier, FamilyState>(
  (ref) => FamilyNotifier(),
);

/// Fëmija aktiv i zgjedhur.
final activeChildProvider = Provider<ChildProfile?>(
  (ref) => ref.watch(familyProvider).activeChild,
);
