import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../controllers/mystic_controller.dart';
import '../definitions/mystic_skill_definitions.dart';
import '../models/mystic_state.dart';
import '../models/mystic_troop_type.dart';
import '../providers/mystic_progress_config_provider.dart';
import '../services/mystic_progress_service.dart';
import '../widgets/mystic_activation_card.dart';
import '../widgets/mystic_bottom_actions.dart';
import '../widgets/mystic_progress_card.dart';
import '../widgets/mystic_skill_card.dart';
import '../widgets/mystic_troop_selector.dart';

class MysticScreen extends ConsumerWidget {
  const MysticScreen({super.key, required this.amId});

  final String amId;

  Future<void> _activateTroop({
    required BuildContext context,
    required WidgetRef ref,
    required MysticState mysticState,
    required MysticTroopType troopToActivate,
  }) async {
    final controller = ref.read(mysticControllerProvider.notifier);

    if (controller.activateTroop(troopToActivate)) {
      return;
    }

    final troopToReplace = await showDialog<MysticTroopType>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AMColors.panel,
          title: const Text('Replace Active Troop', style: AMTextStyles.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You can have only two active normal troop types. '
                'Choose which active troop ${troopToActivate.displayName} '
                'should replace.',
                style: AMTextStyles.body,
              ),
              const SizedBox(height: AMSpacing.md),
              for (final activeTroop in mysticState.activeTroops)
                Padding(
                  padding: const EdgeInsets.only(bottom: AMSpacing.sm),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white12),
                    ),
                    leading: const Icon(
                      Icons.swap_horiz_rounded,
                      color: AMColors.gold,
                    ),
                    title: Text(
                      activeTroop.displayName,
                      style: AMTextStyles.body.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: const Text(
                      'Replace this troop',
                      style: AMTextStyles.muted,
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(activeTroop),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );

    if (troopToReplace == null) {
      return;
    }

    controller.replaceActiveTroop(
      troopToRemove: troopToReplace,
      troopToActivate: troopToActivate,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mysticAsync = ref.watch(mysticControllerProvider);
    final progressConfig = ref.watch(mysticProgressConfigProvider);

    return AMPage(
      padding: EdgeInsets.zero,
      child: mysticAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AMSpacing.xl),
          child: Center(child: CircularProgressIndicator(color: AMColors.gold)),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(AMSpacing.lg),
          child: AMCard(
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AMColors.danger,
                  size: 42,
                ),
                const SizedBox(height: AMSpacing.md),
                Text(
                  'Unable to load Mystic.',
                  style: AMTextStyles.title.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AMSpacing.sm),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: AMTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ),
        data: (mysticState) {
          final selectedTroop = mysticState.selectedTroop;
          final selectedSkills = mysticSkillsForTroop(selectedTroop);
          final overallProgress =
              MysticProgressService.calculateOverallProgress(
                state: mysticState,
                config: progressConfig,
              );
          final progressTroops = <MysticTroopType>[
            ...mysticState.activeTroops,
            MysticTroopType.angels,
          ];

          final progressByTroop = <String, double>{
            for (final troopType in progressTroops)
              troopType.displayName:
                  MysticProgressService.calculateTroopProgress(
                    state: mysticState,
                    config: progressConfig,
                    troopType: troopType,
                  ),
          };

          final trackedSkills = progressTroops.fold<int>(
            0,
            (total, troopType) =>
                total +
                MysticProgressService.trackedSkillCount(
                  config: progressConfig,
                  troopType: troopType,
                ),
          );

          final totalSkills = progressTroops.fold<int>(
            0,
            (total, troopType) =>
                total + mysticSkillsForTroop(troopType).length,
          );

          final prioritySkills = progressTroops.fold<int>(
            0,
            (total, troopType) =>
                total +
                MysticProgressService.prioritySkillCount(
                  config: progressConfig,
                  troopType: troopType,
                ),
          );

          double progressForTroop(MysticTroopType troopType) {
            return MysticProgressService.calculateTroopProgress(
              state: mysticState,
              config: progressConfig,
              troopType: troopType,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AMSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AMColors.goldLight,
                      ),
                    ),
                    const SizedBox(width: AMSpacing.xs),
                    Expanded(child: Text('Mystic', style: AMTextStyles.title)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Text(
                    'Strengthen your troop-specific Mystic skills.',
                    style: AMTextStyles.subtitle,
                  ),
                ),
                const SizedBox(height: AMSpacing.md),
                const _MysticBanner(),
                const SizedBox(height: AMSpacing.md),
                MysticProgressCard(
                  overallProgress: overallProgress,
                  troopProgress: progressByTroop,
                  trackedSkills: trackedSkills,
                  totalSkills: totalSkills,
                  prioritySkills: prioritySkills,
                  lastUpdated: mysticState.lastUpdated,
                ),
                const SizedBox(height: AMSpacing.md),
                MysticTroopSelector(
                  selectedTroop: selectedTroop,
                  activeTroops: mysticState.activeTroops,
                  progressForTroop: progressForTroop,
                  onSelected: ref
                      .read(mysticControllerProvider.notifier)
                      .selectTroop,
                ),
                const SizedBox(height: AMSpacing.md),
                MysticActivationCard(
                  troopType: selectedTroop,
                  isActive: mysticState.isActive(selectedTroop),
                  onActivate: () {
                    _activateTroop(
                      context: context,
                      ref: ref,
                      mysticState: mysticState,
                      troopToActivate: selectedTroop,
                    );
                  },
                ),
                const SizedBox(height: AMSpacing.md),
                for (var index = 0; index < selectedSkills.length; index++) ...[
                  MysticSkillCard(
                    definition: selectedSkills[index],
                    level: mysticState.levelFor(selectedSkills[index].id),
                    config: progressConfig.configFor(selectedSkills[index].id),
                    onDecrease: () {
                      ref
                          .read(mysticControllerProvider.notifier)
                          .decreaseSkill(selectedSkills[index].id);
                    },
                    onIncrease: () {
                      ref
                          .read(mysticControllerProvider.notifier)
                          .increaseSkill(selectedSkills[index].id);
                    },
                  ),
                  if (index != selectedSkills.length - 1)
                    const SizedBox(height: AMSpacing.md),
                ],
                const SizedBox(height: AMSpacing.lg),
                MysticBottomActions(
                  hasUnsavedChanges: mysticState.hasUnsavedChanges,
                  isSaving: mysticAsync.isLoading,
                  onCancel: ref.read(mysticControllerProvider.notifier).cancel,
                  onSave: () async {
                    await ref.read(mysticControllerProvider.notifier).save();

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mystic progress saved.')),
                    );
                  },
                ),
                const SizedBox(height: AMSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MysticBanner extends StatelessWidget {
  const _MysticBanner();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          AMAssets.mystic.banner(),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return Container(
              color: AMColors.panel,
              alignment: Alignment.center,
              child: const Icon(
                Icons.auto_awesome,
                color: AMColors.gold,
                size: 58,
              ),
            );
          },
        ),
      ),
    );
  }
}
