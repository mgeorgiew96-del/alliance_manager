import 'artifact_category.dart';
import 'artifact_rarity.dart';

class ArtifactItemDefinition {
  const ArtifactItemDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.rarity,
    required this.assetFileName,
    required this.starEffects,
  });

  final String id;
  final String name;

  final ArtifactCategory category;
  final ArtifactRarity rarity;

  /// Filename only, without the folder.
  ///
  /// Example:
  /// `angel_sword.png`
  final String assetFileName;

  /// Effects unlocked by complete stars.
  ///
  /// Index 0 represents the 1-star effect,
  /// index 1 represents the 2-star effect, and so on.
  final List<String> starEffects;

  int get minimumLevel => 0;

  int get maximumLevel => rarity.maximumLevel;

  int get maximumStars => rarity.maximumStars;

  int get selectionLimit {
    return category.trackedSelectionLimit;
  }
}
