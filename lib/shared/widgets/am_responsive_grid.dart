import 'package:flutter/material.dart';

import '../layout/responsive_breakpoints.dart';
import '../theme/am_spacing.dart';

class AMResponsiveGrid extends StatelessWidget {
  const AMResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 2,
    this.spacing = AMSpacing.md,
    this.runSpacing = AMSpacing.md,
    this.childAspectRatio,
  });

  final List<Widget> children;

  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  final double spacing;
  final double runSpacing;

  final double? childAspectRatio;

  int _columnCountForWidth(double width) {
    if (width >= ResponsiveBreakpoints.desktop) {
      return desktopColumns;
    }

    if (width >= ResponsiveBreakpoints.tablet) {
      return tabletColumns;
    }

    return mobileColumns;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = _columnCountForWidth(constraints.maxWidth);

        if (children.isEmpty) {
          return const SizedBox.shrink();
        }

        final totalHorizontalSpacing = spacing * (columnCount - 1);

        final itemWidth =
            (constraints.maxWidth - totalHorizontalSpacing) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            if (childAspectRatio == null) {
              return SizedBox(width: itemWidth, child: child);
            }

            return SizedBox(
              width: itemWidth,
              child: AspectRatio(aspectRatio: childAspectRatio!, child: child),
            );
          }).toList(),
        );
      },
    );
  }
}
