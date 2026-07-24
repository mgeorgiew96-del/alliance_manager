import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_primary_button.dart';
import '../models/mystic_troop_type.dart';

class MysticActivationCard extends StatelessWidget {
  const MysticActivationCard({
    super.key,
    required this.troopType,
    required this.isActive,
    required this.onActivate,
  });

  final MysticTroopType troopType;
  final bool isActive;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final isAngels = troopType == MysticTroopType.angels;

    return AMCard(
      padding: const EdgeInsets.all(AMSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 470;

          final information = Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive
                      ? AMColors.gold.withValues(alpha: 0.12)
                      : AMColors.panelLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? AMColors.gold : Colors.white12,
                  ),
                ),
                child: Icon(
                  isAngels
                      ? Icons.star_rounded
                      : isActive
                      ? Icons.check_circle
                      : Icons.shield_outlined,
                  color: isActive ? AMColors.gold : AMColors.textMuted,
                ),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      troopType.displayName,
                      style: AMTextStyles.body.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AMSpacing.xs),
                    Text(
                      isAngels
                          ? 'Always active • 20% of Mystic progress'
                          : isActive
                          ? 'Active • 40% of Mystic progress'
                          : 'Inactive • does not affect Mystic progress',
                      style: AMTextStyles.muted,
                    ),
                  ],
                ),
              ),
            ],
          );

          final action = isAngels
              ? const _StatusBadge(text: 'ALWAYS ACTIVE')
              : isActive
              ? const _StatusBadge(text: 'ACTIVE')
              : SizedBox(
                  width: compact ? double.infinity : 140,
                  child: AMPrimaryButton(
                    text: 'ACTIVATE',
                    onPressed: onActivate,
                  ),
                );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                information,
                const SizedBox(height: AMSpacing.md),
                action,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: information),
              const SizedBox(width: AMSpacing.md),
              action,
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AMSpacing.sm,
        vertical: AMSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AMColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AMColors.gold),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AMColors.goldLight,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
