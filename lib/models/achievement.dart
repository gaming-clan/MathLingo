/// Modeli i arritjes (badge) i gamifikimit.
///
/// Të gjitha 15 badge-t janë definuar si konstante në [AchievementService.all].
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
  });

  /// ID unike e badge-it (p.sh. 'first_session', 'perfect_score').
  final String id;

  /// Emoji që përfaqëson badge-in.
  final String emoji;

  /// Emri i shfaqur për badge-in.
  final String name;

  /// Përshkrimi i shkurtër i kushtit.
  final String description;
}
