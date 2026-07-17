import '../definitions/artifact_catalog.dart';
import '../models/artifact_category.dart';
import '../models/artifact_item_definition.dart';
import '../models/artifact_item_state.dart';
import '../models/artifact_star_stage.dart';
import '../models/artifacts_state.dart';

abstract final class ArtifactProgressService {
  static double itemProgress({
    required ArtifactItemDefinition definition,
    required ArtifactItemState state,
  }) {
    if (!state.isOwned) {
      return 0;
    }

    return ArtifactStarProgression.progressFor(
      rarity: definition.rarity,
      progressionIndex: state.starStageIndex,
    );
  }

  static double categoryProgress({
    required ArtifactsState state,
    required ArtifactCategory category,
  }) {
    final selected = _selectedItems(state: state, category: category);

    if (selected.isEmpty) {
      return 0;
    }

    var totalProgress = 0.0;

    for (final entry in selected) {
      totalProgress += itemProgress(
        definition: entry.definition,
        state: entry.state,
      );
    }

    return totalProgress / selected.length;
  }

  static double overallProgress({required ArtifactsState state}) {
    final selectedArtifacts = _selectedItems(
      state: state,
      category: ArtifactCategory.artifact,
    );

    final selectedCrowns = _selectedItems(
      state: state,
      category: ArtifactCategory.crown,
    );

    final allSelected = [...selectedArtifacts, ...selectedCrowns];

    if (allSelected.isEmpty) {
      return 0;
    }

    var totalProgress = 0.0;

    for (final entry in allSelected) {
      totalProgress += itemProgress(
        definition: entry.definition,
        state: entry.state,
      );
    }

    return totalProgress / allSelected.length;
  }

  static int selectedCount({
    required ArtifactsState state,
    required ArtifactCategory category,
  }) {
    return _selectedItems(state: state, category: category).length;
  }

  static List<_SelectedArtifactEntry> _selectedItems({
    required ArtifactsState state,
    required ArtifactCategory category,
  }) {
    final result = <_SelectedArtifactEntry>[];

    for (final definition in ArtifactCatalog.forCategory(category)) {
      final itemState = state.item(definition.id);

      if (!itemState.isSelectedForProgress) {
        continue;
      }

      result.add(
        _SelectedArtifactEntry(definition: definition, state: itemState),
      );
    }

    return result;
  }
}

class _SelectedArtifactEntry {
  const _SelectedArtifactEntry({required this.definition, required this.state});

  final ArtifactItemDefinition definition;
  final ArtifactItemState state;
}
