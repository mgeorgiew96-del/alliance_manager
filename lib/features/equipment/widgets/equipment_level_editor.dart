import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';

class EquipmentLevelEditor extends StatelessWidget {
  const EquipmentLevelEditor({
    super.key,
    required this.title,
    required this.level,
    required this.minimumLevel,
    required this.maximumLevel,
    required this.onLevelChanged,
    this.description,
    this.isTracked = true,
  });

  final String title;
  final String? description;

  final int level;
  final int minimumLevel;
  final int maximumLevel;

  final bool isTracked;

  final ValueChanged<int> onLevelChanged;

  bool get _canDecrease {
    return level > minimumLevel;
  }

  bool get _canIncrease {
    return level < maximumLevel;
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: isTracked ? 1 : 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AMTextStyles.subtitle),
                      if (description != null &&
                          description!.trim().isNotEmpty) ...[
                        const SizedBox(height: AMSpacing.xs),
                        Text(description!, style: AMTextStyles.muted),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AMSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AMSpacing.sm,
                    vertical: AMSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isTracked ? 'Tracked' : 'Recorded only',
                    style: AMTextStyles.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.lg),
            Text('LEVEL', style: AMTextStyles.body),
            const SizedBox(height: AMSpacing.xs),
            Text(
              'Valid range: $minimumLevel–$maximumLevel',
              style: AMTextStyles.muted,
            ),
            const SizedBox(height: AMSpacing.sm),
            Row(
              children: [
                IconButton(
                  tooltip: 'Decrease level',
                  onPressed: _canDecrease
                      ? () {
                          onLevelChanged(level - 1);
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
                    child: Text('$level', style: AMTextStyles.title),
                  ),
                ),
                IconButton(
                  tooltip: 'Increase level',
                  onPressed: _canIncrease
                      ? () {
                          onLevelChanged(level + 1);
                        }
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
