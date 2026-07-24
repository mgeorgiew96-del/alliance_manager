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
import '../../../shared/widgets/am_primary_button.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/beast_controller.dart';
import '../definitions/beast_skill_definitions.dart';
import '../definitions/beast_skin_definitions.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_progress_config.dart';
import '../models/beast_state.dart';
import '../models/beast_type.dart';
import '../providers/beast_progress_config_provider.dart';
import '../services/beast_progress_service.dart';

class BeastScreen extends ConsumerWidget {
  const BeastScreen({super.key, required this.amId});

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text('Failed to load Beast data.', style: AMTextStyles.body),
        ),
      ),
      data: (state) {
        final config = ref.watch(beastProgressConfigProvider);

        return _BeastOverview(amId: amId, state: state, config: config);
      },
    );
  }
}

class _BeastOverview extends ConsumerWidget {
  const _BeastOverview({
    required this.amId,
    required this.state,
    required this.config,
  });

  final String amId;
  final BeastState state;
  final BeastProgressConfig config;

  static const int _minBeastLevel = 1;
  static const int _maxBeastLevel = 40;

  double get _levelProgress {
    final availableLevels = _maxBeastLevel - _minBeastLevel;

    if (availableLevels <= 0) {
      return 0;
    }

    final adjustedLevel = state.beastLevel - _minBeastLevel;

    return (adjustedLevel / availableLevels).clamp(0, 1).toDouble();
  }

  double get _skillsProgress {
    return BeastProgressService.calculateSkillsProgress(
      state: state,
      config: config,
    );
  }

  double get _talentsProgress {
    return BeastProgressService.calculateTalentsProgress(
      state: state,
      config: config,
    );
  }

  double get _skinsProgress {
    return BeastProgressService.calculateSkinsProgress(
      state: state,
      config: config,
    );
  }

