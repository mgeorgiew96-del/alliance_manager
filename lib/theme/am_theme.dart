import 'package:flutter/material.dart';
import 'am_colors.dart';

class AMTheme {
  AMTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AMColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AMColors.gold,
      surface: AMColors.surface,
      error: AMColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AMColors.background,
      foregroundColor: AMColors.textPrimary,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AMColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AMColors.gold,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: AMColors.textPrimary, fontSize: 14),
      bodySmall: TextStyle(color: AMColors.textSecondary, fontSize: 12),
    ),
  );
}
