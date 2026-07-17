import '../models/artifact_category.dart';
import '../models/artifact_item_definition.dart';
import '../models/artifact_rarity.dart';

const crownDefinitions = <ArtifactItemDefinition>[
  ArtifactItemDefinition(
    id: 'emperor',
    name: "Emperor's Crown",
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.blue,
    assetFileName: 'emperor.png',
    starEffects: [
      'Monster Attack Speed',
      'Gathering Speed',
      'Troop Load',
      'Infantry and Cavalry HP',
    ],
  ),
  ArtifactItemDefinition(
    id: 'erebus',
    name: "Erebus's Crown",
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.purple,
    assetFileName: 'erebus.png',
    starEffects: [
      'Infantry and Cavalry HP',
      'Infantry Attack',
      'Angel HP',
      'Cavalry Attack',
      'Archer and Mage Attack',
    ],
  ),
  ArtifactItemDefinition(
    id: 'fire_demon',
    name: "Fire Demon's Crown",
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.gold,
    assetFileName: 'fire_demon.png',
    starEffects: [
      'Damage Against Infantry and Cavalry',
      'Infantry and Cavalry HP',
      'Troops Attack',
      'Damage Against Angels',
      'Infantry and Cavalry Attack',
      'Troops Damage',
    ],
  ),
  ArtifactItemDefinition(
    id: 'thunder',
    name: 'Thunderbolt Crown',
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.gold,
    assetFileName: 'thunder.png',
    starEffects: [
      'Archer and Mage Attack',
      'Enemy Troops HP Reduction',
      'Angel Attack',
      'Enemy Troops Attack Reduction',
      'Archer and Mage HP',
      'Troops Damage Taken Reduction',
    ],
  ),
  ArtifactItemDefinition(
    id: 'ice',
    name: 'Ice Crown',
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.gold,
    assetFileName: 'ice.png',
    starEffects: [
      'Infantry and Cavalry HP',
      'Enemy Troops Attack Reduction',
      'Archer and Mage Attack',
      'Enemy Troops HP Reduction',
      'Angel HP',
      'Troops Damage',
    ],
  ),
  ArtifactItemDefinition(
    id: 'evernight',
    name: 'Evernight Crown',
    category: ArtifactCategory.crown,
    rarity: ArtifactRarity.gold,
    assetFileName: 'evernight.png',
    starEffects: [
      'Infantry and Cavalry Damage Taken Reduction',
      'Archer and Mage Attack',
      'Enemy Troops Attack Reduction',
      'Angel Damage',
      'Infantry and Cavalry HP',
      'Troops Damage Taken Reduction',
    ],
  ),
];
