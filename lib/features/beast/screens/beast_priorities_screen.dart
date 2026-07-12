import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/category_weight_editor.dart';
import '../../../shared/widgets/priority_editor_list.dart';
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
  BeastType _selectedTalentBeast = BeastType.panda;

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
            CategoryWeightEditor(
              title: 'CATEGORY WEIGHTS',
              description:
                  'These values determine how much each category '
                  'contributes to overall Beast progress. The total '
                  'must equal 100% before saving.',
              items: [
                CategoryWeightItem(
                  id: 'skills',
                  label: 'Skills',
                  weight: config.skillsWeight,
                ),
                CategoryWeightItem(
                  id: 'talents',
                  label: 'Talents',
                  weight: config.talentsWeight,
                ),
                CategoryWeightItem(
                  id: 'skins',
                  label: 'Skins',
                  weight: config.skinsWeight,
                ),
              ],
              onWeightChanged: (categoryId, newWeight) {
                switch (categoryId) {
                  case 'skills':
                    controller.setCategoryWeights(
                      skillsWeight: newWeight,
                      talentsWeight: config.talentsWeight,
                      skinsWeight: config.skinsWeight,
                    );
                    return;

                  case 'talents':
                    controller.setCategoryWeights(
                      skillsWeight: config.skillsWeight,
                      talentsWeight: newWeight,
                      skinsWeight: config.skinsWeight,
                    );
                    return;

                  case 'skins':
                    controller.setCategoryWeights(
                      skillsWeight: config.skillsWeight,
                      talentsWeight: config.talentsWeight,
                      skinsWeight: newWeight,
                    );
                    return;
                }
              },
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
                if (!config.weightsAreValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Category weights must total 100% before '
                        'saving.',
                      ),
                    ),
                  );
                  return;
                }

                await controller.save();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Beast priorities saved.')),
                );
              },
              onCancel: () async {
                await controller.cancel();

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
        return _TalentsPrioritiesSection(
          selectedBeast: _selectedTalentBeast,
          onBeastSelected: (beastType) {
            setState(() {
              _selectedTalentBeast = beastType;
            });
          },
        );

      case 2:
        return const _SkinsPrioritiesSection();

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
        _SectionSummaryCard(
          icon: Icons.pets,
          title: 'SKILL PRIORITIES',
          trackedCount: trackedCount,
          totalCount: beastSkillDefinitions.length,
          itemLabel: 'skills',
          description:
              'Ignored skills remain stored in the player profile '
              'but do not affect Beast progress.',
        ),
        const SizedBox(height: AMSpacing.md),
        PriorityEditorList(
          items: beastSkillDefinitions,
          idForItem: (skill) {
            return skill.id;
          },
          titleForItem: (skill) {
            return skill.name;
          },
          minimumLevelForItem: (skill) {
            return skill.minLevel;
          },
          maximumLevelForItem: (skill) {
            return skill.maxLevel;
          },
          configForItem: (skill) {
            final itemConfig = config.skillConfigs[skill.id];

            if (itemConfig == null) {
              return null;
            }

            return PriorityEditorItemConfig(
              isTracked: itemConfig.isTracked,
              targetLevel: itemConfig.targetLevel,
              priority: itemConfig.priority,
            );
          },
          onTrackedChanged: (skill, isTracked) {
            controller.setSkillTracked(skillId: skill.id, isTracked: isTracked);
          },
          onTargetLevelChanged: (skill, targetLevel) {
            controller.setSkillTargetLevel(
              skillId: skill.id,
              targetLevel: targetLevel,
            );
          },
          onPriorityChanged: (skill, priority) {
            controller.setSkillPriority(skillId: skill.id, priority: priority);
          },
          emptyMessage: 'No Beast skills are available.',
        ),
      ],
    );
  }
}

class _TalentsPrioritiesSection extends ConsumerWidget {
  const _TalentsPrioritiesSection({
    required this.selectedBeast,
    required this.onBeastSelected,
  });

