import 'package:flutter/material.dart';

import '../progress/progress_priority.dart';
import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_card.dart';
import 'priority_item_editor.dart';

class PriorityEditorList<T> extends StatelessWidget {
  const PriorityEditorList({
    super.key,
    required this.items,
    required this.idForItem,
    required this.titleForItem,
    required this.minimumLevelForItem,
    required this.maximumLevelForItem,
    required this.configForItem,
    required this.onTrackedChanged,
    required this.onTargetLevelChanged,
    required this.onPriorityChanged,
    this.descriptionForItem,
    this.emptyMessage = 'No items are available.',
  });

  final List<T> items;

  final String Function(T item) idForItem;
  final String Function(T item) titleForItem;
  final String? Function(T item)? descriptionForItem;

  final int Function(T item) minimumLevelForItem;
  final int Function(T item) maximumLevelForItem;

  final PriorityEditorItemConfig? Function(T item) configForItem;

  final void Function(T item, bool isTracked) onTrackedChanged;

  final void Function(T item, int targetLevel) onTargetLevelChanged;

  final void Function(T item, ProgressPriority priority) onPriorityChanged;

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AMCard(child: Text(emptyMessage, style: AMTextStyles.muted));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _PriorityEditorListItem<T>(
            item: items[index],
            idForItem: idForItem,
            titleForItem: titleForItem,
            descriptionForItem: descriptionForItem,
            minimumLevelForItem: minimumLevelForItem,
            maximumLevelForItem: maximumLevelForItem,
            configForItem: configForItem,
            onTrackedChanged: onTrackedChanged,
            onTargetLevelChanged: onTargetLevelChanged,
            onPriorityChanged: onPriorityChanged,
          ),
          if (index < items.length - 1) const SizedBox(height: AMSpacing.md),
        ],
      ],
    );
  }
}

class PriorityEditorItemConfig {
  const PriorityEditorItemConfig({
    required this.isTracked,
    required this.targetLevel,
    required this.priority,
  });

  final bool isTracked;
  final int targetLevel;
  final ProgressPriority priority;
}

class _PriorityEditorListItem<T> extends StatelessWidget {
  const _PriorityEditorListItem({
    required this.item,
    required this.idForItem,
    required this.titleForItem,
    required this.descriptionForItem,
    required this.minimumLevelForItem,
    required this.maximumLevelForItem,
    required this.configForItem,
    required this.onTrackedChanged,
    required this.onTargetLevelChanged,
    required this.onPriorityChanged,
  });

  final T item;

  final String Function(T item) idForItem;
  final String Function(T item) titleForItem;
  final String? Function(T item)? descriptionForItem;

  final int Function(T item) minimumLevelForItem;
  final int Function(T item) maximumLevelForItem;

  final PriorityEditorItemConfig? Function(T item) configForItem;

  final void Function(T item, bool isTracked) onTrackedChanged;

  final void Function(T item, int targetLevel) onTargetLevelChanged;

  final void Function(T item, ProgressPriority priority) onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    final itemId = idForItem(item);
    final itemTitle = titleForItem(item);
    final itemConfig = configForItem(item);

    if (itemConfig == null) {
      return AMCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemTitle, style: AMTextStyles.subtitle),
            const SizedBox(height: AMSpacing.xs),
            Text(
              'Missing progress configuration for item: $itemId',
              style: AMTextStyles.muted,
            ),
          ],
        ),
      );
    }

    final minimumLevel = minimumLevelForItem(item);
    final maximumLevel = maximumLevelForItem(item);

    final safeTargetLevel = itemConfig.targetLevel.clamp(
      minimumLevel,
      maximumLevel,
    );

    return PriorityItemEditor(
      title: itemTitle,
      description: descriptionForItem?.call(item),
      isTracked: itemConfig.isTracked,
      targetLevel: safeTargetLevel,
      minimumLevel: minimumLevel,
      maximumLevel: maximumLevel,
      priority: itemConfig.priority,
      onTrackedChanged: (isTracked) {
        onTrackedChanged(item, isTracked);
      },
      onTargetLevelChanged: (targetLevel) {
        final safeLevel = targetLevel.clamp(minimumLevel, maximumLevel);

        onTargetLevelChanged(item, safeLevel);
      },
      onPriorityChanged: (priority) {
        onPriorityChanged(item, priority);
      },
    );
  }
}
