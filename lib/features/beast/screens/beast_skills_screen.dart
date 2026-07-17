import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/beast_controller.dart';
import '../models/beast_state.dart';

class BeastSkillsScreen extends ConsumerWidget {
  const BeastSkillsScreen({super.key, required this.amId});

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text('Failed to load Beast skills.', style: AMTextStyles.body),
        ),
      ),
      data: (state) {
        return _BeastSkillsView(state: state, amId: amId);
      },
    );
  }
}

class _BeastSkillsView extends ConsumerWidget {
  const _BeastSkillsView({required this.state, required this.amId});

  final BeastState state;
  final String amId;

  double get _progress {
    var current = 0;
    var maximum = 0;

    for (final skill in _skillDefinitions) {
      final level = state.skillLevels[skill.id] ?? 1;

      current += level - 1;
      maximum += skill.maxLevel - 1;
    }

    if (maximum == 0) {
      return 0;
    }

    return current / maximum;
  }

  String get _lastUpdatedText {
    final lastUpdated = state.lastUpdated;

    if (lastUpdated == null) {
      return 'Not saved yet';
    }

    return '${lastUpdated.day.toString().padLeft(2, '0')}.'
        '${lastUpdated.month.toString().padLeft(2, '0')}.'
        '${lastUpdated.year} '
        '${lastUpdated.hour.toString().padLeft(2, '0')}:'
        '${lastUpdated.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(beastControllerProvider.notifier);

    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackButton(
              onPressed: () {
                context.go('/member/$amId/beast');
              },
            ),
            const SizedBox(height: AMSpacing.md),
            AMModuleHeader(
              title: 'BEAST SKILLS',
              progress: _progress,
              lastUpdated: _lastUpdatedText,
              hasUnsavedChanges: state.hasUnsavedChanges,
            ),
            if (state.hasUnsavedChanges) ...[
              AMSaveCancelBar(
                onSave: controller.save,
                onCancel: controller.cancel,
              ),
              const SizedBox(height: AMSpacing.lg),
            ],
            for (final skill in _skillDefinitions) ...[
              _SkillCard(
                skill: skill,
                level: state.skillLevels[skill.id] ?? 1,
                onIncrease: () {
                  controller.increaseSkill(
                    skillId: skill.id,
                    maxLevel: skill.maxLevel,
                  );
                },
                onDecrease: () {
                  controller.decreaseSkill(skillId: skill.id);
                },
              ),
              const SizedBox(height: AMSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back to Beast',
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: AMSpacing.xs),
        Text('Back to Beast', style: AMTextStyles.body),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.skill,
    required this.level,
    required this.onIncrease,
    required this.onDecrease,
  });

  final _SkillDefinition skill;
  final int level;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  double get _progress {
    final availableLevels = skill.maxLevel - skill.minLevel;

    if (availableLevels <= 0) {
      return 0;
    }

    final completedLevels = level - skill.minLevel;

    return (completedLevels / availableLevels).clamp(0, 1).toDouble();
  }

  double get _currentBonus {
    final gainedLevels = level - skill.minLevel;

    return skill.baseValue + (gainedLevels * skill.stepValue);
  }

  bool get _isMaxed {
    return level >= skill.maxLevel;
  }

  String get _currentBonusText {
    return '${_currentBonus.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isMaxed ? Colors.green : colorScheme.primary,
                width: _isMaxed ? 2 : 1.4,
              ),
              boxShadow: [
                if (_isMaxed)
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.22),
                    blurRadius: 14,
                  ),
              ],
            ),
            child: ClipOval(
              child: AMAssetImage(
                path: AMAssets.beast.skill(skill.id),
                size: 64,
                fit: BoxFit.cover,
                fallbackIcon: Icons.auto_awesome,
                fallbackIconSize: 30,
              ),
            ),
          ),
          const SizedBox(width: AMSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(skill.name, style: AMTextStyles.subtitle),
                    ),
                    if (_isMaxed)
                      const Text(
                        'MAX',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AMSpacing.xs),
                Text(
                  'Lv. $level / ${skill.maxLevel}',
                  style: AMTextStyles.body,
                ),
                const SizedBox(height: AMSpacing.md),
                AMProgressBar(progress: _progress),
                const SizedBox(height: AMSpacing.md),
                Text(skill.description, style: AMTextStyles.body),
                const SizedBox(height: AMSpacing.md),
                Text('CURRENT BONUS', style: AMTextStyles.muted),
                const SizedBox(height: AMSpacing.xs),
                Text(_currentBonusText, style: AMTextStyles.title),
                const SizedBox(height: AMSpacing.md),
                Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Decrease level',
                      onPressed: level > skill.minLevel ? onDecrease : null,
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: AMSpacing.md),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: AMSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text('$level', style: AMTextStyles.title),
                      ),
                    ),
                    const SizedBox(width: AMSpacing.md),
                    IconButton.filled(
                      tooltip: 'Increase level',
                      onPressed: level < skill.maxLevel ? onIncrease : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillDefinition {
  const _SkillDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.baseValue,
    required this.stepValue,
  });

  final String id;
  final String name;
  final String description;

  final double baseValue;
  final double stepValue;

  int get minLevel => 1;
  int get maxLevel => 30;
}

