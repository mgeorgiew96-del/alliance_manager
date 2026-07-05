import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/enums/member_rank.dart';
import '../../../shared/enums/troop_type.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _rankLabel(MemberRank rank) {
    switch (rank) {
      case MemberRank.r5:
        return 'R5';
      case MemberRank.r4:
        return 'R4';
      case MemberRank.r3:
        return 'R3';
      case MemberRank.r2:
        return 'R2';
      case MemberRank.r1:
        return 'R1';
    }
  }

  String _troopLabel(TroopType troop) {
    switch (troop) {
      case TroopType.infantry:
        return 'Infantry';
      case TroopType.cavalry:
        return 'Cavalry';
      case TroopType.archer:
        return 'Archer';
      case TroopType.mage:
        return 'Mage';
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = sessionService.member;

    if (member == null) {
      return AMPage(
        child: AMCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No active session',
                style: AMTextStyles.title,
              ),
              const SizedBox(height: AMSpacing.md),
              AMPrimaryButton(
                text: 'BACK TO LOGIN',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        ),
      );
    }

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AMCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${member.playerName}',
                  style: AMTextStyles.title,
                ),
                const SizedBox(height: AMSpacing.sm),
                Text(
                  '${_rankLabel(member.rank)} • APX • Realm ${member.realmId}',
                  style: AMTextStyles.subtitle,
                ),
                const SizedBox(height: AMSpacing.lg),
                _InfoRow(label: 'AM ID', value: member.amId),
                _InfoRow(
                  label: 'Castle Level',
                  value: member.castleLevel.toString(),
                ),
                _InfoRow(
                  label: 'Frontline',
                  value: _troopLabel(member.frontlineTroop),
                ),
                _InfoRow(
                  label: 'Backline',
                  value: _troopLabel(member.backlineTroop),
                ),
                _InfoRow(
                  label: 'Overall Progress',
                  value: '${member.overallProgress.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          const _DashboardCard(
            title: 'Alliance Snapshot',
            content: 'Members: 1 / 100\nPending requests: 0\nHealth: Stable',
          ),
          const SizedBox(height: AMSpacing.md),
          const _DashboardCard(
            title: 'Quick Actions',
            content: 'Members • Beast • Equipment • Titan • Statistics',
          ),
          const SizedBox(height: AMSpacing.md),
          const _DashboardCard(
            title: 'Notifications',
            content: 'No new notifications.',
          ),
          const SizedBox(height: AMSpacing.lg),
          AMPrimaryButton(
            text: 'MEMBERS',
            icon: Icons.people,
            onPressed: () => context.go('/members'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AMTextStyles.subtitle),
          Text(value, style: AMTextStyles.body),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.sm),
          Text(content, style: AMTextStyles.body),
        ],
      ),
    );
  }
}