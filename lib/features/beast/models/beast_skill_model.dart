class BeastSkillModel {
  const BeastSkillModel({
    required this.id,
    required this.name,
    required this.level,
    required this.minLevel,
    required this.maxLevel,
    this.isImportant = true,
  });

  final String id;
  final String name;
  final int level;
  final int minLevel;
  final int maxLevel;
  final bool isImportant;
}
