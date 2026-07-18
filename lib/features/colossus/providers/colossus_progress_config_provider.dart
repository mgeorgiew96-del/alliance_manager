import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/colossus_progress_config.dart';

class ColossusProgressConfigNotifier extends Notifier<ColossusProgressConfig> {
  @override
  ColossusProgressConfig build() {
    return ColossusProgressConfig.defaults();
  }

  void replaceConfig(ColossusProgressConfig config) {
    state = config;
  }
}

final colossusProgressConfigProvider =
    NotifierProvider<ColossusProgressConfigNotifier, ColossusProgressConfig>(
      ColossusProgressConfigNotifier.new,
    );
