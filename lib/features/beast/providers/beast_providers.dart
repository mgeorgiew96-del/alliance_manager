import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_beast_data.dart';
import '../models/beast_model.dart';
import '../models/beast_type.dart';

class SelectedBeastNotifier extends Notifier<BeastType> {
  @override
  BeastType build() {
    return BeastType.panda;
  }

  void select(BeastType beast) {
    state = beast;
  }
}

final selectedBeastProvider =
    NotifierProvider<SelectedBeastNotifier, BeastType>(
  SelectedBeastNotifier.new,
);

final currentBeastProvider = Provider<BeastModel>((ref) {
  final selectedBeast = ref.watch(selectedBeastProvider);

  return switch (selectedBeast) {
    BeastType.panda => pandaBeast,
    BeastType.dragon => dragonBeast,
    BeastType.pegasus => pegasusBeast,
    BeastType.phoenix => phoenixBeast,
  };
});