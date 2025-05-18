import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:everfin/core/theme/styles/button_styles.dart';

import 'app_colors.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        outline: AppColors.darkBorder,
        surface: AppColors.darkBackgroundTertiary,
      ),
      dividerColor: AppColors.darkBorder,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        titleSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.lightText,
        ),
        labelMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightText,
        ),
        headlineSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightText,
        ),
        headlineMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.lightText,
        ),
        bodyMedium: const TextStyle(fontSize: 16, color: AppColors.fadedText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyles.elevated,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyles.outlined,
      ),
      cardColor: AppColors.darkBackgroundSecondary,
    );
  }
}
