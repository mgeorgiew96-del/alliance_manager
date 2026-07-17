import 'package:flutter/material.dart';

import '../../theme/am_spacing.dart';
import '../../theme/am_text_styles.dart';

class GameLevelStepper extends StatelessWidget {
  const GameLevelStepper({
    super.key,
    required this.level,
    required this.minLevel,
    required this.maxLevel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int level;
  final int minLevel;
  final int maxLevel;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final canDecrease = level > minLevel;
    final canIncrease = level < maxLevel;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: canDecrease ? onDecrease : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$level / $maxLevel', style: AMTextStyles.body),
        const SizedBox(width: AMSpacing.sm),
        IconButton(
          onPressed: canIncrease ? onIncrease : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
