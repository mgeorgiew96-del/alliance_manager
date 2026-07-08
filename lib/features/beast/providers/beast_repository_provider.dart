import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/beast_repository.dart';

final beastRepositoryProvider = Provider<BeastRepository>((ref) {
  return InMemoryBeastRepository();
});