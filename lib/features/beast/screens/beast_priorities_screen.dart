import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/priority_item_editor.dart';
import '../definitions/beast_skill_definitions.dart';
import '../definitions/beast_skin_definitions.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_type.dart';
import '../providers/beast_progress_config_provider.dart';

class BeastPrioritiesScreen extends ConsumerStatefulWidget {
  const BeastPrioritiesScreen({super.key});

  @override
  ConsumerState<BeastPrioritiesScreen> createState() {
    return _BeastPrioritiesScreenState();
  }
}

class _BeastPrioritiesScreenState extends ConsumerState<BeastPrioritiesScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(beastProgressConfigProvider);
    final controller = ref.read(beastProgressConfigProvider.notifier);

    return DefaultTabController(
      length: 3,
      child: AMPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageHeader(
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AMSpacing.lg),
            _CategoryWeightsCard(
              skillsWeight: config.skillsWeight,
              talentsWeight: config.talentsWeight,
              skinsWeight: config.skinsWeight,
            ),
            const SizedBox(height: AMSpacing.lg),
            TabBar(
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              tabs: const [
                Tab(icon: Icon(Icons.pets), text: 'Skills'),
                Tab(icon: Icon(Icons.account_tree), text: 'Talents'),
                Tab(icon: Icon(Icons.theater_comedy), text: 'Skins'),
              ],
            ),
            const SizedBox(height: AMSpacing.lg),
            _buildSelectedTab(),
            const SizedBox(height: AMSpacing.lg),
            AMSaveCancelBar(
              onSave: () async {
                controller.save();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Beast priorities saved.')),
                );
              },
              onCancel: () async {
                controller.cancel();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unsaved Beast priority changes cancelled.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_selectedTabIndex) {
      case 0:
        return const _SkillsPrioritiesSection();

      case 1:
        return const _TalentsPlaceholder();

      case 2:
        return const _SkinsPlaceholder();

      default:
        return const _SkillsPrioritiesSection();
    }
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: AMSpacing.sm),
            Expanded(
              child: Text('BEAST PRIORITIES', style: AMTextStyles.title),
            ),
          ],
        ),
        const SizedBox(height: AMSpacing.sm),
        Text(
          'Configure which Beast items contribute to player '
          'progress and define their target levels.',
          style: AMTextStyles.body,
        ),
        const SizedBox(height: AMSpacing.xs),
        Text(
          'These settings are intended for R4 and R5 alliance '
          'management.',
          style: AMTextStyles.muted,
        ),
      ],
    );
  }
}

class _CategoryWeightsCard extends StatelessWidget {
  const _CategoryWeightsCard({
    required this.skillsWeight,
    required this.talentsWeight,
    required this.skinsWeight,
  });

  final double skillsWeight;
  final double talentsWeight;
  final double skinsWeight;

  @override
  Widget build(BuildContext context) {
    final totalWeight = skillsWeight + talentsWeight + skinsWeight;

    final weightsAreValid = (totalWeight - 1).abs() <= 0.0001;

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CATEGORY WEIGHTS', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'These values determine how much each category '
            'contributes to overall Beast progress.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          _WeightRow(label: 'Skills', weight: skillsWeight),
          const SizedBox(height: AMSpacing.sm),
          _WeightRow(label: 'Talents', weight: talentsWeight),
          const SizedBox(height: AMSpacing.sm),
          _WeightRow(label: 'Skins', weight: skinsWeight),
          const SizedBox(height: AMSpacing.md),
          const Divider(),
          const SizedBox(height: AMSpacing.sm),
          Row(
            children: [
              Expanded(child: Text('Total', style: AMTextStyles.subtitle)),
              Text(_percentageText(totalWeight), style: AMTextStyles.subtitle),
            ],
          ),
          if (!weightsAreValid) ...[
            const SizedBox(height: AMSpacing.sm),
            const Text(
              'Category weights must total 100%.',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  const _WeightRow({required this.label, required this.weight});

  final String label;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AMTextStyles.body)),
        Text(_percentageText(weight), style: AMTextStyles.body),
      ],
    );
  }
}

