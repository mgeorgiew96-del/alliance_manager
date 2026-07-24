import '../../../shared/progress/progress_calculator.dart';
import '../../../shared/progress/progress_category.dart';
import '../../../shared/progress/progress_item.dart';
import '../definitions/mystic_skill_definitions.dart';
import '../models/mystic_progress_config.dart';
import '../models/mystic_state.dart';
import '../models/mystic_troop_type.dart';

class MysticProgressService {
  const MysticProgressService._();

  static const double activeTroopWeight = 0.40;
  static const double angelsWeight = 0.20;

  static List<ProgressCategory> buildCategories({
    required MysticState state,
    required MysticProgressConfig config,
  }) {
    return MysticTroopType.values
        .map((troopType) {
          final skills = mysticSkillsForTroop(troopType);
          final isActive = state.isActive(troopType);
          final categoryWeight = troopType == MysticTroopType.angels
              ? angelsWeight
              : isActive
              ? activeTroopWeight
              : 0.0;

          return ProgressCategory(
            id: troopType.name,
            name: troopType.displayName,
            weight: categoryWeight,
            isTracked: isActive,
            items: skills
                .map((skill) {
                  final itemConfig = config.configFor(skill.id);

                  return ProgressItem(
                    id: skill.id,
                    name: skill.name,
                    currentValue: state.levelFor(skill.id).toDouble(),
                    minimumValue: skill.minLevel.toDouble(),
                    targetValue: itemConfig.targetLevel.toDouble(),
                    isTracked: itemConfig.isTracked,
                    weight: itemConfig.weight,
                  );
                })
                .toList(growable: false),
          );
        })
        .toList(growable: false);
  }

  static double calculateOverallProgress({
    required MysticState state,
    required MysticProgressConfig config,
  }) {
    return ProgressCalculator.calculateModuleProgress(
      buildCategories(state: state, config: config),
    );
  }

  static double calculateTroopProgress({
    required MysticState state,
    required MysticProgressConfig config,
    required MysticTroopType troopType,
  }) {
    final skills = mysticSkillsForTroop(troopType);
    final category = ProgressCategory(
      id: troopType.name,
      name: troopType.displayName,
      weight: 1,
      items: skills
          .map((skill) {
            final itemConfig = config.configFor(skill.id);

            return ProgressItem(
              id: skill.id,
              name: skill.name,
              currentValue: state.levelFor(skill.id).toDouble(),
              minimumValue: skill.minLevel.toDouble(),
              targetValue: itemConfig.targetLevel.toDouble(),
              isTracked: itemConfig.isTracked,
              weight: itemConfig.weight,
            );
          })
          .toList(growable: false),
    );

    return category.progress;
  }

  static int trackedSkillCount({
    required MysticProgressConfig config,
    MysticTroopType? troopType,
  }) {
    final skills = troopType == null
        ? mysticSkillDefinitions
        : mysticSkillsForTroop(troopType);

    return skills.where((skill) {
      return config.configFor(skill.id).isTracked;
    }).length;
  }

  static int prioritySkillCount({
    required MysticProgressConfig config,
    MysticTroopType? troopType,
  }) {
    final skills = troopType == null
        ? mysticSkillDefinitions
        : mysticSkillsForTroop(troopType);

    return skills.where((skill) {
      return config.configFor(skill.id).isPriority;
    }).length;
  }
}
