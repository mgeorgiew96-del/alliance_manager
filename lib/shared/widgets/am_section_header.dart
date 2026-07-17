import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';

class AMSectionHeader extends StatelessWidget {
  const AMSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AMTextStyles.subtitle),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: AMSpacing.xs),
                  Text(subtitle!, style: AMTextStyles.muted),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AMSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
