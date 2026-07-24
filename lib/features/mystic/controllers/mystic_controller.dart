import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../definitions/mystic_skill_definitions.dart';
import '../models/mystic_state.dart';
import '../models/mystic_troop_type.dart';

final mysticControllerProvider =
    AsyncNotifierProvider<MysticController, MysticState>(MysticController.new);

class MysticController extends AsyncNotifier<MysticState> {
  @override
  Future<MysticState> build() async {
    return MysticState.initial();
  }

  void selectTroop(MysticTroopType troopType) {
    final current = state.asData?.value;

    if (current == null || current.selectedTroop == troopType) {
      return;
    }

    state = AsyncData(current.copyWith(selectedTroop: troopType));
  }

  /// Activates an inactive normal troop when fewer than two are active.
  ///
  /// Returns false when a replacement choice is required.
  bool activateTroop(MysticTroopType troopType) {
    final current = state.asData?.value;

    if (current == null ||
        troopType == MysticTroopType.angels ||
        current.activeTroops.contains(troopType)) {
      return true;
    }

    if (current.activeTroops.length >= 2) {
      return false;
    }

    state = AsyncData(
      current.copyWith(
        activeTroops: Set.unmodifiable({...current.activeTroops, troopType}),
      ),
    );

    return true;
  }

  void replaceActiveTroop({
    required MysticTroopType troopToRemove,
    required MysticTroopType troopToActivate,
  }) {
    final current = state.asData?.value;

    if (current == null ||
        troopToRemove == MysticTroopType.angels ||
        troopToActivate == MysticTroopType.angels ||
        !current.activeTroops.contains(troopToRemove) ||
        current.activeTroops.contains(troopToActivate)) {
      return;
    }

    final updated = {...current.activeTroops}
      ..remove(troopToRemove)
      ..add(troopToActivate);

    state = AsyncData(
      current.copyWith(activeTroops: Set.unmodifiable(updated)),
    );
  }

  void setSkillLevel({required String skillId, required int level}) {
    final current = state.asData?.value;

    if (current == null) {
      return;
    }

    final definition = mysticSkillDefinitionFor(skillId);
    final safeLevel = level.clamp(definition.minLevel, definition.maxLevel);

    if (current.levelFor(skillId) == safeLevel) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        skillLevels: Map.unmodifiable({
          ...current.skillLevels,
          skillId: safeLevel,
        }),
      ),
    );
  }

  void increaseSkill(String skillId) {
    final current = state.asData?.value;

    if (current == null) {
      return;
    }

    setSkillLevel(skillId: skillId, level: current.levelFor(skillId) + 1);
  }

  void decreaseSkill(String skillId) {
    final current = state.asData?.value;

    if (current == null) {
      return;
    }

    setSkillLevel(skillId: skillId, level: current.levelFor(skillId) - 1);
  }

  Future<void> save() async {
    final current = state.asData?.value;

    if (current == null || !current.hasUnsavedChanges) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        savedActiveTroops: Set.unmodifiable(current.activeTroops),
        savedSkillLevels: Map.unmodifiable(current.skillLevels),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  void cancel() {
    final current = state.asData?.value;

    if (current == null || !current.hasUnsavedChanges) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        activeTroops: Set.unmodifiable(current.savedActiveTroops),
        skillLevels: Map.unmodifiable(current.savedSkillLevels),
      ),
    );
  }
}
