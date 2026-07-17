import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_card.dart';
import 'am_progress_bar.dart';

class AMProgressEditorCard extends StatelessWidget {
  const AMProgressEditorCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.maximumValue,
    required this.onIncrease,
    required this.onDecrease,
    this.description,
    this.icon = Icons.auto_awesome,
    this.minimumValue = 0,
    this.isTracked = true,
  });

  final String title;
  final String? description;

  final int currentValue;
  final int minimumValue;
  final int maximumValue;

  final IconData icon;
  final bool isTracked;

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  bool get _canDecrease {
    return currentValue > minimumValue;
  }

  bool get _canIncrease {
    return currentValue < maximumValue;
  }

  bool get _isMaximum {
    return currentValue >= maximumValue;
  }

  double get _progress {
    final range = maximumValue - minimumValue;

    if (range <= 0) {
      return 0;
    }

    return ((currentValue - minimumValue) / range).clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: isTracked ? 1 : 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isMaximum
                        ? Colors.green.withValues(alpha: 0.16)
                        : colorScheme.primary.withValues(alpha: 0.12),
                    border: Border.all(
                      color: _isMaximum ? Colors.green : colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(_isMaximum ? Icons.check : icon, size: 26),
                ),
                const SizedBox(width: AMSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AMTextStyles.title),
                      const SizedBox(height: AMSpacing.xs),
                      Text(
                        isTracked ? 'Tracked for progress' : 'Recorded only',
                        style: AMTextStyles.muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.lg),
            Text(
              'LEVEL',
              style: AMTextStyles.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AMSpacing.xs),
            Text(
              '$currentValue / $maximumValue',
              style: AMTextStyles.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AMSpacing.md),
            AMProgressBar(progress: _progress, height: 12),
            const SizedBox(height: AMSpacing.sm),
            Text(
              'Progress ${(_progress * 100).toStringAsFixed(0)}%',
              style: AMTextStyles.muted,
              textAlign: TextAlign.center,
            ),
            if (description != null && description!.trim().isNotEmpty) ...[
              const SizedBox(height: AMSpacing.lg),
              Text('DESCRIPTION', style: AMTextStyles.muted),
              const SizedBox(height: AMSpacing.xs),
              Text(description!, style: AMTextStyles.body),
            ],
            if (_isMaximum) ...[
              const SizedBox(height: AMSpacing.lg),
              const Text(
                'MAX LEVEL',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AMSpacing.lg),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: 'Decrease level',
                  onPressed: _canDecrease ? onDecrease : null,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: AMSpacing.md),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: AMSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text('$currentValue', style: AMTextStyles.title),
                  ),
                ),
                const SizedBox(width: AMSpacing.md),
                IconButton.filled(
                  tooltip: 'Increase level',
                  onPressed: _canIncrease ? onIncrease : null,
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
