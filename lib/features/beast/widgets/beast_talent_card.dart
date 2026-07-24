import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../models/definitions/beast_talent_definition.dart';

class BeastTalentCard extends StatelessWidget {
  const BeastTalentCard({
    super.key,
    required this.talent,
    required this.level,
    required this.onIncrease,
    required this.onDecrease,
  });

  final BeastTalentDefinition talent;
  final int level;

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final progress = talent.maxLevel == 0 ? 0.0 : level / talent.maxLevel;

    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: AMCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              talent.name,
              style: AMTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AMSpacing.sm),
            Text('Lv $level / ${talent.maxLevel}', style: AMTextStyles.body),
            const SizedBox(height: AMSpacing.sm),
            AMProgressBar(progress: progress),
            const SizedBox(height: AMSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: level > 0 ? onDecrease : null,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: level < talent.maxLevel ? onIncrease : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
