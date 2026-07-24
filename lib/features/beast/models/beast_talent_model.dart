class BeastTalentModel {
  const BeastTalentModel({
    required this.id,
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.positionX,
    required this.positionY,
    this.isImportant = true,
  });

  final String id;
  final String name;
  final int level;
  final int maxLevel;

  /// Position in the talent tree.
  final double positionX;
  final double positionY;

  final bool isImportant;
}
