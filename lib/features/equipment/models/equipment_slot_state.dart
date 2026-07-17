import 'equipment_enhancement_state.dart';

class EquipmentSlotState {
  const EquipmentSlotState({
    required this.enhancements,
    required this.jewelLevels,
  });

  final List<EquipmentEnhancementState> enhancements;

  /// Jewel levels belong to the complete equipment slot,
  /// not to individual equipment pieces.
  final List<int> jewelLevels;

  EquipmentSlotState copyWith({
    List<EquipmentEnhancementState>? enhancements,
    List<int>? jewelLevels,
  }) {
    return EquipmentSlotState(
      enhancements: enhancements ?? this.enhancements,
      jewelLevels: jewelLevels ?? this.jewelLevels,
    );
  }
}
