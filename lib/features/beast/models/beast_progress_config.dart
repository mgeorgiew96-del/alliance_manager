import '../../../shared/progress/progress_priority.dart';
import '../definitions/beast_skill_definitions.dart';
import '../definitions/beast_skin_definitions.dart';
import '../definitions/beast_talent_definitions.dart';
import 'beast_type.dart';

class BeastTrackedItemConfig {
  const BeastTrackedItemConfig({
    required this.id,
    required this.isTracked,
    required this.targetLevel,
    required this.priority,
  });

  final String id;
  final bool isTracked;
  final int targetLevel;
  final ProgressPriority priority;

  BeastTrackedItemConfig copyWith({
    String? id,
    bool? isTracked,
    int? targetLevel,
    ProgressPriority? priority,
  }) {
    return BeastTrackedItemConfig(
      id: id ?? this.id,
      isTracked: isTracked ?? this.isTracked,
      targetLevel: targetLevel ?? this.targetLevel,
      priority: priority ?? this.priority,
    );
  }
}

class BeastProgressConfig {
  const BeastProgressConfig({
    required this.skillsWeight,
    required this.talentsWeight,
    required this.skinsWeight,
    required this.skillConfigs,
    required this.talentConfigsByBeast,
    required this.skinConfigs,
  });

  final double skillsWeight;
  final double talentsWeight;
  final double skinsWeight;

  final Map<String, BeastTrackedItemConfig> skillConfigs;

  final Map<BeastType, Map<String, BeastTrackedItemConfig>>
      talentConfigsByBeast;

  final Map<String, BeastTrackedItemConfig> skinConfigs;

  double get totalWeight {
    return skillsWeight + talentsWeight + skinsWeight;
  }

  bool get weightsAreValid {
    return (totalWeight - 1).abs() <= 0.0001;
  }

  Map<String, BeastTrackedItemConfig> talentConfigsFor(
    BeastType beastType,
  ) {
    return talentConfigsByBeast[beastType] ?? const {};
  }

  BeastProgressConfig copyWith({
    double? skillsWeight,
    double? talentsWeight,
    double? skinsWeight,
    Map<String, BeastTrackedItemConfig>? skillConfigs,
    Map<BeastType, Map<String, BeastTrackedItemConfig>>?
        talentConfigsByBeast,
    Map<String, BeastTrackedItemConfig>? skinConfigs,
  }) {
    return BeastProgressConfig(
      skillsWeight: skillsWeight ?? this.skillsWeight,
      talentsWeight: talentsWeight ?? this.talentsWeight,
      skinsWeight: skinsWeight ?? this.skinsWeight,
      skillConfigs: skillConfigs ?? this.skillConfigs,
      talentConfigsByBeast:
          talentConfigsByBeast ?? this.talentConfigsByBeast,
      skinConfigs: skinConfigs ?? this.skinConfigs,
    );
  }

  factory BeastProgressConfig.initial() {
    final skillConfigs = <String, BeastTrackedItemConfig>{
      for (final skill in beastSkillDefinitions)
        skill.id: BeastTrackedItemConfig(
          id: skill.id,
          isTracked: true,
          targetLevel: skill.maxLevel,
          priority: ProgressPriority.recommended,
        ),
    };

    final talentConfigsByBeast =
        <BeastType, Map<String, BeastTrackedItemConfig>>{
      for (final beastType in BeastType.values)
        beastType: {
          for (final talent
              in talentDefinitionsForBeast(beastType))
            talent.id: BeastTrackedItemConfig(
              id: talent.id,
              isTracked: true,
              targetLevel: talent.maxLevel,
              priority: ProgressPriority.recommended,
            ),
        },
    };

    final skinConfigs = <String, BeastTrackedItemConfig>{
      for (final skin in beastSkinDefinitions)
        skin.id: BeastTrackedItemConfig(
          id: skin.id,
          isTracked: true,
          targetLevel: skin.maxLevel,
          priority: ProgressPriority.recommended,
        ),
    };

    return BeastProgressConfig(
      skillsWeight: 0.50,
      talentsWeight: 0.30,
      skinsWeight: 0.20,
      skillConfigs: skillConfigs,
      talentConfigsByBeast: talentConfigsByBeast,
      skinConfigs: skinConfigs,
    );
  }
}