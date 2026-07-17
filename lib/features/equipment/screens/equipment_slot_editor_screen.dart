import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/am_section_header.dart';
import '../../../shared/widgets/am_unsaved_changes_banner.dart';
import '../controllers/equipment_controller.dart';
import '../definitions/equipment_slot_definitions.dart';
import '../models/equipment_slot_type.dart';
import '../widgets/equipment_level_editor.dart';

class EquipmentSlotEditorScreen extends ConsumerWidget {
  const EquipmentSlotEditorScreen({
    super.key,
    required this.amId,
    required this.slotType,
  });

  final String amId;
  final EquipmentSlotType slotType;

  String get _equipmentRoute {
    return '/member/$amId/equipment';
  }

  Future<void> _saveChanges({
    required BuildContext context,
    required EquipmentController controller,
    required bool showMessage,
  }) async {
    await controller.save();

    if (!context.mounted || !showMessage) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Equipment changes saved.')));
  }

  void _cancelChanges({
    required BuildContext context,
    required EquipmentController controller,
    required bool showMessage,
  }) {
    controller.cancel();

    if (!context.mounted || !showMessage) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unsaved Equipment changes cancelled.')),
    );
  }

  Future<_UnsavedChangesAction?> _showUnsavedChangesDialog(
    BuildContext context,
  ) {
    return showDialog<_UnsavedChangesAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Unsaved changes'),
          content: const Text(
            'You have unsaved Equipment changes. '
            'Save them before leaving?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(_UnsavedChangesAction.stay);
              },
              child: const Text('STAY'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(_UnsavedChangesAction.discard);
              },
              child: const Text('DISCARD'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(_UnsavedChangesAction.save);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleBack({
    required BuildContext context,
    required EquipmentController controller,
    required bool hasUnsavedChanges,
  }) async {
    if (!hasUnsavedChanges) {
      context.go(_equipmentRoute);
      return;
    }

    final action = await _showUnsavedChangesDialog(context);

    if (!context.mounted ||
        action == null ||
        action == _UnsavedChangesAction.stay) {
      return;
    }

    if (action == _UnsavedChangesAction.save) {
      await _saveChanges(
        context: context,
        controller: controller,
        showMessage: false,
      );

      if (context.mounted) {
        context.go(_equipmentRoute);
      }

      return;
    }

    _cancelChanges(
      context: context,
      controller: controller,
      showMessage: false,
    );

    if (context.mounted) {
      context.go(_equipmentRoute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(equipmentControllerProvider.notifier);

    final state = ref.watch(equipmentControllerProvider);

    final slotDefinition = equipmentDefinitionFor(slotType);

    final slotState = state.slot(slotType);

    return PopScope(
      canPop: !state.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        await _handleBack(
          context: context,
          controller: controller,
          hasUnsavedChanges: state.hasUnsavedChanges,
        );
      },
      child: AMPage(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back to Equipment',
                    onPressed: () {
                      _handleBack(
                        context: context,
                        controller: controller,
                        hasUnsavedChanges: state.hasUnsavedChanges,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: AMSpacing.sm),
                  Expanded(
                    child: Text(
                      slotDefinition.name.toUpperCase(),
                      style: AMTextStyles.title,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.md),
              _EquipmentSlotHero(
                slotType: slotType,
                slotName: slotDefinition.name,
                enhancementCount: slotDefinition.enhancements.length,
                jewelCount: slotState.jewelLevels.length,
                jewelName: _jewelName(slotDefinition.jewelType.name),
              ),
              const SizedBox(height: AMSpacing.md),
              AMUnsavedChangesBanner(
                visible: state.hasUnsavedChanges,
                message:
                    '${slotDefinition.name} '
                    'has unsaved changes.',
              ),
              if (state.hasUnsavedChanges) const SizedBox(height: AMSpacing.lg),
              const AMSectionHeader(
                title: 'Enhancements',
                subtitle:
                    'Enhancement levels contribute '
                    'to Equipment progress.',
              ),
              const SizedBox(height: AMSpacing.md),
              for (final definition in slotDefinition.enhancements) ...[
                Builder(
                  builder: (context) {
                    final enhancement = slotState.enhancements.firstWhere((
                      item,
                    ) {
                      return item.id == definition.id;
                    });

                    return EquipmentLevelEditor(
                      title: definition.name,
                      level: enhancement.level,
                      minimumLevel: 0,
                      maximumLevel: definition.maxLevel,
                      isTracked: definition.isTrackedByDefault,
                      onLevelChanged: (value) {
                        controller.setEnhancementLevel(
                          slotType,
                          definition.id,
                          value,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AMSpacing.md),
              ],
              const SizedBox(height: AMSpacing.md),
              AMSectionHeader(
                title: 'Jewels',
                subtitle:
                    'These jewels belong to the '
                    'complete ${slotDefinition.name} '
                    'slot.',
              ),
              const SizedBox(height: AMSpacing.md),
              for (
                var index = 0;
                index < slotState.jewelLevels.length;
                index++
              ) ...[
                EquipmentLevelEditor(
                  title:
                      '${_jewelName(slotDefinition.jewelType.name)} '
                      '${index + 1}',
                  level: slotState.jewelLevels[index],
                  minimumLevel: 0,
                  maximumLevel: 30,
                  onLevelChanged: (value) {
                    controller.setJewelLevel(slotType, index, value);
                  },
                ),
                const SizedBox(height: AMSpacing.md),
              ],
              const SizedBox(height: AMSpacing.md),
              AMSaveCancelBar(
                saveEnabled: state.hasUnsavedChanges,
                onSave: () {
                  _saveChanges(
                    context: context,
                    controller: controller,
                    showMessage: true,
                  );
                },
                onCancel: state.hasUnsavedChanges
                    ? () {
                        _cancelChanges(
                          context: context,
                          controller: controller,
                          showMessage: true,
                        );
                      }
                    : null,
              ),
              const SizedBox(height: AMSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _EquipmentSlotHero extends StatelessWidget {
  const _EquipmentSlotHero({
    required this.slotType,
    required this.slotName,
    required this.enhancementCount,
    required this.jewelCount,
    required this.jewelName,
  });

  final EquipmentSlotType slotType;
  final String slotName;

  final int enhancementCount;
  final int jewelCount;

  final String jewelName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.primary, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.16),
                  blurRadius: 18,
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: AMAssetImage(
                path: AMAssets.equipment.slot(slotType),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(17),
                fallbackIcon: Icons.inventory_2_outlined,
                fallbackIconSize: 82,
              ),
            ),
          ),
          const SizedBox(height: AMSpacing.lg),
          Text(
            slotName.toUpperCase(),
            style: AMTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AMSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AMSpacing.md,
            runSpacing: AMSpacing.sm,
            children: [
              _HeroDetail(
                icon: Icons.tune,
                text: '$enhancementCount enhancements',
              ),
              _HeroDetail(
                icon: Icons.diamond_outlined,
                text: '$jewelCount $jewelName jewels',
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            'Equipment piece level is not tracked. '
            'Only enhancements and jewels contribute '
            'to progress.',
            style: AMTextStyles.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HeroDetail extends StatelessWidget {
  const _HeroDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AMSpacing.md,
        vertical: AMSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AMSpacing.xs),
          Text(text, style: AMTextStyles.body),
        ],
      ),
    );
  }
}

enum _UnsavedChangesAction { save, discard, stay }

String _jewelName(String value) {
  if (value.isEmpty) {
    return value;
  }

  return '${value[0].toUpperCase()}'
      '${value.substring(1)}';
}
