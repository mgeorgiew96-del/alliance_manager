import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_number_stepper.dart';
import '../models/totem_data.dart';
import '../models/totem_definition.dart';

class TotemCard extends StatelessWidget {
  const TotemCard({
    super.key,
    required this.definition,
    required this.data,
    required this.isPrimary,
    required this.isSecondary,
    required this.accentColor,
    required this.onLevelChanged,
    required this.onSkillLevelChanged,
    required this.onSetPrimary,
    required this.onSetSecondary,
  });

  final TotemDefinition definition;
  final TotemData data;
  final bool isPrimary;
  final bool isSecondary;
  final Color accentColor;
  final ValueChanged<int> onLevelChanged;
  final ValueChanged<int> onSkillLevelChanged;
  final VoidCallback onSetPrimary;
  final VoidCallback onSetSecondary;

  String get _assetPath {
    return 'assets/images/totem/${definition.assetFileName}';
  }

  @override
  Widget build(BuildContext context) {
    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.name,
                      style: AMTextStyles.title.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      '${definition.rarity.displayName} Totem',
                      style: AMTextStyles.muted.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPrimary)
                _RoleBadge(label: 'PRIMARY', color: AMColors.gold)
              else if (isSecondary)
                _RoleBadge(label: 'SECONDARY', color: AMColors.blueLight),
            ],
          ),
          const SizedBox(height: AMSpacing.md),
          Center(
            child: AMAssetImage(
              path: _assetPath,
              size: 112,
              fit: BoxFit.contain,
              fallbackIcon: Icons.account_balance_rounded,
              fallbackIconSize: 46,
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          AMNumberStepper(
            label: 'Level',
            value: data.level.toDouble(),
            minValue: definition.minimumLevel.toDouble(),
            maxValue: definition.maximumLevel.toDouble(),
            step: definition.levelStep.toDouble(),
            decimalPlaces: 0,
            compact: true,
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
            compact: true,
            semanticLabel: '${definition.name} skill level',
            onChanged: (value) => onSkillLevelChanged(value.round()),
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isPrimary ? null : onSetPrimary,
                  child: Text(isPrimary ? 'PRIMARY' : 'SET PRIMARY'),
                ),
              ),
              const SizedBox(width: AMSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: isSecondary ? null : onSetSecondary,
                  child: Text(isSecondary ? 'SECONDARY' : 'SET SECONDARY'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.72)),
      ),
      child: Text(
        label,
        style: AMTextStyles.muted.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }
}
