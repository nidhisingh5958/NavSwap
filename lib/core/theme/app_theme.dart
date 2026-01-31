import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      cardColor: Colors.white,
      dividerColor: AppColors.ink.withOpacity(0.1),
      colorScheme: const ColorScheme.light(
        primary: AppColors.ink,
        secondary: AppColors.inkSoft,
        surface: Colors.white,
        error: AppColors.critical,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(AppColors.ink),
        displayMedium: AppTextStyles.displayMedium(AppColors.ink),
        headlineLarge: AppTextStyles.headlineLarge(AppColors.ink),
        headlineMedium: AppTextStyles.headlineMedium(AppColors.ink),
        headlineSmall: AppTextStyles.headlineSmall(AppColors.ink),
        titleLarge: AppTextStyles.titleLarge(AppColors.inkSoft),
        titleMedium: AppTextStyles.titleMedium(AppColors.inkSoft),
        bodyLarge: AppTextStyles.bodyLarge(AppColors.ink),
        bodyMedium: AppTextStyles.bodyMedium(AppColors.inkSoft),
        bodySmall: AppTextStyles.bodySmall(AppColors.fog),
        labelLarge: AppTextStyles.labelLarge(AppColors.ink),
        labelMedium: AppTextStyles.labelMedium(AppColors.inkSoft),
        labelSmall: AppTextStyles.labelSmall(AppColors.fog),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(color: AppColors.ink.withValues(alpha: 0.08)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTextStyles.labelLarge(Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: AppColors.ink.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: BorderSide(color: AppColors.ink.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.fog,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.ink.withOpacity(0.08),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.midnight,
      cardColor: AppColors.graphite,
      dividerColor: AppColors.steel,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: AppColors.accent,
        surface: AppColors.graphite,
        error: AppColors.critical,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(Colors.white),
        displayMedium: AppTextStyles.displayMedium(Colors.white),
        headlineLarge: AppTextStyles.headlineLarge(Colors.white),
        headlineMedium: AppTextStyles.headlineMedium(Colors.white),
        headlineSmall: AppTextStyles.headlineSmall(Colors.white),
        titleLarge: AppTextStyles.titleLarge(AppColors.accent),
        titleMedium: AppTextStyles.titleMedium(AppColors.fog),
        bodyLarge: AppTextStyles.bodyLarge(Colors.white),
        bodyMedium: AppTextStyles.bodyMedium(AppColors.accent),
        bodySmall: AppTextStyles.bodySmall(AppColors.fog),
        labelLarge: AppTextStyles.labelLarge(Colors.white),
        labelMedium: AppTextStyles.labelMedium(AppColors.accent),
        labelSmall: AppTextStyles.labelSmall(AppColors.fog),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.midnight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: AppColors.graphite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: const BorderSide(color: AppColors.steel),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTextStyles.labelLarge(AppColors.ink),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.steel),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoal,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.steel),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.charcoal,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.fog,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.steel,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
