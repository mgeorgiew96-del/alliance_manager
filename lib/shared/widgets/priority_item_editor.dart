import 'package:flutter/material.dart';

import '../progress/progress_priority.dart';
import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_card.dart';

class PriorityItemEditor extends StatelessWidget {
  const PriorityItemEditor({
    super.key,
    required this.title,
    required this.isTracked,
    required this.targetLevel,
    required this.minimumLevel,
    required this.maximumLevel,
    required this.priority,
    required this.onTrackedChanged,
    required this.onTargetLevelChanged,
    required this.onPriorityChanged,
    this.description,
  });

  final String title;
  final String? description;

  final bool isTracked;
  final int targetLevel;
  final int minimumLevel;
  final int maximumLevel;
  final ProgressPriority priority;

  final ValueChanged<bool> onTrackedChanged;
  final ValueChanged<int> onTargetLevelChanged;
  final ValueChanged<ProgressPriority> onPriorityChanged;

  bool get _canDecrease {
    return isTracked && targetLevel > minimumLevel;
  }

  bool get _canIncrease {
    return isTracked && targetLevel < maximumLevel;
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
            _Header(
              title: title,
              description: description,
              isTracked: isTracked,
              onTrackedChanged: onTrackedChanged,
            ),
            const SizedBox(height: AMSpacing.md),
            const Divider(),
            const SizedBox(height: AMSpacing.md),
            _TargetLevelEditor(
              targetLevel: targetLevel,
              minimumLevel: minimumLevel,
              maximumLevel: maximumLevel,
              canDecrease: _canDecrease,
              canIncrease: _canIncrease,
              onDecrease: () {
                onTargetLevelChanged(targetLevel - 1);
              },
              onIncrease: () {
                onTargetLevelChanged(targetLevel + 1);
              },
            ),
            const SizedBox(height: AMSpacing.lg),
            _PriorityEditor(
              priority: priority,
              enabled: isTracked,
              onChanged: onPriorityChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.description,
    required this.isTracked,
    required this.onTrackedChanged,
  });

  final String title;
  final String? description;
  final bool isTracked;
  final ValueChanged<bool> onTrackedChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AMTextStyles.subtitle),
              if (description != null && description!.trim().isNotEmpty) ...[
                const SizedBox(height: AMSpacing.xs),
                Text(description!, style: AMTextStyles.muted),
              ],
            ],
          ),
        ),
        const SizedBox(width: AMSpacing.sm),
        Column(
          children: [
            Switch(value: isTracked, onChanged: onTrackedChanged),
            Text(isTracked ? 'Tracked' : 'Ignored', style: AMTextStyles.muted),
          ],
        ),
      ],
    );
  }
}

class _TargetLevelEditor extends StatelessWidget {
  const _TargetLevelEditor({
    required this.targetLevel,
    required this.minimumLevel,
    required this.maximumLevel,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int targetLevel;
  final int minimumLevel;
  final int maximumLevel;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TARGET LEVEL', style: AMTextStyles.body),
        const SizedBox(height: AMSpacing.xs),
        Text(
          'Valid range: $minimumLevel–$maximumLevel',
          style: AMTextStyles.muted,
        ),
        const SizedBox(height: AMSpacing.sm),
        Row(
          children: [
            IconButton(
              tooltip: 'Decrease target level',
              onPressed: canDecrease ? onDecrease : null,
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: AMSpacing.md,
                  horizontal: AMSpacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$targetLevel', style: AMTextStyles.subtitle),
              ),
            ),
            IconButton(
              tooltip: 'Increase target level',
              onPressed: canIncrease ? onIncrease : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriorityEditor extends StatelessWidget {
  const _PriorityEditor({
    required this.priority,
    required this.enabled,
    required this.onChanged,
  });

  final ProgressPriority priority;
  final bool enabled;
  final ValueChanged<ProgressPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PRIORITY', style: AMTextStyles.body),
        const SizedBox(height: AMSpacing.sm),
        IgnorePointer(
          ignoring: !enabled,
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Wrap(
              spacing: AMSpacing.sm,
              runSpacing: AMSpacing.sm,
              children: ProgressPriority.values.map((value) {
                return ChoiceChip(
                  selected: priority == value,
                  label: Text(_priorityLabel(value)),
                  avatar: Icon(_priorityIcon(value), size: 18),
                  onSelected: (_) {
                    onChanged(value);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

String _priorityLabel(ProgressPriority priority) {
  final name = priority.name;

  if (name.isEmpty) {
    return 'Priority';
  }

  return '${name[0].toUpperCase()}${name.substring(1)}';
}

IconData _priorityIcon(ProgressPriority priority) {
  switch (priority.name.toLowerCase()) {
    case 'optional':
    case 'low':
      return Icons.low_priority;

    case 'recommended':
    case 'medium':
    case 'important':
      return Icons.thumb_up_alt_outlined;

    case 'required':
    case 'high':
    case 'critical':
      return Icons.priority_high;

    default:
      return Icons.flag_outlined;
  }
}
