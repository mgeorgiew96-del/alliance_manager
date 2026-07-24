import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/enums/member_rank.dart';
import '../../../shared/enums/troop_type.dart';
import '../../../shared/permissions/admin_permissions.dart';
import '../../../shared/services/service_locator.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../../artifacts/controllers/artifacts_controller.dart';
import '../../artifacts/services/artifact_progress_service.dart';
import '../../beast/controllers/beast_controller.dart';
import '../../beast/providers/beast_progress_config_provider.dart';
import '../../beast/services/beast_progress_service.dart';
import '../../colossus/controllers/colossus_controller.dart';
import '../../colossus/providers/colossus_progress_config_provider.dart';
import '../../colossus/services/colossus_progress_service.dart';
import '../../equipment/controllers/equipment_controller.dart';
import '../../equipment/providers/equipment_progress_config_provider.dart';
import '../../equipment/services/equipment_progress_service.dart';
import '../../mystic/controllers/mystic_controller.dart';
import '../../mystic/providers/mystic_progress_config_provider.dart';
import '../../mystic/services/mystic_progress_service.dart';

class DashboardScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final member = sessionService.member;

    if (member == null) {
      return AMPage(
        child: AMCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No active session', style: AMTextStyles.title),
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

    final colossusState = ref.watch(colossusControllerProvider);
    final colossusConfig = ref.watch(colossusProgressConfigProvider);
    final colossusProgress = colossusState.when(
      data: (state) {
        return ColossusProgressService.calculate(
          state: state,
          config: colossusConfig,
        );
      },
      loading: () => 0.0,
      error: (error, stackTrace) => 0.0,
    );

    final mysticState = ref.watch(mysticControllerProvider);
    final mysticConfig = ref.watch(mysticProgressConfigProvider);
    final mysticProgress = mysticState.when(
      data: (state) {
        return MysticProgressService.calculateOverallProgress(
          state: state,
          config: mysticConfig,
        );
      },
      loading: () => 0.0,
      error: (error, stackTrace) => 0.0,
    );

    final liveOverallProgress = _averageProgress([
      beastProgress,
      equipmentProgress,
      artifactsProgress,
      colossusProgress,
      mysticProgress,
    ]);

    final canAccessAdministration = isAllianceAdministrator(member.rank);

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AMCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, mighty ${member.playerName}',
                  style: AMTextStyles.title,
                ),
                const SizedBox(height: AMSpacing.sm),
                Text(
                  '${_rankLabel(member.rank)} • APX • '
                  'Realm ${member.realmId}',
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
                  value: '${(liveOverallProgress * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          const _DashboardCard(
            title: 'Alliance Overview',
            content:
                'Members: 1 / 100\n'
                'Pending requests: 0\n'
                'Health: Stable',
          ),
          const SizedBox(height: AMSpacing.md),
          _DashboardCard(
            title: 'Quick Actions',
            content: canAccessAdministration
                ? 'Members • Beast • Equipment • Artifacts • Colossus • '
                      'Mystic • Administration'
                : 'Members • Beast • Equipment • Artifacts • Colossus • '
                      'Mystic',
          ),
          const SizedBox(height: AMSpacing.md),
          const _DashboardCard(
            title: 'Notifications',
            content: 'No new notifications.',
          ),
          
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

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
  const _DashboardCard({required this.title, required this.content});

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

double _averageProgress(List<double> values) {
  if (values.isEmpty) {
    return 0;
  }

  final total = values.fold<double>(0, (sum, value) => sum + value);

  return (total / values.length).clamp(0, 1).toDouble();
}
