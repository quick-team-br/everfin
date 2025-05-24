import 'package:flutter/material.dart';

import 'package:desenrolai/core/theme/styles/button_styles.dart';
import 'package:desenrolai/core/theme/styles/text_styles.dart';

import 'app_colors.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackgroundPrimary,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        outline: AppColors.lightBorder,
        surface: AppColors.lightBackgroundTertiary,
        error: AppColors.red,
      ),
      dividerColor: AppColors.lightBorder,
      textTheme:
          TextStyles(
            primaryTextColor: AppColors.lightPrimaryText,
            secondaryTextColor: AppColors.lightSecondaryText,
          ).textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyles.elevated(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyles.outlined(AppColors.lightPrimaryText),
      ),
      cardColor: AppColors.lightBackgroundSecondary,
    );
  }
}
