import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/totem_repository.dart';

final totemRepositoryProvider = Provider<TotemRepository>((ref) {
  return InMemoryTotemRepository();
});
