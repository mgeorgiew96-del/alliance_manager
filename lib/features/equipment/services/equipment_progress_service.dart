import '../../../shared/progress/progress_calculator.dart';
import '../../../shared/progress/progress_category.dart';
import '../../../shared/progress/progress_item.dart';
import '../definitions/equipment_slot_definitions.dart';
import '../models/equipment_slot_type.dart';
import '../models/equipment_state.dart';
import 'equipment_progress_config.dart';

class EquipmentProgressService {
  const EquipmentProgressService._();

  static List<ProgressCategory> buildCategories({
    required EquipmentState state,
    required EquipmentProgressConfig config,
  }) {
    return equipmentSlotDefinitions.map((slotDefinition) {
      return _buildSlotCategory(
        state: state,
        config: config,
        slotType: slotDefinition.type,
      );
    }).toList();
  }

  static double calculateOverallProgress({
    required EquipmentState state,
    required EquipmentProgressConfig config,
  }) {
    return ProgressCalculator.calculateModuleProgress(
      buildCategories(state: state, config: config),
    );
  }

  static double calculateSlotProgress({
    required EquipmentState state,
    required EquipmentProgressConfig config,
    required EquipmentSlotType slotType,
  }) {
    return _buildSlotCategory(
      state: state,
      config: config,
      slotType: slotType,
    ).progress;
  }

  static ProgressCategory _buildSlotCategory({
    required EquipmentState state,
    required EquipmentProgressConfig config,
    required EquipmentSlotType slotType,
  }) {
    final slotDefinition = equipmentDefinitionFor(slotType);

    final slotState = state.slot(slotType);

    final slotConfig = config.configForSlot(slotType);

    final items = <ProgressItem>[];

    for (final enhancementDefinition in slotDefinition.enhancements) {
      final enhancementState = slotState.enhancements.firstWhere((enhancement) {
        return enhancement.id == enhancementDefinition.id;
      });

      final itemConfig =
          slotConfig?.enhancementConfigs[enhancementDefinition.id];

      items.add(
        ProgressItem(
          id: '${slotType.name}_${enhancementDefinition.id}',
          name: enhancementDefinition.name,
          currentValue: enhancementState.level.toDouble(),
          minimumValue: 0,
          targetValue:
              (itemConfig?.targetLevel ?? enhancementDefinition.maxLevel)
                  .toDouble(),
          isTracked:
              itemConfig?.isTracked ?? enhancementDefinition.isTrackedByDefault,
          weight: 1,
        ),
      );
    }

    for (
      var jewelIndex = 0;
      jewelIndex < slotDefinition.jewelCount;
      jewelIndex++
    ) {
      final jewelId = 'jewel_$jewelIndex';
      final itemConfig = slotConfig?.jewelConfigs[jewelId];

      final currentLevel = jewelIndex < slotState.jewelLevels.length
          ? slotState.jewelLevels[jewelIndex]
          : 0;

      items.add(
        ProgressItem(
          id: '${slotType.name}_$jewelId',
          name:
              '${_jewelName(slotDefinition.jewelType.name)} '
              '${jewelIndex + 1}',
          currentValue: currentLevel.toDouble(),
          minimumValue: 0,
          targetValue: (itemConfig?.targetLevel ?? 30).toDouble(),
          isTracked: itemConfig?.isTracked ?? true,
          weight: 1,
        ),
      );
    }

    return ProgressCategory(
      id: slotType.name,
      name: slotDefinition.name,
      items: items,
      weight: slotConfig?.weight ?? 0,
      isTracked: (slotConfig?.weight ?? 0) > 0,
    );
  }
}

String _jewelName(String value) {
  if (value.isEmpty) {
    return value;
  }

  return '${value[0].toUpperCase()}${value.substring(1)}';
}
