import 'package:flutter/material.dart';

import 'am_colors.dart';

class AMTextStyles {
  static const title = TextStyle(
    color: AMColors.goldLight,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.6,
  );

  static const subtitle = TextStyle(
    color: AMColors.textSecondary,
    fontSize: 14,
  );

  static const body = TextStyle(color: AMColors.textPrimary, fontSize: 14);

  static const muted = TextStyle(color: AMColors.textMuted, fontSize: 12);

  static const button = TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
