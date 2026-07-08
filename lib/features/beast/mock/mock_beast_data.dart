import '../models/beast_model.dart';
import '../models/beast_progress_model.dart';
import '../models/beast_skin_model.dart';
import '../models/beast_skin_type.dart';
import '../models/beast_skill_model.dart';
import '../models/beast_type.dart';

const beastSkills = [
  BeastSkillModel(
    id: 'march_speed_up',
    name: 'March Speed Up',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'steel_skin',
    name: 'Steel Skin',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'anti_cavalry',
    name: 'Anti-Cavalry',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'resist_magic',
    name: 'Resist Magic',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'anti_infantry',
    name: 'Anti-Infantry',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'smothered_flare',
    name: 'Smothered Flare',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'wounded_limit',
    name: 'Wounded Limit',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'life_source',
    name: 'Life Source',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'force_expansion',
    name: 'Force Expansion',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'attack_expert',
    name: 'Attack Expert',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'quick_heal',
    name: 'Quick Heal',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'recruitment_speed_up',
    name: 'Recruitment Speed Up',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'wounded_conversion',
    name: 'Wounded Conversion',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'anti_angel',
    name: 'Anti-Angel',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'vigor_star',
    name: 'Vigor Star',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
  BeastSkillModel(
    id: 'level_up_booster',
    name: 'Level Up Booster',
    level: 1,
    maxLevel: 30,
    minLevel: 1,
  ),
];

const beastSkins = [
  BeastSkinModel(
    type: BeastSkinType.regular,
    level: 0,
    maxLevel: 20,
  ),
  BeastSkinModel(
    type: BeastSkinType.ice,
    level: 0,
    maxLevel: 20,
  ),
  BeastSkinModel(
    type: BeastSkinType.dark,
    level: 0,
    maxLevel: 16,
  ),
  BeastSkinModel(
    type: BeastSkinType.desert,
    level: 0,
    maxLevel: 16,
  ),
  BeastSkinModel(
    type: BeastSkinType.mecha,
    level: 0,
    maxLevel: 16,
  ),
  BeastSkinModel(
    type: BeastSkinType.dracula,
    level: 0,
    maxLevel: 16,
  ),
];

const emptyBeastProgress = BeastProgressModel(
  skillsProgress: 0,
  talentsProgress: 0,
  skinsProgress: 0,
);

final pandaBeast = BeastModel(
  type: BeastType.panda,
  level: 1,
  progress: emptyBeastProgress,
  skills: beastSkills,
  talents: const [],
  skins: beastSkins,
);

final dragonBeast = BeastModel(
  type: BeastType.dragon,
  level: 1,
  progress: emptyBeastProgress,
  skills: beastSkills,
  talents: const [],
  skins: beastSkins,
);

final pegasusBeast = BeastModel(
  type: BeastType.pegasus,
  level: 1,
  progress: emptyBeastProgress,
  skills: beastSkills,
  talents: const [],
  skins: beastSkins,
);

final phoenixBeast = BeastModel(
  type: BeastType.phoenix,
  level: 1,
  progress: emptyBeastProgress,
  skills: beastSkills,
  talents: const [],
  skins: beastSkins,
);