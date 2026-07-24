import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mystic_progress_config.dart';
import '../models/mystic_troop_type.dart';

final mysticProgressConfigProvider =
    NotifierProvider<MysticProgressConfigController, MysticProgressConfig>(
      MysticProgressConfigController.new,
    );

class MysticProgressConfigController extends Notifier<MysticProgressConfig> {
  @override
  MysticProgressConfig build() {
    return MysticProgressConfig.initial();
  }

  void setTracked({required String skillId, required bool isTracked}) {
    final current = state.configFor(skillId);

    state = state.copyWith(
      skillConfigs: Map.unmodifiable({
        ...state.skillConfigs,
        skillId: current.copyWith(isTracked: isTracked),
      }),
    );
  }

  void setPriority({required String skillId, required bool isPriority}) {
    final current = state.configFor(skillId);

    state = state.copyWith(
      skillConfigs: Map.unmodifiable({
        ...state.skillConfigs,
        skillId: current.copyWith(isPriority: isPriority),
      }),
    );
  }

  void setTargetLevel({required String skillId, required int targetLevel}) {
    final current = state.configFor(skillId);
    final safeTarget = targetLevel.clamp(1, 5);

    state = state.copyWith(
      skillConfigs: Map.unmodifiable({
        ...state.skillConfigs,
        skillId: current.copyWith(targetLevel: safeTarget),
      }),
    );
  }

  void setSkillWeight({required String skillId, required double weight}) {
    final current = state.configFor(skillId);

    state = state.copyWith(
      skillConfigs: Map.unmodifiable({
        ...state.skillConfigs,
        skillId: current.copyWith(weight: weight < 0 ? 0 : weight),
      }),
    );
  }

  void setTroopWeight({
    required MysticTroopType troopType,
    required double weight,
  }) {
    state = state.copyWith(
      troopWeights: Map.unmodifiable({
        ...state.troopWeights,
        troopType: weight < 0 ? 0 : weight,
      }),
    );
  }

  void reset() {
    state = MysticProgressConfig.initial();
  }
}
