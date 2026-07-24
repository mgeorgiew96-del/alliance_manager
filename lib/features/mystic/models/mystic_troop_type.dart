enum MysticTroopType {
  infantry,
  cavalry,
  archer,
  mage,
  angels;

  String get displayName {
    switch (this) {
      case MysticTroopType.infantry:
        return 'Infantry';
      case MysticTroopType.cavalry:
        return 'Cavalry';
      case MysticTroopType.archer:
        return 'Archers';
      case MysticTroopType.mage:
        return 'Mages';
      case MysticTroopType.angels:
        return 'Angels';
    }
  }

  String get assetId {
    switch (this) {
      case MysticTroopType.infantry:
        return 'infantry';
      case MysticTroopType.cavalry:
        return 'cavalry';
      case MysticTroopType.archer:
        return 'archer';
      case MysticTroopType.mage:
        return 'mage';
      case MysticTroopType.angels:
        return 'angels';
    }
  }

  int get skillCount {
    return this == MysticTroopType.angels ? 2 : 6;
  }
}
