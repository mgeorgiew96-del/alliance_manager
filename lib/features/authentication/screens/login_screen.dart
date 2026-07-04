import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/service_locator.dart';
import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_logo.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../../../shared/widgets/am_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _amIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _amIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final amId = _amIdController.text.trim();
    final password = _passwordController.text.trim();

    if (amId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter AM ID and password.')),
      );
      return;
    }

    final result = await authService.login(
      amId: amId,
      password: password,
    );

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid AM ID or password.')),
      );
      return;
    }

    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: AMCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AMLogo(size: 90),
            const SizedBox(height: 16),
            const Text(
              'APX Alliance Manager',
              textAlign: TextAlign.center,
              style: AMTextStyles.title,
            ),
            const SizedBox(height: 8),
            const Text(
              'Login with your AM ID',
              textAlign: TextAlign.center,
              style: AMTextStyles.subtitle,
            ),
            const SizedBox(height: 32),
            AMTextField(
              controller: _amIdController,
              label: 'AM ID',
              hint: 'AM-1360-001',
              icon: Icons.badge,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            AMTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: AMColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AMPrimaryButton(
              text: 'LOGIN',
              icon: Icons.login,
              onPressed: _login,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/create-account'),
              child: const Text('Create account request'),
            ),
            const SizedBox(height: 8),
            const Text(
              'No email required for members',
              style: AMTextStyles.muted,
            ),
          ],
        ),
      ),
    );
  }
}