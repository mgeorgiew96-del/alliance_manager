import '../definitions/colossus_definitions.dart';
import 'colossus_type.dart';

class ColossusStatProgressConfig {
  const ColossusStatProgressConfig({
    required this.isTracked,
    required this.targetLevel,
    required this.weight,
  });

  const ColossusStatProgressConfig.defaults()
    : isTracked = true,
      targetLevel = ColossusDefinitions.maximumStatLevel,
      weight = 1;

  final bool isTracked;
  final int targetLevel;
  final double weight;

  ColossusStatProgressConfig copyWith({
    bool? isTracked,
    int? targetLevel,
    double? weight,
  }) {
    return ColossusStatProgressConfig(
      isTracked: isTracked ?? this.isTracked,
      targetLevel: targetLevel ?? this.targetLevel,
      weight: weight ?? this.weight,
    );
  }
}

class ColossusProgressConfig {
  const ColossusProgressConfig({required this.statConfigs});

  factory ColossusProgressConfig.defaults() {
    return ColossusProgressConfig(
      statConfigs: <String, ColossusStatProgressConfig>{
        for (final type in ColossusType.values)
          for (final stat in ColossusDefinitions.statsFor(type))
            keyFor(type: type, statId: stat.id):
                const ColossusStatProgressConfig.defaults(),
      },
    );
  }

  final Map<String, ColossusStatProgressConfig> statConfigs;

  ColossusStatProgressConfig configFor({
    required ColossusType type,
    required String statId,
  }) {
    return statConfigs[keyFor(type: type, statId: statId)] ??
        const ColossusStatProgressConfig.defaults();
  }

  ColossusProgressConfig updateStat({
    required ColossusType type,
    required String statId,
    required ColossusStatProgressConfig config,
  }) {
    return copyWith(
      statConfigs: <String, ColossusStatProgressConfig>{
        ...statConfigs,
        keyFor(type: type, statId: statId): config,
      },
    );
  }

  ColossusProgressConfig copyWith({
    Map<String, ColossusStatProgressConfig>? statConfigs,
  }) {
    return ColossusProgressConfig(statConfigs: statConfigs ?? this.statConfigs);
  }

  static String keyFor({required ColossusType type, required String statId}) {
    return '${type.name}:$statId';
  }
}
