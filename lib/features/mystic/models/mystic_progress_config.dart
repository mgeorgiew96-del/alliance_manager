import '../../../shared/progress/progress_priority.dart';
import '../definitions/mystic_skill_definitions.dart';
import 'mystic_troop_type.dart';

class MysticTrackedSkillConfig {
  const MysticTrackedSkillConfig({
    required this.skillId,
    required this.isTracked,
    required this.isPriority,
    required this.targetLevel,
    required this.weight,
    required this.priority,
  });

  final String skillId;
  final bool isTracked;
  final bool isPriority;
  final int targetLevel;
  final double weight;
  final ProgressPriority priority;

  MysticTrackedSkillConfig copyWith({
    String? skillId,
    bool? isTracked,
    bool? isPriority,
    int? targetLevel,
    double? weight,
    ProgressPriority? priority,
  }) {
    return MysticTrackedSkillConfig(
      skillId: skillId ?? this.skillId,
      isTracked: isTracked ?? this.isTracked,
      isPriority: isPriority ?? this.isPriority,
      targetLevel: targetLevel ?? this.targetLevel,
      weight: weight ?? this.weight,
      priority: priority ?? this.priority,
    );
  }
}

class MysticProgressConfig {
  const MysticProgressConfig({
    required this.skillConfigs,
    required this.troopWeights,
  });

  final Map<String, MysticTrackedSkillConfig> skillConfigs;
  final Map<MysticTroopType, double> troopWeights;

  MysticTrackedSkillConfig configFor(String skillId) {
    return skillConfigs[skillId] ??
        MysticTrackedSkillConfig(
          skillId: skillId,
          isTracked: true,
          isPriority: false,
          targetLevel: 5,
          weight: 1,
          priority: ProgressPriority.recommended,
        );
  }

  double weightForTroop(MysticTroopType troopType) {
    return troopWeights[troopType] ?? 1;
  }

  MysticProgressConfig copyWith({
    Map<String, MysticTrackedSkillConfig>? skillConfigs,
    Map<MysticTroopType, double>? troopWeights,
  }) {
    return MysticProgressConfig(
      skillConfigs: skillConfigs ?? this.skillConfigs,
      troopWeights: troopWeights ?? this.troopWeights,
    );
  }

  factory MysticProgressConfig.initial() {
    return MysticProgressConfig(
      skillConfigs: {
        for (final skill in mysticSkillDefinitions)
          skill.id: MysticTrackedSkillConfig(
            skillId: skill.id,
            isTracked: true,
            isPriority: false,
            targetLevel: skill.maxLevel,
            weight: 1,
            priority: ProgressPriority.recommended,
          ),
      },
      troopWeights: const {
        MysticTroopType.infantry: 1,
        MysticTroopType.cavalry: 1,
        MysticTroopType.archer: 1,
        MysticTroopType.mage: 1,
        MysticTroopType.angels: 1,
      },
    );
  }
}
