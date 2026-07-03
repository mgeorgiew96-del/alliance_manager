class RealmModel {
  const RealmModel({
    required this.realmId,
    required this.name,
    required this.isActive,
    this.createdAt,
    this.createdBy,
  });

  final String realmId;
  final String name;
  final bool isActive;
  final DateTime? createdAt;
  final String? createdBy;

  RealmModel copyWith({
    String? realmId,
    String? name,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return RealmModel(
      realmId: realmId ?? this.realmId,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}