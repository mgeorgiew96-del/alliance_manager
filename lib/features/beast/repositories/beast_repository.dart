import '../models/beast_state.dart';

abstract class BeastRepository {
  Future<BeastState> loadBeastState({required String amId});

  Future<void> saveBeastState({
    required String amId,
    required BeastState state,
  });
}

class InMemoryBeastRepository implements BeastRepository {
  BeastState _state = BeastState.initial();

  @override
  Future<BeastState> loadBeastState({required String amId}) async {
    return _state;
  }

  @override
  Future<void> saveBeastState({
    required String amId,
    required BeastState state,
  }) async {
    _state = state;
  }
}
