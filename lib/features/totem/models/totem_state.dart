import 'totem_data.dart';
import 'totem_type.dart';

class TotemState {
  const TotemState({
    required this.totems,
    required this.savedTotems,
    required this.primaryType,
    required this.secondaryType,
    required this.savedPrimaryType,
    required this.savedSecondaryType,
    this.lastUpdated,
  });

  factory TotemState.initial() {
    final initialTotems = <TotemType, TotemData>{
      for (final type in TotemType.values) type: TotemData.initial(type),
    };

    return TotemState(
      totems: initialTotems,
      savedTotems: _copyTotems(initialTotems),
      primaryType: TotemType.wrath,
      secondaryType: TotemType.fire,
      savedPrimaryType: TotemType.wrath,
      savedSecondaryType: TotemType.fire,
    );
  }

  final Map<TotemType, TotemData> totems;
  final Map<TotemType, TotemData> savedTotems;

  final TotemType primaryType;
  final TotemType secondaryType;
  final TotemType savedPrimaryType;
  final TotemType savedSecondaryType;

  final DateTime? lastUpdated;

  TotemData dataFor(TotemType type) {
    return totems[type] ?? TotemData.initial(type);
  }

  TotemData get primaryTotem => dataFor(primaryType);
  TotemData get secondaryTotem => dataFor(secondaryType);

  bool isPrimary(TotemType type) => primaryType == type;

  bool isSecondary(TotemType type) => secondaryType == type;

  bool isSelected(TotemType type) => isPrimary(type) || isSecondary(type);

  bool get hasUnsavedChanges {
    if (primaryType != savedPrimaryType ||
        secondaryType != savedSecondaryType) {
      return true;
    }

    for (final type in TotemType.values) {
      final current = totems[type];
      final saved = savedTotems[type];

      if (current == null || saved == null) {
        return true;
      }

      if (current.level != saved.level ||
          current.skillLevel != saved.skillLevel) {
        return true;
      }
    }

    return false;
  }

  TotemState updateTotem(TotemData updatedData) {
    return copyWith(
      totems: <TotemType, TotemData>{
        ...totems,
        updatedData.type: updatedData,
      },
    );
  }

  TotemState setLevel({required TotemType type, required int level}) {
    return updateTotem(dataFor(type).setLevel(level));
  }

  TotemState setSkillLevel({
    required TotemType type,
    required int skillLevel,
  }) {
    return updateTotem(dataFor(type).setSkillLevel(skillLevel));
  }

  TotemState setPrimary(TotemType type) {
    if (primaryType == type) {
      return this;
    }

    if (secondaryType == type) {
      return copyWith(
        primaryType: type,
        secondaryType: primaryType,
      );
    }

    return copyWith(primaryType: type);
  }

  TotemState setSecondary(TotemType type) {
    if (secondaryType == type) {
      return this;
    }

    if (primaryType == type) {
      return copyWith(
        primaryType: secondaryType,
        secondaryType: type,
      );
    }

    return copyWith(secondaryType: type);
  }

  TotemState saveSnapshot({DateTime? savedAt}) {
    return copyWith(
      savedTotems: _copyTotems(totems),
      savedPrimaryType: primaryType,
      savedSecondaryType: secondaryType,
      lastUpdated: savedAt ?? DateTime.now(),
    );
  }

  TotemState cancelChanges() {
    return copyWith(
      totems: _copyTotems(savedTotems),
      primaryType: savedPrimaryType,
      secondaryType: savedSecondaryType,
    );
  }

  TotemState copyWith({
    Map<TotemType, TotemData>? totems,
    Map<TotemType, TotemData>? savedTotems,
    TotemType? primaryType,
    TotemType? secondaryType,
    TotemType? savedPrimaryType,
    TotemType? savedSecondaryType,
    DateTime? lastUpdated,
    bool clearLastUpdated = false,
  }) {
    final nextPrimaryType = primaryType ?? this.primaryType;
    final nextSecondaryType = secondaryType ?? this.secondaryType;

    assert(
      nextPrimaryType != nextSecondaryType,
      'Primary and Secondary Totems must be different.',
    );

    return TotemState(
      totems: totems ?? this.totems,
      savedTotems: savedTotems ?? this.savedTotems,
      primaryType: nextPrimaryType,
      secondaryType: nextSecondaryType,
      savedPrimaryType: savedPrimaryType ?? this.savedPrimaryType,
      savedSecondaryType: savedSecondaryType ?? this.savedSecondaryType,
      lastUpdated: clearLastUpdated ? null : lastUpdated ?? this.lastUpdated,
    );
  }

  static Map<TotemType, TotemData> _copyTotems(
    Map<TotemType, TotemData> source,
  ) {
    return <TotemType, TotemData>{
      for (final entry in source.entries) entry.key: entry.value.copyWith(),
    };
  }
}
