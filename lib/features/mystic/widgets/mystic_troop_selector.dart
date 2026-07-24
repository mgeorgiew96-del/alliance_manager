import 'package:flutter/material.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../models/mystic_troop_type.dart';

class MysticTroopSelector extends StatelessWidget {
  const MysticTroopSelector({
    super.key,
    required this.selectedTroop,
    required this.activeTroops,
    required this.progressForTroop,
    required this.onSelected,
  });

  final MysticTroopType selectedTroop;
  final Set<MysticTroopType> activeTroops;
  final double Function(MysticTroopType troopType) progressForTroop;
  final ValueChanged<MysticTroopType> onSelected;

  bool _isActive(MysticTroopType troop) {
    return troop == MysticTroopType.angels || activeTroops.contains(troop);
  }

  String _statusFor(MysticTroopType troop) {
    if (troop == MysticTroopType.angels) {
      return 'ALWAYS ACTIVE';
    }

    return _isActive(troop) ? 'ACTIVE' : 'INACTIVE';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 5 : 3;
        final spacing = AMSpacing.sm;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: MysticTroopType.values
              .map((troop) {
                final isSelected = troop == selectedTroop;
                final isActive = _isActive(troop);
                final progress = progressForTroop(troop);

                return SizedBox(
                  width: itemWidth,
                  child: InkWell(
                    onTap: () => onSelected(troop),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      constraints: const BoxConstraints(minHeight: 92),
                      padding: const EdgeInsets.all(AMSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AMColors.blue : AMColors.panelLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AMColors.gold
                              : isActive
                              ? AMColors.gold.withValues(alpha: 0.55)
                              : Colors.white12,
                          width: isSelected ? 1.4 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            troop.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? AMColors.goldLight
                                  : AMColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: AMSpacing.xs),
                          Text(
                            '${(progress.clamp(0, 1) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: AMColors.goldLight,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: AMSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                troop == MysticTroopType.angels
                                    ? Icons.star_rounded
                                    : isActive
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 13,
                                color: isActive
                                    ? AMColors.gold
                                    : AMColors.textMuted,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  _statusFor(troop),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isActive
                                        ? AMColors.gold
                                        : AMColors.textMuted,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}
