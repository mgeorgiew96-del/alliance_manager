import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../definitions/high_tech_definitions.dart';
import '../models/high_tech_state.dart';
import '../providers/high_tech_repository_provider.dart';
import '../repositories/high_tech_repository.dart';

class HighTechController extends AsyncNotifier<HighTechState> {
  static const String _currentAmId = 'AM-1360-001';

  late HighTechRepository _repository;

  @override
  Future<HighTechState> build() async {
    _repository = ref.read(highTechRepositoryProvider);

    return _repository.loadHighTechState(amId: _currentAmId);
  }

  HighTechState? get _currentState {
    return state.asData?.value;
  }

  void setLevel({
    required String nodeId,
    required int level,
  }) {
    final currentState = _currentState;
    if (currentState == null) return;

    final definition = highTechDefinitionFor(nodeId);
    final safeLevel = level.clamp(
      definition.minLevel,
      definition.maxLevel,
    );

    if (currentState.levelFor(nodeId) == safeLevel) return;

    final updatedLevels = Map<String, int>.from(currentState.levels);
    updatedLevels[nodeId] = safeLevel;

    state = AsyncData(
      currentState.copyWith(
        levels: Map.unmodifiable(updatedLevels),
      ),
    );
  }

  void increaseLevel({required String nodeId}) {
    final currentState = _currentState;
    if (currentState == null) return;

    setLevel(
      nodeId: nodeId,
      level: currentState.levelFor(nodeId) + 1,
    );
  }

  void decreaseLevel({required String nodeId}) {
    final currentState = _currentState;
    if (currentState == null) return;

    setLevel(
      nodeId: nodeId,
      level: currentState.levelFor(nodeId) - 1,
    );
  }

  Future<void> save() async {
    final currentState = _currentState;
    if (currentState == null || !currentState.hasUnsavedChanges) return;

    final savedState = currentState.copyWith(
      savedLevels: Map.unmodifiable(
        Map<String, int>.from(currentState.levels),
      ),
      lastUpdatedAt: DateTime.now(),
    );

    await _repository.saveHighTechState(
      amId: _currentAmId,
      state: savedState,
    );

    state = AsyncData(savedState);
  }

  Future<void> cancel() async {
    final savedState = await _repository.loadHighTechState(
      amId: _currentAmId,
    );

    state = AsyncData(
      savedState.copyWith(
        levels: Map.unmodifiable(
          Map<String, int>.from(savedState.savedLevels),
        ),
      ),
    );
  }
}

final highTechControllerProvider =
    AsyncNotifierProvider<HighTechController, HighTechState>(
      HighTechController.new,
    );
