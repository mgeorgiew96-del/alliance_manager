import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';

class AMUnsavedChangesBanner extends StatelessWidget {
  const AMUnsavedChangesBanner({
    super.key,
    required this.visible,
    this.message = 'You have unsaved changes.',
  });

  final bool visible;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: !visible
          ? const SizedBox.shrink()
          : Container(
              key: const ValueKey('unsaved_banner'),
              width: double.infinity,
              padding: const EdgeInsets.all(AMSpacing.md),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.orange),
                  const SizedBox(width: AMSpacing.md),
                  Expanded(child: Text(message, style: AMTextStyles.body)),
                ],
              ),
            ),
    );
  }
}
