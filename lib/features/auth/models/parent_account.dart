/// Modeli i llogarisë prindërore.
///
/// Ruan vetëm informacionin minimal — UID Firebase dhe email-in.
/// NDALIM: Asnjë të dhënë fëmijësh nuk ruhet këtu (vetëm te FamilyProfile).
///
/// Persistohet te Hive box `parent_account` me serialiazim manual (pa codegen).
class ParentAccount {
  const ParentAccount({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.cloudSyncEnabled = false,
    this.lastSyncAt,
  });

  /// Firebase UID — identifikuesi kryesor, jo email.
  final String uid;

  final String email;

  final DateTime createdAt;

  /// A ka aktivizuar prindi sinkronizimin cloud?
  final bool cloudSyncEnabled;

  final DateTime? lastSyncAt;

  ParentAccount copyWith({
    bool? cloudSyncEnabled,
    DateTime? lastSyncAt,
  }) {
    return ParentAccount(
      uid: uid,
      email: email,
      createdAt: createdAt,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'cloudSyncEnabled': cloudSyncEnabled,
        'lastSyncAt': lastSyncAt?.toIso8601String(),
      };

  factory ParentAccount.fromMap(Map<dynamic, dynamic> map) => ParentAccount(
        uid: map['uid'] as String,
        email: map['email'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        cloudSyncEnabled: map['cloudSyncEnabled'] as bool? ?? false,
        lastSyncAt: map['lastSyncAt'] != null
            ? DateTime.parse(map['lastSyncAt'] as String)
            : null,
      );
}
