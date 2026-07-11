import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/beast_controller.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_state.dart';
import '../models/beast_type.dart';
import '../widgets/beast_talent_card.dart';

class BeastTalentsScreen extends ConsumerWidget {
  const BeastTalentsScreen({
    super.key,
    required this.beastType,
  });

  final BeastType beastType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () => const AMPage(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text(
            'Failed to load Beast talents.',
            style: AMTextStyles.body,
          ),
        ),
      ),
      data: (state) => _BeastTalentsView(
        beastType: beastType,
        state: state,
      ),
    );
  }
}

class _BeastTalentsView extends ConsumerWidget {
  const _BeastTalentsView({
    required this.beastType,
    required this.state,
  });

  final BeastType beastType;
  final BeastState state;

  int _levelFor(String talentId) {
    return state.talentLevels[talentId] ?? 0;
  }

  double get _progress {
    final talents = talentDefinitionsForBeast(beastType);

    var current = 0;
    var maximum = 0;

    for (final talent in talents) {
      current += _levelFor(talent.id);
      maximum += talent.maxLevel;
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
    final talents = talentDefinitionsForBeast(beastType);

    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AMModuleHeader(
              title: '${beastType.name.toUpperCase()} TALENTS',
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

            for (final talent in talents)
              BeastTalentCard(
                talent: talent,
                level: _levelFor(talent.id),
                onIncrease: () => controller.increaseTalent(
                  talentId: talent.id,
                  maxLevel: talent.maxLevel,
                ),
                onDecrease: () => controller.decreaseTalent(
                  talentId: talent.id,
                ),
              ),
          ],
        ),
      ),
    );
  }
}