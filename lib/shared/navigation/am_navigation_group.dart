import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_navigation_destination.dart';
import 'am_navigation_tile.dart';

class AMNavigationGroup extends StatelessWidget {
  const AMNavigationGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.destinations,
    required this.isExpanded,
    required this.isSelected,
    required this.onExpansionChanged,
    required this.onDestinationSelected,
    required this.isDestinationSelected,
    this.indent = 0,
  });

  final String title;
  final IconData icon;
  final List<AMNavigationDestination> destinations;

  final bool isExpanded;
  final bool isSelected;

  final VoidCallback onExpansionChanged;
  final ValueChanged<AMNavigationDestination> onDestinationSelected;
  final bool Function(AMNavigationDestination destination)
  isDestinationSelected;

  final double indent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onExpansionChanged,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AMSpacing.md,
                  vertical: AMSpacing.md,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: isSelected ? colorScheme.primary : null),
                    const SizedBox(width: AMSpacing.md),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AMTextStyles.body,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isSelected ? colorScheme.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                top: AMSpacing.xs,
                left: AMSpacing.md,
              ),
              child: Column(
                children: [
                  for (var index = 0; index < destinations.length; index++) ...[
                    AMNavigationTile(
                      destination: destinations[index],
                      isSelected: isDestinationSelected(destinations[index]),
                      isCompact: true,
                      onTap: () {
                        onDestinationSelected(destinations[index]);
                      },
                    ),
                    if (index < destinations.length - 1)
                      const SizedBox(height: AMSpacing.xs),
                  ],
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
