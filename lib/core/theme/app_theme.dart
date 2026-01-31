import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      cardColor: Colors.white,
      dividerColor: AppColors.line,
      colorScheme: const ColorScheme.light(
        primary: AppColors.ink,
        secondary: AppColors.inkSoft,
        surface: Colors.white,
        error: AppColors.critical,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.hero(AppColors.ink),
        headlineSmall: AppTextStyles.headline(AppColors.ink),
        titleSmall: AppTextStyles.title(AppColors.inkSoft),
        bodyMedium: AppTextStyles.body(AppColors.ink),
        bodySmall: AppTextStyles.caption(AppColors.fog),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.midnight,
      cardColor: AppColors.graphite,
      dividerColor: AppColors.line,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: AppColors.accent,
        surface: AppColors.graphite,
        error: AppColors.critical,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.hero(Colors.white),
        headlineSmall: AppTextStyles.headline(Colors.white),
        titleSmall: AppTextStyles.title(AppColors.accent),
        bodyMedium: AppTextStyles.body(AppColors.accent),
        bodySmall: AppTextStyles.caption(AppColors.fog),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.midnight,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.graphite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.graphite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
