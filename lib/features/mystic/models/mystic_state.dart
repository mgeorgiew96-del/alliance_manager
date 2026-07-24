import '../definitions/mystic_skill_definitions.dart';
import 'mystic_troop_type.dart';

class MysticState {
  const MysticState({
    required this.selectedTroop,
    required this.activeTroops,
    required this.savedActiveTroops,
    required this.skillLevels,
    required this.savedSkillLevels,
    required this.lastUpdated,
  });

  final MysticTroopType selectedTroop;

  /// Exactly two normal troop types are active.
  /// Angels are always active and are therefore not stored in this set.
  final Set<MysticTroopType> activeTroops;
  final Set<MysticTroopType> savedActiveTroops;

  final Map<String, int> skillLevels;
  final Map<String, int> savedSkillLevels;
  final DateTime? lastUpdated;

  bool isActive(MysticTroopType troopType) {
    return troopType == MysticTroopType.angels ||
        activeTroops.contains(troopType);
  }

  bool get hasUnsavedChanges {
    if (!_setsAreEqual(activeTroops, savedActiveTroops)) {
      return true;
    }

    if (skillLevels.length != savedSkillLevels.length) {
      return true;
    }

    for (final entry in skillLevels.entries) {
      if (savedSkillLevels[entry.key] != entry.value) {
        return true;
      }
    }

    return false;
  }

  int levelFor(String skillId) {
    return skillLevels[skillId] ?? 0;
  }

  MysticState copyWith({
    MysticTroopType? selectedTroop,
    Set<MysticTroopType>? activeTroops,
    Set<MysticTroopType>? savedActiveTroops,
    Map<String, int>? skillLevels,
    Map<String, int>? savedSkillLevels,
    DateTime? lastUpdated,
    bool clearLastUpdated = false,
  }) {
    return MysticState(
      selectedTroop: selectedTroop ?? this.selectedTroop,
      activeTroops: activeTroops ?? this.activeTroops,
      savedActiveTroops: savedActiveTroops ?? this.savedActiveTroops,
      skillLevels: skillLevels ?? this.skillLevels,
      savedSkillLevels: savedSkillLevels ?? this.savedSkillLevels,
      lastUpdated: clearLastUpdated ? null : lastUpdated ?? this.lastUpdated,
    );
  }

  factory MysticState.initial() {
    final levels = <String, int>{
      for (final skill in mysticSkillDefinitions) skill.id: skill.minLevel,
    };

    const initialActiveTroops = {
      MysticTroopType.infantry,
      MysticTroopType.cavalry,
    };

    return MysticState(
      selectedTroop: MysticTroopType.infantry,
      activeTroops: Set.unmodifiable(initialActiveTroops),
      savedActiveTroops: Set.unmodifiable(initialActiveTroops),
      skillLevels: Map.unmodifiable(levels),
      savedSkillLevels: Map.unmodifiable(levels),
      lastUpdated: null,
    );
  }
}

bool _setsAreEqual<T>(Set<T> first, Set<T> second) {
  if (first.length != second.length) {
    return false;
  }

  return first.containsAll(second);
}
