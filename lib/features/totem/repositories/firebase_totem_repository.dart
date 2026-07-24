import '../models/totem_state.dart';
import 'totem_repository.dart';

class FirebaseTotemRepository implements TotemRepository {
  const FirebaseTotemRepository();

  @override
  Future<TotemState> loadTotemState({
    required String amId,
  }) async {
    // TODO: Load from Firebase
    return TotemState.initial();
  }

  @override
  Future<void> saveTotemState({
    required String amId,
    required TotemState state,
  }) async {
    // TODO: Save to Firebase
  }
}