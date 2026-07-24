import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_equipment_slot_card.dart';
import '../../../shared/widgets/am_module_overview.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_responsive_grid.dart';
import '../controllers/equipment_controller.dart';
import '../definitions/equipment_slot_definitions.dart';
import '../models/equipment_slot_type.dart';
import '../providers/equipment_progress_config_provider.dart';
import '../services/equipment_progress_service.dart';

class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key, required this.amId});

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentState = ref.watch(equipmentControllerProvider);

    final progressConfig = ref.watch(equipmentProgressConfigProvider);

    final overallProgress = EquipmentProgressService.calculateOverallProgress(
      state: equipmentState,
      config: progressConfig,
    );

    final slotCards = equipmentSlotDefinitions.map((definition) {
      final slotState = equipmentState.slot(definition.type);

      final slotConfig = progressConfig.configForSlot(definition.type);

      final slotProgress = EquipmentProgressService.calculateSlotProgress(
        state: equipmentState,
        config: progressConfig,
        slotType: definition.type,
      );

      final trackedEnhancementCount =
          slotConfig?.enhancementConfigs.values
              .where((item) => item.isTracked)
              .length ??
          0;

      return AMEquipmentSlotCard(
        title: definition.name,
        imagePath: AMAssets.equipment.slot(definition.type),
        progress: slotProgress,
        trackedEnhancementCount: trackedEnhancementCount,
        totalEnhancementCount: definition.enhancements.length,
        jewelType: definition.jewelType,
        jewelLevels: slotState.jewelLevels,
        warningText: _warningTextForSlot(definition.type),
        onOpen: () {
          context.go(
            '/member/$amId/equipment/'
            '${definition.type.name}',
          );
        },
      );
    }).toList();

    return AMModuleOverview(
      title: 'Equipment',
      bannerPath: AMAssets.common.banner('equipment_banner'),
      bannerTagline: '',
      description:
          '',
      fallbackIcon: Icons.shield_outlined,
      onBack: () {
        context.go('/member/$amId');
      },
      progressContent: _EquipmentProgressCard(overallProgress: overallProgress),
      content: AMResponsiveGrid(
        mobileColumns: 1,
        tabletColumns: 2,
        desktopColumns: 2,
        children: slotCards,
      ),
    );
  }
}

class _EquipmentProgressCard extends StatelessWidget {
  const _EquipmentProgressCard({required this.overallProgress});

  final double overallProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  border: Border.all(color: colorScheme.primary),
                ),
                child: const Icon(Icons.workspace_premium_outlined, size: 28),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERALL EQUIPMENT PROGRESS',
                      style: AMTextStyles.subtitle,
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      'Enhancements and jewels only',
                      style: AMTextStyles.muted,
                    ),
                  ],
                ),
              ),
              Text(
                '${(overallProgress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.title,
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.lg),
          AMProgressBar(progress: overallProgress),
          const SizedBox(height: AMSpacing.sm),
          Text(
            'Equipment piece levels are not included. '
            'Progress is calculated from enhancement '
            'and jewel levels.',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

String? _warningTextForSlot(EquipmentSlotType slotType) {
  switch (slotType) {
    case EquipmentSlotType.helmet:
    case EquipmentSlotType.clothes:
      return 'The Angels enhancement is visible '
          'but excluded from progress by default.';

    case EquipmentSlotType.weapon:
    case EquipmentSlotType.belt:
    case EquipmentSlotType.accessory:
    case EquipmentSlotType.boots:
      return null;
  }
}
