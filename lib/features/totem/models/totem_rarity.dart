enum TotemRarity {
  blue,
  purple,
  gold;

  String get displayName {
    switch (this) {
      case TotemRarity.blue:
        return 'Blue';
      case TotemRarity.purple:
        return 'Purple';
      case TotemRarity.gold:
        return 'Gold';
    }
  }

  double get defaultProgressWeight {
    switch (this) {
      case TotemRarity.blue:
        return 1;
      case TotemRarity.purple:
        return 1.5;
      case TotemRarity.gold:
        return 2;
    }
  }
}