  double get _overallProgress {
    return BeastProgressService.calculateOverallProgress(
      state: state,
      config: config,
    );
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

  String get _beastName {
    return _nameForBeast(state.selectedBeast);
  }

  String get _beastImagePath {
    return AMAssets.beast.overview(state.selectedBeast);
  }

  String get _beastAbout {
    switch (state.selectedBeast) {
      case BeastType.panda:
        return 'The Panda is the guardian of balance and resilience. '
            'Best for defensive builds.';

      case BeastType.dragon:
        return 'The Dragon represents raw power and pressure. '
            'Best for 1vs1 damage-focused builds.';

      case BeastType.pegasus:
        return 'The Pegasus brings speed and momentum. '
            'Best for balanced attacking builds.';

      case BeastType.phoenix:
        return 'The Phoenix represents rebirth and endurance. '
            'Best until Beast Talents are above 67k.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(beastControllerProvider.notifier);

    return AMModuleOverview(
      title: 'Beast',
      bannerPath: AMAssets.common.banner('beast_banner'),
      bannerTagline: '',
      bannerAlignment: Alignment.topCenter,
      description:
          '',
      fallbackIcon: Icons.pets,
      onBack: () {
        context.go('/member/$amId');
      },
      progressContent: _HeroSection(
        selectedBeast: state.selectedBeast,
        selectedBeastName: _beastName,
        selectedBeastImagePath: _beastImagePath,
        beastLevel: state.beastLevel,
        maxBeastLevel: _maxBeastLevel,
        beastLevelProgress: _levelProgress,
        overallProgress: _overallProgress,
        onSelectBeast: controller.selectBeast,
        onIncreaseLevel: controller.increaseBeastLevel,
        onDecreaseLevel: controller.decreaseBeastLevel,
      ),
      unsavedChangesContent: state.hasUnsavedChanges
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '● Unsaved Beast changes',
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
          _SubProgressCard(
            levelProgress: _levelProgress,
            skillsProgress: _skillsProgress,
            talentsProgress: _talentsProgress,
            skinsProgress: _skinsProgress,
            skillsWeight: config.skillsWeight,
            talentsWeight: config.talentsWeight,
            skinsWeight: config.skinsWeight,
          ),
          const SizedBox(height: AMSpacing.md),
          _NavigationRow(amId: amId, selectedBeast: state.selectedBeast),
          const SizedBox(height: AMSpacing.md),
          _OverviewGrid(state: state, config: config, beastAbout: _beastAbout),
          const SizedBox(height: AMSpacing.md),
          Center(
            child: Text(
              'Last Updated: $_lastUpdatedText',
              style: AMTextStyles.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.selectedBeast,
    required this.selectedBeastName,
    required this.selectedBeastImagePath,
    required this.beastLevel,
    required this.maxBeastLevel,
    required this.beastLevelProgress,
    required this.overallProgress,
    required this.onSelectBeast,
    required this.onIncreaseLevel,
    required this.onDecreaseLevel,
  });

  final BeastType selectedBeast;
  final String selectedBeastName;
  final String selectedBeastImagePath;

  final int beastLevel;
  final int maxBeastLevel;

  final double beastLevelProgress;
  final double overallProgress;

  final ValueChanged<BeastType> onSelectBeast;

  final VoidCallback onIncreaseLevel;
  final VoidCallback onDecreaseLevel;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AMSpacing.sm,
            runSpacing: AMSpacing.sm,
            children: BeastType.values.map((beastType) {
              final isSelected = beastType == selectedBeast;

              return ChoiceChip(
                selected: isSelected,
                label: Text(_nameForBeast(beastType)),
                avatar: ClipOval(
                  child: AMAssetImage(
                    path: AMAssets.beast.overview(beastType),
                    size: 32,
                    fit: BoxFit.cover,
                    fallbackIcon: Icons.pets,
                    fallbackIconSize: 18,
                  ),
                ),
                onSelected: (_) {
                  onSelectBeast(beastType);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AMSpacing.lg),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AMAssetImage(
                    path: selectedBeastImagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    fallbackIcon: Icons.pets,
                    fallbackIconSize: 72,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          Center(child: Text(selectedBeastName, style: AMTextStyles.title)),
          const SizedBox(height: AMSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Overall Beast Progress',
                  style: AMTextStyles.subtitle,
                ),
              ),
              Text(
                '${(overallProgress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.title,
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.sm),
          AMProgressBar(progress: overallProgress),
          const SizedBox(height: AMSpacing.lg),
          Text(
            'Beast Lv. $beastLevel / '
            '$maxBeastLevel',
            style: AMTextStyles.subtitle,
          ),
          const SizedBox(height: AMSpacing.sm),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Decrease Beast level',
                onPressed: beastLevel > 1 ? onDecreaseLevel : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(child: AMProgressBar(progress: beastLevelProgress)),
              const SizedBox(width: AMSpacing.md),
              IconButton.filled(
                tooltip: 'Increase Beast level',
                onPressed: beastLevel < maxBeastLevel ? onIncreaseLevel : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            'Level Progress: '
            '${(beastLevelProgress * 100).toStringAsFixed(1)}%',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Beast Level is recorded but does not contribute '
            'to Beast Progress.',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

class _SubProgressCard extends StatelessWidget {
  const _SubProgressCard({
    required this.levelProgress,
    required this.skillsProgress,
    required this.talentsProgress,
    required this.skinsProgress,
    required this.skillsWeight,
    required this.talentsWeight,
    required this.skinsWeight,
  });

  final double levelProgress;
  final double skillsProgress;
  final double talentsProgress;
  final double skinsProgress;

  final double skillsWeight;
  final double talentsWeight;
  final double skinsWeight;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BEAST PROGRESS SUMMARY', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.md),
          _ProgressRow(
            label: 'Level',
            weightLabel: 'Recorded only',
            progress: levelProgress,
          ),
          _ProgressRow(
            label: 'Skills',
            weightLabel: _weightText(skillsWeight),
            progress: skillsProgress,
          ),
          _ProgressRow(
            label: 'Talents',
            weightLabel: _weightText(talentsWeight),
            progress: talentsProgress,
          ),
          _ProgressRow(
            label: 'Skins',
            weightLabel: _weightText(skinsWeight),
            progress: skinsProgress,
          ),
        ],
      ),
    );
  }

  String _weightText(double weight) {
    return '${(weight * 100).toStringAsFixed(0)}%';
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.weightLabel,
    required this.progress,
  });

  final String label;
  final String weightLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AMTextStyles.body)),
              Text(weightLabel, style: AMTextStyles.muted),
              const SizedBox(width: AMSpacing.sm),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.body,
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.xs),
          AMProgressBar(progress: progress),
        ],
      ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({required this.amId, required this.selectedBeast});

  final String amId;
  final BeastType selectedBeast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AMPrimaryButton(
          text: 'SKILLS',
          icon: Icons.pets,
          onPressed: () {
            context.go('/member/$amId/beast/skills');
          },
        ),
        const SizedBox(height: AMSpacing.sm),
        AMPrimaryButton(
          text: 'TALENTS',
          icon: Icons.account_tree,
          onPressed: () {
            context.go(
              '/member/$amId/beast/talents/'
              '${selectedBeast.name}',
            );
          },
        ),
        const SizedBox(height: AMSpacing.sm),
        AMPrimaryButton(
          text: 'SKINS',
          icon: Icons.theater_comedy,
          onPressed: () {
            context.go('/member/$amId/beast/skins');
          },
        ),
      ],
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({
    required this.state,
    required this.config,
    required this.beastAbout,
  });

  final BeastState state;
  final BeastProgressConfig config;
  final String beastAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SkillsOverviewCard(state: state, config: config),
        const SizedBox(height: AMSpacing.md),
        _TalentOverviewCard(state: state, config: config),
        const SizedBox(height: AMSpacing.md),
        _SkinsOverviewCard(state: state, config: config),
        const SizedBox(height: AMSpacing.md),
        _AboutBeastCard(beastAbout: beastAbout),
      ],
    );
  }
}

class _SkillsOverviewCard extends StatelessWidget {
  const _SkillsOverviewCard({required this.state, required this.config});

