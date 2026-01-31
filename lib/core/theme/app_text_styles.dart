import 'package:flutter/material.dart';

class AppTextStyles {
  static const String displayFont = 'Times New Roman';

  static TextStyle hero(Color color) => TextStyle(
    fontFamily: displayFont,
    fontSize: 40,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w500,
    height: 0.95,
    color: color,
  );

  static TextStyle headline(Color color) => TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle title(Color color) => TextStyle(
    fontSize: 16,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle body(Color color) =>
      TextStyle(fontSize: 14, height: 1.4, color: color);

  static TextStyle caption(Color color) =>
      TextStyle(fontSize: 12, letterSpacing: 1.2, color: color);
}
