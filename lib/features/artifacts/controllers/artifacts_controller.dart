import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/artifact_item_state.dart';
import '../models/artifacts_state.dart';
import '../services/artifact_item_update_service.dart';
import '../services/artifact_selection_service.dart';
import '../services/artifacts_state_factory.dart';

class ArtifactsController extends AsyncNotifier<ArtifactsState> {
  @override
  Future<ArtifactsState> build() async {
    return ArtifactsStateFactory.initial();
  }

  ArtifactsState? get _currentState {
    return state.whenOrNull(data: (data) => data);
  }

  ArtifactItemState? _item(String itemId) {
    final currentState = _currentState;

    if (currentState == null) {
      return null;
    }

    return currentState.item(itemId);
  }

  void setLevel({required String itemId, required int level}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.setLevel(
      state: currentItem,
      level: level,
    );

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  void increaseLevel({required String itemId}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.increaseLevel(currentItem);

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  void decreaseLevel({required String itemId}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.decreaseLevel(currentItem);

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  void setStarStage({required String itemId, required int progressionIndex}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.setStarStage(
      state: currentItem,
      progressionIndex: progressionIndex,
    );

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  void increaseStarStage({required String itemId}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.increaseStarStage(
      currentItem,
    );

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  void decreaseStarStage({required String itemId}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return;
    }

    final updatedItem = ArtifactItemUpdateService.decreaseStarStage(
      currentItem,
    );

    _replaceItem(currentState: currentState, updatedItem: updatedItem);
  }

  String? toggleSelection({required String itemId}) {
    final currentState = _currentState;
    final currentItem = _item(itemId);

    if (currentState == null || currentItem == null) {
      return 'Artifact data is not ready yet.';
    }

    if (currentItem.isSelectedForProgress) {
      final updatedItem = currentItem.copyWith(isSelectedForProgress: false);

      _replaceItem(currentState: currentState, updatedItem: updatedItem);

      return null;
    }

    final error = ArtifactSelectionService.selectionError(
      items: currentState.items,
      itemId: itemId,
    );

    if (error != null) {
      return error;
    }

    final updatedItem = currentItem.copyWith(isSelectedForProgress: true);

    _replaceItem(currentState: currentState, updatedItem: updatedItem);

    return null;
  }

  Future<void> save() async {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    final savedState = currentState.saveSnapshot(savedAt: DateTime.now());

    state = AsyncData(savedState);
  }

  Future<void> cancel() async {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.cancelChanges());
  }

  void _replaceItem({
    required ArtifactsState currentState,
    required ArtifactItemState updatedItem,
  }) {
    final updatedItems = Map<String, ArtifactItemState>.from(
      currentState.items,
    );

    updatedItems[updatedItem.itemId] = updatedItem;

    state = AsyncData(currentState.copyWith(items: updatedItems));
  }
}

final artifactsControllerProvider =
    AsyncNotifierProvider<ArtifactsController, ArtifactsState>(
      ArtifactsController.new,
    );
