import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/progress/progress_priority.dart';
import '../models/equipment_slot_type.dart';
import '../services/equipment_progress_config.dart';

class EquipmentProgressConfigController
    extends Notifier<EquipmentProgressConfig> {
  late EquipmentProgressConfig _savedConfig;

  @override
  EquipmentProgressConfig build() {
    final initialConfig = EquipmentProgressConfig.initial();
    _savedConfig = initialConfig;
    return initialConfig;
  }

  void setSlotWeight({
    required EquipmentSlotType slotType,
    required double weight,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final updatedSlotConfigs =
        Map<EquipmentSlotType, EquipmentSlotProgressConfig>.from(
          state.slotConfigs,
        );

    updatedSlotConfigs[slotType] = currentSlotConfig.copyWith(
      weight: weight.clamp(0, 1).toDouble(),
    );

    state = state.copyWith(slotConfigs: updatedSlotConfigs);
  }

  void setEnhancementTracked({
    required EquipmentSlotType slotType,
    required String enhancementId,
    required bool isTracked,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final currentItem = currentSlotConfig.enhancementConfigs[enhancementId];

    if (currentItem == null) {
      return;
    }

    final updatedEnhancements = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.enhancementConfigs,
    );

    updatedEnhancements[enhancementId] = currentItem.copyWith(
      isTracked: isTracked,
    );

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(
        enhancementConfigs: updatedEnhancements,
      ),
    );
  }

  void setEnhancementTargetLevel({
    required EquipmentSlotType slotType,
    required String enhancementId,
    required int targetLevel,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final currentItem = currentSlotConfig.enhancementConfigs[enhancementId];

    if (currentItem == null) {
      return;
    }

    final updatedEnhancements = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.enhancementConfigs,
    );

    updatedEnhancements[enhancementId] = currentItem.copyWith(
      targetLevel: targetLevel,
    );

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(
        enhancementConfigs: updatedEnhancements,
      ),
    );
  }

  void setEnhancementPriority({
    required EquipmentSlotType slotType,
    required String enhancementId,
    required ProgressPriority priority,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final currentItem = currentSlotConfig.enhancementConfigs[enhancementId];

    if (currentItem == null) {
      return;
    }

    final updatedEnhancements = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.enhancementConfigs,
    );

    updatedEnhancements[enhancementId] = currentItem.copyWith(
      priority: priority,
    );

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(
        enhancementConfigs: updatedEnhancements,
      ),
    );
  }

  void setJewelTracked({
    required EquipmentSlotType slotType,
    required int jewelIndex,
    required bool isTracked,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final jewelId = 'jewel_$jewelIndex';
    final currentItem = currentSlotConfig.jewelConfigs[jewelId];

    if (currentItem == null) {
      return;
    }

    final updatedJewels = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.jewelConfigs,
    );

    updatedJewels[jewelId] = currentItem.copyWith(isTracked: isTracked);

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(jewelConfigs: updatedJewels),
    );
  }

  void setJewelTargetLevel({
    required EquipmentSlotType slotType,
    required int jewelIndex,
    required int targetLevel,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final jewelId = 'jewel_$jewelIndex';
    final currentItem = currentSlotConfig.jewelConfigs[jewelId];

    if (currentItem == null) {
      return;
    }

    final updatedJewels = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.jewelConfigs,
    );

    updatedJewels[jewelId] = currentItem.copyWith(targetLevel: targetLevel);

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(jewelConfigs: updatedJewels),
    );
  }

  void setJewelPriority({
    required EquipmentSlotType slotType,
    required int jewelIndex,
    required ProgressPriority priority,
  }) {
    final currentSlotConfig = state.slotConfigs[slotType];

    if (currentSlotConfig == null) {
      return;
    }

    final jewelId = 'jewel_$jewelIndex';
    final currentItem = currentSlotConfig.jewelConfigs[jewelId];

    if (currentItem == null) {
      return;
    }

    final updatedJewels = Map<String, EquipmentTrackedItemConfig>.from(
      currentSlotConfig.jewelConfigs,
    );

    updatedJewels[jewelId] = currentItem.copyWith(priority: priority);

    _updateSlotConfig(
      slotType: slotType,
      config: currentSlotConfig.copyWith(jewelConfigs: updatedJewels),
    );
  }

  void _updateSlotConfig({
    required EquipmentSlotType slotType,
    required EquipmentSlotProgressConfig config,
  }) {
    final updatedSlotConfigs =
        Map<EquipmentSlotType, EquipmentSlotProgressConfig>.from(
          state.slotConfigs,
        );

    updatedSlotConfigs[slotType] = config;

    state = state.copyWith(slotConfigs: updatedSlotConfigs);
  }

  void save() {
    _savedConfig = state;
  }

  void cancel() {
    state = _savedConfig;
  }

  void resetToDefaults() {
    state = EquipmentProgressConfig.initial();
  }
}

final equipmentProgressConfigProvider =
    NotifierProvider<
      EquipmentProgressConfigController,
      EquipmentProgressConfig
    >(EquipmentProgressConfigController.new);
