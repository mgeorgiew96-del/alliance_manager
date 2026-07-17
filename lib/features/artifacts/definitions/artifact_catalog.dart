import '../models/artifact_category.dart';
import '../models/artifact_item_definition.dart';
import 'artifact_definitions.dart';
import 'crown_definitions.dart';

abstract final class ArtifactCatalog {
  static const List<ArtifactItemDefinition> all = [
    ...artifactDefinitions,
    ...crownDefinitions,
  ];

  static List<ArtifactItemDefinition> forCategory(ArtifactCategory category) {
    return all
        .where((item) {
          return item.category == category;
        })
        .toList(growable: false);
  }

  static ArtifactItemDefinition byId(String itemId) {
    return all.firstWhere(
      (item) => item.id == itemId,
      orElse: () {
        throw StateError('Unknown Artifact item ID: $itemId');
      },
    );
  }

  static ArtifactItemDefinition? tryById(String itemId) {
    for (final item in all) {
      if (item.id == itemId) {
        return item;
      }
    }

    return null;
  }
}
