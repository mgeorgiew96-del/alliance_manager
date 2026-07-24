class AllianceModel {
  const AllianceModel({
    required this.allianceId,
    required this.realmId,
    required this.name,
    required this.displayName,
    required this.r5MemberId,
    required this.isActive,
    this.createdAt,
    this.createdBy,
  });

  final String allianceId;
  final String realmId;
  final String name;
  final String displayName;
  final String r5MemberId;
  final bool isActive;
  final DateTime? createdAt;
  final String? createdBy;

  AllianceModel copyWith({
    String? allianceId,
    String? realmId,
    String? name,
    String? displayName,
    String? r5MemberId,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return AllianceModel(
      allianceId: allianceId ?? this.allianceId,
      realmId: realmId ?? this.realmId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      r5MemberId: r5MemberId ?? this.r5MemberId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
