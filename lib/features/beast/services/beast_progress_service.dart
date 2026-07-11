import '../../../shared/progress/progress_calculator.dart';
import '../../../shared/progress/progress_category.dart';
import '../../../shared/progress/progress_item.dart';
import '../definitions/beast_skill_definitions.dart';
import '../definitions/beast_skin_definitions.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_progress_config.dart';
import '../models/beast_state.dart';

class BeastProgressService {
  const BeastProgressService._();

  static List<ProgressCategory> buildCategories({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    return [
      _buildSkillsCategory(
        state: state,
        config: config,
      ),
      _buildTalentsCategory(
        state: state,
        config: config,
      ),
      _buildSkinsCategory(
        state: state,
        config: config,
      ),
    ];
  }

  static double calculateOverallProgress({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    return ProgressCalculator.calculateModuleProgress(
      buildCategories(
        state: state,
        config: config,
      ),
    );
  }

  static double calculateSkillsProgress({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    return _buildSkillsCategory(
      state: state,
      config: config,
    ).progress;
  }

  static double calculateTalentsProgress({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    return _buildTalentsCategory(
      state: state,
      config: config,
    ).progress;
  }

  static double calculateSkinsProgress({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    return _buildSkinsCategory(
      state: state,
      config: config,
    ).progress;
  }

  static ProgressCategory _buildSkillsCategory({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    final items = beastSkillDefinitions.map((skill) {
      final itemConfig = config.skillConfigs[skill.id];

      final currentLevel =
          state.skillLevels[skill.id] ?? skill.minLevel;

      return ProgressItem(
        id: skill.id,
        name: skill.name,
        currentValue: currentLevel.toDouble(),
        minimumValue: skill.minLevel.toDouble(),
        targetValue: (
          itemConfig?.targetLevel ?? skill.maxLevel
        ).toDouble(),
        isTracked: itemConfig?.isTracked ?? true,
        weight: 1,
      );
    }).toList();

    return ProgressCategory(
      id: 'skills',
      name: 'Skills',
      items: items,
      weight: config.skillsWeight,
      isTracked: config.skillsWeight > 0,
    );
  }

  static ProgressCategory _buildTalentsCategory({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    final talents = talentDefinitionsForBeast(
      state.selectedBeast,
    );

    final talentConfigs = config.talentConfigsFor(
      state.selectedBeast,
    );

    final items = talents.map((talent) {
      final itemConfig = talentConfigs[talent.id];

      final currentLevel =
          state.talentLevels[talent.id] ?? 0;

      return ProgressItem(
        id: talent.id,
        name: talent.name,
        currentValue: currentLevel.toDouble(),
        minimumValue: 0,
        targetValue: (
          itemConfig?.targetLevel ?? talent.maxLevel
        ).toDouble(),
        isTracked: itemConfig?.isTracked ?? true,
        weight: 1,
      );
    }).toList();

    return ProgressCategory(
      id: 'talents',
      name: 'Talents',
      items: items,
      weight: config.talentsWeight,
      isTracked: config.talentsWeight > 0,
    );
  }

  static ProgressCategory _buildSkinsCategory({
    required BeastState state,
    required BeastProgressConfig config,
  }) {
    final items = beastSkinDefinitions.map((skin) {
      final itemConfig = config.skinConfigs[skin.id];

      final currentLevel =
          state.skinLevels[skin.id] ?? skin.minLevel;

      return ProgressItem(
        id: skin.id,
        name: skin.name,
        currentValue: currentLevel.toDouble(),
        minimumValue: skin.minLevel.toDouble(),
        targetValue: (
          itemConfig?.targetLevel ?? skin.maxLevel
        ).toDouble(),
        isTracked: itemConfig?.isTracked ?? true,
        weight: 1,
      );
    }).toList();

    return ProgressCategory(
      id: 'skins',
      name: 'Skins',
      items: items,
      weight: config.skinsWeight,
      isTracked: config.skinsWeight > 0,
    );
  }
}