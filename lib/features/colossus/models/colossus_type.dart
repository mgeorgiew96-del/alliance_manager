enum ColossusType {
  infantry,
  cavalry,
  archer,
  mage;

  String get displayName {
    switch (this) {
      case ColossusType.infantry:
        return 'Infantry';
      case ColossusType.cavalry:
        return 'Cavalry';
      case ColossusType.archer:
        return 'Archer';
      case ColossusType.mage:
        return 'Mage';
    }
  }
}