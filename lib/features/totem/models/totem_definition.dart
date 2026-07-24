import 'totem_rarity.dart';
import 'totem_type.dart';

class TotemDefinition {
  const TotemDefinition({
    required this.type,
    required this.rarity,
    required this.assetFileName,
    required this.minimumLevel,
    required this.maximumLevel,
    required this.levelStep,
    required this.minimumSkillLevel,
    required this.maximumSkillLevel,
    required this.skillLevelStep,
  });

  final TotemType type;
  final TotemRarity rarity;

  /// Filename only, without the folder.
  ///
  /// Example:
  /// `fertility.png`
  final String assetFileName;

  final int minimumLevel;
  final int maximumLevel;
  final int levelStep;

  final int minimumSkillLevel;
  final int maximumSkillLevel;
  final int skillLevelStep;

  String get id => type.name;

  String get name => type.displayName;

  int clampLevel(int value) {
    return value.clamp(minimumLevel, maximumLevel);
  }

  int clampSkillLevel(int value) {
    return value.clamp(minimumSkillLevel, maximumSkillLevel);
  }
}
