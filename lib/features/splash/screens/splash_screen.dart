import 'package:flutter/material.dart';

import '../../../theme/am_typography.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Alliance Manager',
          style: AMTypography.title,
        ),
      ),
    );
  }
}