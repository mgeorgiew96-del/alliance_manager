import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/service_locator.dart';
import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
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
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _amIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoggingIn) return;

    final amId = _amIdController.text.trim();
    final password = _passwordController.text.trim();

    if (amId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter AM ID and password.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final result = await authService.login(
        amId: amId,
        password: password,
      );

      if (!mounted) return;

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid AM ID or password.'),
          ),
        );
        return;
      }

      context.go('/dashboard');
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong while logging in. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            child: AMCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo/alliance_manager_logo.webp',
                      width: 260,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          width: 260,
                          height: 260,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.shield,
                            size: 90,
                            color: Colors.amber,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ALLIANCE MANAGER',
                    textAlign: TextAlign.center,
                    style: AMTextStyles.title,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Built by players, designed for alliances.',
                    textAlign: TextAlign.center,
                    style: AMTextStyles.subtitle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login with your AM ID',
                    textAlign: TextAlign.center,
                    style: AMTextStyles.muted,
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
                        onChanged: _isLoggingIn
                            ? null
                            : (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: AMColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AMPrimaryButton(
                    text: _isLoggingIn
                        ? 'LOGGING IN...'
                        : 'LOGIN',
                    icon: _isLoggingIn
                        ? Icons.hourglass_top
                        : Icons.login,
                    onPressed: () {
                      if (_isLoggingIn) return;
                      _login();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isLoggingIn
                        ? null
                        : () {
                            context.go('/create-account');
                          },
                    child: const Text(
                      'Create account request',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No email required for members',
                    style: AMTextStyles.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}