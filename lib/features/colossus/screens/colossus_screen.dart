import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_overview.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/colossus_controller.dart';
import '../definitions/colossus_definitions.dart';
import '../models/colossus_data.dart';
import '../models/colossus_progress_config.dart';
import '../models/colossus_state.dart';
import '../models/colossus_stat_definition.dart';
import '../models/colossus_type.dart';
import '../providers/colossus_progress_config_provider.dart';
import '../services/colossus_progress_service.dart';

class ColossusScreen extends ConsumerStatefulWidget {
  const ColossusScreen({super.key, required this.amId});

  final String amId;

  @override
  ConsumerState<ColossusScreen> createState() {
    return _ColossusScreenState();
  }
}

class _ColossusScreenState extends ConsumerState<ColossusScreen> {
  ColossusType _selectedType = ColossusType.infantry;

  @override
  Widget build(BuildContext context) {
    final colossusState = ref.watch(colossusControllerProvider);

    return colossusState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text(
            'Failed to load Colossus data.',
            style: AMTextStyles.body,
          ),
        ),
      ),
      data: (state) {
        final config = ref.watch(colossusProgressConfigProvider);

        return _buildContent(context: context, state: state, config: config);
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required ColossusState state,
    required ColossusProgressConfig config,
  }) {
    final controller = ref.read(colossusControllerProvider.notifier);

    final selectedData = state.dataFor(_selectedType);

    final overallProgress = ColossusProgressService.calculate(
      state: state,
      config: config,
    );

    return AMModuleOverview(
      title: 'Colossus',
      bannerPath: AMAssets.common.banner('colossus_banner'),
      bannerTagline: '',
      description:
          '',
      fallbackIcon: Icons.account_balance,
      onBack: () {
        context.go('/member/${widget.amId}');
      },
      progressContent: _OverallProgressCard(
        progress: overallProgress,
        totalActiveLevel: state.totalActiveLevel,
        maximumActiveLevel: state.maximumActiveLevel,
        activeTypes: state.activeTypes,
      ),
      unsavedChangesContent: state.hasUnsavedChanges
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '● Unsaved Colossus changes',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AMSpacing.md),
                AMSaveCancelBar(
                  onSave: controller.save,
                  onCancel: controller.cancel,
                ),
              ],
            )
          : null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ColossusSelector(
            selectedType: _selectedType,
            activeTypes: state.activeTypes,
            onSelected: (type) {
              setState(() {
                _selectedType = type;
              });
            },
          ),
          const SizedBox(height: AMSpacing.md),
          _SelectedColossusCard(
            type: _selectedType,
            data: selectedData,
            isActive: state.isActive(_selectedType),
            onActivate: () {
              _activateSelectedColossus(
                context: context,
                state: state,
                controller: controller,
              );
            },
          ),
          const SizedBox(height: AMSpacing.md),
          _StatsSection(
            type: _selectedType,
            data: selectedData,
            config: config,
            onIncrease: (statId) {
              controller.increaseStat(type: _selectedType, statId: statId);
            },
            onDecrease: (statId) {
              controller.decreaseStat(type: _selectedType, statId: statId);
            },
          ),
          const SizedBox(height: AMSpacing.md),
          _SpecialSkillsSection(type: _selectedType, data: selectedData),
          const SizedBox(height: AMSpacing.md),
          Center(
            child: Text(
              'Last Updated: ${_formatLastUpdated(state.lastUpdated)}',
              style: AMTextStyles.muted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _activateSelectedColossus({
    required BuildContext context,
    required ColossusState state,
    required ColossusController controller,
  }) async {
    if (state.isActive(_selectedType)) {
      return;
    }

    final typeToReplace = await showDialog<ColossusType>(
      context: context,
      builder: (dialogContext) {
        return _ReplaceActiveColossusDialog(
          newType: _selectedType,
          activeTypes: state.activeTypes,
        );
      },
    );

    if (typeToReplace == null) {
      return;
    }

    controller.replaceActiveColossus(remove: typeToReplace, add: _selectedType);
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard({
    required this.progress,
    required this.totalActiveLevel,
    required this.maximumActiveLevel,
    required this.activeTypes,
  });

  final double progress;
  final int totalActiveLevel;
  final int maximumActiveLevel;
  final Set<ColossusType> activeTypes;

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
                  border: Border.all(color: colorScheme.primary),
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.account_balance, size: 28),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERALL COLOSSUS PROGRESS',
                      style: AMTextStyles.subtitle,
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      'Only tracked stats from the two active '
                      'Colossus contribute.',
                      style: AMTextStyles.muted,
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.title,
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.lg),
          AMProgressBar(progress: progress),
          const SizedBox(height: AMSpacing.lg),
          _SummaryRow(
            label: 'Active Colossus',
            value:
                '${activeTypes.length} / '
                '${ColossusDefinitions.activeColossusLimit}',
          ),
          const SizedBox(height: AMSpacing.sm),
          _SummaryRow(
            label: 'Total Active Level',
            value: '$totalActiveLevel / $maximumActiveLevel',
          ),
          const SizedBox(height: AMSpacing.sm),
          _SummaryRow(
            label: 'Active Pair',
            value: activeTypes.map((type) => type.displayName).join(' + '),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AMTextStyles.body)),
        Text(value, style: AMTextStyles.muted),
      ],
    );
  }
}

