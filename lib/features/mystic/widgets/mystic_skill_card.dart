import 'package:flutter/material.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../models/mystic_progress_config.dart';
import '../models/mystic_skill_definition.dart';

class MysticSkillCard extends StatelessWidget {
  const MysticSkillCard({
    super.key,
    required this.definition,
    required this.level,
    required this.config,
    required this.onDecrease,
    required this.onIncrease,
  });

  final MysticSkillDefinition definition;
  final int level;
  final MysticTrackedSkillConfig config;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  bool get _usesPercentage {
    return definition.skillNumber != 3 && definition.skillNumber != 5;
  }

  String get _currentValueText {
    final value = definition.valueAtLevel(level);
    final formatted = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);

    return '+$formatted${_usesPercentage ? '%' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final canDecrease = level > definition.minLevel;
    final canIncrease = level < definition.maxLevel;

    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkillIcon(definition: definition),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.name,
                      style: AMTextStyles.body.copyWith(
                        color: AMColors.goldLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      'Level $level / ${definition.maxLevel}',
                      style: AMTextStyles.muted.copyWith(
                        color: AMColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadges(config: config),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            definition.description,
            style: AMTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AMSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AMSpacing.md),
            decoration: BoxDecoration(
              color: AMColors.background.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT BONUS',
                        style: TextStyle(
                          color: AMColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: AMSpacing.xs),
                      Text(
                        _currentValueText,
                        style: const TextStyle(
                          color: AMColors.success,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                _LevelButton(
                  icon: Icons.remove,
                  enabled: canDecrease,
                  onPressed: onDecrease,
                ),
                Container(
                  width: 48,
                  alignment: Alignment.center,
                  child: Text(
                    '$level',
                    style: const TextStyle(
                      color: AMColors.goldLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _LevelButton(
                  icon: Icons.add,
                  enabled: canIncrease,
                  onPressed: onIncrease,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  const _SkillIcon({required this.definition});

  final MysticSkillDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AMColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AMColors.gold, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AMAssets.mystic.skill(
          troopId: definition.troopType.assetId,
          skillNumber: definition.skillNumber,
        ),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.auto_awesome, color: AMColors.gold, size: 32);
        },
      ),
    );
  }
}

class _StatusBadges extends StatelessWidget {
  const _StatusBadges({required this.config});

  final MysticTrackedSkillConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (config.isPriority)
          const _Badge(
            icon: Icons.star_rounded,
            label: 'Priority',
            color: AMColors.warning,
          ),
        if (config.isPriority && config.isTracked)
          const SizedBox(height: AMSpacing.xs),
        if (config.isTracked)
          const _Badge(
            icon: Icons.check_circle_outline,
            label: 'Tracked',
            color: AMColors.success,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  const _LevelButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      color: AMColors.goldLight,
      disabledColor: AMColors.textMuted,
      style: IconButton.styleFrom(
        backgroundColor: AMColors.blue,
        disabledBackgroundColor: AMColors.panelLight,
        side: BorderSide(color: enabled ? AMColors.gold : Colors.white12),
      ),
    );
  }
}
