import '../models/equipment_state.dart';

abstract class EquipmentRepository {
  EquipmentState get savedState;

  Future<void> save({required EquipmentState state});
}

class InMemoryEquipmentRepository implements EquipmentRepository {
  EquipmentState _savedState = EquipmentState.empty();

  @override
  EquipmentState get savedState {
    return _savedState;
  }

  @override
  Future<void> save({required EquipmentState state}) async {
    _savedState = state;
  }
}

final EquipmentRepository equipmentRepository = InMemoryEquipmentRepository();
