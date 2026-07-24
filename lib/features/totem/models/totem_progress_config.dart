import 'totem_rarity.dart';

class TotemProgressConfig {
  const TotemProgressConfig({
    required this.levelWeight,
    required this.skillLevelWeight,
    required this.rarityWeights,
  });

  factory TotemProgressConfig.defaults() {
    return const TotemProgressConfig(
      levelWeight: 0.4,
      skillLevelWeight: 0.6,
      rarityWeights: <TotemRarity, double>{
        TotemRarity.blue: 1,
        TotemRarity.purple: 1.5,
        TotemRarity.gold: 2,
      },
    );
  }

  final double levelWeight;
  final double skillLevelWeight;
  final Map<TotemRarity, double> rarityWeights;

  double get componentWeightTotal => levelWeight + skillLevelWeight;

  bool get hasValidComponentWeights {
    return (componentWeightTotal - 1).abs() < 0.000001;
  }

  double weightForRarity(TotemRarity rarity) {
    return rarityWeights[rarity] ?? rarity.defaultProgressWeight;
  }

  TotemProgressConfig copyWith({
    double? levelWeight,
    double? skillLevelWeight,
    Map<TotemRarity, double>? rarityWeights,
  }) {
    return TotemProgressConfig(
      levelWeight: levelWeight ?? this.levelWeight,
      skillLevelWeight: skillLevelWeight ?? this.skillLevelWeight,
      rarityWeights: rarityWeights ?? this.rarityWeights,
    );
  }

  TotemProgressConfig updateRarityWeight({
    required TotemRarity rarity,
    required double weight,
  }) {
    final safeWeight = weight < 0 ? 0.0 : weight;

    return copyWith(
      rarityWeights: <TotemRarity, double>{
        ...rarityWeights,
        rarity: safeWeight,
      },
    );
  }
}
