import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/beast_controller.dart';
import '../models/beast_state.dart';

class BeastSkillsScreen extends ConsumerWidget {
  const BeastSkillsScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () => const AMPage(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text(
            'Failed to load Beast skills.',
            style: AMTextStyles.body,
          ),
        ),
      ),
      data: (state) => _BeastSkillsView(state: state),
    );
  }
}

class _BeastSkillsView extends ConsumerWidget {
  const _BeastSkillsView({
    required this.state,
  });

  final BeastState state;

  double get _progress {
    var current = 0;
    var maximum = 0;

    for (final skill in _skillDefinitions) {
      final level = state.skillLevels[skill.id] ?? 1;
      current += level - 1;
      maximum += skill.maxLevel - 1;
    }

    if (maximum == 0) return 0;

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
                onIncrease: () => controller.increaseSkill(
                  skillId: skill.id,
                  maxLevel: skill.maxLevel,
                ),
                onDecrease: () => controller.decreaseSkill(
                  skillId: skill.id,
                ),
              ),
              const SizedBox(height: AMSpacing.md),
            ],
          ],
        ),
      ),
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
    return (level - 1) / (skill.maxLevel - 1);
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill.name,
            style: AMTextStyles.subtitle,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Lv. $level / ${skill.maxLevel}',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.md),
          AMProgressBar(progress: _progress),
          const SizedBox(height: AMSpacing.sm),
          Text(
            '${(_progress * 100).toStringAsFixed(1)}%',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: level > 1 ? onDecrease : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: AMSpacing.md),
              IconButton(
                onPressed: level < skill.maxLevel ? onIncrease : null,
                icon: const Icon(Icons.add),
              ),
            ],
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
    required this.maxLevel,
  });

  final String id;
  final String name;
  final int maxLevel;
}

const _skillDefinitions = [
  _SkillDefinition(
    id: 'march_speed_up',
    name: 'March Speed Up',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'steel_skin',
    name: 'Steel Skin',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'anti_cavalry',
    name: 'Anti-Cavalry',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'resist_magic',
    name: 'Resist Magic',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'anti_infantry',
    name: 'Anti-Infantry',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'smothered_flare',
    name: 'Smothered Flare',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'wounded_limit',
    name: 'Wounded Limit',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'life_source',
    name: 'Life Source',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'force_expansion',
    name: 'Force Expansion',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'attack_expert',
    name: 'Attack Expert',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'quick_heal',
    name: 'Quick Heal',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'recruitment_speed_up',
    name: 'Recruitment Speed Up',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'wounded_conversion',
    name: 'Wounded Conversion',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'anti_angel',
    name: 'Anti-Angel',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'vigor_star',
    name: 'Vigor Star',
    maxLevel: 30,
  ),
  _SkillDefinition(
    id: 'level_up_booster',
    name: 'Level Up Booster',
    maxLevel: 30,
  ),
];