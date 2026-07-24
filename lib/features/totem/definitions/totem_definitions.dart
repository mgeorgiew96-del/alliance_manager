import '../models/totem_definition.dart';
import '../models/totem_rarity.dart';
import '../models/totem_type.dart';

const totemDefinitions = <TotemDefinition>[
  TotemDefinition(
    type: TotemType.fertility,
    rarity: TotemRarity.blue,
    assetFileName: 'blue_fertility.png',
    minimumLevel: 0,
    maximumLevel: 120,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 10,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.hunting,
    rarity: TotemRarity.blue,
    assetFileName: 'blue_hunting.png',
    minimumLevel: 0,
    maximumLevel: 120,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 10,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.fire,
    rarity: TotemRarity.purple,
    assetFileName: 'purple_fire.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.darkness,
    rarity: TotemRarity.purple,
    assetFileName: 'purple_darkness.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.order,
    rarity: TotemRarity.purple,
    assetFileName: 'purple_order.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.wrath,
    rarity: TotemRarity.gold,
    assetFileName: 'gold_wrath.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.guard,
    rarity: TotemRarity.gold,
    assetFileName: 'gold_guard.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
  TotemDefinition(
    type: TotemType.earth,
    rarity: TotemRarity.gold,
    assetFileName: 'gold_earth.png',
    minimumLevel: 0,
    maximumLevel: 450,
    levelStep: 1,
    minimumSkillLevel: 1,
    maximumSkillLevel: 30,
    skillLevelStep: 1,
  ),
];

abstract final class TotemDefinitions {
  static List<TotemDefinition> get all => totemDefinitions;

  static TotemDefinition forType(TotemType type) {
    return totemDefinitions.firstWhere(
      (definition) => definition.type == type,
    );
  }

  static List<TotemDefinition> forRarity(TotemRarity rarity) {
    return totemDefinitions.where((definition) {
      return definition.rarity == rarity;
    }).toList(growable: false);
  }
}
