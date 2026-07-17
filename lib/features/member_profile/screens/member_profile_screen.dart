import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/mock/mock_member_data.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_castle_module_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../../../shared/widgets/am_responsive_grid.dart';
import '../../artifacts/controllers/artifacts_controller.dart';
import '../../artifacts/services/artifact_progress_service.dart';
import '../../beast/controllers/beast_controller.dart';
import '../../beast/providers/beast_progress_config_provider.dart';
import '../../beast/services/beast_progress_service.dart';
import '../../equipment/controllers/equipment_controller.dart';
import '../../equipment/providers/equipment_progress_config_provider.dart';
import '../../equipment/services/equipment_progress_service.dart';
import '../../../shared/constants/am_assets.dart';

class MemberProfileScreen extends ConsumerWidget {
  const MemberProfileScreen({super.key, required this.amId});

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = mockMembers.firstWhere((member) => member.amId == amId);

    final beastState = ref.watch(beastControllerProvider);

    final beastConfig = ref.watch(beastProgressConfigProvider);

    final beastProgress = beastState.when(
      data: (state) {
        return BeastProgressService.calculateOverallProgress(
          state: state,
          config: beastConfig,
        );
      },
      loading: () => 0.0,
      error: (error, stackTrace) => 0.0,
    );

    final equipmentState = ref.watch(equipmentControllerProvider);

    final equipmentConfig = ref.watch(equipmentProgressConfigProvider);

    final equipmentProgress = EquipmentProgressService.calculateOverallProgress(
      state: equipmentState,
      config: equipmentConfig,
    );

    final artifactsState = ref.watch(artifactsControllerProvider);

    final artifactsProgress = artifactsState.when(
      data: (state) {
        return ArtifactProgressService.overallProgress(state: state);
      },
      loading: () => 0.0,
      error: (error, stackTrace) => 0.0,
    );

    final castleModules = <Widget>[
      AMCastleModuleCard(
        title: 'Beast',
        description: 'Manage Beast level, skills, talents, and skins.',
        icon: Icons.pets,
        imagePath: AMAssets.common.moduleIcon('beast'),
        progress: beastProgress,
        onOpen: () {
          context.go('/member/$amId/beast');
        },
      ),
      AMCastleModuleCard(
        title: 'Equipment',
        description:
            'Weapons, helmets, belts, clothes, accessories, '
            'boots, enhancements, and jewels.',
        icon: Icons.shield,
        imagePath: AMAssets.common.moduleIcon('equipment'),
        progress: equipmentProgress,
        onOpen: () {
          context.go('/member/$amId/equipment');
        },
      ),
      AMCastleModuleCard(
        title: 'Artifacts',
        description:
            'Track selected artifacts, crowns, levels, stars, '
            'and gold rank progression.',
        icon: Icons.workspace_premium,
        imagePath: AMAssets.common.moduleIcon('artifacts'),
        progress: artifactsProgress,
        onOpen: () {
          context.go('/member/$amId/artifacts');
        },
      ),
      AMCastleModuleCard(
        title: 'Colossus',
        description:
            'Track troop-dependent Colossus stats and special '
            'skills.',
        icon: Icons.account_tree,
        imagePath: AMAssets.common.moduleIcon('colossus'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'Mystic',
        description:
            'Track frontline, backline, and Angels Mystic '
            'progress.',
        icon: Icons.auto_awesome,
        imagePath: AMAssets.common.moduleIcon('mystic'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'High Tech',
        description: 'Track the complete High Tech tree and priority nodes.',
        icon: Icons.memory,
        imagePath: AMAssets.common.moduleIcon('high_tech'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'Totem',
        description: 'Track selected Totem level and skill progress.',
        icon: Icons.park,
        imagePath: AMAssets.common.moduleIcon('totem'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'Titan',
        description: 'Track Titan level, tier, phases, steps, and talents.',
        icon: Icons.security,
        imagePath: AMAssets.common.moduleIcon('titan'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'Decorations',
        description:
            'Track Garden, Decoration Sets, Statues, and '
            'Illusions.',
        icon: Icons.castle,
        imagePath: AMAssets.common.moduleIcon('decorations'),
        progress: 0,
        isAvailable: false,
        onOpen: () {},
      ),
      AMCastleModuleCard(
        title: 'Statistics',
        description: 'Review general, event, and troop-specific stats.',
        icon: Icons.bar_chart,
        progress: 0,
        isAvailable: false,
        imagePath: AMAssets.common.moduleIcon('statistics'),
        onOpen: () {},
      ),
    ];

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
                const _ProfileRow(label: 'Alliance', value: 'APX'),
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
                  value: _capitalise(member.frontlineTroop.name),
                ),
                _ProfileRow(
                  label: 'Backline',
                  value: _capitalise(member.backlineTroop.name),
                ),
                _ProfileRow(
                  label: 'Overall Progress',
                  value: '${member.overallProgress.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: AMSpacing.lg),
          Text('MY CASTLE', style: AMTextStyles.title),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Track and manage progress across every castle module.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          AMResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 2,
            children: castleModules,
          ),
          const SizedBox(height: AMSpacing.lg),
          AMPrimaryButton(
            text: 'BACK TO MEMBERS',
            icon: Icons.arrow_back,
            onPressed: () {
              context.go('/members');
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AMTextStyles.subtitle)),
          const SizedBox(width: AMSpacing.md),
          Flexible(
            child: Text(
              value,
              style: AMTextStyles.body,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalise(String value) {
  if (value.isEmpty) {
    return value;
  }

  return '${value[0].toUpperCase()}'
      '${value.substring(1)}';
}
