import 'package:flutter/material.dart';

class AppColors {
  // Core palette — dark ops console aesthetic
  static const Color midnight = Color(0xFF000000);
  static const Color charcoal = Color(0xFF0A0A0A);
  static const Color graphite = Color(0xFF141414);
  static const Color slate = Color(0xFF1E1E1E);
  static const Color steel = Color(0xFF2A2A2A);

  // Light mode palette
  static const Color paper = Color(0xFFF7F7F2);
  static const Color cream = Color(0xFFFAFAFA);
  static const Color ink = Color(0xFF0A0A0A);
  static const Color inkSoft = Color(0xFF3A3A3A);

  // Accent & semantic
  static const Color accent = Color(0xFFE8E8E8);
  static const Color fog = Color(0xFF8A8A8A);
  static const Color line = Color(0xFF2A2A2A);
  static const Color lineSoft = Color(0xFF1A1A1A);

  // Status colors
  static const Color healthy = Color(0xFF00D26A);
  static const Color critical = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);
  static const Color info = Color(0xFF007AFF);

  // Gradients for cards
  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFF5F5F5)],
  );
}
