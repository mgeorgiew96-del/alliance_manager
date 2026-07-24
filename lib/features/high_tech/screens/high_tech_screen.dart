import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_overview.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/high_tech_controller.dart';
import '../models/high_tech_progress_config.dart';
import '../services/high_tech_progress_service.dart';
import '../widgets/high_tech_tree.dart';

class HighTechScreen extends ConsumerWidget {
  const HighTechScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  static const String bannerAssetPath =
      'assets/images/banners/high_tech_banner.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(highTechControllerProvider);

    return asyncState.when(
      loading: () => AMModuleOverview(
        title: 'High Tech',
        bannerPath: bannerAssetPath,
        bannerTagline: '',
        description: '',
        fallbackIcon: Icons.account_tree_outlined,
        onBack: () {
          context.go('/member/$amId');
        },
        progressContent: const Center(child: CircularProgressIndicator()),
        content: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => AMModuleOverview(
        title: 'High Tech',
        bannerPath: bannerAssetPath,
        bannerTagline: '',
        description: '',
        fallbackIcon: Icons.account_tree_outlined,
        onBack: () {
          context.go('/member/$amId');
        },
        progressContent: AMCard(
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 42),
              const SizedBox(height: AMSpacing.md),
              Text(
                'High Tech could not be loaded.',
                style: AMTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AMSpacing.sm),
              Text(
                '$error',
                style: AMTextStyles.muted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        content: const SizedBox.shrink(),
      ),
      data: (state) {
        final controller = ref.read(highTechControllerProvider.notifier);
        final progressConfig = HighTechProgressConfig.initial();
        final progress = HighTechProgressService.calculateOverallProgress(
          state: state,
          config: progressConfig,
        );

        return AMModuleOverview(
          title: 'High Tech',
          bannerPath: bannerAssetPath,
          bannerTagline: '',
          description: '',
          fallbackIcon: Icons.account_tree_outlined,
          onBack: () {
            context.go('/member/$amId');
          },
          progressContent: _HighTechProgressCard(
            progress: progress,
            trackedCount: HighTechProgressService.trackedCount(progressConfig),
            priorityCount:
                HighTechProgressService.priorityCount(progressConfig),
          ),
          unsavedChangesContent: state.hasUnsavedChanges
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '● Unsaved High Tech changes',
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
          content: const _TreeSection(),
        );
      },
    );
  }
}

class _HighTechProgressCard extends StatelessWidget {
  const _HighTechProgressCard({
    required this.progress,
    required this.trackedCount,
    required this.priorityCount,
  });

  final double progress;
  final int trackedCount;
  final int priorityCount;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'OVERALL HIGH TECH PROGRESS',
                  style: AMTextStyles.subtitle,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.title,
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          AMProgressBar(progress: progress),
          const SizedBox(height: AMSpacing.sm),
          Text(
            '$trackedCount tracked • $priorityCount priority',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

class _TreeSection extends StatelessWidget {
  const _TreeSection();

  @override
  Widget build(BuildContext context) {
    return const AMCard(
      child: SizedBox(
        height: 680,
        child: _TreeViewport(),
      ),
    );
  }
}

class _TreeViewport extends ConsumerWidget {
  const _TreeViewport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(highTechControllerProvider).asData?.value;

    if (state == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(child: HighTechTree(state: state)),
          const Positioned(
            right: 14,
            bottom: 14,
            child: _PanZoomHint(),
          ),
        ],
      ),
    );
  }
}

class _PanZoomHint extends StatelessWidget {
  const _PanZoomHint();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xDD17130F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6F5832)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.open_with, size: 15, color: Color(0xFFC89B4A)),
            SizedBox(width: 6),
            Text(
              'Drag and pinch to explore',
              style: TextStyle(color: Color(0xFFE5D5B1), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
