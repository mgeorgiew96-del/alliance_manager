import '../beast_type.dart';

class BeastTalentDefinition {
  const BeastTalentDefinition({
    required this.id,
    required this.name,
    required this.maxLevel,
    required this.positionX,
    required this.positionY,
    this.description = '',
    this.beastType,
  });

  final String id;
  final String name;
  final int maxLevel;
  final double positionX;
  final double positionY;
  final String description;
  final BeastType? beastType;
}