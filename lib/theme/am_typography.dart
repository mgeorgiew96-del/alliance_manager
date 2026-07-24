import 'package:flutter/material.dart';

import 'am_colors.dart';

class AMTypography {
  AMTypography._();

  static const TextStyle title = TextStyle(
    color: AMColors.gold,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: AMColors.textSecondary,
    fontSize: 16,
  );

  static const TextStyle body = TextStyle(
    color: AMColors.textPrimary,
    fontSize: 14,
  );

  static const TextStyle small = TextStyle(
    color: AMColors.textSecondary,
    fontSize: 12,
  );
}
