class EquipmentEnhancementState {
  const EquipmentEnhancementState({required this.id, required this.level});

  final String id;
  final int level;

  EquipmentEnhancementState copyWith({String? id, int? level}) {
    return EquipmentEnhancementState(
      id: id ?? this.id,
      level: level ?? this.level,
    );
  }
}
