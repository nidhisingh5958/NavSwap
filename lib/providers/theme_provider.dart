import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  const ThemeState({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  bool get isDark => themeMode == ThemeMode.dark;
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() => const ThemeState(themeMode: ThemeMode.dark);

  void setThemeMode(ThemeMode mode) {
    state = ThemeState(themeMode: mode);
  }

  void toggleTheme() {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    state = ThemeState(themeMode: newMode);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);
