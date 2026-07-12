import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/beast_progress_config_repository.dart';

final beastProgressConfigRepositoryProvider =
    Provider<BeastProgressConfigRepository>((ref) {
      return InMemoryBeastProgressConfigRepository();
    });
