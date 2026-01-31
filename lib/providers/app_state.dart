import 'package:flutter/material.dart';

enum Role { customer, driver, staff, admin, scanner }

extension RoleX on Role {
  String get label {
    switch (this) {
      case Role.customer:
        return 'Customer';
      case Role.driver:
        return 'Driver';
      case Role.staff:
        return 'Station Staff';
      case Role.admin:
        return 'Admin';
      case Role.scanner:
        return 'Battery Scanner';
    }
  }

  String get tagline {
    switch (this) {
      case Role.customer:
        return 'Fastest swap. Smartest route.';
      case Role.driver:
        return 'Move energy without delays.';
      case Role.staff:
        return 'Zero downtime operations.';
      case Role.admin:
        return 'Live control of the grid.';
      case Role.scanner:
        return 'Track every cell in motion.';
    }
  }

  bool get prefersDarkMode {
    switch (this) {
      case Role.customer:
        return false;
      case Role.driver:
      case Role.staff:
      case Role.admin:
      case Role.scanner:
        return true;
    }
  }
}

class AppState extends ChangeNotifier {
  Role _role = Role.customer;

  Role get role => _role;

  ThemeMode get themeMode =>
      _role.prefersDarkMode ? ThemeMode.dark : ThemeMode.light;

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
