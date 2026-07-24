import '../models/beast_upgrade_item.dart';

const List<BeastUpgradeItem> beastSkillDefinitions = [
  BeastUpgradeItem(
    id: 'march_speed_up',
    name: 'March Speed Up',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'steel_skin',
    name: 'Steel Skin',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'anti_cavalry',
    name: 'Anti-Cavalry',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'resist_magic',
    name: 'Resist Magic',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'anti_infantry',
    name: 'Anti-Infantry',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'smothered_flare',
    name: 'Smothered Flare',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'wounded_limit',
    name: 'Wounded Limit',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'life_source',
    name: 'Life Source',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'force_expansion',
    name: 'Force Expansion',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'attack_expert',
    name: 'Attack Expert',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'quick_heal',
    name: 'Quick Heal',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'recruitment_speed_up',
    name: 'Recruitment Speed Up',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'wounded_conversion',
    name: 'Wounded Conversion',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'anti_angel',
    name: 'Anti-Angel',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'vigor_star',
    name: 'Vigor Star',
    minLevel: 1,
    maxLevel: 30,
  ),
  BeastUpgradeItem(
    id: 'level_up_booster',
    name: 'Level Up Booster',
    minLevel: 1,
    maxLevel: 30,
  ),
];

const List<String> beastOverviewSkillIds = [
  'force_expansion',
  'anti_infantry',
  'anti_cavalry',
  'steel_skin',
  'resist_magic',
  'smothered_flare',
];

BeastUpgradeItem? beastSkillById(String skillId) {
  for (final skill in beastSkillDefinitions) {
    if (skill.id == skillId) {
      return skill;
    }
  }

  return null;
}
