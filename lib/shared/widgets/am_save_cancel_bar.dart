import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';

class AMSaveCancelBar extends StatelessWidget {
  const AMSaveCancelBar({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.saveEnabled = true,
  });

  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool saveEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.close),
            label: const Text('CANCEL'),
          ),
        ),
        const SizedBox(width: AMSpacing.md),
        Expanded(
          child: FilledButton.icon(
            onPressed: saveEnabled ? onSave : null,
            icon: const Icon(Icons.save),
            label: const Text('SAVE'),
          ),
        ),
      ],
    );
  }
}
