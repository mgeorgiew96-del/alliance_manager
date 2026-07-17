class ColossusStatDefinition {
  const ColossusStatDefinition({
    required this.id,
    required this.name,
    required this.iconId,
    this.maximumLevel = 25,
  });

  final String id;
  final String name;
  final String iconId;
  final int maximumLevel;
}