class _SkillsPrioritiesSection extends ConsumerWidget {
  const _SkillsPrioritiesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);
    final controller = ref.read(beastProgressConfigProvider.notifier);

    final trackedCount = config.skillConfigs.values
        .where((item) => item.isTracked)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AMCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.pets),
                  const SizedBox(width: AMSpacing.sm),
                  Expanded(
                    child: Text(
                      'SKILL PRIORITIES',
                      style: AMTextStyles.subtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.sm),
              Text(
                '$trackedCount of '
                '${beastSkillDefinitions.length} skills are '
                'currently tracked.',
                style: AMTextStyles.body,
              ),
              const SizedBox(height: AMSpacing.xs),
              Text(
                'Ignored skills remain stored in the player profile '
                'but do not affect Beast progress.',
                style: AMTextStyles.muted,
              ),
            ],
          ),
        ),
        const SizedBox(height: AMSpacing.md),
        for (final skill in beastSkillDefinitions) ...[
          Builder(
            builder: (context) {
              final itemConfig = config.skillConfigs[skill.id];

              if (itemConfig == null) {
                return AMCard(
                  child: Text(
                    'Missing progress configuration for '
                    '${skill.name}.',
                    style: AMTextStyles.muted,
                  ),
                );
              }

              return PriorityItemEditor(
                title: skill.name,
                isTracked: itemConfig.isTracked,
                targetLevel: itemConfig.targetLevel,
                minimumLevel: skill.minLevel,
                maximumLevel: skill.maxLevel,
                priority: itemConfig.priority,
                onTrackedChanged: (isTracked) {
                  controller.setSkillTracked(
                    skillId: skill.id,
                    isTracked: isTracked,
                  );
                },
                onTargetLevelChanged: (targetLevel) {
                  controller.setSkillTargetLevel(
                    skillId: skill.id,
                    targetLevel: targetLevel,
                  );
                },
                onPriorityChanged: (priority) {
                  controller.setSkillPriority(
                    skillId: skill.id,
                    priority: priority,
                  );
                },
              );
            },
          ),
          const SizedBox(height: AMSpacing.md),
        ],
      ],
    );
  }
}

class _TalentsPlaceholder extends ConsumerWidget {
  const _TalentsPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);

    final pandaConfigs = config.talentConfigsFor(BeastType.panda);

    final trackedCount = pandaConfigs.values
        .where((item) => item.isTracked)
        .length;

    final totalCount = talentDefinitionsForBeast(BeastType.panda).length;

    return _PlaceholderCard(
      icon: Icons.account_tree,
      title: 'TALENT PRIORITIES',
      description:
          '$trackedCount of $totalCount Panda talents are '
          'currently tracked.',
      message:
          'Beast selection and editable Talent priority rows '
          'will be connected in the next step.',
    );
  }
}

class _SkinsPlaceholder extends ConsumerWidget {
  const _SkinsPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);

    final trackedCount = config.skinConfigs.values
        .where((item) => item.isTracked)
        .length;

    return _PlaceholderCard(
      icon: Icons.theater_comedy,
      title: 'SKIN PRIORITIES',
      description:
          '$trackedCount of ${beastSkinDefinitions.length} '
          'skins are currently tracked.',
      message:
          'Editable Skin priority rows will be connected after '
          'the Talent tab.',
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String description;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: AMSpacing.sm),
              Expanded(child: Text(title, style: AMTextStyles.subtitle)),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Text(description, style: AMTextStyles.body),
          const SizedBox(height: AMSpacing.sm),
          Text(message, style: AMTextStyles.muted),
        ],
      ),
    );
  }
}

String _percentageText(double value) {
  return '${(value * 100).toStringAsFixed(0)}%';
}
