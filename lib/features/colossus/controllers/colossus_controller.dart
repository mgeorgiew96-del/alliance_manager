import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/colossus_state.dart';
import '../models/colossus_type.dart';

class ColossusController extends AsyncNotifier<ColossusState> {
  @override
  Future<ColossusState> build() async {
    return ColossusState.initial();
  }

  ColossusState? get _currentState {
    return state.whenOrNull(data: (data) => data);
  }

  void increaseStat({required ColossusType type, required String statId}) {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.increaseStat(type: type, statId: statId));
  }

  void decreaseStat({required ColossusType type, required String statId}) {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.decreaseStat(type: type, statId: statId));
  }

  void setStatLevel({
    required ColossusType type,
    required String statId,
    required int level,
  }) {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(
      currentState.setStatLevel(type: type, statId: statId, level: level),
    );
  }

  void replaceActiveColossus({
    required ColossusType remove,
    required ColossusType add,
  }) {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(
      currentState.replaceActiveColossus(remove: remove, add: add),
    );
  }

  Future<void> save() async {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.saveSnapshot());
  }

  void cancel() {
    final currentState = _currentState;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.cancelChanges());
  }
}

final colossusControllerProvider =
    AsyncNotifierProvider<ColossusController, ColossusState>(
      ColossusController.new,
    );
