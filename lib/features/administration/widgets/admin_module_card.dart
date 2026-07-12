import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_primary_button.dart';

class AdminModuleCard extends StatelessWidget {
  const AdminModuleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
    this.isComingSoon = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isComingSoon;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AMTextStyles.subtitle),
                    const SizedBox(height: AMSpacing.xs),
                    Text(description, style: AMTextStyles.body),
                  ],
                ),
              ),
            ],
          ),
          if (isComingSoon) ...[
            const SizedBox(height: AMSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AMSpacing.sm,
                vertical: AMSpacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Text('COMING SOON', style: AMTextStyles.muted),
            ),
          ],
          const SizedBox(height: AMSpacing.lg),
          AMPrimaryButton(
            text: buttonText,
            icon: isComingSoon ? Icons.lock_clock : Icons.arrow_forward,
            onPressed:
                onPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This module is coming soon.'),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
