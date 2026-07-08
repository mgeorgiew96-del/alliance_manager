import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/mock/mock_member_data.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_tile.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  @override
  Widget build(BuildContext context) {
    final member = mockMembers.firstWhere(
      (member) => member.amId == amId,
    );

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AMCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.playerName, style: AMTextStyles.title),
                const SizedBox(height: AMSpacing.sm),
                Text(member.amId, style: AMTextStyles.subtitle),
                const SizedBox(height: AMSpacing.lg),
                _ProfileRow(label: 'Realm', value: member.realmId),
                _ProfileRow(label: 'Alliance', value: 'APX'),
                _ProfileRow(
                  label: 'Rank',
                  value: member.rank.name.toUpperCase(),
                ),
                _ProfileRow(
                  label: 'Castle Level',
                  value: member.castleLevel.toString(),
                ),
                _ProfileRow(
                  label: 'Frontline',
                  value: member.frontlineTroop.name,
                ),
                _ProfileRow(
                  label: 'Backline',
                  value: member.backlineTroop.name,
                ),
                _ProfileRow(
                  label: 'Progress',
                  value: '${member.overallProgress.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),

          const SizedBox(height: AMSpacing.lg),

          const Text('Modules', style: AMTextStyles.title),

          const SizedBox(height: AMSpacing.md),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AMSpacing.md,
            mainAxisSpacing: AMSpacing.md,
            childAspectRatio: 1.05,
            children: [
              AMModuleTile(
                title: 'Beast',
                icon: Icons.pets,
                onTap: () => context.go('/member/$amId/beast'),
              ),
              AMModuleTile(
                title: 'Equipment',
                icon: Icons.shield,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Artifacts',
                icon: Icons.workspace_premium,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Colossus',
                icon: Icons.account_tree,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Mystic',
                icon: Icons.auto_awesome,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'High Tech',
                icon: Icons.memory,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Titan',
                icon: Icons.security,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Totem',
                icon: Icons.park,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Decorations',
                icon: Icons.castle,
                onTap: () {},
              ),
              AMModuleTile(
                title: 'Statistics',
                icon: Icons.bar_chart,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: AMSpacing.lg),

          AMPrimaryButton(
            text: 'BACK TO MEMBERS',
            icon: Icons.arrow_back,
            onPressed: () => context.go('/members'),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
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