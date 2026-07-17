import '../definitions/artifact_catalog.dart';
import '../models/artifact_category.dart';
import '../models/artifact_item_state.dart';

abstract final class ArtifactSelectionService {
  static int selectedCount({
    required Map<String, ArtifactItemState> items,
    required ArtifactCategory category,
  }) {
    var count = 0;

    for (final entry in items.entries) {
      final definition = ArtifactCatalog.tryById(entry.key);

      if (definition == null || definition.category != category) {
        continue;
      }

      if (entry.value.isSelectedForProgress) {
        count++;
      }
    }

    return count;
  }

  static bool canSelect({
    required Map<String, ArtifactItemState> items,
    required String itemId,
  }) {
    final definition = ArtifactCatalog.byId(itemId);

    final itemState = items[itemId] ?? ArtifactItemState(itemId: itemId);

    if (itemState.isSelectedForProgress) {
      return true;
    }

    if (!itemState.isOwned) {
      return false;
    }

    final currentSelected = selectedCount(
      items: items,
      category: definition.category,
    );

    return currentSelected < definition.category.trackedSelectionLimit;
  }

  static String? selectionError({
    required Map<String, ArtifactItemState> items,
    required String itemId,
  }) {
    final definition = ArtifactCatalog.byId(itemId);

    final itemState = items[itemId] ?? ArtifactItemState(itemId: itemId);

    if (itemState.isSelectedForProgress) {
      return null;
    }

    if (!itemState.isOwned) {
      return 'Set the item level above 0 before selecting it.';
    }

    final currentSelected = selectedCount(
      items: items,
      category: definition.category,
    );

    final limit = definition.category.trackedSelectionLimit;

    if (currentSelected >= limit) {
      return 'Only $limit '
          '${definition.category.pluralName.toLowerCase()} '
          'can be selected for progress.';
    }

    return null;
  }
}
