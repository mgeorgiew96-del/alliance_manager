import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/am_spacing.dart';
import '../../../theme/am_typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AMSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/logo/alliance_manager_logo.webp',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.shield,
                        size: 110,
                        color: Colors.amber,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('SIGN IN'),
                ),
              ),
              const SizedBox(height: AMSpacing.xl),
              const Text(
                'Version 1.0.0',
                style: AMTypography.small,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AMSpacing.xs),
              const Text(
                'APX Edition (Alpha)',
                style: AMTypography.small,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
