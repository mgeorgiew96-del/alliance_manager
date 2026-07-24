import 'mystic_troop_type.dart';

class MysticSkillDefinition {
  const MysticSkillDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.troopType,
    required this.skillNumber,
    required this.valuesByLevel,
    this.minLevel = 0,
    this.maxLevel = 5,
  });

  final String id;
  final String name;
  final String description;
  final MysticTroopType troopType;
  final int skillNumber;
  final List<double> valuesByLevel;
  final int minLevel;
  final int maxLevel;

  double valueAtLevel(int level) {
    final safeLevel = level.clamp(minLevel, maxLevel);
    return valuesByLevel[safeLevel];
  }
}
