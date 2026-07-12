import '../models/beast_progress_config.dart';

abstract class BeastProgressConfigRepository {
  Future<BeastProgressConfig> loadConfig();

  Future<void> saveConfig({required BeastProgressConfig config});
}

class InMemoryBeastProgressConfigRepository
    implements BeastProgressConfigRepository {
  BeastProgressConfig _config = BeastProgressConfig.initial();

  @override
  Future<BeastProgressConfig> loadConfig() async {
    return _config;
  }

  @override
  Future<void> saveConfig({required BeastProgressConfig config}) async {
    _config = config;
  }
}
