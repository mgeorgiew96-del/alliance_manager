import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../../../shared/widgets/am_text_field.dart';
import '../../../shared/widgets/am_logo.dart';

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

  void _login() {
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

    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050914),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: AMCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AMLogo(size: 90),
                    const SizedBox(height: 16),
                    const Text(
                      'APX Alliance Manager',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFE8A3),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Login with your AM ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
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
                          style: TextStyle(color: Colors.white70),
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
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}