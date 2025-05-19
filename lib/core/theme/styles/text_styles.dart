import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  final Color primaryTextColor;
  final Color secondaryTextColor;

  TextStyles({
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: secondaryTextColor),
  );
}
