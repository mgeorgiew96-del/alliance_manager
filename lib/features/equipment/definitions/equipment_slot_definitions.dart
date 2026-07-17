import '../models/equipment_jewel_type.dart';
import '../models/equipment_slot_type.dart';

class EquipmentEnhancementDefinition {
  const EquipmentEnhancementDefinition({
    required this.id,
    required this.name,
    required this.maxLevel,
    this.isTrackedByDefault = true,
  });

  final String id;
  final String name;
  final int maxLevel;
  final bool isTrackedByDefault;
}

class EquipmentSlotDefinition {
  const EquipmentSlotDefinition({
    required this.type,
    required this.name,
    required this.pieceCount,
    required this.enhancements,
    required this.jewelType,
    required this.jewelCount,
  });

  final EquipmentSlotType type;
  final String name;
  final int pieceCount;
  final List<EquipmentEnhancementDefinition> enhancements;
  final EquipmentJewelType jewelType;
  final int jewelCount;

  String get id => type.name;
}

const equipmentSlotDefinitions = <EquipmentSlotDefinition>[
  EquipmentSlotDefinition(
    type: EquipmentSlotType.weapon,
    name: 'Weapon',
    pieceCount: 2,
    jewelType: EquipmentJewelType.ruby,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_vs_infantry',
        name: 'Damage Increased vs Infantry',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_vs_cavalry',
        name: 'Damage Increased vs Cavalry',
        maxLevel: 30,
      ),
    ],
  ),
  EquipmentSlotDefinition(
    type: EquipmentSlotType.helmet,
    name: 'Helmet',
    pieceCount: 3,
    jewelType: EquipmentJewelType.ruby,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_archers',
        name: 'Damage Taken Reduced from Archers',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_mages',
        name: 'Damage Taken Reduced from Mages',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_angels',
        name: 'Damage Taken Reduced from Angels',
        maxLevel: 30,
        isTrackedByDefault: false,
      ),
    ],
  ),
  EquipmentSlotDefinition(
    type: EquipmentSlotType.belt,
    name: 'Belt',
    pieceCount: 4,
    jewelType: EquipmentJewelType.sapphire,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_in_attacks',
        name: 'Damage Increased in Attacks',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_defense',
        name: 'Damage Increased in Defense',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_elite_wars',
        name: 'Damage Increased in Elite Wars',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_realm_invasion',
        name: 'Damage Increased in Realm Invasion',
        maxLevel: 30,
      ),
    ],
  ),
  EquipmentSlotDefinition(
    type: EquipmentSlotType.clothes,
    name: 'Clothes',
    pieceCount: 3,
    jewelType: EquipmentJewelType.sapphire,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_archers',
        name: 'Damage Taken Reduced from Archers',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_mages',
        name: 'Damage Taken Reduced from Mages',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_taken_from_angels',
        name: 'Damage Taken Reduced from Angels',
        maxLevel: 30,
        isTrackedByDefault: false,
      ),
    ],
  ),
  EquipmentSlotDefinition(
    type: EquipmentSlotType.accessory,
    name: 'Accessory',
    pieceCount: 4,
    jewelType: EquipmentJewelType.topaz,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_in_attacks',
        name: 'Damage Increased in Attacks',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_defense',
        name: 'Damage Increased in Defense',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_elite_wars',
        name: 'Damage Increased in Elite Wars',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_realm_invasion',
        name: 'Damage Increased in Realm Invasion',
        maxLevel: 30,
      ),
    ],
  ),
  EquipmentSlotDefinition(
    type: EquipmentSlotType.boots,
    name: 'Boots',
    pieceCount: 4,
    jewelType: EquipmentJewelType.topaz,
    jewelCount: 2,
    enhancements: [
      EquipmentEnhancementDefinition(
        id: 'damage_in_attacks',
        name: 'Damage Increased in Attacks',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_defense',
        name: 'Damage Increased in Defense',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_elite_wars',
        name: 'Damage Increased in Elite Wars',
        maxLevel: 30,
      ),
      EquipmentEnhancementDefinition(
        id: 'damage_in_realm_invasion',
        name: 'Damage Increased in Realm Invasion',
        maxLevel: 30,
      ),
    ],
  ),
];

EquipmentSlotDefinition equipmentDefinitionFor(EquipmentSlotType type) {
  return equipmentSlotDefinitions.firstWhere(
    (definition) => definition.type == type,
  );
}
