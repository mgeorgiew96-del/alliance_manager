import '../definitions/colossus_definitions.dart';
import 'colossus_type.dart';

class ColossusData {
  const ColossusData({required this.type, required this.statLevels});

  factory ColossusData.initial(ColossusType type) {
    final definitions = ColossusDefinitions.statsFor(type);

    return ColossusData(
      type: type,
      statLevels: <String, int>{
        for (final definition in definitions) definition.id: 0,
      },
    );
  }

  final ColossusType type;
  final Map<String, int> statLevels;

  int statLevel(String statId) {
    return statLevels[statId] ?? 0;
  }

  int get totalLevel {
    return statLevels.values.fold<int>(0, (total, level) => total + level);
  }

  int get maximumLevel => ColossusDefinitions.maximumColossusLevel;

  int get unlockedSpecialSkillCount {
    return ColossusDefinitions.specialSkillUnlockLevels.where((unlockLevel) {
      return totalLevel >= unlockLevel;
    }).length;
  }

  bool isSpecialSkillUnlocked(int specialSkillIndex) {
    return ColossusDefinitions.isSpecialSkillUnlocked(
      colossusLevel: totalLevel,
      specialSkillIndex: specialSkillIndex,
    );
  }

  ColossusData setStatLevel({required String statId, required int level}) {
    final definitions = ColossusDefinitions.statsFor(type);

    final matchingDefinition = definitions.where((definition) {
      return definition.id == statId;
    });

    if (matchingDefinition.isEmpty) {
      return this;
    }

    final maximumLevel = matchingDefinition.first.maximumLevel;
    final safeLevel = level.clamp(0, maximumLevel);

    return copyWith(
      statLevels: <String, int>{...statLevels, statId: safeLevel},
    );
  }

  ColossusData increaseStat(String statId) {
    return setStatLevel(statId: statId, level: statLevel(statId) + 1);
  }

  ColossusData decreaseStat(String statId) {
    return setStatLevel(statId: statId, level: statLevel(statId) - 1);
  }

  ColossusData copyWith({ColossusType? type, Map<String, int>? statLevels}) {
    return ColossusData(
      type: type ?? this.type,
      statLevels: statLevels ?? this.statLevels,
    );
  }
}
