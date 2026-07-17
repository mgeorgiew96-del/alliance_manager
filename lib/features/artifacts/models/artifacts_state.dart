import 'artifact_item_state.dart';

class ArtifactsState {
  const ArtifactsState({
    required this.items,
    required this.savedItems,
    this.lastUpdated,
  });

  final Map<String, ArtifactItemState> items;
  final Map<String, ArtifactItemState> savedItems;

  final DateTime? lastUpdated;

  bool get hasUnsavedChanges {
    if (items.length != savedItems.length) {
      return true;
    }

    for (final entry in items.entries) {
      final savedItem = savedItems[entry.key];

      if (savedItem == null) {
        return true;
      }

      final currentItem = entry.value;

      if (currentItem.level != savedItem.level ||
          currentItem.starStageIndex != savedItem.starStageIndex ||
          currentItem.isSelectedForProgress !=
              savedItem.isSelectedForProgress) {
        return true;
      }
    }

    return false;
  }

  ArtifactItemState item(String itemId) {
    return items[itemId] ?? ArtifactItemState(itemId: itemId);
  }

  ArtifactsState copyWith({
    Map<String, ArtifactItemState>? items,
    Map<String, ArtifactItemState>? savedItems,
    DateTime? lastUpdated,
    bool clearLastUpdated = false,
  }) {
    return ArtifactsState(
      items: items ?? this.items,
      savedItems: savedItems ?? this.savedItems,
      lastUpdated: clearLastUpdated ? null : lastUpdated ?? this.lastUpdated,
    );
  }

  ArtifactsState saveSnapshot({DateTime? savedAt}) {
    final snapshot = Map<String, ArtifactItemState>.from(items);

    return copyWith(
      savedItems: snapshot,
      lastUpdated: savedAt ?? DateTime.now(),
    );
  }

  ArtifactsState cancelChanges() {
    return copyWith(items: Map<String, ArtifactItemState>.from(savedItems));
  }
}
