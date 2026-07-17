import '../../../shared/progress/progress_priority.dart';
import '../definitions/equipment_slot_definitions.dart';
import '../models/equipment_slot_type.dart';

class EquipmentTrackedItemConfig {
  const EquipmentTrackedItemConfig({
    required this.id,
    required this.isTracked,
    required this.targetLevel,
    required this.priority,
  });

  final String id;
  final bool isTracked;
  final int targetLevel;
  final ProgressPriority priority;

  EquipmentTrackedItemConfig copyWith({
    String? id,
    bool? isTracked,
    int? targetLevel,
    ProgressPriority? priority,
  }) {
    return EquipmentTrackedItemConfig(
      id: id ?? this.id,
      isTracked: isTracked ?? this.isTracked,
      targetLevel: targetLevel ?? this.targetLevel,
      priority: priority ?? this.priority,
    );
  }
}

class EquipmentSlotProgressConfig {
  const EquipmentSlotProgressConfig({
    required this.slotType,
    required this.weight,
    required this.enhancementConfigs,
    required this.jewelConfigs,
  });

  final EquipmentSlotType slotType;

  /// Contribution of this slot to total Equipment progress.
  final double weight;

  final Map<String, EquipmentTrackedItemConfig> enhancementConfigs;

  /// Jewel keys use the format `jewel_0`, `jewel_1`, etc.
  final Map<String, EquipmentTrackedItemConfig> jewelConfigs;

  EquipmentSlotProgressConfig copyWith({
    EquipmentSlotType? slotType,
    double? weight,
    Map<String, EquipmentTrackedItemConfig>? enhancementConfigs,
    Map<String, EquipmentTrackedItemConfig>? jewelConfigs,
  }) {
    return EquipmentSlotProgressConfig(
      slotType: slotType ?? this.slotType,
      weight: weight ?? this.weight,
      enhancementConfigs: enhancementConfigs ?? this.enhancementConfigs,
      jewelConfigs: jewelConfigs ?? this.jewelConfigs,
    );
  }
}

class EquipmentProgressConfig {
  const EquipmentProgressConfig({required this.slotConfigs});

  final Map<EquipmentSlotType, EquipmentSlotProgressConfig> slotConfigs;

  EquipmentSlotProgressConfig? configForSlot(EquipmentSlotType slotType) {
    return slotConfigs[slotType];
  }

  double get totalWeight {
    return slotConfigs.values.fold<double>(
      0,
      (sum, config) => sum + config.weight,
    );
  }

  bool get weightsAreValid {
    return (totalWeight - 1).abs() <= 0.0001;
  }

  EquipmentProgressConfig copyWith({
    Map<EquipmentSlotType, EquipmentSlotProgressConfig>? slotConfigs,
  }) {
    return EquipmentProgressConfig(
      slotConfigs: slotConfigs ?? this.slotConfigs,
    );
  }

  factory EquipmentProgressConfig.initial() {
    const slotWeight = 1 / 6;

    final configs = <EquipmentSlotType, EquipmentSlotProgressConfig>{};

    for (final slotDefinition in equipmentSlotDefinitions) {
      final enhancementConfigs = <String, EquipmentTrackedItemConfig>{};

      for (final enhancement in slotDefinition.enhancements) {
        enhancementConfigs[enhancement.id] = EquipmentTrackedItemConfig(
          id: enhancement.id,
          isTracked: enhancement.isTrackedByDefault,
          targetLevel: enhancement.maxLevel,
          priority: ProgressPriority.recommended,
        );
      }

      final jewelConfigs = <String, EquipmentTrackedItemConfig>{};

      for (
        var jewelIndex = 0;
        jewelIndex < slotDefinition.jewelCount;
        jewelIndex++
      ) {
        final jewelId = 'jewel_$jewelIndex';

        jewelConfigs[jewelId] = EquipmentTrackedItemConfig(
          id: jewelId,
          isTracked: true,
          targetLevel: 30,
          priority: ProgressPriority.recommended,
        );
      }

      configs[slotDefinition.type] = EquipmentSlotProgressConfig(
        slotType: slotDefinition.type,
        weight: slotWeight,
        enhancementConfigs: enhancementConfigs,
        jewelConfigs: jewelConfigs,
      );
    }

    return EquipmentProgressConfig(slotConfigs: configs);
  }
}
