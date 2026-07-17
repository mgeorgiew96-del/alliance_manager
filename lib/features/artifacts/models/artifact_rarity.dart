enum ArtifactRarity {
  blue,
  purple,
  gold;

  int get maximumLevel {
    switch (this) {
      case ArtifactRarity.blue:
        return 30;

      case ArtifactRarity.purple:
        return 40;

      case ArtifactRarity.gold:
        return 50;
    }
  }

  int get maximumStars {
    switch (this) {
      case ArtifactRarity.blue:
        return 4;

      case ArtifactRarity.purple:
        return 5;

      case ArtifactRarity.gold:
        return 6;
    }
  }

  String get displayName {
    switch (this) {
      case ArtifactRarity.blue:
        return 'Blue';

      case ArtifactRarity.purple:
        return 'Purple';

      case ArtifactRarity.gold:
        return 'Gold';
    }
  }
}
