import 'package:flutter/material.dart';

import 'package:desenrolai/core/theme/styles/button_styles.dart';
import 'package:desenrolai/core/theme/styles/text_styles.dart';

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
        error: AppColors.red,
      ),
      dividerColor: AppColors.darkBorder,
      textTheme:
          TextStyles(
            primaryTextColor: AppColors.darkPrimaryText,
            secondaryTextColor: AppColors.darkSecondaryText,
          ).textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyles.elevated(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyles.outlined(AppColors.darkPrimaryText),
      ),
      cardColor: AppColors.darkBackgroundSecondary,
    );
  }
}
