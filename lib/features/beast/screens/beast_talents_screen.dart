import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/am_unsaved_changes_banner.dart';
import '../controllers/beast_controller.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_state.dart';
import '../models/beast_type.dart';
import '../widgets/beast_talent_tree.dart';
import '../../../shared/widgets/am_progress_editor_card.dart';

class BeastTalentsScreen extends ConsumerStatefulWidget {
  const BeastTalentsScreen({
    super.key,
    required this.amId,
    required this.beastType,
  });

  final String amId;
  final BeastType beastType;

  @override
  ConsumerState<BeastTalentsScreen> createState() {
    return _BeastTalentsScreenState();
  }
}

class _BeastTalentsScreenState extends ConsumerState<BeastTalentsScreen> {
  String? _selectedTalentId;

  @override
  Widget build(BuildContext context) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text(
            'Failed to load Beast talents.',
            style: AMTextStyles.body,
          ),
        ),
      ),
      data: (state) {
        return _buildContent(context: context, state: state);
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required BeastState state,
  }) {
    final controller = ref.read(beastControllerProvider.notifier);

    final talents = talentDefinitionsForBeast(widget.beastType);

    if (talents.isEmpty) {
      return const AMPage(
        child: Center(
          child: Text('No talents are available.', style: AMTextStyles.body),
        ),
      );
    }

    _selectedTalentId ??= talents.first.id;

    final selectedTalent = talents.firstWhere(
      (talent) => talent.id == _selectedTalentId,
      orElse: () => talents.first,
    );

    int levelForTalent(String talentId) {
      return state.talentLevels[talentId] ?? 0;
    }

    final currentTotal = talents.fold<int>(0, (sum, talent) {
      return sum + levelForTalent(talent.id);
    });

    final maximumTotal = talents.fold<int>(0, (sum, talent) {
      return sum + talent.maxLevel;
    });

    final progress = maximumTotal == 0 ? 0.0 : currentTotal / maximumTotal;

    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Back to Beast',
                  onPressed: () {
                    context.go('/member/${widget.amId}/beast');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: AMSpacing.sm),
                Expanded(
                  child: Text(
                    '${_beastName(widget.beastType).toUpperCase()} '
                    'TALENTS',
                    style: AMTextStyles.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AMSpacing.md),
            AMModuleHeader(
              title: 'TALENT TREE',
              progress: progress,
              lastUpdated: _lastUpdatedText(state.lastUpdated),
              hasUnsavedChanges: state.hasUnsavedChanges,
            ),
            AMUnsavedChangesBanner(
              visible: state.hasUnsavedChanges,
              message:
                  '${_beastName(widget.beastType)} talents '
                  'have unsaved changes.',
            ),
            if (state.hasUnsavedChanges) ...[
              const SizedBox(height: AMSpacing.md),
              AMSaveCancelBar(
                onSave: controller.save,
                onCancel: controller.cancel,
              ),
            ],
            const SizedBox(height: AMSpacing.lg),
            Text(
              'Tap a talent node to select it. '
              'Edit the selected talent below the tree.',
              style: AMTextStyles.body,
            ),
            const SizedBox(height: AMSpacing.lg),
            BeastTalentTree(
              beastType: widget.beastType,
              talents: talents,
              selectedTalentId: selectedTalent.id,
              levelForTalent: levelForTalent,
              onTalentSelected: (talent) {
                setState(() {
                  _selectedTalentId = talent.id;
                });
              },
            ),
            AMProgressEditorCard(
              title: selectedTalent.name,
              currentValue: levelForTalent(selectedTalent.id),
              maximumValue: selectedTalent.maxLevel,
              description:
                  'Upgrade ${selectedTalent.name} to strengthen your Beast '
                  'talent build.',
              onIncrease: () {
                controller.increaseTalent(
                  talentId: selectedTalent.id,
                  maxLevel: selectedTalent.maxLevel,
                );
              },
              onDecrease: () {
                controller.decreaseTalent(talentId: selectedTalent.id);
              },
            ),
            const SizedBox(height: AMSpacing.lg),
          ],
        ),
      ),
    );
  }
}

String _lastUpdatedText(DateTime? lastUpdated) {
  if (lastUpdated == null) {
    return 'Not saved yet';
  }

  return '${lastUpdated.day.toString().padLeft(2, '0')}.'
      '${lastUpdated.month.toString().padLeft(2, '0')}.'
      '${lastUpdated.year} '
      '${lastUpdated.hour.toString().padLeft(2, '0')}:'
      '${lastUpdated.minute.toString().padLeft(2, '0')}';
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
