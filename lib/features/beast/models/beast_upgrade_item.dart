class BeastUpgradeItem {
  const BeastUpgradeItem({
    required this.id,
    required this.name,
    required this.minLevel,
    required this.maxLevel,
    this.description,
  });

  final String id;
  final String name;
  final int minLevel;
  final int maxLevel;
  final String? description;

  int clampLevel(int level) {
    return level.clamp(minLevel, maxLevel);
  }

  double progressForLevel(int level) {
    final clampedLevel = clampLevel(level);
    final availableLevels = maxLevel - minLevel;

    if (availableLevels <= 0) {
      return 0;
    }

    return (clampedLevel - minLevel) / availableLevels;
  }
}