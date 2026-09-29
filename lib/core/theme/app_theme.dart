import 'package:flutter/material.dart';

class AppColors {
  // Primary brand brown (#7F4D2C with alpha ~75%)
  static const Color primaryBrown = Color(0xC17F4D2C);
  static const Color solidBrown = Color(0xFF7F4D2C);
  static const Color darkBrown = Color(0xFF3E2723);

  // Translucent backgrounds matching Android drawables
  // category_btn.xml: #90FFFFFF
  static const Color categoryBtnBg = Color(0x90FFFFFF);
  // main_menu_btn.xml: #BFFFFFFF
  static const Color mainMenuBtnBg = Color(0xBFFFFFFF);
  // sub_btn_menu.xml: #77FFFFFF
  static const Color subMenuBtnBg = Color(0x77FFFFFF);

  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textBlack = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color borderBrown = Color(0x807F4D2C);

  static const double borderRadius = 20.0;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoKufi',
      scaffoldBackgroundColor: const Color(0xFFF7F4EF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.solidBrown,
        primary: AppColors.solidBrown,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'NotoKufi',
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'NotoKufi',
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        titleLarge: TextStyle(
          fontFamily: 'NotoKufi',
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'NotoKufi',
          fontWeight: FontWeight.normal,
          color: AppColors.textDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'NotoKufi',
          fontWeight: FontWeight.normal,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
