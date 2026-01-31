import 'package:flutter/material.dart';

class AppTextStyles {
  // Display — Hero titles
  static TextStyle displayLarge(Color color) => TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: color,
  );

  static TextStyle displayMedium(Color color) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.15,
    color: color,
  );

  // Headlines
  static TextStyle headlineLarge(Color color) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: color,
  );

  static TextStyle headlineMedium(Color color) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: color,
  );

  static TextStyle headlineSmall(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: color,
  );

  // Titles — Section headers
  static TextStyle titleLarge(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.3,
    color: color,
  );

  static TextStyle titleMedium(Color color) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.3,
    color: color,
  );

  // Body
  static TextStyle bodyLarge(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: color,
  );

  static TextStyle bodySmall(Color color) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: color,
  );

  // Labels
  static TextStyle labelLarge(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle labelMedium(Color color) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle labelSmall(Color color) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: color,
  );

  // Mono — for data/numbers
  static TextStyle mono(Color color, {double size = 14}) => TextStyle(
    fontFamily: 'SF Mono',
    fontSize: size,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color,
  );
}
