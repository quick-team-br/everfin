import 'package:flutter/material.dart';

import 'package:everfin/core/theme/app_colors.dart';

class ButtonStyles {
  static final elevated = ElevatedButton.styleFrom(
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

  static final outlined = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    side: const BorderSide(color: AppColors.darkBorder),
    foregroundColor: AppColors.lightText,
  );
}
