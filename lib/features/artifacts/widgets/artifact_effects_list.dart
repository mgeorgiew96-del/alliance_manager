import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';

class ArtifactEffectsList extends StatelessWidget {
  const ArtifactEffectsList({
    super.key,
    required this.effects,
    required this.unlockedStars,
  });

  final List<String> effects;
  final int unlockedStars;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < effects.length; index++) ...[
          _ArtifactEffectRow(
            starNumber: index + 1,
            effect: effects[index],
            isUnlocked: unlockedStars >= index + 1,
          ),
          if (index < effects.length - 1) const SizedBox(height: AMSpacing.sm),
        ],
      ],
    );
  }
}

class _ArtifactEffectRow extends StatelessWidget {
  const _ArtifactEffectRow({
    required this.starNumber,
    required this.effect,
    required this.isUnlocked,
  });

  final int starNumber;
  final String effect;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final color = isUnlocked ? Colors.green : Theme.of(context).disabledColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isUnlocked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AMSpacing.sm),
        Text(
          '$starNumber★',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: AMSpacing.sm),
        Expanded(
          child: Text(
            effect,
            style: isUnlocked ? AMTextStyles.body : AMTextStyles.muted,
          ),
        ),
      ],
    );
  }
}
