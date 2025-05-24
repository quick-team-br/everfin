import 'package:flutter/material.dart';

import 'package:desenrolai/core/theme/app_colors.dart';

class ButtonStyles {
  static ButtonStyle elevated() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    );
  }

  static ButtonStyle outlined(Color primaryText) {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // side: const BorderSide(color: AppColors.darkBorder),
      foregroundColor: primaryText,
    );
  }
}