class _ColossusSelector extends StatelessWidget {
  const _ColossusSelector({
    required this.selectedType,
    required this.activeTypes,
    required this.onSelected,
  });

  final ColossusType selectedType;
  final Set<ColossusType> activeTypes;
  final ValueChanged<ColossusType> onSelected;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Wrap(
        spacing: AMSpacing.sm,
        runSpacing: AMSpacing.sm,
        children: ColossusType.values.map((type) {
          final isActive = activeTypes.contains(type);

          return ChoiceChip(
            selected: selectedType == type,
            onSelected: (_) {
              onSelected(type);
            },
            avatar: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: AMAssetImage(
                    path: AMAssets.colossus.artwork(type),
                    size: 32,
                    fit: BoxFit.cover,
                    fallbackIcon: _fallbackIconFor(type),
                    fallbackIconSize: 18,
                  ),
                ),
                if (isActive)
                  Positioned(
                    right: -3,
                    top: -3,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            label: Text(type.displayName),
          );
        }).toList(),
      ),
    );
  }
}

class _SelectedColossusCard extends StatelessWidget {
  const _SelectedColossusCard({
    required this.type,
    required this.data,
    required this.isActive,
    required this.onActivate,
  });

  final ColossusType type;
  final ColossusData data;
  final bool isActive;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useHorizontalLayout = constraints.maxWidth >= 760;

          final artwork = _ColossusArtwork(type: type, isActive: isActive);

          final details = _ColossusDetails(
            type: type,
            data: data,
            isActive: isActive,
            onActivate: onActivate,
          );

          if (useHorizontalLayout) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: artwork),
                const SizedBox(width: AMSpacing.lg),
                Expanded(child: details),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              artwork,
              const SizedBox(height: AMSpacing.lg),
              details,
            ],
          );
        },
      ),
    );
  }
}

class _ColossusArtwork extends StatelessWidget {
  const _ColossusArtwork({required this.type, required this.isActive});

