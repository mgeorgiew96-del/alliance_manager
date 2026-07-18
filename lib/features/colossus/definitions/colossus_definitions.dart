import '../models/colossus_stat_definition.dart';
import '../models/colossus_type.dart';

abstract final class ColossusDefinitions {
  static const int maximumStatLevel = 25;
  static const int maximumColossusLevel = 150;
  static const int activeColossusLimit = 2;

  static const List<int> specialSkillUnlockLevels = <int>[50, 70, 90, 110, 130];

  static const Map<ColossusType, List<ColossusStatDefinition>> statsByColossus =
      <ColossusType, List<ColossusStatDefinition>>{
        ColossusType.infantry: <ColossusStatDefinition>[
          ColossusStatDefinition(
            id: 'attack',
            name: 'Attack',
            iconId: 'infantry_attack',
          ),
          ColossusStatDefinition(id: 'hp', name: 'HP', iconId: 'infantry_hp'),
          ColossusStatDefinition(
            id: 'defense',
            name: 'Defense',
            iconId: 'infantry_defense',
          ),
          ColossusStatDefinition(
            id: 'reduce_cavalry',
            name: 'Reduced Damage from Cavalry',
            iconId: 'infantry_reduce_cavalry',
          ),
          ColossusStatDefinition(
            id: 'reduce_archer',
            name: 'Reduced Damage from Archers',
            iconId: 'infantry_reduce_archer',
          ),
          ColossusStatDefinition(
            id: 'reduce_mage',
            name: 'Reduced Damage from Mages',
            iconId: 'infantry_reduce_mage',
          ),
        ],
        ColossusType.cavalry: <ColossusStatDefinition>[
          ColossusStatDefinition(
            id: 'attack',
            name: 'Attack',
            iconId: 'cavalry_attack',
          ),
          ColossusStatDefinition(id: 'hp', name: 'HP', iconId: 'cavalry_hp'),
          ColossusStatDefinition(
            id: 'defense',
            name: 'Defense',
            iconId: 'cavalry_defense',
          ),
          ColossusStatDefinition(
            id: 'reduce_infantry',
            name: 'Reduced Damage from Infantry',
            iconId: 'cavalry_reduce_infantry',
          ),
          ColossusStatDefinition(
            id: 'reduce_archer',
            name: 'Reduced Damage from Archers',
            iconId: 'cavalry_reduce_archer',
          ),
          ColossusStatDefinition(
            id: 'reduce_mage',
            name: 'Reduced Damage from Mages',
            iconId: 'cavalry_reduce_mage',
          ),
        ],
        ColossusType.archer: <ColossusStatDefinition>[
          ColossusStatDefinition(
            id: 'attack',
            name: 'Attack',
            iconId: 'archer_attack',
          ),
          ColossusStatDefinition(id: 'hp', name: 'HP', iconId: 'archer_hp'),
          ColossusStatDefinition(
            id: 'defense',
            name: 'Defense',
            iconId: 'archer_defense',
          ),
          ColossusStatDefinition(
            id: 'damage_infantry',
            name: 'Damage vs Infantry',
            iconId: 'archer_damage_infantry',
          ),
          ColossusStatDefinition(
            id: 'damage_cavalry',
            name: 'Damage vs Cavalry',
            iconId: 'archer_damage_cavalry',
          ),
          ColossusStatDefinition(
            id: 'damage_mage',
            name: 'Damage vs Mages',
            iconId: 'archer_damage_mage',
          ),
        ],
        ColossusType.mage: <ColossusStatDefinition>[
          ColossusStatDefinition(
            id: 'attack',
            name: 'Attack',
            iconId: 'mage_attack',
          ),
          ColossusStatDefinition(id: 'hp', name: 'HP', iconId: 'mage_hp'),
          ColossusStatDefinition(
            id: 'defense',
            name: 'Defense',
            iconId: 'mage_defense',
          ),
          ColossusStatDefinition(
            id: 'damage_infantry',
            name: 'Damage vs Infantry',
            iconId: 'mage_damage_infantry',
          ),
          ColossusStatDefinition(
            id: 'damage_cavalry',
            name: 'Damage vs Cavalry',
            iconId: 'mage_damage_cavalry',
          ),
          ColossusStatDefinition(
            id: 'damage_archer',
            name: 'Damage vs Archers',
            iconId: 'mage_damage_archer',
          ),
        ],
      };

  static List<ColossusStatDefinition> statsFor(ColossusType type) {
    return statsByColossus[type] ?? const <ColossusStatDefinition>[];
  }

  static bool isSpecialSkillUnlocked({
    required int colossusLevel,
    required int specialSkillIndex,
  }) {
    if (specialSkillIndex < 0 ||
        specialSkillIndex >= specialSkillUnlockLevels.length) {
      return false;
    }

    return colossusLevel >= specialSkillUnlockLevels[specialSkillIndex];
  }
}
