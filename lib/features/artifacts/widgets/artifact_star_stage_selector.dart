import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../models/artifact_rarity.dart';
import '../models/artifact_star_stage.dart';

class ArtifactStarStageSelector extends StatelessWidget {
  const ArtifactStarStageSelector({
    super.key,
    required this.rarity,
    required this.selectedStageIndex,
    required this.enabled,
    required this.onChanged,
  });

  final ArtifactRarity rarity;
  final int selectedStageIndex;
  final bool enabled;

  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final stages = ArtifactStarProgression.forRarity(rarity);

    return Wrap(
      spacing: AMSpacing.sm,
      runSpacing: AMSpacing.sm,
      children: [
        for (final stage in stages)
          ChoiceChip(
            selected: stage.progressionIndex == selectedStageIndex,
            label: Text(stage.compactLabel, style: AMTextStyles.body),
            onSelected: enabled
                ? (_) {
                    onChanged(stage.progressionIndex);
                  }
                : null,
          ),
      ],
    );
  }
}