  final ColossusType type;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: AspectRatio(
              aspectRatio: 1,
              child: AMAssetImage(
                path: AMAssets.colossus.artwork(type),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(16),
                fallbackIcon: _fallbackIconFor(type),
                fallbackIconSize: 80,
              ),
            ),
          ),
        ),
        if (isActive)
          Positioned(
            top: AMSpacing.sm,
            right: AMSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AMSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.lightGreenAccent),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ColossusDetails extends StatelessWidget {
  const _ColossusDetails({
    required this.type,
    required this.data,
    required this.isActive,
    required this.onActivate,
  });

  final ColossusType type;
  final ColossusData data;
  final bool isActive;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final levelProgress =
        data.totalLevel / ColossusDefinitions.maximumColossusLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type.displayName.toUpperCase(), style: AMTextStyles.title),
        const SizedBox(height: AMSpacing.xs),
        Text(_descriptionFor(type), style: AMTextStyles.body),
        const SizedBox(height: AMSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text('Colossus Level', style: AMTextStyles.subtitle),
            ),
            Text(
              '${data.totalLevel} / '
              '${ColossusDefinitions.maximumColossusLevel}',
              style: AMTextStyles.title,
            ),
          ],
        ),
        const SizedBox(height: AMSpacing.sm),
        AMProgressBar(progress: levelProgress),
        const SizedBox(height: AMSpacing.md),
        Text(
          '${data.unlockedSpecialSkillCount} / '
          '${ColossusDefinitions.specialSkillUnlockLevels.length} '
          'special skills unlocked',
          style: AMTextStyles.muted,
        ),
        const SizedBox(height: AMSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: isActive
              ? OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ACTIVE COLOSSUS'),
                )
              : FilledButton.icon(
                  onPressed: onActivate,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('ACTIVATE COLOSSUS'),
                ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.type,
    required this.data,
    required this.config,
    required this.onIncrease,
    required this.onDecrease,
  });

  final ColossusType type;
  final ColossusData data;
  final ColossusProgressConfig config;
  final ValueChanged<String> onIncrease;
  final ValueChanged<String> onDecrease;

  @override
  Widget build(BuildContext context) {
    final definitions = ColossusDefinitions.statsFor(type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UPGRADE STATS', style: AMTextStyles.subtitle),
        const SizedBox(height: AMSpacing.xs),
        Text(
          'Each stat has a maximum level of '
          '${ColossusDefinitions.maximumStatLevel}.',
          style: AMTextStyles.muted,
        ),
        const SizedBox(height: AMSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1050
                ? 3
                : constraints.maxWidth >= 620
                ? 2
                : 1;

            const spacing = AMSpacing.md;

            final cardWidth = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: definitions.map((definition) {
                final statConfig = config.configFor(
                  type: type,
                  statId: definition.id,
                );

                return SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    definition: definition,
                    level: data.statLevel(definition.id),
                    targetLevel: statConfig.targetLevel,
                    isTracked: statConfig.isTracked,
                    onIncrease: () {
                      onIncrease(definition.id);
                    },
                    onDecrease: () {
                      onDecrease(definition.id);
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.definition,
    required this.level,
    required this.targetLevel,
    required this.isTracked,
    required this.onIncrease,
    required this.onDecrease,
  });

  final ColossusStatDefinition definition;
  final int level;
  final int targetLevel;
  final bool isTracked;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final maximumLevel = definition.maximumLevel;
    final progress = level / maximumLevel;

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: AMAssetImage(
                  path: AMAssets.colossus.skill(definition.iconId),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(10),
                  fallbackIcon: Icons.auto_awesome,
                  fallbackIconSize: 26,
                ),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(definition.name, style: AMTextStyles.subtitle),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      isTracked
                          ? 'Tracked • Target Lv. $targetLevel'
                          : 'Not tracked',
                      style: AMTextStyles.muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Level $level / $maximumLevel',
                  style: AMTextStyles.body,
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Decrease level',
                onPressed: level > 0 ? onDecrease : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: AMSpacing.sm),
              IconButton.filled(
                tooltip: 'Increase level',
                onPressed: level < maximumLevel ? onIncrease : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.sm),
          AMProgressBar(progress: progress),
        ],
      ),
    );
  }
}

class _SpecialSkillsSection extends StatelessWidget {
  const _SpecialSkillsSection({required this.type, required this.data});

