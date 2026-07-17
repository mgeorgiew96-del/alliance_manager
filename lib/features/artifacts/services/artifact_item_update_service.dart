import '../definitions/artifact_catalog.dart';
import '../models/artifact_item_state.dart';
import '../models/artifact_star_stage.dart';

abstract final class ArtifactItemUpdateService {
  static ArtifactItemState setLevel({
    required ArtifactItemState state,
    required int level,
  }) {
    final definition = ArtifactCatalog.byId(state.itemId);

    final safeLevel = level.clamp(
      definition.minimumLevel,
      definition.maximumLevel,
    );

    if (safeLevel == 0) {
      return state.copyWith(
        level: 0,
        starStageIndex: 0,
        isSelectedForProgress: false,
      );
    }

    return state.copyWith(level: safeLevel);
  }

  static ArtifactItemState setStarStage({
    required ArtifactItemState state,
    required int progressionIndex,
  }) {
    if (!state.isOwned) {
      return state.copyWith(starStageIndex: 0);
    }

    final definition = ArtifactCatalog.byId(state.itemId);

    final stages = ArtifactStarProgression.forRarity(definition.rarity);

    final safeIndex = progressionIndex.clamp(0, stages.length - 1);

    return state.copyWith(starStageIndex: safeIndex);
  }

  static ArtifactItemState increaseLevel(ArtifactItemState state) {
    return setLevel(state: state, level: state.level + 1);
  }

  static ArtifactItemState decreaseLevel(ArtifactItemState state) {
    return setLevel(state: state, level: state.level - 1);
  }

  static ArtifactItemState increaseStarStage(ArtifactItemState state) {
    return setStarStage(
      state: state,
      progressionIndex: state.starStageIndex + 1,
    );
  }

  static ArtifactItemState decreaseStarStage(ArtifactItemState state) {
    return setStarStage(
      state: state,
      progressionIndex: state.starStageIndex - 1,
    );
  }
}
