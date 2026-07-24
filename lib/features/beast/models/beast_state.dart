import 'beast_type.dart';

class BeastState {
  const BeastState({
    required this.selectedBeast,
    required this.skillLevels,
    required this.talentLevels,
    required this.skinLevels,
    required this.beastLevel,
    required this.hasUnsavedChanges,
    this.lastUpdated,
  });

  final BeastType selectedBeast;
  final Map<String, int> skillLevels;
  final Map<String, int> talentLevels;
  final Map<String, int> skinLevels;
  final int beastLevel;
  final bool hasUnsavedChanges;
  final DateTime? lastUpdated;

  BeastState copyWith({
    BeastType? selectedBeast,
    Map<String, int>? skillLevels,
    Map<String, int>? talentLevels,
    Map<String, int>? skinLevels,
    int? beastLevel,
    bool? hasUnsavedChanges,
    DateTime? lastUpdated,
  }) {
    return BeastState(
      selectedBeast: selectedBeast ?? this.selectedBeast,
      skillLevels: skillLevels ?? this.skillLevels,
      talentLevels: talentLevels ?? this.talentLevels,
      skinLevels: skinLevels ?? this.skinLevels,
      beastLevel: beastLevel ?? this.beastLevel,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory BeastState.initial() {
    return const BeastState(
      selectedBeast: BeastType.panda,
      skillLevels: {},
      talentLevels: {},
      skinLevels: {},
      beastLevel: 1,
      hasUnsavedChanges: false,
      lastUpdated: null,
    );
  }
}
