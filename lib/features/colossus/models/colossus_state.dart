import '../definitions/colossus_definitions.dart';
import 'colossus_data.dart';
import 'colossus_type.dart';

class ColossusState {
  const ColossusState({
    required this.colossus,
    required this.savedcolossus,
    required this.activeTypes,
    required this.savedActiveTypes,
    this.lastUpdated,
  });

  factory ColossusState.initial() {
    final initialcolossus = <ColossusType, ColossusData>{
      for (final type in ColossusType.values) type: ColossusData.initial(type),
    };

    const initialActiveTypes = <ColossusType>{
      ColossusType.infantry,
      ColossusType.cavalry,
    };

    return ColossusState(
      colossus: initialcolossus,
      savedcolossus: _copycolossus(initialcolossus),
      activeTypes: initialActiveTypes,
      savedActiveTypes: initialActiveTypes,
    );
  }

  final Map<ColossusType, ColossusData> colossus;
  final Map<ColossusType, ColossusData> savedcolossus;

  final Set<ColossusType> activeTypes;
  final Set<ColossusType> savedActiveTypes;

  final DateTime? lastUpdated;

  ColossusData dataFor(ColossusType type) {
    return colossus[type] ?? ColossusData.initial(type);
  }

  bool isActive(ColossusType type) {
    return activeTypes.contains(type);
  }

  int get activeCount => activeTypes.length;

  int get totalActiveLevel {
    return activeTypes.fold<int>(
      0,
      (total, type) => total + dataFor(type).totalLevel,
    );
  }

  int get maximumActiveLevel {
    return ColossusDefinitions.maximumColossusLevel *
        ColossusDefinitions.activeColossusLimit;
  }

  bool get hasUnsavedChanges {
    if (!_setsAreEqual(activeTypes, savedActiveTypes)) {
      return true;
    }

    for (final type in ColossusType.values) {
      final current = colossus[type];
      final saved = savedcolossus[type];

      if (current == null || saved == null) {
        return true;
      }

      if (!_mapsAreEqual(current.statLevels, saved.statLevels)) {
        return true;
      }
    }

    return false;
  }

  ColossusState updateColossus(ColossusData updatedData) {
    return copyWith(
      colossus: <ColossusType, ColossusData>{
        ...colossus,
        updatedData.type: updatedData,
      },
    );
  }

  ColossusState setStatLevel({
    required ColossusType type,
    required String statId,
    required int level,
  }) {
    final updatedData = dataFor(
      type,
    ).setStatLevel(statId: statId, level: level);

    return updateColossus(updatedData);
  }

  ColossusState increaseStat({
    required ColossusType type,
    required String statId,
  }) {
    final updatedData = dataFor(type).increaseStat(statId);
    return updateColossus(updatedData);
  }

  ColossusState decreaseStat({
    required ColossusType type,
    required String statId,
  }) {
    final updatedData = dataFor(type).decreaseStat(statId);
    return updateColossus(updatedData);
  }

  ColossusState replaceActiveColossus({
    required ColossusType remove,
    required ColossusType add,
  }) {
    if (!activeTypes.contains(remove)) {
      return this;
    }

    if (activeTypes.contains(add)) {
      return this;
    }

    final updatedActiveTypes = Set<ColossusType>.from(activeTypes)
      ..remove(remove)
      ..add(add);

    return copyWith(activeTypes: updatedActiveTypes);
  }

  ColossusState saveSnapshot({DateTime? savedAt}) {
    return copyWith(
      savedcolossus: _copycolossus(colossus),
      savedActiveTypes: Set<ColossusType>.from(activeTypes),
      lastUpdated: savedAt ?? DateTime.now(),
    );
  }

  ColossusState cancelChanges() {
    return copyWith(
      colossus: _copycolossus(savedcolossus),
      activeTypes: Set<ColossusType>.from(savedActiveTypes),
    );
  }

  ColossusState copyWith({
    Map<ColossusType, ColossusData>? colossus,
    Map<ColossusType, ColossusData>? savedcolossus,
    Set<ColossusType>? activeTypes,
    Set<ColossusType>? savedActiveTypes,
    DateTime? lastUpdated,
    bool clearLastUpdated = false,
  }) {
    return ColossusState(
      colossus: colossus ?? this.colossus,
      savedcolossus: savedcolossus ?? this.savedcolossus,
      activeTypes: activeTypes ?? this.activeTypes,
      savedActiveTypes: savedActiveTypes ?? this.savedActiveTypes,
      lastUpdated: clearLastUpdated ? null : lastUpdated ?? this.lastUpdated,
    );
  }

  static Map<ColossusType, ColossusData> _copycolossus(
    Map<ColossusType, ColossusData> source,
  ) {
    return <ColossusType, ColossusData>{
      for (final entry in source.entries)
        entry.key: entry.value.copyWith(
          statLevels: Map<String, int>.from(entry.value.statLevels),
        ),
    };
  }

  static bool _setsAreEqual<T>(Set<T> first, Set<T> second) {
    if (first.length != second.length) {
      return false;
    }

    return first.containsAll(second);
  }

  static bool _mapsAreEqual(Map<String, int> first, Map<String, int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }
}
