import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_primary_button.dart';

class MysticBottomActions extends StatelessWidget {
  const MysticBottomActions({
    super.key,
    required this.hasUnsavedChanges,
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
  });

  final bool hasUnsavedChanges;
  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: hasUnsavedChanges && !isSaving ? onCancel : null,
            icon: const Icon(Icons.undo_rounded),
            label: const Text('Cancel changes'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AMColors.textSecondary,
              disabledForegroundColor: AMColors.textMuted,
              side: BorderSide(
                color: hasUnsavedChanges
                    ? AMColors.textSecondary
                    : Colors.white12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: AMTextStyles.button,
            ),
          ),
        ),
        const SizedBox(height: AMSpacing.sm),
        AMPrimaryButton(
          text: isSaving ? 'Saving...' : 'Save Mystic',
          icon: isSaving ? Icons.hourglass_top_rounded : Icons.save_rounded,
          onPressed: hasUnsavedChanges && !isSaving ? onSave : () {},
        ),
      ],
    );
  }
}
