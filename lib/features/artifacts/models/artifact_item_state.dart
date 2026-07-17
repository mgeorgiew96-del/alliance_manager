class ArtifactItemState {
  const ArtifactItemState({
    required this.itemId,
    this.level = 0,
    this.starStageIndex = 0,
    this.isSelectedForProgress = false,
  });

  final String itemId;

  /// Recorded only. Level does not contribute to progress.
  ///
  /// Level 0 means the item is not owned.
  final int level;

  /// Ordered index in the progression for the item's rarity.
  ///
  /// Blue:
  /// 0–4
  ///
  /// Purple:
  /// 0–5
  ///
  /// Gold:
  /// 0–16
  final int starStageIndex;

  /// Only selected items contribute to progress.
  ///
  /// Maximum selections:
  /// - 5 Artifacts
  /// - 4 Crowns
  final bool isSelectedForProgress;

  bool get isOwned {
    return level > 0;
  }

  ArtifactItemState copyWith({
    int? level,
    int? starStageIndex,
    bool? isSelectedForProgress,
  }) {
    return ArtifactItemState(
      itemId: itemId,
      level: level ?? this.level,
      starStageIndex: starStageIndex ?? this.starStageIndex,
      isSelectedForProgress:
          isSelectedForProgress ?? this.isSelectedForProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'level': level,
      'starStageIndex': starStageIndex,
      'isSelectedForProgress': isSelectedForProgress,
    };
  }

  factory ArtifactItemState.fromMap(Map<String, dynamic> map) {
    return ArtifactItemState(
      itemId: map['itemId'] as String? ?? '',
      level: map['level'] as int? ?? 0,
      starStageIndex: map['starStageIndex'] as int? ?? 0,
      isSelectedForProgress: map['isSelectedForProgress'] as bool? ?? false,
    );
  }
}