  final BeastState state;
  final BeastProgressConfig config;

  @override
  Widget build(BuildContext context) {
    final trackedSkills = beastSkillDefinitions.where((skill) {
      return config.skillConfigs[skill.id]?.isTracked ?? true;
    }).toList();

    final previewSkills = trackedSkills.take(6).toList();

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SKILLS OVERVIEW', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${trackedSkills.length} of '
            '${beastSkillDefinitions.length} tracked',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          if (previewSkills.isEmpty)
            Text(
              'No Beast skills are currently tracked.',
              style: AMTextStyles.muted,
            )
          else
            for (final skill in previewSkills) ...[
              Row(
                children: [
                  ClipOval(
                    child: AMAssetImage(
                      path: AMAssets.beast.skill(skill.id),
                      size: 28,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.pets,
                      fallbackIconSize: 16,
                    ),
                  ),
                  const SizedBox(width: AMSpacing.sm),
                  Expanded(child: Text(skill.name, style: AMTextStyles.body)),
                  Text(
                    'Lv. '
                    '${state.skillLevels[skill.id] ?? skill.minLevel}'
                    ' / '
                    '${config.skillConfigs[skill.id]?.targetLevel ?? skill.maxLevel}',
                    style: AMTextStyles.muted,
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.sm),
            ],
        ],
      ),
    );
  }
}

class _TalentOverviewCard extends StatelessWidget {
  const _TalentOverviewCard({required this.state, required this.config});

  final BeastState state;
  final BeastProgressConfig config;

  @override
  Widget build(BuildContext context) {
    final talents = talentDefinitionsForBeast(state.selectedBeast);

    final talentConfig = config.talentConfigsFor(state.selectedBeast);

    final trackedTalents = talents.where((talent) {
      return talentConfig[talent.id]?.isTracked ?? true;
    }).toList();

    final totalLevels = trackedTalents.fold<int>(0, (sum, talent) {
      return sum + (state.talentLevels[talent.id] ?? 0);
    });

    final previewTalents = trackedTalents.take(7).toList();

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TALENT TREE OVERVIEW', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${trackedTalents.length} of '
            '${talents.length} tracked',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            'Tracked Talent Levels: '
            '$totalLevels',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.lg),
          if (previewTalents.isEmpty)
            Text(
              'No Beast talents are currently tracked.',
              style: AMTextStyles.muted,
            )
          else
            Wrap(
              spacing: AMSpacing.md,
              runSpacing: AMSpacing.md,
              children: previewTalents.map((talent) {
                return SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: ClipOval(
                          child: AMAssetImage(
                            path: AMAssets.beast.talent(
                              beastType: state.selectedBeast,
                              talentId: talent.id,
                            ),
                            size: 52,
                            fit: BoxFit.cover,
                            fallbackIcon: Icons.auto_awesome,
                            fallbackIconSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: AMSpacing.xs),
                      Text(
                        talent.name,
                        style: AMTextStyles.body,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${state.talentLevels[talent.id] ?? 0}'
                        ' / '
                        '${talent.maxLevel}',
                        style: AMTextStyles.muted,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _SkinsOverviewCard extends StatelessWidget {
  const _SkinsOverviewCard({required this.state, required this.config});

  final BeastState state;
  final BeastProgressConfig config;

  @override
  Widget build(BuildContext context) {
    final trackedSkins = beastSkinDefinitions.where((skin) {
      return config.skinConfigs[skin.id]?.isTracked ?? true;
    }).toList();

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SKINS OVERVIEW', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${trackedSkins.length} of '
            '${beastSkinDefinitions.length} tracked',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          if (trackedSkins.isEmpty)
            Text(
              'No Beast skins are currently tracked.',
              style: AMTextStyles.muted,
            )
          else
            Wrap(
              spacing: AMSpacing.md,
              runSpacing: AMSpacing.md,
              children: trackedSkins.map((skin) {
                final targetLevel =
                    config.skinConfigs[skin.id]?.targetLevel ?? skin.maxLevel;

                return SizedBox(
                  width: 110,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: AMAssetImage(
                          path: AMAssets.beast.skin(
                            beastType: state.selectedBeast,
                            skinId: skin.id,
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          borderRadius: BorderRadius.circular(12),
                          fallbackIcon: Icons.pets,
                          fallbackIconSize: 36,
                        ),
                      ),
                      const SizedBox(height: AMSpacing.xs),
                      Text(
                        skin.name,
                        style: AMTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AMSpacing.xs),
                      Text(
                        'Lv. '
                        '${state.skinLevels[skin.id] ?? skin.minLevel}'
                        ' / $targetLevel',
                        style: AMTextStyles.muted,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _AboutBeastCard extends StatelessWidget {
  const _AboutBeastCard({required this.beastAbout});

  final String beastAbout;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ABOUT THIS BEAST', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.md),
          Text(beastAbout, style: AMTextStyles.body),
        ],
      ),
    );
  }
}

String _nameForBeast(BeastType beastType) {
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
