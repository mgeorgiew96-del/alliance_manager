import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';

class AdminSectionHeader extends StatelessWidget {
  const AdminSectionHeader({super.key, required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AMTextStyles.title),
        if (description != null && description!.trim().isNotEmpty) ...[
          const SizedBox(height: AMSpacing.xs),
          Text(description!, style: AMTextStyles.muted),
        ],
      ],
    );
  }
}
