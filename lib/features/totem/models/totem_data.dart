import '../definitions/totem_definitions.dart';
import 'totem_type.dart';

class TotemData {
  const TotemData({
    required this.type,
    required this.level,
    required this.skillLevel,
  });

  factory TotemData.initial(TotemType type) {
    final definition = TotemDefinitions.forType(type);

    return TotemData(
      type: type,
      level: definition.minimumLevel,
      skillLevel: definition.minimumSkillLevel,
    );
  }

  final TotemType type;
  final int level;
  final int skillLevel;

  TotemData setLevel(int value) {
    final definition = TotemDefinitions.forType(type);

    return copyWith(level: definition.clampLevel(value));
  }

  TotemData increaseLevel() {
    final definition = TotemDefinitions.forType(type);

    return setLevel(level + definition.levelStep);
  }

  TotemData decreaseLevel() {
    final definition = TotemDefinitions.forType(type);

    return setLevel(level - definition.levelStep);
  }

  TotemData setSkillLevel(int value) {
    final definition = TotemDefinitions.forType(type);

    return copyWith(skillLevel: definition.clampSkillLevel(value));
  }

  TotemData increaseSkillLevel() {
    final definition = TotemDefinitions.forType(type);

    return setSkillLevel(skillLevel + definition.skillLevelStep);
  }

  TotemData decreaseSkillLevel() {
    final definition = TotemDefinitions.forType(type);

    return setSkillLevel(skillLevel - definition.skillLevelStep);
  }

  TotemData copyWith({TotemType? type, int? level, int? skillLevel}) {
    return TotemData(
      type: type ?? this.type,
      level: level ?? this.level,
      skillLevel: skillLevel ?? this.skillLevel,
    );
  }
}
