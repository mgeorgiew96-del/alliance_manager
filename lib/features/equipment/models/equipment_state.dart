import '../definitions/equipment_slot_definitions.dart';
import 'equipment_enhancement_state.dart';
import 'equipment_slot_state.dart';
import 'equipment_slot_type.dart';

class EquipmentState {
  const EquipmentState({
    required this.slots,
    required this.hasUnsavedChanges,
    this.lastUpdated,
  });

  final Map<EquipmentSlotType, EquipmentSlotState> slots;

  final bool hasUnsavedChanges;
  final DateTime? lastUpdated;

  EquipmentSlotState slot(EquipmentSlotType type) {
    return slots[type]!;
  }

  EquipmentState copyWith({
    Map<EquipmentSlotType, EquipmentSlotState>? slots,
    bool? hasUnsavedChanges,
    DateTime? lastUpdated,
  }) {
    return EquipmentState(
      slots: slots ?? this.slots,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory EquipmentState.empty() {
    final slots = <EquipmentSlotType, EquipmentSlotState>{};

    for (final definition in equipmentSlotDefinitions) {
      slots[definition.type] = EquipmentSlotState(
        enhancements: definition.enhancements.map((enhancement) {
          return EquipmentEnhancementState(id: enhancement.id, level: 0);
        }).toList(),
        jewelLevels: List<int>.filled(definition.jewelCount, 0),
      );
    }

    return EquipmentState(slots: slots, hasUnsavedChanges: false);
  }
}
