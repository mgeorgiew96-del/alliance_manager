import '../../../shared/constants/am_assets.dart';
import '../models/artifact_category.dart';
import '../models/artifact_item_definition.dart';

abstract final class ArtifactAssetService {
  static String pathFor(ArtifactItemDefinition definition) {
    switch (definition.category) {
      case ArtifactCategory.artifact:
        return AMAssets.artifacts.artifact(definition.assetFileName);

      case ArtifactCategory.crown:
        return AMAssets.artifacts.crown(definition.assetFileName);
    }
  }
}
