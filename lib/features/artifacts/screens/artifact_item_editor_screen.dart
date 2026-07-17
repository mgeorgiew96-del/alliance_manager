import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/am_unsaved_changes_banner.dart';
import '../controllers/artifacts_controller.dart';
import '../definitions/artifact_catalog.dart';
import '../models/artifact_item_definition.dart';
import '../models/artifact_item_state.dart';
import '../models/artifact_star_stage.dart';
import '../models/artifacts_state.dart';
import '../services/artifact_asset_service.dart';
import '../services/artifact_progress_service.dart';
import '../widgets/artifact_effects_list.dart';
import '../widgets/artifact_star_stage_selector.dart';

class ArtifactItemEditorScreen extends ConsumerWidget {
  const ArtifactItemEditorScreen({
    super.key,
    required this.amId,
    required this.itemId,
  });

  final String amId;
  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artifactsState = ref.watch(artifactsControllerProvider);

    return artifactsState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text('Failed to load Artifact.', style: AMTextStyles.body),
        ),
      ),
      data: (state) {
        final definition = ArtifactCatalog.byId(itemId);

        return _ArtifactItemEditorView(
          amId: amId,
          definition: definition,
          state: state,
          itemState: state.item(itemId),
        );
      },
    );
  }
}

class _ArtifactItemEditorView extends ConsumerWidget {
  const _ArtifactItemEditorView({
    required this.amId,
    required this.definition,
    required this.state,
    required this.itemState,
  });

  final String amId;
  final ArtifactItemDefinition definition;
  final ArtifactsState state;
  final ArtifactItemState itemState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(artifactsControllerProvider.notifier);

    final currentStage = ArtifactStarProgression.stageAt(
      rarity: definition.rarity,
      progressionIndex: itemState.starStageIndex,
    );

    final progress = ArtifactProgressService.itemProgress(
      definition: definition,
      state: itemState,
    );

    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Back to Artifacts',
                  onPressed: () {
                    context.go('/member/$amId/artifacts');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: AMSpacing.sm),
                Expanded(
                  child: Text(
                    definition.name.toUpperCase(),
                    style: AMTextStyles.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.md),
            AMUnsavedChangesBanner(
              visible: state.hasUnsavedChanges,
              message: '${definition.name} has unsaved changes.',
            ),
            if (state.hasUnsavedChanges) ...[
              const SizedBox(height: AMSpacing.md),
              AMSaveCancelBar(
                onSave: controller.save,
                onCancel: controller.cancel,
              ),
            ],
            const SizedBox(height: AMSpacing.lg),
            _ArtifactHeroCard(
              definition: definition,
              itemState: itemState,
              currentStage: currentStage,
              progress: progress,
            ),
            const SizedBox(height: AMSpacing.lg),
            _LevelEditorCard(
              definition: definition,
              itemState: itemState,
              onDecrease: () {
                controller.decreaseLevel(itemId: definition.id);
              },
              onIncrease: () {
                controller.increaseLevel(itemId: definition.id);
              },
            ),
            const SizedBox(height: AMSpacing.lg),
            AMCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STAR PROGRESSION', style: AMTextStyles.subtitle),
                  const SizedBox(height: AMSpacing.xs),
                  Text(
                    itemState.isOwned
                        ? 'Select the current star or rank stage.'
                        : 'Set the item level above 0 before choosing stars.',
                    style: AMTextStyles.muted,
                  ),
                  const SizedBox(height: AMSpacing.md),
                  ArtifactStarStageSelector(
                    rarity: definition.rarity,
                    selectedStageIndex: itemState.starStageIndex,
                    enabled: itemState.isOwned,
                    onChanged: (value) {
                      controller.setStarStage(
                        itemId: definition.id,
                        progressionIndex: value,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AMSpacing.lg),
            AMCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STAR EFFECTS', style: AMTextStyles.subtitle),
                  const SizedBox(height: AMSpacing.md),
                  ArtifactEffectsList(
                    effects: definition.starEffects,
                    unlockedStars: currentStage.stars,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AMSpacing.lg),
            _SelectionCard(
              itemState: itemState,
              onToggle: () {
                final error = controller.toggleSelection(itemId: definition.id);

                if (error == null || !context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              },
            ),
            const SizedBox(height: AMSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _ArtifactHeroCard extends StatelessWidget {
  const _ArtifactHeroCard({
    required this.definition,
    required this.itemState,
    required this.currentStage,
    required this.progress,
  });

  final ArtifactItemDefinition definition;
  final ArtifactItemState itemState;
  final ArtifactStarStage currentStage;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withValues(alpha: 0.20),
              border: Border.all(color: colorScheme.primary, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 16,
                ),
              ],
            ),
            child: AMAssetImage(
              path: ArtifactAssetService.pathFor(definition),
              width: 168,
              height: 168,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(15),
              fallbackIcon: Icons.auto_awesome,
              fallbackIconSize: 64,
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            definition.name,
            style: AMTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${definition.rarity.displayName} '
            '${definition.category.displayName}',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            itemState.isOwned
                ? 'Level ${itemState.level} / '
                      '${definition.maximumLevel}'
                : 'Not owned',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(currentStage.displayLabel, style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.md),
          AMProgressBar(progress: progress),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% '
            'star progress',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

class _LevelEditorCard extends StatelessWidget {
  const _LevelEditorCard({
    required this.definition,
    required this.itemState,
    required this.onDecrease,
    required this.onIncrease,
  });

  final ArtifactItemDefinition definition;
  final ArtifactItemState itemState;

  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LEVEL', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            'Level is recorded only and does not affect progress.',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Decrease level',
                onPressed: itemState.level > 0 ? onDecrease : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: AMSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    '${itemState.level} / '
                    '${definition.maximumLevel}',
                    style: AMTextStyles.title,
                  ),
                ),
              ),
              const SizedBox(width: AMSpacing.md),
              IconButton.filled(
                tooltip: 'Increase level',
                onPressed: itemState.level < definition.maximumLevel
                    ? onIncrease
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({required this.itemState, required this.onToggle});

  final ArtifactItemState itemState;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROGRESS SELECTION', style: AMTextStyles.subtitle),
          const SizedBox(height: AMSpacing.xs),
          Text(
            itemState.isSelectedForProgress
                ? 'This item contributes to Artifact progress.'
                : 'This item is recorded but excluded from progress.',
            style: AMTextStyles.body,
          ),
          const SizedBox(height: AMSpacing.md),
          SizedBox(
            width: double.infinity,
            child: itemState.isSelectedForProgress
                ? OutlinedButton.icon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('REMOVE FROM PROGRESS'),
                  )
                : FilledButton.icon(
                    onPressed: itemState.isOwned ? onToggle : null,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('SELECT FOR PROGRESS'),
                  ),
          ),
        ],
      ),
    );
  }
}
