import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_card.dart';

class AMModuleTile extends StatelessWidget {
  const AMModuleTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AMCard(
        child: SizedBox(
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36),
              const SizedBox(height: AMSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AMTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}