import '../models/mystic_skill_definition.dart';
import '../models/mystic_troop_type.dart';

const List<MysticSkillDefinition> mysticSkillDefinitions = [
  MysticSkillDefinition(
    id: 'infantry_1',
    name: 'Exhilaration',
    description: 'Increase HP of Infantry by X%.',
    troopType: MysticTroopType.infantry,
    skillNumber: 1,
    valuesByLevel: [0, 4, 7, 10, 13.5, 18],
  ),
  MysticSkillDefinition(
    id: 'infantry_2',
    name: 'Toughness',
    description: 'Infantry take X% less attack damage.',
    troopType: MysticTroopType.infantry,
    skillNumber: 2,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'infantry_3',
    name: 'Elite Infantry',
    description: 'Increases base HP of Infantry by X.',
    troopType: MysticTroopType.infantry,
    skillNumber: 3,
    valuesByLevel: [0, 20, 40, 60, 80, 100],
  ),
  MysticSkillDefinition(
    id: 'infantry_4',
    name: 'Dragon Armor',
    description:
        'Reduces damage taken by Infantry during Cross-Realm battles by X%.',
    troopType: MysticTroopType.infantry,
    skillNumber: 4,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'infantry_5',
    name: 'Dragon Scale Shield',
    description:
        'Increases base Defense of Infantry by X when attacked by Archers.',
    troopType: MysticTroopType.infantry,
    skillNumber: 5,
    valuesByLevel: [0, 3, 6, 9, 12, 15],
  ),
  MysticSkillDefinition(
    id: 'infantry_6',
    name: 'Intervene',
    description:
        'When battling with Lords, Infantry share damage taken by Archers '
        'and Mages by 50%. All shared damage taken by Infantry is '
        'additionally reduced by X%.',
    troopType: MysticTroopType.infantry,
    skillNumber: 6,
    valuesByLevel: [0, 20, 25, 30, 40, 50],
  ),
  MysticSkillDefinition(
    id: 'cavalry_1',
    name: 'Dodge',
    description: 'Cavalry have a X% chance to dodge enemy attacks.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 1,
    valuesByLevel: [0, 3.5, 6, 8.5, 12, 16],
  ),
  MysticSkillDefinition(
    id: 'cavalry_2',
    name: 'Savage Impact',
    description: 'Cavalry attacks have a X% chance to stun targeted enemies.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 2,
    valuesByLevel: [0, 5, 8.5, 12, 16.5, 21],
  ),
  MysticSkillDefinition(
    id: 'cavalry_3',
    name: 'Elite Cavalry',
    description: 'Increases base HP of Cavalry by X.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 3,
    valuesByLevel: [0, 20, 40, 60, 80, 100],
  ),
  MysticSkillDefinition(
    id: 'cavalry_4',
    name: ' Gold Horseshoes',
    description:
        'Reduces damage taken by Cavalry during Cross-Realm battles by X%.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 4,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'cavalry_5',
    name: 'Magic Barrier',
    description:
        'Increases base Defense of Cavalry by X when attacked by Mages.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 5,
    valuesByLevel: [0, 3, 6, 9, 12, 15],
  ),
  MysticSkillDefinition(
    id: 'cavalry_6',
    name: 'Wild Instinct',
    description:
        'When battling with Lords, Cavalry can perceive an attack and reduce '
        'its damage by X%. The trigger chance increases when it does not '
        'activate and resets after activation.',
    troopType: MysticTroopType.cavalry,
    skillNumber: 6,
    valuesByLevel: [0, 13.5, 24, 34.5, 46.5, 60],
  ),
  MysticSkillDefinition(
    id: 'archer_1',
    name: 'Mage Killer',
    description: 'Archers deal X% more damage to Mages.',
    troopType: MysticTroopType.archer,
    skillNumber: 1,
    valuesByLevel: [0, 5.5, 9.5, 13.5, 18.5, 24],
  ),
  MysticSkillDefinition(
    id: 'archer_2',
    name: ' Split Arrow',
    description:
        'Archers have an X% chance to simultaneously hit three enemies '
        'in the front.',
    troopType: MysticTroopType.archer,
    skillNumber: 2,
    valuesByLevel: [0, 4, 7, 10, 13.5, 18],
  ),
  MysticSkillDefinition(
    id: 'archer_3',
    name: ' Elite Archers',
    description: 'Increases base Attack of Archers by X',
    troopType: MysticTroopType.archer,
    skillNumber: 3,
    valuesByLevel: [0, 2, 4, 6, 8, 10],
  ),
  MysticSkillDefinition(
    id: 'archer_4',
    name: ' Dragon Bow',
    description:
        'Increases damage dealt by Archers during Cross-Realm battles by X%.',
    troopType: MysticTroopType.archer,
    skillNumber: 4,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'archer_5',
    name: ' Dragonslayer Arrow',
    description:
        'Increases base Attack of Archers by X when attacking Cavalry.',
    troopType: MysticTroopType.archer,
    skillNumber: 5,
    valuesByLevel: [0, 3, 6, 9, 12, 15],
  ),
  MysticSkillDefinition(
    id: 'archer_6',
    name: 'Rain of Arrows',
    description:
        'When battling with Lords, Archers launch Rain of Arrows after six '
        'attacks to damage all enemy troops except Beasts.',
    troopType: MysticTroopType.archer,
    skillNumber: 6,
    valuesByLevel: [0, 2, 4.5, 7, 9.5, 12],
  ),
  MysticSkillDefinition(
    id: 'mage_1',
    name: 'Fatal Hit',
    description:
        'Mages have a X% chance of dealing higher damage with each attack.',
    troopType: MysticTroopType.mage,
    skillNumber: 1,
    valuesByLevel: [0, 3.5, 6, 8.5, 12, 16],
  ),
  MysticSkillDefinition(
    id: 'mage_2',
    name: ' Fanaticism',
    description: 'Mage attack damage is increased by X0%.',
    troopType: MysticTroopType.mage,
    skillNumber: 2,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'mage_3',
    name: 'Eite Mages',
    description: 'Increases base Attack of Mages by X.',
    troopType: MysticTroopType.mage,
    skillNumber: 3,
    valuesByLevel: [0, 2, 4, 6, 8, 10],
  ),
  MysticSkillDefinition(
    id: 'mage_4',
    name: 'Phoenix Wand',
    description:
        'Increases damage dealt by Mages during Cross-Realm battles by X%.',
    troopType: MysticTroopType.mage,
    skillNumber: 4,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
  MysticSkillDefinition(
    id: 'mage_5',
    name: 'Pierce Armor Skill',
    description: 'Increases base Attack of Mages by X when attacking Infantry.',
    troopType: MysticTroopType.mage,
    skillNumber: 5,
    valuesByLevel: [0, 3, 6, 9, 12, 15],
  ),
  MysticSkillDefinition(
    id: 'mage_6',
    name: 'Spell',
    description:
        'When battling with Lords, increases critical damage dealt by Mages '
        'when launching Critical Strikes by X%.',
    troopType: MysticTroopType.mage,
    skillNumber: 6,
    valuesByLevel: [0, 6, 12.5, 19, 25, 30],
  ),
  MysticSkillDefinition(
    id: 'angels_1',
    name: 'Blazing Soul',
    description: 'Increases damage of Angels Sacred Flame by X%',
    troopType: MysticTroopType.angels,
    skillNumber: 1,
    valuesByLevel: [0, 5.5, 9.5, 13.5, 18.5, 24],
  ),
  MysticSkillDefinition(
    id: 'angels_2',
    name: 'Flame Missile',
    description:
        'Angels normal attack deals an additional X% damage to one enemy '
        'nearest the target.',
    troopType: MysticTroopType.angels,
    skillNumber: 2,
    valuesByLevel: [0, 4.5, 8, 11.5, 15.5, 20],
  ),
];

List<MysticSkillDefinition> mysticSkillsForTroop(MysticTroopType troopType) {
  return mysticSkillDefinitions
      .where((skill) => skill.troopType == troopType)
      .toList(growable: false);
}

MysticSkillDefinition mysticSkillDefinitionFor(String skillId) {
  return mysticSkillDefinitions.firstWhere((skill) => skill.id == skillId);
}
