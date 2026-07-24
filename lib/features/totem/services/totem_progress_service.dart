import '../definitions/totem_definitions.dart';
import '../models/totem_data.dart';
import '../models/totem_definition.dart';
import '../models/totem_progress_config.dart';
import '../models/totem_state.dart';
import '../models/totem_type.dart';

class TotemProgressService {
  const TotemProgressService._();

  static double calculateOverallProgress({
    required TotemState state,
    required TotemProgressConfig config,
  }) {
    final primaryDefinition = TotemDefinitions.forType(state.primaryType);
    final secondaryDefinition = TotemDefinitions.forType(state.secondaryType);

    final primaryWeight = config.weightForRarity(primaryDefinition.rarity);
    final secondaryWeight = config.weightForRarity(
      secondaryDefinition.rarity,
    );

    final totalWeight = primaryWeight + secondaryWeight;

    if (totalWeight <= 0) {
      return 0;
    }

    final primaryProgress = calculateTotemProgress(
      type: state.primaryType,
      state: state,
      config: config,
    );

    final secondaryProgress = calculateTotemProgress(
      type: state.secondaryType,
      state: state,
      config: config,
    );

    final weightedProgress =
        (primaryProgress * primaryWeight) +
        (secondaryProgress * secondaryWeight);

    return (weightedProgress / totalWeight).clamp(0, 1).toDouble();
  }

  static double calculatePrimaryProgress({
    required TotemState state,
    required TotemProgressConfig config,
  }) {
    return calculateTotemProgress(
      type: state.primaryType,
      state: state,
      config: config,
    );
  }

  static double calculateSecondaryProgress({
    required TotemState state,
    required TotemProgressConfig config,
  }) {
    return calculateTotemProgress(
      type: state.secondaryType,
      state: state,
      config: config,
    );
  }

  static double calculateTotemProgress({
    required TotemType type,
    required TotemState state,
    required TotemProgressConfig config,
  }) {
    final definition = TotemDefinitions.forType(type);
    final data = state.dataFor(type);

    final levelProgress = calculateLevelProgress(
      data: data,
      definition: definition,
    );

    final skillProgress = calculateSkillProgress(
      data: data,
      definition: definition,
    );

    final totalComponentWeight = config.componentWeightTotal;

    if (totalComponentWeight <= 0) {
      return 0;
    }

    final weightedProgress =
        (levelProgress * config.levelWeight) +
        (skillProgress * config.skillLevelWeight);

    return (weightedProgress / totalComponentWeight)
        .clamp(0, 1)
        .toDouble();
  }

  static double calculateLevelProgress({
    required TotemData data,
    required TotemDefinition definition,
  }) {
    return _calculateProgress(
      currentValue: data.level,
      minimumValue: definition.minimumLevel,
      maximumValue: definition.maximumLevel,
    );
  }

  static double calculateSkillProgress({
    required TotemData data,
    required TotemDefinition definition,
  }) {
    return _calculateProgress(
      currentValue: data.skillLevel,
      minimumValue: definition.minimumSkillLevel,
      maximumValue: definition.maximumSkillLevel,
    );
  }

  static double rarityWeightFor({
    required TotemType type,
    required TotemProgressConfig config,
  }) {
    final definition = TotemDefinitions.forType(type);
    return config.weightForRarity(definition.rarity);
  }

  static double _calculateProgress({
    required int currentValue,
    required int minimumValue,
    required int maximumValue,
  }) {
    final availableProgress = maximumValue - minimumValue;

    if (availableProgress <= 0) {
      return currentValue >= maximumValue ? 1 : 0;
    }

    final completedProgress = currentValue - minimumValue;

    return (completedProgress / availableProgress)
        .clamp(0, 1)
        .toDouble();
  }
}
