import 'package:flutter/material.dart';

import '../../theme/am_colors.dart';
import '../../theme/am_spacing.dart';
import '../../theme/am_text_styles.dart';

class GameProgressBar extends StatelessWidget {
  const GameProgressBar({
    super.key,
    required this.label,
    required this.progress,
  });

  final String label;

  /// Progress from 0 to 100.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0, 100);
    final progressValue = clampedProgress / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AMTextStyles.subtitle),
            Text(
              '${clampedProgress.toStringAsFixed(1)}%',
              style: AMTextStyles.body,
            ),
          ],
        ),
        const SizedBox(height: AMSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 12,
            backgroundColor: AMColors.panelLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AMColors.gold),
          ),
        ),
      ],
    );
  }
}
