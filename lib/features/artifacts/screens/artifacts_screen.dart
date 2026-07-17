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
import '../../../shared/widgets/am_responsive_grid.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/artifacts_controller.dart';
import '../definitions/artifact_catalog.dart';
import '../models/artifact_category.dart';
import '../models/artifact_item_definition.dart';
import '../models/artifact_item_state.dart';
import '../models/artifact_rarity.dart';
import '../models/artifact_star_stage.dart';
import '../models/artifacts_state.dart';
import '../services/artifact_asset_service.dart';
import '../services/artifact_progress_service.dart';

class ArtifactsScreen extends ConsumerStatefulWidget {
  const ArtifactsScreen({super.key, required this.amId});

  final String amId;

  @override
  ConsumerState<ArtifactsScreen> createState() {
    return _ArtifactsScreenState();
  }
}

class _ArtifactsScreenState extends ConsumerState<ArtifactsScreen> {
  ArtifactCategory _selectedCategory = ArtifactCategory.artifact;

  @override
  Widget build(BuildContext context) {
    final artifactsState = ref.watch(artifactsControllerProvider);

    return artifactsState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text('Failed to load Artifacts.', style: AMTextStyles.body),
        ),
      ),
      data: (state) {
        return _buildContent(context: context, state: state);
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required ArtifactsState state,
  }) {
    final controller = ref.read(artifactsControllerProvider.notifier);

    final overallProgress = ArtifactProgressService.overallProgress(
      state: state,
    );

    final artifactProgress = ArtifactProgressService.categoryProgress(
      state: state,
      category: ArtifactCategory.artifact,
    );

    final crownProgress = ArtifactProgressService.categoryProgress(
      state: state,
      category: ArtifactCategory.crown,
    );

    final selectedArtifacts = ArtifactProgressService.selectedCount(
      state: state,
      category: ArtifactCategory.artifact,
    );

    final selectedCrowns = ArtifactProgressService.selectedCount(
      state: state,
      category: ArtifactCategory.crown,
    );

    final visibleDefinitions = ArtifactCatalog.forCategory(_selectedCategory);

    return AMModuleOverview(
      title: 'Artifacts',
      bannerPath: AMAssets.common.banner('artifacts_banner'),
      bannerTagline: 'Collect ancient relics. Gain unmatched strength.',
      description:
          'Record every Artifact and Crown. Only the selected '
          '5 Artifacts and 4 Crowns contribute to progress.',
      fallbackIcon: Icons.workspace_premium,
      onBack: () {
        context.go('/member/${widget.amId}');
      },
      progressContent: _OverallProgressCard(
        overallProgress: overallProgress,
        artifactProgress: artifactProgress,
        crownProgress: crownProgress,
        selectedArtifacts: selectedArtifacts,
        selectedCrowns: selectedCrowns,
      ),
      unsavedChangesContent: state.hasUnsavedChanges
          ? AMSaveCancelBar(
              onSave: controller.save,
              onCancel: controller.cancel,
            )
          : null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CategorySelector(
            selectedCategory: _selectedCategory,
            selectedArtifacts: selectedArtifacts,
            selectedCrowns: selectedCrowns,
            onChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: AMSpacing.lg),
          Text(
            _selectedCategory.pluralName.toUpperCase(),
            style: AMTextStyles.subtitle,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            _selectedCategory == ArtifactCategory.artifact
                ? 'Select up to 5 owned Artifacts for progress.'
                : 'Select up to 4 owned Crowns for progress.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          AMResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 2,
            children: visibleDefinitions.map((definition) {
              final itemState = state.item(definition.id);

              return _ArtifactOverviewCard(
                definition: definition,
                itemState: itemState,
                onOpen: () {
                  context.go(
                    '/member/${widget.amId}/artifacts/'
                    '${definition.id}',
                  );
                },
                onToggleSelection: () {
                  final error = controller.toggleSelection(
                    itemId: definition.id,
                  );

                  if (error == null || !context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard({
    required this.overallProgress,
    required this.artifactProgress,
    required this.crownProgress,
    required this.selectedArtifacts,
    required this.selectedCrowns,
  });

  final double overallProgress;
  final double artifactProgress;
  final double crownProgress;

  final int selectedArtifacts;
  final int selectedCrowns;

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
                child: const Icon(Icons.workspace_premium, size: 28),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERALL ARTIFACT PROGRESS',
                      style: AMTextStyles.subtitle,
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      'Stars only. Item levels are recorded but '
                      'excluded from progress.',
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
          const SizedBox(height: AMSpacing.lg),
          _ProgressSummaryRow(
            label: 'Artifacts ($selectedArtifacts / 5 selected)',
            progress: artifactProgress,
          ),
          const SizedBox(height: AMSpacing.md),
          _ProgressSummaryRow(
            label: 'Crowns ($selectedCrowns / 4 selected)',
            progress: crownProgress,
          ),
        ],
      ),
    );
  }
}

class _ProgressSummaryRow extends StatelessWidget {
  const _ProgressSummaryRow({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AMTextStyles.body)),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: AMTextStyles.muted,
            ),
          ],
        ),
        const SizedBox(height: AMSpacing.xs),
        AMProgressBar(progress: progress),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.selectedCategory,
    required this.selectedArtifacts,
    required this.selectedCrowns,
    required this.onChanged,
  });

  final ArtifactCategory selectedCategory;

  final int selectedArtifacts;
  final int selectedCrowns;

  final ValueChanged<ArtifactCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ArtifactCategory>(
      segments: [
        ButtonSegment<ArtifactCategory>(
          value: ArtifactCategory.artifact,
          icon: const Icon(Icons.auto_awesome),
          label: Text('Artifacts $selectedArtifacts/5'),
        ),
        ButtonSegment<ArtifactCategory>(
          value: ArtifactCategory.crown,
          icon: const Icon(Icons.workspace_premium),
          label: Text('Crowns $selectedCrowns/4'),
        ),
      ],
      selected: {selectedCategory},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        if (selection.isEmpty) {
          return;
        }

        onChanged(selection.first);
      },
    );
  }
}

