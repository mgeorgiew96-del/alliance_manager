import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: Center(
        child: AMCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64),
              const SizedBox(height: AMSpacing.lg),
              const Text(
                'ACCESS DENIED',
                style: AMTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AMSpacing.md),
              const Text(
                'You do not have permission to access this section.',
                style: AMTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AMSpacing.lg),
              AMPrimaryButton(
                text: 'RETURN TO DASHBOARD',
                icon: Icons.dashboard,
                onPressed: () {
                  context.go('/dashboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
