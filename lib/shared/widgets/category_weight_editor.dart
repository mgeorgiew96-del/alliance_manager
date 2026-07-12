import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_card.dart';

class CategoryWeightEditor extends StatelessWidget {
  const CategoryWeightEditor({
    super.key,
    required this.title,
    required this.description,
    required this.items,
    required this.onWeightChanged,
    this.step = 0.05,
  });

  final String title;
  final String description;
  final List<CategoryWeightItem> items;
  final void Function(String id, double weight) onWeightChanged;
  final double step;

  double get totalWeight {
    return items.fold<double>(0, (sum, item) => sum + item.weight);
  }

  bool get weightsAreValid {
    return (totalWeight - 1).abs() <= 0.0001;
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(description, style: AMTextStyles.muted),
          const SizedBox(height: AMSpacing.lg),
          for (var index = 0; index < items.length; index++) ...[
            _WeightItemRow(
              item: items[index],
              step: step,
              onWeightChanged: onWeightChanged,
            ),
            if (index < items.length - 1) const SizedBox(height: AMSpacing.md),
          ],
          const SizedBox(height: AMSpacing.lg),
          const Divider(),
          const SizedBox(height: AMSpacing.sm),
          Row(
            children: [
              Expanded(child: Text('Total', style: AMTextStyles.subtitle)),
              Text(_percentageText(totalWeight), style: AMTextStyles.subtitle),
            ],
          ),
          if (!weightsAreValid) ...[
            const SizedBox(height: AMSpacing.sm),
            const Text(
              'Category weights must total 100% before saving.',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CategoryWeightItem {
  const CategoryWeightItem({
    required this.id,
    required this.label,
    required this.weight,
  });

  final String id;
  final String label;
  final double weight;
}

class _WeightItemRow extends StatelessWidget {
  const _WeightItemRow({
    required this.item,
    required this.step,
    required this.onWeightChanged,
  });

  final CategoryWeightItem item;
  final double step;
  final void Function(String id, double weight) onWeightChanged;

  bool get canDecrease {
    return item.weight >= step;
  }

  bool get canIncrease {
    return item.weight <= 1 - step;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.label, style: AMTextStyles.body),
        const SizedBox(height: AMSpacing.sm),
        Row(
          children: [
            IconButton(
              tooltip: 'Decrease ${item.label} weight',
              onPressed: canDecrease
                  ? () {
                      onWeightChanged(
                        item.id,
                        _normaliseWeight(item.weight - step),
                      );
                    }
                  : null,
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: AMSpacing.sm,
                  vertical: AMSpacing.md,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _percentageText(item.weight),
                  style: AMTextStyles.subtitle,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Increase ${item.label} weight',
              onPressed: canIncrease
                  ? () {
                      onWeightChanged(
                        item.id,
                        _normaliseWeight(item.weight + step),
                      );
                    }
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}

double _normaliseWeight(double value) {
  return double.parse(value.clamp(0, 1).toStringAsFixed(2));
}

String _percentageText(double value) {
  return '${(value * 100).toStringAsFixed(0)}%';
}
