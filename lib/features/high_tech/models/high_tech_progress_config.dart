import '../definitions/high_tech_definitions.dart';

class HighTechItemProgressConfig {
  const HighTechItemProgressConfig({
    required this.isTracked,
    required this.isPriority,
  });

  final bool isTracked;
  final bool isPriority;

  HighTechItemProgressConfig copyWith({bool? isTracked, bool? isPriority}) {
    return HighTechItemProgressConfig(
      isTracked: isTracked ?? this.isTracked,
      isPriority: isPriority ?? this.isPriority,
    );
  }
}

class HighTechProgressConfig {
  const HighTechProgressConfig({required this.items});

  final Map<String, HighTechItemProgressConfig> items;

  HighTechItemProgressConfig configFor(String nodeId) {
    return items[nodeId] ??
        const HighTechItemProgressConfig(isTracked: false, isPriority: false);
  }

  HighTechProgressConfig copyWithItem({
    required String nodeId,
    required HighTechItemProgressConfig config,
  }) {
    return HighTechProgressConfig(
      items: Map.unmodifiable({...items, nodeId: config}),
    );
  }

  factory HighTechProgressConfig.initial() {
    return HighTechProgressConfig(
      items: Map.unmodifiable({
        for (final definition in highTechDefinitions)
          definition.id: const HighTechItemProgressConfig(
            isTracked: true,
            isPriority: false,
          ),
      }),
    );
  }
}
