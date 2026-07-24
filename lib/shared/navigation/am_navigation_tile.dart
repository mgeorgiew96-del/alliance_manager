import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_navigation_destination.dart';

class AMNavigationTile extends StatelessWidget {
  const AMNavigationTile({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onTap,
    this.isCompact = false,
    this.indent = 0,
  });

  final AMNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  /// Compact tiles are used for destinations inside an expandable group.
  final bool isCompact;

  /// Additional indentation for nested navigation destinations.
  final double indent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;

    final iconColor = isSelected
        ? colorScheme.primary
        : destination.isAvailable
        ? null
        : disabledColor;

    final horizontalPadding = isCompact ? AMSpacing.sm : AMSpacing.md;
    final verticalPadding = isCompact ? AMSpacing.sm : AMSpacing.md;
    final iconSize = isCompact ? 20.0 : 24.0;
    final borderRadius = isCompact ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Material(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: isCompact ? 0.10 : 0.14)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                Icon(destination.icon, size: iconSize, color: iconColor),
                SizedBox(width: isCompact ? AMSpacing.sm : AMSpacing.md),
                Expanded(
                  child: Text(
                    destination.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: destination.isAvailable
                        ? AMTextStyles.body
                        : AMTextStyles.muted,
                  ),
                ),
                if (!destination.isAvailable)
                  Icon(
                    Icons.lock_clock_outlined,
                    size: isCompact ? 16 : 18,
                    color: disabledColor,
                  )
                else if (isSelected)
                  Icon(
                    Icons.chevron_right,
                    size: isCompact ? 18 : 24,
                    color: colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
