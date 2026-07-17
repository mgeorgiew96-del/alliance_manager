import 'package:flutter/material.dart';

import '../../theme/am_spacing.dart';
import '../../theme/am_text_styles.dart';

class GameSectionHeader extends StatelessWidget {
  const GameSectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AMTextStyles.title),
          if (subtitle != null) ...[
            const SizedBox(height: AMSpacing.xs),
            Text(subtitle!, style: AMTextStyles.subtitle),
          ],
        ],
      ),
    );
  }
}
