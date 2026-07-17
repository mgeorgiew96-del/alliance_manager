import 'package:flutter/material.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';

class BeastTalentNode extends StatelessWidget {
  const BeastTalentNode({
    super.key,
    required this.name,
    required this.iconPath,
    required this.level,
    required this.maximumLevel,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String iconPath;
  final int level;
  final int maximumLevel;
  final bool isSelected;
  final VoidCallback onTap;

  bool get _isMaxed {
    return level >= maximumLevel;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = isSelected
        ? colorScheme.primary
        : _isMaxed
        ? Colors.green
        : Theme.of(context).dividerColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$name, level $level of $maximumLevel',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: isSelected ? 1.06 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 138,
            padding: const EdgeInsets.all(AMSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1.2,
              ),
              boxShadow: [
                if (_isMaxed)
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.28),
                    blurRadius: 18,
                  ),
                if (isSelected)
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.24),
                    blurRadius: 14,
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isMaxed ? Colors.green : colorScheme.primary,
                      width: 1.8,
                    ),
                  ),
                  child: ClipOval(
                    child: AMAssetImage(
                      path: iconPath,
                      size: 52,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.auto_awesome,
                      fallbackIconSize: 26,
                    ),
                  ),
                ),
                const SizedBox(height: AMSpacing.xs),
                Text(
                  name,
                  style: AMTextStyles.body,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AMSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AMSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    _isMaxed ? 'MAX' : '$level / $maximumLevel',
                    style: AMTextStyles.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
