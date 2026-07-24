enum TotemType {
  fertility,
  hunting,
  fire,
  darkness,
  order,
  wrath,
  guard,
  earth;

  String get displayName {
    switch (this) {
      case TotemType.fertility:
        return 'Fertility';
      case TotemType.hunting:
        return 'hunting';
      case TotemType.fire:
        return 'Fire';
      case TotemType.darkness:
        return 'Darkness';
      case TotemType.order:
        return 'Order';
      case TotemType.wrath:
        return 'Wrath';
      case TotemType.guard:
        return 'Guard';
      case TotemType.earth:
        return 'Earth';
    }
  }
}
