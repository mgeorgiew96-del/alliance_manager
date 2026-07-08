import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/game/game_info_button.dart';
import '../../../shared/widgets/game/game_level_stepper.dart';
import '../../../shared/widgets/game/game_progress_bar.dart';
import '../models/beast_skill_model.dart';

class BeastSkillCard extends StatelessWidget {
  const BeastSkillCard({
    super.key,
    required this.skill,
    required this.onIncrease,
    required this.onDecrease,
  });

  final BeastSkillModel skill;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final progress = (skill.level / skill.maxLevel) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: AMSpacing.md),
      child: AMCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    skill.name,
                    style: AMTextStyles.subtitle,
                  ),
                ),
                GameInfoButton(
                  title: skill.name,
                  description:
                      'Description will come from the Encyclopedia database.',
                ),
              ],
            ),

            const SizedBox(height: AMSpacing.md),

            GameProgressBar(
              label: 'Progress',
              progress: progress,
            ),

            const SizedBox(height: AMSpacing.md),

            Center(
              child: GameLevelStepper(
                level: skill.level,
                minLevel: 1,
                maxLevel: skill.maxLevel,
                onDecrease: onDecrease,
                onIncrease: onIncrease,
              ),
            ),
          ],
        ),
      ),
    );
  }
}