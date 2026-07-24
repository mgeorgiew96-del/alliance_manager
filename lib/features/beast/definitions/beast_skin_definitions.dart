import '../models/beast_upgrade_item.dart';

const List<BeastUpgradeItem> beastSkinDefinitions = [
  BeastUpgradeItem(id: 'regular', name: 'Regular', minLevel: 0, maxLevel: 20),
  BeastUpgradeItem(id: 'ice', name: 'Ice', minLevel: 0, maxLevel: 20),
  BeastUpgradeItem(id: 'dark', name: 'Dark', minLevel: 0, maxLevel: 16),
  BeastUpgradeItem(id: 'desert', name: 'Desert', minLevel: 0, maxLevel: 16),
  BeastUpgradeItem(id: 'mecha', name: 'Mecha', minLevel: 0, maxLevel: 16),
  BeastUpgradeItem(id: 'dracula', name: 'Dracula', minLevel: 0, maxLevel: 16),
];

BeastUpgradeItem? beastSkinById(String skinId) {
  for (final skin in beastSkinDefinitions) {
    if (skin.id == skinId) {
      return skin;
    }
  }

  return null;
}
