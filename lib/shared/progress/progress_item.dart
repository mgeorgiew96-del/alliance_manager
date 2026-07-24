class ProgressItem {
  const ProgressItem({
    required this.id,
    required this.name,
    required this.currentValue,
    required this.minimumValue,
    required this.targetValue,
    this.isTracked = true,
    this.weight = 1,
  });

  final String id;
  final String name;

  /// The player's current value.
  final double currentValue;

  /// The lowest valid value for this item.
  final double minimumValue;

  /// The value considered complete for progress purposes.
  final double targetValue;

  /// Untracked items remain stored but do not affect progress.
  final bool isTracked;

  /// Relative importance inside the category.
  final double weight;

  double get progress {
    final availableProgress = targetValue - minimumValue;

    if (availableProgress <= 0) {
      return currentValue >= targetValue ? 1 : 0;
    }

    final completedProgress = currentValue - minimumValue;
    final result = completedProgress / availableProgress;

    return result.clamp(0, 1).toDouble();
  }

  ProgressItem copyWith({
    String? id,
    String? name,
    double? currentValue,
    double? minimumValue,
    double? targetValue,
    bool? isTracked,
    double? weight,
  }) {
    return ProgressItem(
      id: id ?? this.id,
      name: name ?? this.name,
      currentValue: currentValue ?? this.currentValue,
      minimumValue: minimumValue ?? this.minimumValue,
      targetValue: targetValue ?? this.targetValue,
      isTracked: isTracked ?? this.isTracked,
      weight: weight ?? this.weight,
    );
  }
}
