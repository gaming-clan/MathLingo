import 'child_profile.dart';

/// Profili familjar — mban listën e fëmijëve.
class FamilyProfile {
  const FamilyProfile({
    required this.id,
    required this.createdAt,
    required this.children,
  });

  final String id;
  final DateTime createdAt;

  /// Fëmijët e familjes (max 4).
  final List<ChildProfile> children;

  static const int maxChildren = 4;

  bool get isFull => children.length >= maxChildren;

  FamilyProfile copyWith({
    String? id,
    DateTime? createdAt,
    List<ChildProfile>? children,
  }) {
    return FamilyProfile(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'children': children.map((c) => c.toMap()).toList(),
      };

  factory FamilyProfile.fromMap(Map map) {
    final rawChildren = map['children'];
    final children = <ChildProfile>[];
    if (rawChildren is List) {
      for (final item in rawChildren) {
        if (item is Map) {
          try {
            children.add(ChildProfile.fromMap(item));
          } on Object {
            // ignore malformed records
          }
        }
      }
    }
    return FamilyProfile(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as num?)?.toInt() ?? 0,
      ),
      children: children,
    );
  }
}