class _ArtifactOverviewCard extends StatelessWidget {
  const _ArtifactOverviewCard({
    required this.definition,
    required this.itemState,
    required this.onOpen,
    required this.onToggleSelection,
  });

  final ArtifactItemDefinition definition;
  final ArtifactItemState itemState;

  final VoidCallback onOpen;
  final VoidCallback onToggleSelection;

  @override
  Widget build(BuildContext context) {
    final currentStage = ArtifactStarProgression.stageAt(
      rarity: definition.rarity,
      progressionIndex: itemState.starStageIndex,
    );

    final progress = ArtifactProgressService.itemProgress(
      definition: definition,
      state: itemState,
    );

    return AMCard(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AMSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompactArtifactArtwork(
                    definition: definition,
                    isSelected: itemState.isSelectedForProgress,
                  ),
                  const SizedBox(width: AMSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                definition.name,
                                style: AMTextStyles.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        const SizedBox(height: AMSpacing.xs),
                        _RarityBadge(rarity: definition.rarity),
                        const SizedBox(height: AMSpacing.sm),
                        Text(
                          itemState.isOwned
                              ? 'Level ${itemState.level} / '
                                    '${definition.maximumLevel}'
                              : 'Not owned',
                          style: AMTextStyles.body,
                        ),
                        const SizedBox(height: AMSpacing.xs),
                        Text(
                          currentStage.displayLabel,
                          style: AMTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AMSpacing.md),
              AMProgressBar(progress: progress),
              const SizedBox(height: AMSpacing.xs),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% '
                'star progress',
                style: AMTextStyles.muted,
              ),
              const SizedBox(height: AMSpacing.md),
              SizedBox(
                width: double.infinity,
                child: itemState.isSelectedForProgress
                    ? OutlinedButton.icon(
                        onPressed: onToggleSelection,
                        icon: const Icon(Icons.remove_circle_outline),
                        label: const Text('REMOVE FROM PROGRESS'),
                      )
                    : FilledButton.icon(
                        onPressed: itemState.isOwned ? onToggleSelection : null,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('SELECT FOR PROGRESS'),
                      ),
              ),
              if (!itemState.isOwned) ...[
                const SizedBox(height: AMSpacing.sm),
                Text(
                  'Open the item and set its level above 0 '
                  'before selecting it.',
                  style: AMTextStyles.muted,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactArtifactArtwork extends StatelessWidget {
  const _CompactArtifactArtwork({
    required this.definition,
    required this.isSelected,
  });

  final ArtifactItemDefinition definition;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 104,
          height: 104,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black.withValues(alpha: 0.20),
            border: Border.all(
              color: isSelected ? Colors.green : colorScheme.primary,
              width: isSelected ? 2 : 1.2,
            ),
          ),
          child: AMAssetImage(
            path: ArtifactAssetService.pathFor(definition),
            width: 96,
            height: 96,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(12),
            fallbackIcon: Icons.auto_awesome,
            fallbackIconSize: 42,
          ),
        ),
        if (isSelected)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(Icons.check, size: 17, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _RarityBadge extends StatelessWidget {
  const _RarityBadge({required this.rarity});

  final ArtifactRarity rarity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AMSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        rarity.displayName.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (rarity) {
      case ArtifactRarity.blue:
        return Colors.blue.withValues(alpha: 0.88);

      case ArtifactRarity.purple:
        return Colors.purple.withValues(alpha: 0.88);

      case ArtifactRarity.gold:
        return Colors.orange.withValues(alpha: 0.88);
    }
  }

  Color get _borderColor {
    switch (rarity) {
      case ArtifactRarity.blue:
        return Colors.lightBlueAccent;

      case ArtifactRarity.purple:
        return Colors.purpleAccent;

      case ArtifactRarity.gold:
        return Colors.amberAccent;
    }
  }
}
