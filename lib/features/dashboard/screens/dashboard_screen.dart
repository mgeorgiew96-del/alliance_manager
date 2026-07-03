import 'package:flutter/material.dart';

import '../../../theme/am_colors.dart';
import '../../../theme/am_spacing.dart';
import '../../../theme/am_typography.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AMSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _AllianceBanner(),
              SizedBox(height: AMSpacing.md),
              _DashboardCard(title: 'Daily Brief', content: 'No urgent updates today.'),
              SizedBox(height: AMSpacing.md),
              _DashboardCard(title: 'Alliance Snapshot', content: 'Members: 0\nProgress: 0%\nHealth: Stable'),
              SizedBox(height: AMSpacing.md),
              _DashboardCard(title: 'Upcoming Events', content: 'No events scheduled.'),
              SizedBox(height: AMSpacing.md),
              _DashboardCard(title: 'Quick Actions', content: 'Members • Events • Reports'),
              SizedBox(height: AMSpacing.md),
              _DashboardCard(title: 'Notifications', content: 'No new notifications.'),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllianceBanner extends StatelessWidget {
  const _AllianceBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AMSpacing.lg),
      decoration: BoxDecoration(
        color: AMColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AMColors.goldDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('APX Apex Predators', style: AMTypography.title),
          SizedBox(height: AMSpacing.sm),
          Text('Realm 1360', style: AMTypography.subtitle),
          SizedBox(height: AMSpacing.md),
          Text('Welcome back, aHTu.', style: AMTypography.body),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String content;

  const _DashboardCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AMSpacing.md),
      decoration: BoxDecoration(
        color: AMColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(  color: AMColors.goldDark.withValues(alpha: 0.5),),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AMTypography.subtitle),
          const SizedBox(height: AMSpacing.sm),
          Text(content, style: AMTypography.body),
        ],
      ),
    );
  }
}