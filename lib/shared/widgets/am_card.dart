import 'package:flutter/material.dart';

import '../theme/am_colors.dart';

class AMCard extends StatelessWidget {
  const AMCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AMColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AMColors.gold, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
