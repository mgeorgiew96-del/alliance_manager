import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_progress_bar.dart';

class AMModuleHeader extends StatelessWidget {
  const AMModuleHeader({
    super.key,
    required this.title,
    required this.progress,
    required this.lastUpdated,
    required this.hasUnsavedChanges,
  });

  final String title;
  final double progress;
  final String lastUpdated;
  final bool hasUnsavedChanges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AMTextStyles.title,
        ),

        const SizedBox(height: AMSpacing.md),

        AMProgressBar(
          progress: progress,
        ),

        const SizedBox(height: AMSpacing.sm),

        Text(
          '${(progress * 100).toStringAsFixed(1)}%',
          style: AMTextStyles.body,
        ),

        const SizedBox(height: AMSpacing.sm),

        Text(
          'Last Updated: $lastUpdated',
          style: AMTextStyles.muted,
        ),

        if (hasUnsavedChanges) ...[
          const SizedBox(height: AMSpacing.sm),
          const Text(
            '● Unsaved changes',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],

        const SizedBox(height: AMSpacing.lg),
      ],
    );
  }
}