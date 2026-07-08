import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/beast_state.dart';
import '../providers/beast_repository_provider.dart';
import '../repositories/beast_repository.dart';

class BeastController extends AsyncNotifier<BeastState> {
  late BeastRepository _repository;

  @override
  Future<BeastState> build() async {
    _repository = ref.read(beastRepositoryProvider);

    return _repository.loadBeastState(
      amId: 'AM-1360-001',
    );
  }

  BeastState? get _currentState {
    return state.whenOrNull(
      data: (data) => data,
    );
  }

  void increaseTalent({
    required String talentId,
    required int maxLevel,
  }) {
    final currentState = _currentState;

    if (currentState == null) return;

    final currentLevel = currentState.talentLevels[talentId] ?? 0;

    if (currentLevel >= maxLevel) return;

    final updatedLevels = Map<String, int>.from(
      currentState.talentLevels,
    );

    updatedLevels[talentId] = currentLevel + 1;

    state = AsyncData(
      currentState.copyWith(
        talentLevels: updatedLevels,
        hasUnsavedChanges: true,
      ),
    );
  }

  void decreaseTalent({
    required String talentId,
  }) {
    final currentState = _currentState;

    if (currentState == null) return;

    final currentLevel = currentState.talentLevels[talentId] ?? 0;

    if (currentLevel <= 0) return;

    final updatedLevels = Map<String, int>.from(
      currentState.talentLevels,
    );

    updatedLevels[talentId] = currentLevel - 1;

    state = AsyncData(
      currentState.copyWith(
        talentLevels: updatedLevels,
        hasUnsavedChanges: true,
      ),
    );
  }

  Future<void> save() async {
    final currentState = _currentState;

    if (currentState == null) return;

    final savedState = currentState.copyWith(
      hasUnsavedChanges: false,
      lastUpdated: DateTime.now(),
    );

    await _repository.saveBeastState(
      amId: 'AM-1360-001',
      state: savedState,
    );

    state = AsyncData(savedState);
  }

  Future<void> cancel() async {
    final savedState = await _repository.loadBeastState(
      amId: 'AM-1360-001',
    );

    state = AsyncData(
      savedState.copyWith(
        hasUnsavedChanges: false,
      ),
    );
  }
}

final beastControllerProvider =
    AsyncNotifierProvider<BeastController, BeastState>(
  BeastController.new,
);