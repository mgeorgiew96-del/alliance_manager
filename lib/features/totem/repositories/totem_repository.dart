import '../models/totem_state.dart';

abstract class TotemRepository {
  Future<TotemState> loadTotemState({
    required String amId,
  });

  Future<void> saveTotemState({
    required String amId,
    required TotemState state,
  });
}

class InMemoryTotemRepository implements TotemRepository {
  TotemState _state = TotemState.initial();

  @override
  Future<TotemState> loadTotemState({
    required String amId,
  }) async {
    return _state;
  }

  @override
  Future<void> saveTotemState({
    required String amId,
    required TotemState state,
  }) async {
    _state = state;
  }
}
