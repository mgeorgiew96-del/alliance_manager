import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../theme/am_typography.dart';
import '../../../theme/am_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AMSpacing.lg),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                const Text(
                  'Alliance Manager',
                  style: AMTypography.title,
                ),

                const SizedBox(height: AMSpacing.md),

                const Text(
                  'Built by Players.\nDesigned for Alliances.',
                  textAlign: TextAlign.center,
                  style: AMTypography.subtitle,
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {context.go('/login');},
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: AMSpacing.md),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Create Alliance'),
                  ),
                ),

                const SizedBox(height: AMSpacing.xl),

                const Text(
                  'Version 0.0.1 Alpha',
                  style: AMTypography.small,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}