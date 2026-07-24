class HighTechNodeDefinition {
  const HighTechNodeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.minLevel,
    required this.maxLevel,
  });

  final String id;
  final String name;
  final String description;
  final String assetPath;
  final int minLevel;
  final int maxLevel;
}
