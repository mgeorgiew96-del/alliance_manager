import '../definitions/artifact_catalog.dart';
import '../models/artifact_item_state.dart';
import '../models/artifacts_state.dart';

abstract final class ArtifactsStateFactory {
  static ArtifactsState initial() {
    final items = <String, ArtifactItemState>{};

    for (final definition in ArtifactCatalog.all) {
      items[definition.id] = ArtifactItemState(itemId: definition.id);
    }

    final savedItems = Map<String, ArtifactItemState>.from(items);

    return ArtifactsState(items: items, savedItems: savedItems);
  }

  static ArtifactsState fromSavedItems({
    required Map<String, ArtifactItemState> savedItems,
    DateTime? lastUpdated,
  }) {
    final completeItems = <String, ArtifactItemState>{};

    for (final definition in ArtifactCatalog.all) {
      completeItems[definition.id] =
          savedItems[definition.id] ?? ArtifactItemState(itemId: definition.id);
    }

    final snapshot = Map<String, ArtifactItemState>.from(completeItems);

    return ArtifactsState(
      items: completeItems,
      savedItems: snapshot,
      lastUpdated: lastUpdated,
    );
  }
}
