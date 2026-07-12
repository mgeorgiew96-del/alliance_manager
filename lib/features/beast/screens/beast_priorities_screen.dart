import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../definitions/beast_skill_definitions.dart';
import '../definitions/beast_skin_definitions.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_type.dart';
import '../providers/beast_progress_config_provider.dart';

class BeastPrioritiesScreen extends ConsumerWidget {
  const BeastPrioritiesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(beastProgressConfigProvider);
    final controller = ref.read(
      beastProgressConfigProvider.notifier,
    );

    return DefaultTabController(
      length: 3,
      child: AMPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: AMSpacing.sm),
                Expanded(
                  child: Text(
                    'BEAST PRIORITIES',
                    style: AMTextStyles.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.sm),
            Text(
              'Configure which Beast items contribute to progress '
              'and define their target levels.',
              style: AMTextStyles.body,
            ),
            const SizedBox(height: AMSpacing.lg),
            _CategoryWeightsCard(
              skillsWeight: config.skillsWeight,
              talentsWeight: config.talentsWeight,
              skinsWeight: config.skinsWeight,
            ),
            const SizedBox(height: AMSpacing.lg),
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.pets),
                  text: 'Skills',
                ),
                Tab(
                  icon: Icon(Icons.account_tree),
                  text: 'Talents',
                ),
                Tab(
                  icon: Icon(Icons.theater_comedy),
                  text: 'Skins',
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.md),
            SizedBox(
              height: 260,
              child: TabBarView(
                children: [
                  _SkillsPlaceholder(
                    trackedCount: config.skillConfigs.values
                        .where((item) => item.isTracked)
                        .length,
                  ),
                  _TalentsPlaceholder(
                    trackedCount: config
                        .talentConfigsFor(BeastType.panda)
                        .values
                        .where((item) => item.isTracked)
                        .length,
                  ),
                  _SkinsPlaceholder(
                    trackedCount: config.skinConfigs.values
                        .where((item) => item.isTracked)
                        .length,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AMSpacing.lg),
            AMSaveCancelBar(
              onSave: () async {
                controller.save();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Beast priorities saved.',
                    ),
                  ),
                );
              },
              onCancel: () async {
                controller.cancel();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Unsaved priority changes cancelled.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
    final totalWeight =
        skillsWeight + talentsWeight + skinsWeight;

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CATEGORY WEIGHTS',
            style: AMTextStyles.subtitle,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'These weights determine how much each category '
            'contributes to overall Beast progress.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          _WeightRow(
            label: 'Skills',
            weight: skillsWeight,
          ),
          const SizedBox(height: AMSpacing.sm),
          _WeightRow(
            label: 'Talents',
            weight: talentsWeight,
          ),
          const SizedBox(height: AMSpacing.sm),
          _WeightRow(
            label: 'Skins',
            weight: skinsWeight,
          ),
          const SizedBox(height: AMSpacing.md),
          const Divider(),
          const SizedBox(height: AMSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: AMTextStyles.subtitle,
                ),
              ),
              Text(
                _percentageText(totalWeight),
                style: AMTextStyles.subtitle,
              ),
            ],
          ),
          if ((totalWeight - 1).abs() > 0.0001) ...[
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
  const _WeightRow({
    required this.label,
    required this.weight,
  });

  final String label;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AMTextStyles.body,
          ),
        ),
        Text(
          _percentageText(weight),
          style: AMTextStyles.body,
        ),
      ],
    );
  }
}

class _SkillsPlaceholder extends StatelessWidget {
  const _SkillsPlaceholder({
    required this.trackedCount,
  });

  final int trackedCount;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: _PlaceholderCard(
        icon: Icons.pets,
        title: 'SKILL PRIORITIES',
        description:
            '$trackedCount of ${beastSkillDefinitions.length} '
            'skills are currently tracked.',
        message:
            'The editable Skill priority rows will be added next.',
      ),
    );
  }
}

class _TalentsPlaceholder extends StatelessWidget {
  const _TalentsPlaceholder({
    required this.trackedCount,
  });

  final int trackedCount;

  @override
  Widget build(BuildContext context) {
    final pandaTalentCount = talentDefinitionsForBeast(
      BeastType.panda,
    ).length;

    return Align(
      alignment: Alignment.topCenter,
      child: _PlaceholderCard(
        icon: Icons.account_tree,
        title: 'TALENT PRIORITIES',
        description:
            '$trackedCount of $pandaTalentCount Panda talents '
            'are currently tracked.',
        message:
            'Beast selection and editable Talent priority rows '
            'will be added next.',
      ),
    );
  }
}

class _SkinsPlaceholder extends StatelessWidget {
  const _SkinsPlaceholder({
    required this.trackedCount,
  });

  final int trackedCount;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: _PlaceholderCard(
        icon: Icons.theater_comedy,
        title: 'SKIN PRIORITIES',
        description:
            '$trackedCount of ${beastSkinDefinitions.length} '
            'skins are currently tracked.',
        message:
            'The editable Skin priority rows will be added next.',
      ),
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
              Expanded(
                child: Text(
                  title,
                  style: AMTextStyles.subtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            description,
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            message,
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

String _percentageText(double value) {
  return '${(value * 100).toStringAsFixed(0)}%';
}