const _skillDefinitions = [
  _SkillDefinition(
    id: 'march_speed_up',
    name: 'March Speed Up',
    description: 'Raises marching army speed.',
    baseValue: 2.0,
    stepValue: 1.0,
  ),
  _SkillDefinition(
    id: 'steel_skin',
    name: 'Steel Skin',
    description:
        'When troops are attacked by Archers, damage taken is reduced.',
    baseValue: 2.0,
    stepValue: 1.1,
  ),
  _SkillDefinition(
    id: 'anti_cavalry',
    name: 'Anti-Cavalry',
    description: 'For troops attacking Cavalry, damage is increased.',
    baseValue: 1.6,
    stepValue: 0.9,
  ),
  _SkillDefinition(
    id: 'resist_magic',
    name: 'Resist Magic',
    description: 'When troops are attacked by Mages, damage taken is reduced.',
    baseValue: 2.0,
    stepValue: 1.1,
  ),
  _SkillDefinition(
    id: 'anti_infantry',
    name: 'Anti-Infantry',
    description: 'For troops attacking Infantry, damage is increased.',
    baseValue: 1.6,
    stepValue: 0.9,
  ),
  _SkillDefinition(
    id: 'smothered_flare',
    name: 'Smothered Flare',
    description: 'When troops are attacked by Angels, damage taken is reduced.',
    baseValue: 2.0,
    stepValue: 1.1,
  ),
  _SkillDefinition(
    id: 'wounded_limit',
    name: 'Wounded Limit',
    description:
        'Increases the maximum limit of wounded soldiers in the Hospital.',
    baseValue: 13.0,
    stepValue: 1.0,
  ),
  _SkillDefinition(
    id: 'life_source',
    name: 'Life Source',
    description: 'Raises the maximum HP of all armies.',
    baseValue: 1.6,
    stepValue: 0.8,
  ),
  _SkillDefinition(
    id: 'force_expansion',
    name: 'Force Expansion',
    description: 'Raises the maximum size of the marching army.',
    baseValue: 1.0,
    stepValue: 0.5,
  ),
  _SkillDefinition(
    id: 'attack_expert',
    name: 'Attack Expert',
    description: 'Raises all armies’ Attack.',
    baseValue: 1.6,
    stepValue: 0.8,
  ),
  _SkillDefinition(
    id: 'quick_heal',
    name: 'Quick Heal',
    description: 'Raises the healing speed for wounded soldiers.',
    baseValue: 1.6,
    stepValue: 0.8,
  ),
  _SkillDefinition(
    id: 'recruitment_speed_up',
    name: 'Recruitment Speed Up',
    description: 'Raises soldier recruitment speed.',
    baseValue: 1.0,
    stepValue: 0.5,
  ),
  _SkillDefinition(
    id: 'wounded_conversion',
    name: 'Wounded Conversion',
    description:
        'Increases the ratio of killed soldiers converted to wounded soldiers at the end of battle.',
    baseValue: 0.8,
    stepValue: 0.4,
  ),
  _SkillDefinition(
    id: 'anti_angel',
    name: 'Anti-Angel',
    description: 'For troops attacking Angels, damage is increased.',
    baseValue: 1.6,
    stepValue: 0.9,
  ),
  _SkillDefinition(
    id: 'vigor_star',
    name: 'Vigor Star',
    description: 'Decreases recovery time for each point of Vigor.',
    baseValue: 2.0,
    stepValue: 1.0,
  ),
  _SkillDefinition(
    id: 'level_up_booster',
    name: 'Level Up Booster',
    description: 'Increases XP gained from defeating Monsters.',
    baseValue: 1.6,
    stepValue: 0.8,
  ),
];
