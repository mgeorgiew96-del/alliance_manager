import 'progress_item.dart';

class ProgressCategory {
  const ProgressCategory({
    required this.id,
    required this.name,
    required this.items,
    required this.weight,
    this.isTracked = true,
  });

  final String id;
  final String name;
  final List<ProgressItem> items;

  /// Relative importance inside the complete module.
  ///
  /// Example:
  /// Skills = 0.50
  /// Talents = 0.30
  /// Skins = 0.20
  final double weight;

  /// Disabled categories remain available but do not affect module progress.
  final bool isTracked;

  List<ProgressItem> get trackedItems {
    return items.where((item) {
      return item.isTracked && item.weight > 0;
    }).toList();
  }

  double get progress {
    final includedItems = trackedItems;

    if (includedItems.isEmpty) {
      return 0;
    }

    var weightedProgress = 0.0;
    var totalWeight = 0.0;

    for (final item in includedItems) {
      weightedProgress += item.progress * item.weight;
      totalWeight += item.weight;
    }

    if (totalWeight <= 0) {
      return 0;
    }

    return (weightedProgress / totalWeight).clamp(0, 1).toDouble();
  }

  ProgressCategory copyWith({
    String? id,
    String? name,
    List<ProgressItem>? items,
    double? weight,
    bool? isTracked,
  }) {
    return ProgressCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      weight: weight ?? this.weight,
      isTracked: isTracked ?? this.isTracked,
    );
  }
}
