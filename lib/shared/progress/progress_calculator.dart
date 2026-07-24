import 'progress_category.dart';

class ProgressCalculator {
  const ProgressCalculator._();

  static double calculateModuleProgress(List<ProgressCategory> categories) {
    final trackedCategories = categories.where((category) {
      return category.isTracked && category.weight > 0;
    }).toList();

    if (trackedCategories.isEmpty) {
      return 0;
    }

    var weightedProgress = 0.0;
    var totalWeight = 0.0;

    for (final category in trackedCategories) {
      weightedProgress += category.progress * category.weight;
      totalWeight += category.weight;
    }

    if (totalWeight <= 0) {
      return 0;
    }

    return (weightedProgress / totalWeight).clamp(0, 1).toDouble();
  }

  static bool categoryWeightsAreValid(
    List<ProgressCategory> categories, {
    double expectedTotal = 1,
    double tolerance = 0.0001,
  }) {
    final totalWeight = categories
        .where((category) => category.isTracked)
        .fold<double>(0, (sum, category) => sum + category.weight);

    return (totalWeight - expectedTotal).abs() <= tolerance;
  }

  static double totalTrackedCategoryWeight(List<ProgressCategory> categories) {
    return categories
        .where((category) => category.isTracked)
        .fold<double>(0, (sum, category) => sum + category.weight);
  }
}
