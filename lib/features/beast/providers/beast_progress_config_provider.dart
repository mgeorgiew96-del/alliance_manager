import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/progress/progress_priority.dart';
import '../models/beast_progress_config.dart';
import '../models/beast_type.dart';

class BeastProgressConfigController extends Notifier<BeastProgressConfig> {
  late BeastProgressConfig _savedConfig;

  @override
  BeastProgressConfig build() {
    final initialConfig = BeastProgressConfig.initial();
    _savedConfig = initialConfig;
    return initialConfig;
  }

  void setCategoryWeights({
    required double skillsWeight,
    required double talentsWeight,
    required double skinsWeight,
  }) {
    state = state.copyWith(
      skillsWeight: skillsWeight,
      talentsWeight: talentsWeight,
      skinsWeight: skinsWeight,
    );
  }

  void setSkillTracked({required String skillId, required bool isTracked}) {
    final currentConfig = state.skillConfigs[skillId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skillConfigs,
    );

    updatedConfigs[skillId] = currentConfig.copyWith(isTracked: isTracked);

    state = state.copyWith(skillConfigs: updatedConfigs);
  }

  void setSkillTargetLevel({
    required String skillId,
    required int targetLevel,
  }) {
    final currentConfig = state.skillConfigs[skillId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skillConfigs,
    );

    updatedConfigs[skillId] = currentConfig.copyWith(targetLevel: targetLevel);

    state = state.copyWith(skillConfigs: updatedConfigs);
  }

  void setSkillPriority({
    required String skillId,
    required ProgressPriority priority,
  }) {
    final currentConfig = state.skillConfigs[skillId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skillConfigs,
    );

    updatedConfigs[skillId] = currentConfig.copyWith(priority: priority);

    state = state.copyWith(skillConfigs: updatedConfigs);
  }

  void setTalentTracked({
    required BeastType beastType,
    required String talentId,
    required bool isTracked,
  }) {
    final currentBeastConfigs = state.talentConfigsFor(beastType);

    final currentConfig = currentBeastConfigs[talentId];
    if (currentConfig == null) {
      return;
    }

    final updatedBeastConfigs = Map<String, BeastTrackedItemConfig>.from(
      currentBeastConfigs,
    );

    updatedBeastConfigs[talentId] = currentConfig.copyWith(
      isTracked: isTracked,
    );

    _updateTalentConfigsForBeast(
      beastType: beastType,
      updatedConfigs: updatedBeastConfigs,
    );
  }

  void setTalentTargetLevel({
    required BeastType beastType,
    required String talentId,
    required int targetLevel,
  }) {
    final currentBeastConfigs = state.talentConfigsFor(beastType);

    final currentConfig = currentBeastConfigs[talentId];
    if (currentConfig == null) {
      return;
    }

    final updatedBeastConfigs = Map<String, BeastTrackedItemConfig>.from(
      currentBeastConfigs,
    );

    updatedBeastConfigs[talentId] = currentConfig.copyWith(
      targetLevel: targetLevel,
    );

    _updateTalentConfigsForBeast(
      beastType: beastType,
      updatedConfigs: updatedBeastConfigs,
    );
  }

  void setTalentPriority({
    required BeastType beastType,
    required String talentId,
    required ProgressPriority priority,
  }) {
    final currentBeastConfigs = state.talentConfigsFor(beastType);

    final currentConfig = currentBeastConfigs[talentId];
    if (currentConfig == null) {
      return;
    }

    final updatedBeastConfigs = Map<String, BeastTrackedItemConfig>.from(
      currentBeastConfigs,
    );

    updatedBeastConfigs[talentId] = currentConfig.copyWith(priority: priority);

    _updateTalentConfigsForBeast(
      beastType: beastType,
      updatedConfigs: updatedBeastConfigs,
    );
  }

  void setSkinTracked({required String skinId, required bool isTracked}) {
    final currentConfig = state.skinConfigs[skinId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skinConfigs,
    );

    updatedConfigs[skinId] = currentConfig.copyWith(isTracked: isTracked);

    state = state.copyWith(skinConfigs: updatedConfigs);
  }

  void setSkinTargetLevel({required String skinId, required int targetLevel}) {
    final currentConfig = state.skinConfigs[skinId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skinConfigs,
    );

    updatedConfigs[skinId] = currentConfig.copyWith(targetLevel: targetLevel);

    state = state.copyWith(skinConfigs: updatedConfigs);
  }

  void setSkinPriority({
    required String skinId,
    required ProgressPriority priority,
  }) {
    final currentConfig = state.skinConfigs[skinId];
    if (currentConfig == null) {
      return;
    }

    final updatedConfigs = Map<String, BeastTrackedItemConfig>.from(
      state.skinConfigs,
    );

    updatedConfigs[skinId] = currentConfig.copyWith(priority: priority);

    state = state.copyWith(skinConfigs: updatedConfigs);
  }

  void _updateTalentConfigsForBeast({
    required BeastType beastType,
    required Map<String, BeastTrackedItemConfig> updatedConfigs,
  }) {
    final updatedConfigsByBeast =
        Map<BeastType, Map<String, BeastTrackedItemConfig>>.from(
          state.talentConfigsByBeast,
        );

    updatedConfigsByBeast[beastType] = updatedConfigs;

    state = state.copyWith(talentConfigsByBeast: updatedConfigsByBeast);
  }

  void save() {
    _savedConfig = state;
  }

  void cancel() {
    state = _savedConfig;
  }

  void resetToDefaults() {
    state = BeastProgressConfig.initial();
  }
}

final beastProgressConfigProvider =
    NotifierProvider<BeastProgressConfigController, BeastProgressConfig>(
      BeastProgressConfigController.new,
    );
