import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_number_stepper.dart';
import '../models/totem_data.dart';
import '../models/totem_definition.dart';

class TotemSelectedCard extends StatelessWidget {
  const TotemSelectedCard({
    super.key,
    required this.roleLabel,
    required this.roleIcon,
    required this.accentColor,
    required this.definition,
    required this.data,
    required this.artworkSize,
    required this.onLevelChanged,
    required this.onSkillLevelChanged,
  });

  final String roleLabel;
  final IconData roleIcon;
  final Color accentColor;
  final TotemDefinition definition;
  final TotemData data;
  final double artworkSize;
  final ValueChanged<int> onLevelChanged;
  final ValueChanged<int> onSkillLevelChanged;

  String get _assetPath {
    return 'assets/images/totem/${definition.assetFileName}';
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.14),
                  border: Border.all(color: accentColor),
                ),
                child: Icon(roleIcon, color: accentColor, size: 21),
              ),
              const SizedBox(width: AMSpacing.sm),
              Expanded(
                child: Text(
                  roleLabel,
                  style: AMTextStyles.subtitle.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              _ActiveBadge(color: accentColor),
            ],
          ),
          const SizedBox(height: AMSpacing.lg),
          Center(
            child: AMAssetImage(
              path: _assetPath,
              size: artworkSize,
              fit: BoxFit.contain,
              fallbackIcon: Icons.account_balance_rounded,
              fallbackIconSize: artworkSize * 0.42,
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          Text(
            definition.name,
            textAlign: TextAlign.center,
            style: AMTextStyles.title.copyWith(fontSize: 23),
          ),
          const SizedBox(height: AMSpacing.xs),
          Text(
            '${definition.rarity.displayName} Totem',
            textAlign: TextAlign.center,
            style: AMTextStyles.muted.copyWith(
              color: accentColor.withValues(alpha: 0.82),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AMSpacing.lg),
          AMNumberStepper(
            label: 'Level',
            value: data.level.toDouble(),
            minValue: definition.minimumLevel.toDouble(),
            maxValue: definition.maximumLevel.toDouble(),
            step: definition.levelStep.toDouble(),
            decimalPlaces: 0,
            semanticLabel: '${definition.name} level',
            onChanged: (value) => onLevelChanged(value.round()),
          ),
          const SizedBox(height: AMSpacing.md),
          AMNumberStepper(
            label: 'Skill Level',
            value: data.skillLevel.toDouble(),
            minValue: definition.minimumSkillLevel.toDouble(),
            maxValue: definition.maximumSkillLevel.toDouble(),
            step: definition.skillLevelStep.toDouble(),
            decimalPlaces: 0,
            semanticLabel: '${definition.name} skill level',
            onChanged: (value) => onSkillLevelChanged(value.round()),
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Text(
        'ACTIVE',
        style: AMTextStyles.muted.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
