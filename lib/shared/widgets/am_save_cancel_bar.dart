import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import 'am_primary_button.dart';

class AMSaveCancelBar extends StatelessWidget {
  const AMSaveCancelBar({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.saveText = 'SAVE',
    this.cancelText = 'CANCEL',
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String saveText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AMPrimaryButton(
            text: saveText,
            icon: Icons.save,
            onPressed: onSave,
          ),
        ),
        const SizedBox(width: AMSpacing.md),
        Expanded(
          child: AMPrimaryButton(
            text: cancelText,
            icon: Icons.close,
            onPressed: onCancel,
          ),
        ),
      ],
    );
  }
}