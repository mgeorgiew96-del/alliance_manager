import '../definitions/high_tech_definitions.dart';
import '../models/high_tech_progress_config.dart';
import '../models/high_tech_state.dart';

class HighTechProgressService {
  const HighTechProgressService._();

  static double calculateOverallProgress({
    required HighTechState state,
    required HighTechProgressConfig config,
  }) {
    var currentTotal = 0;
    var maximumTotal = 0;

    for (final definition in highTechDefinitions) {
      if (!config.configFor(definition.id).isTracked) {
        continue;
      }

      currentTotal += state.levelFor(definition.id) - definition.minLevel;
      maximumTotal += definition.maxLevel - definition.minLevel;
    }

    if (maximumTotal <= 0) {
      return 0;
    }

    return (currentTotal / maximumTotal).clamp(0.0, 1.0);
  }

  static int trackedCount(HighTechProgressConfig config) {
    return highTechDefinitions
        .where((definition) => config.configFor(definition.id).isTracked)
        .length;
  }

  static int priorityCount(HighTechProgressConfig config) {
    return highTechDefinitions
        .where((definition) => config.configFor(definition.id).isPriority)
        .length;
  }
}
