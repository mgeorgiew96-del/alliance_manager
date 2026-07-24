import '../models/high_tech_state.dart';

abstract class HighTechRepository {
  Future<HighTechState> loadHighTechState({required String amId});

  Future<void> saveHighTechState({
    required String amId,
    required HighTechState state,
  });
}

class InMemoryHighTechRepository implements HighTechRepository {
  HighTechState _state = HighTechState.initial();

  @override
  Future<HighTechState> loadHighTechState({required String amId}) async {
    return _state;
  }

  @override
  Future<void> saveHighTechState({
    required String amId,
    required HighTechState state,
  }) async {
    _state = state;
  }
}
