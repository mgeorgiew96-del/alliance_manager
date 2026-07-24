import '../definitions/high_tech_definitions.dart';

class HighTechState {
  const HighTechState({
    required this.levels,
    required this.savedLevels,
    this.lastUpdatedAt,
  });

  final Map<String, int> levels;
  final Map<String, int> savedLevels;
  final DateTime? lastUpdatedAt;

  int levelFor(String nodeId) => levels[nodeId] ?? 0;

  bool get hasUnsavedChanges {
    for (final definition in highTechDefinitions) {
      if (levelFor(definition.id) !=
          (savedLevels[definition.id] ?? definition.minLevel)) {
        return true;
      }
    }
    return false;
  }

  HighTechState copyWith({
    Map<String, int>? levels,
    Map<String, int>? savedLevels,
    DateTime? lastUpdatedAt,
  }) {
    return HighTechState(
      levels: levels ?? this.levels,
      savedLevels: savedLevels ?? this.savedLevels,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  factory HighTechState.initial() {
    final initialLevels = <String, int>{
      for (final definition in highTechDefinitions)
        definition.id: definition.minLevel,
    };

    return HighTechState(
      levels: Map.unmodifiable(initialLevels),
      savedLevels: Map.unmodifiable(initialLevels),
    );
  }
}
