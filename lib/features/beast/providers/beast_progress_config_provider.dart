import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/progress/progress_priority.dart';
import '../models/beast_progress_config.dart';
import '../models/beast_type.dart';
import '../repositories/beast_progress_config_repository.dart';
import 'beast_progress_config_repository_provider.dart';

class BeastProgressConfigController extends Notifier<BeastProgressConfig> {
  late BeastProgressConfigRepository _repository;
  late BeastProgressConfig _savedConfig;

  @override
  BeastProgressConfig build() {
    _repository = ref.read(beastProgressConfigRepositoryProvider);

    final initialConfig = BeastProgressConfig.initial();
    _savedConfig = initialConfig;

    unawaited(_loadConfig());

    return initialConfig;
  }

  Future<void> _loadConfig() async {
    final loadedConfig = await _repository.loadConfig();

    _savedConfig = loadedConfig;
    state = loadedConfig;
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

  Future<void> save() async {
    if (!state.weightsAreValid) {
      throw StateError('Beast category weights must total 100%.');
    }

    await _repository.saveConfig(config: state);

    _savedConfig = state;
  }

  Future<void> cancel() async {
    final savedConfig = await _repository.loadConfig();

    _savedConfig = savedConfig;
    state = savedConfig;
  }

  void resetToDefaults() {
    state = BeastProgressConfig.initial();
  }

  Future<void> restoreSavedConfig() async {
    state = _savedConfig;
  }
}

final beastProgressConfigProvider =
    NotifierProvider<BeastProgressConfigController, BeastProgressConfig>(
      BeastProgressConfigController.new,
    );
