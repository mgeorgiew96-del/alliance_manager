enum ArtifactCategory {
  artifact,
  crown;

  String get displayName {
    switch (this) {
      case ArtifactCategory.artifact:
        return 'Artifact';

      case ArtifactCategory.crown:
        return 'Crown';
    }
  }

  String get pluralName {
    switch (this) {
      case ArtifactCategory.artifact:
        return 'Artifacts';

      case ArtifactCategory.crown:
        return 'Crowns';
    }
  }

  int get trackedSelectionLimit {
    switch (this) {
      case ArtifactCategory.artifact:
        return 5;

      case ArtifactCategory.crown:
        return 4;
    }
  }
}
