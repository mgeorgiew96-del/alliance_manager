import '../../../shared/progress/progress_calculator.dart';
import '../../../shared/progress/progress_category.dart';
import '../../../shared/progress/progress_item.dart';
import '../definitions/colossus_definitions.dart';
import '../models/colossus_progress_config.dart';
import '../models/colossus_state.dart';
import '../models/colossus_type.dart';

class ColossusProgressService {
  const ColossusProgressService._();

  static List<ProgressCategory> buildCategories({
    required ColossusState state,
    required ColossusProgressConfig config,
  }) {
    final activeTypes = ColossusType.values.where(state.isActive);

    return activeTypes.map((type) {
      final colossusData = state.dataFor(type);
      final statDefinitions = ColossusDefinitions.statsFor(type);

      final items = statDefinitions.map((statDefinition) {
        final statConfig = config.configFor(
          type: type,
          statId: statDefinition.id,
        );

        final safeTargetLevel = statConfig.targetLevel.clamp(
          0,
          statDefinition.maximumLevel,
        );

        return ProgressItem(
          id: '${type.name}:${statDefinition.id}',
          name: '${type.displayName} — ${statDefinition.name}',
          currentValue: colossusData.statLevel(statDefinition.id).toDouble(),
          minimumValue: 0,
          targetValue: safeTargetLevel.toDouble(),
          isTracked: statConfig.isTracked,
          weight: statConfig.weight,
        );
      }).toList();

      final hasTrackedItems = items.any(
        (item) => item.isTracked && item.weight > 0,
      );

      return ProgressCategory(
        id: type.name,
        name: type.displayName,
        items: items,
        weight: 1,
        isTracked: hasTrackedItems,
      );
    }).toList();
  }

  static double calculate({
    required ColossusState state,
    required ColossusProgressConfig config,
  }) {
    final categories = buildCategories(state: state, config: config);

    return ProgressCalculator.calculateModuleProgress(categories);
  }

  static double calculatePercentage({
    required ColossusState state,
    required ColossusProgressConfig config,
  }) {
    return calculate(state: state, config: config) * 100;
  }
}
