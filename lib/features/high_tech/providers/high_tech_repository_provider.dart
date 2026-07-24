import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/high_tech_repository.dart';

final highTechRepositoryProvider = Provider<HighTechRepository>((ref) {
  return InMemoryHighTechRepository();
});
