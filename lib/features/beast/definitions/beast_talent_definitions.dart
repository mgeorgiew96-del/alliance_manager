import '../models/beast_type.dart';
import '../models/definitions/beast_talent_definition.dart';

const allTalentDefinitions = [
  // Row 0
  BeastTalentDefinition(
    id: 'beast_showdown',
    name: 'Beast Showdown',
    maxLevel: 15,
    positionX: 0,
    positionY: 0,
  ),

  // Row 1
  BeastTalentDefinition(
    id: 'beast_inspiration',
    name: 'Beast Inspiration',
    maxLevel: 15,
    positionX: -1,
    positionY: 1,
  ),
  BeastTalentDefinition(
    id: 'troops_converted_attack',
    name: 'Troops Converted Attack',
    maxLevel: 15,
    positionX: 1,
    positionY: 1,
  ),

  // Row 2
  BeastTalentDefinition(
    id: 'potential_awakening',
    name: 'Potential Awakening',
    maxLevel: 15,
    positionX: 0,
    positionY: 2,
  ),

  // Row 3
  BeastTalentDefinition(
    id: 'beasts_growl',
    name: "Beast's Growl",
    maxLevel: 15,
    positionX: -1,
    positionY: 3,
  ),
  BeastTalentDefinition(
    id: 'troops_converted_hp',
    name: 'Troops Converted HP',
    maxLevel: 15,
    positionX: 1,
    positionY: 3,
  ),

  // Row 4
  BeastTalentDefinition(
    id: 'vigor_drain',
    name: 'Vigor Drain',
    maxLevel: 15,
    positionX: 0,
    positionY: 4,
  ),

  // Row 5
  BeastTalentDefinition(
    id: 'defense_expert',
    name: 'Defense Expert',
    maxLevel: 15,
    positionX: -1,
    positionY: 5,
  ),
  BeastTalentDefinition(
    id: 'attack_master',
    name: 'Attack Master',
    maxLevel: 15,
    positionX: 1,
    positionY: 5,
  ),

  // Row 6 — Beast-specific center talent
  BeastTalentDefinition(
    id: 'battle_stampede',
    name: 'Battle Stampede',
    maxLevel: 15,
    positionX: 0,
    positionY: 6,
    beastType: BeastType.pegasus,
  ),
  BeastTalentDefinition(
    id: 'flame_shield',
    name: 'Flame Shield',
    maxLevel: 15,
    positionX: 0,
    positionY: 6,
    beastType: BeastType.phoenix,
  ),
  BeastTalentDefinition(
    id: 'tai_chi_matrix',
    name: 'Tai Chi Matrix',
    maxLevel: 15,
    positionX: 0,
    positionY: 6,
    beastType: BeastType.panda,
  ),
  BeastTalentDefinition(
    id: 'dragon_strength',
    name: 'Dragon Strength',
    maxLevel: 15,
    positionX: 0,
    positionY: 6,
    beastType: BeastType.dragon,
  ),

  // Row 7 — Beast-specific follow-up on left,
  // Angel Rebirth on right
  BeastTalentDefinition(
    id: 'f_battle_stampede',
    name: 'F. Battle Stampede',
    maxLevel: 15,
    positionX: -1,
    positionY: 7,
    beastType: BeastType.pegasus,
  ),
  BeastTalentDefinition(
    id: 'f_flame_shield',
    name: 'F. Flame Shield',
    maxLevel: 15,
    positionX: -1,
    positionY: 7,
    beastType: BeastType.phoenix,
  ),
  BeastTalentDefinition(
    id: 'f_tai_chi_matrix',
    name: 'F. Tai Chi Matrix',
    maxLevel: 15,
    positionX: -1,
    positionY: 7,
    beastType: BeastType.panda,
  ),
  BeastTalentDefinition(
    id: 'f_dragon_strength',
    name: 'F. Dragon Strength',
    maxLevel: 15,
    positionX: -1,
    positionY: 7,
    beastType: BeastType.dragon,
  ),
  BeastTalentDefinition(
    id: 'angel_rebirth',
    name: 'Angel Rebirth',
    maxLevel: 15,
    positionX: 1,
    positionY: 7,
  ),

  // Row 8
  BeastTalentDefinition(
    id: 'strength_combo',
    name: 'Strength Combo',
    maxLevel: 15,
    positionX: 0,
    positionY: 8,
  ),

  // Row 9 — F. Strength Combo on left,
  // Beast-specific third talent on right
  BeastTalentDefinition(
    id: 'f_strength_combo',
    name: 'F. Strength Combo',
    maxLevel: 15,
    positionX: -1,
    positionY: 9,
  ),
  BeastTalentDefinition(
    id: 'spirit_flood',
    name: 'Spirit Flood',
    maxLevel: 15,
    positionX: 1,
    positionY: 9,
    beastType: BeastType.pegasus,
  ),
  BeastTalentDefinition(
    id: 'rebirth_flame',
    name: 'Rebirth Flame',
    maxLevel: 15,
    positionX: 1,
    positionY: 9,
    beastType: BeastType.phoenix,
  ),
  BeastTalentDefinition(
    id: 'holy_blessing',
    name: 'Holy Blessing',
    maxLevel: 15,
    positionX: 1,
    positionY: 9,
    beastType: BeastType.panda,
  ),
  BeastTalentDefinition(
    id: 'dragon_scale',
    name: 'Dragon Scale',
    maxLevel: 15,
    positionX: 1,
    positionY: 9,
    beastType: BeastType.dragon,
  ),

  // Row 10
  BeastTalentDefinition(
    id: 'troops_command',
    name: 'Troops Command',
    maxLevel: 15,
    positionX: 0,
    positionY: 10,
  ),

  // Row 11
  BeastTalentDefinition(
    id: 'beast_coercion',
    name: 'Beast Coercion',
    maxLevel: 15,
    positionX: -1,
    positionY: 11,
  ),
  BeastTalentDefinition(
    id: 'beast_mark',
    name: 'Beast Mark',
    maxLevel: 15,
    positionX: 1,
    positionY: 11,
  ),

  // Row 12
  BeastTalentDefinition(
    id: 'beasts_rage',
    name: "Beast's Rage",
    maxLevel: 15,
    positionX: 0,
    positionY: 12,
  ),
];

List<BeastTalentDefinition> talentDefinitionsForBeast(BeastType beastType) {
  return allTalentDefinitions.where((talent) {
    return talent.beastType == null || talent.beastType == beastType;
  }).toList();
}
