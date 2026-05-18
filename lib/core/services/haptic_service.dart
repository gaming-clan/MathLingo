import 'package:flutter/services.dart';

/// Shërbimi i reagimit haptik — C-03.
///
/// Tre nivele: i butë (tap), mesatar (saktësi), i fortë (level-up/badge).
abstract final class HapticService {
  /// Reagim i butë — tap i zakonshëm.
  static void tap() => HapticFeedback.lightImpact();

  /// Reagim mesatar — përgjigje e saktë.
  static void correct() => HapticFeedback.mediumImpact();

  /// Reagim i fortë — level-up ose badge i ri.
  static void levelUp() => HapticFeedback.heavyImpact();
}
