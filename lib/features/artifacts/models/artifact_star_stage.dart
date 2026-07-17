import 'artifact_rarity.dart';

class ArtifactStarStage {
  const ArtifactStarStage({
    required this.stars,
    required this.rank,
    required this.progressionIndex,
  });

  final int stars;
  final int rank;
  final int progressionIndex;

  bool get hasRank {
    return rank > 0;
  }

  String get displayLabel {
    if (stars <= 0) {
      return '0★';
    }

    if (!hasRank) {
      return '$stars★';
    }

    return '$stars★ Rank $rank';
  }

  String get compactLabel {
    if (stars <= 0) {
      return '0★';
    }

    if (!hasRank) {
      return '$stars★';
    }

    return '$stars★ R$rank';
  }
}

abstract final class ArtifactStarProgression {
  static const ArtifactStarStage zero = ArtifactStarStage(
    stars: 0,
    rank: 0,
    progressionIndex: 0,
  );

  static const List<ArtifactStarStage> blueStages = [
    zero,
    ArtifactStarStage(stars: 1, rank: 0, progressionIndex: 1),
    ArtifactStarStage(stars: 2, rank: 0, progressionIndex: 2),
    ArtifactStarStage(stars: 3, rank: 0, progressionIndex: 3),
    ArtifactStarStage(stars: 4, rank: 0, progressionIndex: 4),
  ];

  static const List<ArtifactStarStage> purpleStages = [
    zero,
    ArtifactStarStage(stars: 1, rank: 0, progressionIndex: 1),
    ArtifactStarStage(stars: 2, rank: 0, progressionIndex: 2),
    ArtifactStarStage(stars: 3, rank: 0, progressionIndex: 3),
    ArtifactStarStage(stars: 4, rank: 0, progressionIndex: 4),
    ArtifactStarStage(stars: 5, rank: 0, progressionIndex: 5),
  ];

  static const List<ArtifactStarStage> goldStages = [
    zero,
    ArtifactStarStage(stars: 1, rank: 0, progressionIndex: 1),
    ArtifactStarStage(stars: 2, rank: 0, progressionIndex: 2),
    ArtifactStarStage(stars: 2, rank: 1, progressionIndex: 3),
    ArtifactStarStage(stars: 3, rank: 0, progressionIndex: 4),
    ArtifactStarStage(stars: 3, rank: 1, progressionIndex: 5),
    ArtifactStarStage(stars: 3, rank: 2, progressionIndex: 6),
    ArtifactStarStage(stars: 4, rank: 0, progressionIndex: 7),
    ArtifactStarStage(stars: 4, rank: 1, progressionIndex: 8),
    ArtifactStarStage(stars: 4, rank: 2, progressionIndex: 9),
    ArtifactStarStage(stars: 4, rank: 3, progressionIndex: 10),
    ArtifactStarStage(stars: 5, rank: 0, progressionIndex: 11),
    ArtifactStarStage(stars: 5, rank: 1, progressionIndex: 12),
    ArtifactStarStage(stars: 5, rank: 2, progressionIndex: 13),
    ArtifactStarStage(stars: 5, rank: 3, progressionIndex: 14),
    ArtifactStarStage(stars: 5, rank: 4, progressionIndex: 15),
    ArtifactStarStage(stars: 6, rank: 0, progressionIndex: 16),
  ];

  static List<ArtifactStarStage> forRarity(ArtifactRarity rarity) {
    switch (rarity) {
      case ArtifactRarity.blue:
        return blueStages;

      case ArtifactRarity.purple:
        return purpleStages;

      case ArtifactRarity.gold:
        return goldStages;
    }
  }

  static ArtifactStarStage stageAt({
    required ArtifactRarity rarity,
    required int progressionIndex,
  }) {
    final stages = forRarity(rarity);

    final safeIndex = progressionIndex.clamp(0, stages.length - 1);

    return stages[safeIndex];
  }

  static double progressFor({
    required ArtifactRarity rarity,
    required int progressionIndex,
  }) {
    final stages = forRarity(rarity);

    if (stages.length <= 1) {
      return 0;
    }

    return progressionIndex.clamp(0, stages.length - 1).toDouble() /
        (stages.length - 1);
  }
}
