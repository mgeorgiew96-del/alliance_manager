class BeastSkillDefinition {
  const BeastSkillDefinition({
    required this.id,
    required this.name,
    required this.minLevel,
    required this.maxLevel,
    this.description = '',
    this.isImportantByDefault = true,
  });

  final String id;
  final String name;
  final int minLevel;
  final int maxLevel;
  final String description;
  final bool isImportantByDefault;
}