  final ColossusType type;
  final ColossusData data;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SPECIAL SKILLS', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Special skills unlock automatically at Colossus '
            'levels 50, 70, 90, 110, and 130.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth >= 760
                  ? (constraints.maxWidth - (AMSpacing.md * 4)) / 5
                  : constraints.maxWidth >= 420
                  ? (constraints.maxWidth - AMSpacing.md) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: AMSpacing.md,
                runSpacing: AMSpacing.md,
                children: List.generate(
                  ColossusDefinitions.specialSkillUnlockLevels.length,
                  (index) {
                    final skillNumber = index + 1;
                    final unlockLevel =
                        ColossusDefinitions.specialSkillUnlockLevels[index];
                    final isUnlocked = data.isSpecialSkillUnlocked(index);

                    return SizedBox(
                      width: itemWidth,
                      child: _SpecialSkillCard(
                        imagePath: AMAssets.colossus.specialSkill(
                          colossusType: type,
                          skillNumber: skillNumber,
                        ),
                        skillNumber: skillNumber,
                        unlockLevel: unlockLevel,
                        isUnlocked: isUnlocked,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SpecialSkillCard extends StatelessWidget {
  const _SpecialSkillCard({
    required this.imagePath,
    required this.skillNumber,
    required this.unlockLevel,
    required this.isUnlocked,
  });

  final String imagePath;
  final int skillNumber;
  final int unlockLevel;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final borderColor = isUnlocked
        ? Colors.amber
        : Theme.of(context).colorScheme.outline;

    return Container(
      padding: const EdgeInsets.all(AMSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isUnlocked ? 2 : 1),
        color: isUnlocked
            ? Colors.amber.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isUnlocked ? 1 : 0.38,
                child: AMAssetImage(
                  path: imagePath,
                  width: 82,
                  height: 82,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(14),
                  fallbackIcon: Icons.auto_awesome,
                  fallbackIconSize: 38,
                ),
              ),
              if (!isUnlocked) const Icon(Icons.lock, size: 34),
            ],
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            'Special Skill $skillNumber',
            style: AMTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            isUnlocked
                ? 'Unlocked at Lv. $unlockLevel'
                : 'Unlocks at Lv. $unlockLevel',
            style: AMTextStyles.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReplaceActiveColossusDialog extends StatefulWidget {
  const _ReplaceActiveColossusDialog({
    required this.newType,
    required this.activeTypes,
  });

  final ColossusType newType;
  final Set<ColossusType> activeTypes;

  @override
  State<_ReplaceActiveColossusDialog> createState() {
    return _ReplaceActiveColossusDialogState();
  }
}

class _ReplaceActiveColossusDialogState
    extends State<_ReplaceActiveColossusDialog> {
  late ColossusType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.activeTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Activate ${widget.newType.displayName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Two Colossus are already active. Choose one to replace.'),
          const SizedBox(height: AMSpacing.md),
          RadioGroup<ColossusType>(
            groupValue: _selectedType,
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _selectedType = value;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.activeTypes.map((type) {
                return RadioListTile<ColossusType>(
                  value: type,
                  title: Text(type.displayName),
                  secondary: ClipOval(
                    child: AMAssetImage(
                      path: AMAssets.colossus.artwork(type),
                      size: 38,
                      fit: BoxFit.cover,
                      fallbackIcon: _fallbackIconFor(type),
                      fallbackIconSize: 20,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop(_selectedType);
          },
          icon: const Icon(Icons.swap_horiz),
          label: const Text('REPLACE'),
        ),
      ],
    );
  }
}

String _formatLastUpdated(DateTime? lastUpdated) {
  if (lastUpdated == null) {
    return 'Not saved yet';
  }

  return '${lastUpdated.day.toString().padLeft(2, '0')}.'
      '${lastUpdated.month.toString().padLeft(2, '0')}.'
      '${lastUpdated.year} '
      '${lastUpdated.hour.toString().padLeft(2, '0')}:'
      '${lastUpdated.minute.toString().padLeft(2, '0')}';
}

String _descriptionFor(ColossusType type) {
  switch (type) {
    case ColossusType.infantry:
      return 'A defensive guardian focused on Infantry strength '
          'and reducing incoming troop damage.';
    case ColossusType.cavalry:
      return 'A relentless mounted giant focused on Cavalry '
          'strength and battlefield resilience.';
    case ColossusType.archer:
      return 'A precision war machine focused on Archer strength '
          'and increased damage against enemy troops.';
    case ColossusType.mage:
      return 'An arcane construct focused on Mage strength and '
          'devastating troop-specific damage.';
  }
}

IconData _fallbackIconFor(ColossusType type) {
  switch (type) {
    case ColossusType.infantry:
      return Icons.shield;
    case ColossusType.cavalry:
      return Icons.directions_run;
    case ColossusType.archer:
      return Icons.gps_fixed;
    case ColossusType.mage:
      return Icons.auto_awesome;
  }
}