  final BeastType selectedBeast;
  final ValueChanged<BeastType> onBeastSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);
    final controller = ref.read(beastProgressConfigProvider.notifier);

    final talents = talentDefinitionsForBeast(selectedBeast);

    final talentConfigs = config.talentConfigsFor(selectedBeast);

    final trackedCount = talentConfigs.values
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
                  const Icon(Icons.account_tree),
                  const SizedBox(width: AMSpacing.sm),
                  Expanded(
                    child: Text(
                      'TALENT PRIORITIES',
                      style: AMTextStyles.subtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.sm),
              Text(
                'Choose a Beast to configure its unique Talent '
                'priorities.',
                style: AMTextStyles.body,
              ),
              const SizedBox(height: AMSpacing.md),
              Wrap(
                spacing: AMSpacing.sm,
                runSpacing: AMSpacing.sm,
                children: BeastType.values.map((beastType) {
                  return ChoiceChip(
                    selected: beastType == selectedBeast,
                    label: Text(_beastName(beastType)),
                    onSelected: (_) {
                      onBeastSelected(beastType);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AMSpacing.md),
              Text(
                '$trackedCount of ${talents.length} '
                '${_beastName(selectedBeast)} talents are '
                'currently tracked.',
                style: AMTextStyles.body,
              ),
              const SizedBox(height: AMSpacing.xs),
              Text(
                'Each Beast keeps its own Talent priority '
                'configuration.',
                style: AMTextStyles.muted,
              ),
            ],
          ),
        ),
        const SizedBox(height: AMSpacing.md),
        PriorityEditorList(
          items: talents,
          idForItem: (talent) {
            return talent.id;
          },
          titleForItem: (talent) {
            return talent.name;
          },
          minimumLevelForItem: (_) {
            return 0;
          },
          maximumLevelForItem: (talent) {
            return talent.maxLevel;
          },
          configForItem: (talent) {
            final itemConfig = talentConfigs[talent.id];

            if (itemConfig == null) {
              return null;
            }

            return PriorityEditorItemConfig(
              isTracked: itemConfig.isTracked,
              targetLevel: itemConfig.targetLevel,
              priority: itemConfig.priority,
            );
          },
          onTrackedChanged: (talent, isTracked) {
            controller.setTalentTracked(
              beastType: selectedBeast,
              talentId: talent.id,
              isTracked: isTracked,
            );
          },
          onTargetLevelChanged: (talent, targetLevel) {
            controller.setTalentTargetLevel(
              beastType: selectedBeast,
              talentId: talent.id,
              targetLevel: targetLevel,
            );
          },
          onPriorityChanged: (talent, priority) {
            controller.setTalentPriority(
              beastType: selectedBeast,
              talentId: talent.id,
              priority: priority,
            );
          },
          emptyMessage:
              'No talents are available for '
              '${_beastName(selectedBeast)}.',
        ),
      ],
    );
  }
}

class _SkinsPrioritiesSection extends ConsumerWidget {
  const _SkinsPrioritiesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);
    final controller = ref.read(beastProgressConfigProvider.notifier);

    final trackedCount = config.skinConfigs.values
        .where((item) => item.isTracked)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionSummaryCard(
          icon: Icons.theater_comedy,
          title: 'SKIN PRIORITIES',
          trackedCount: trackedCount,
          totalCount: beastSkinDefinitions.length,
          itemLabel: 'skins',
          description:
              'Beast skins stack together. Ignored skins remain '
              'stored but do not contribute to Beast progress.',
        ),
        const SizedBox(height: AMSpacing.md),
        PriorityEditorList(
          items: beastSkinDefinitions,
          idForItem: (skin) {
            return skin.id;
          },
          titleForItem: (skin) {
            return skin.name;
          },
          minimumLevelForItem: (skin) {
            return skin.minLevel;
          },
          maximumLevelForItem: (skin) {
            return skin.maxLevel;
          },
          configForItem: (skin) {
            final itemConfig = config.skinConfigs[skin.id];

            if (itemConfig == null) {
              return null;
            }

            return PriorityEditorItemConfig(
              isTracked: itemConfig.isTracked,
              targetLevel: itemConfig.targetLevel,
              priority: itemConfig.priority,
            );
          },
          onTrackedChanged: (skin, isTracked) {
            controller.setSkinTracked(skinId: skin.id, isTracked: isTracked);
          },
          onTargetLevelChanged: (skin, targetLevel) {
            controller.setSkinTargetLevel(
              skinId: skin.id,
              targetLevel: targetLevel,
            );
          },
          onPriorityChanged: (skin, priority) {
            controller.setSkinPriority(skinId: skin.id, priority: priority);
          },
          emptyMessage: 'No Beast skins are available.',
        ),
      ],
    );
  }
}

class _SectionSummaryCard extends StatelessWidget {
  const _SectionSummaryCard({
    required this.icon,
    required this.title,
    required this.trackedCount,
    required this.totalCount,
    required this.itemLabel,
    required this.description,
  });

  final IconData icon;
  final String title;
  final int trackedCount;
  final int totalCount;
  final String itemLabel;
  final String description;

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
          const SizedBox(height: AMSpacing.sm),
          Text(
            '$trackedCount of $totalCount $itemLabel are '
            'currently tracked.',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(description, style: AMTextStyles.muted),
        ],
      ),
    );
  }
}

String _beastName(BeastType beastType) {
  switch (beastType) {
    case BeastType.panda:
      return 'Panda';
    case BeastType.dragon:
      return 'Dragon';
    case BeastType.pegasus:
      return 'Pegasus';
    case BeastType.phoenix:
      return 'Phoenix';
  }
}
