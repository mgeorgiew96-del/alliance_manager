import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment_enhancement_state.dart';
import '../models/equipment_slot_state.dart';
import '../models/equipment_slot_type.dart';
import '../models/equipment_state.dart';
import '../repositories/equipment_repository.dart';

class EquipmentController extends Notifier<EquipmentState> {
  late EquipmentRepository _repository;

  @override
  EquipmentState build() {
    _repository = equipmentRepository;

    return _repository.savedState.copyWith(hasUnsavedChanges: false);
  }

  EquipmentSlotState slot(EquipmentSlotType type) {
    return state.slot(type);
  }

  void setEnhancementLevel(
    EquipmentSlotType type,
    String enhancementId,
    int level,
  ) {
    final currentSlot = state.slots[type];

    if (currentSlot == null) {
      return;
    }

    final safeLevel = level.clamp(0, 30);

    final currentEnhancement = currentSlot.enhancements.firstWhere(
      (enhancement) => enhancement.id == enhancementId,
    );

    if (currentEnhancement.level == safeLevel) {
      return;
    }

    final updatedEnhancements = currentSlot.enhancements.map((enhancement) {
      if (enhancement.id != enhancementId) {
        return enhancement;
      }

      return EquipmentEnhancementState(id: enhancement.id, level: safeLevel);
    }).toList();

    final updatedSlots = Map<EquipmentSlotType, EquipmentSlotState>.from(
      state.slots,
    );

    updatedSlots[type] = currentSlot.copyWith(
      enhancements: updatedEnhancements,
    );

    state = state.copyWith(slots: updatedSlots, hasUnsavedChanges: true);
  }

  void setJewelLevel(EquipmentSlotType type, int jewelIndex, int level) {
    final currentSlot = state.slots[type];

    if (currentSlot == null) {
      return;
    }

    if (jewelIndex < 0 || jewelIndex >= currentSlot.jewelLevels.length) {
      return;
    }

    final safeLevel = level.clamp(0, 30);

    if (currentSlot.jewelLevels[jewelIndex] == safeLevel) {
      return;
    }

    final updatedJewelLevels = List<int>.from(currentSlot.jewelLevels);

    updatedJewelLevels[jewelIndex] = safeLevel;

    final updatedSlots = Map<EquipmentSlotType, EquipmentSlotState>.from(
      state.slots,
    );

    updatedSlots[type] = currentSlot.copyWith(jewelLevels: updatedJewelLevels);

    state = state.copyWith(slots: updatedSlots, hasUnsavedChanges: true);
  }

  Future<void> save() async {
    if (!state.hasUnsavedChanges) {
      return;
    }

    final savedState = state.copyWith(
      hasUnsavedChanges: false,
      lastUpdated: DateTime.now(),
    );

    await _repository.save(state: savedState);

    state = savedState;
  }

  void cancel() {
    state = _repository.savedState.copyWith(hasUnsavedChanges: false);
  }

  void resetDraft() {
    state = EquipmentState.empty().copyWith(
      hasUnsavedChanges: true,
      lastUpdated: state.lastUpdated,
    );
  }
}

final equipmentControllerProvider =
    NotifierProvider<EquipmentController, EquipmentState>(
      EquipmentController.new,
    );
