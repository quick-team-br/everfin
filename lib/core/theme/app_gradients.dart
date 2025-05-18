import 'package:flutter/material.dart';

import 'package:everfin/core/theme/app_colors.dart';

class AppGradients {
  static const primary = LinearGradient(
    colors: [Color(0xFF2C9BFC), Color(0xFF1C5BEE)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  static const red = LinearGradient(
    colors: [Color(0xFFF35C5C), Color(0xFFE53838)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  static const primaryToTransparentTop = LinearGradient(
    colors: [AppColors.primary, Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0.0, .75],
  );
}
