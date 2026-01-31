import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { customer, driver, staff, admin, scanner }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.customer => 'Customer',
    UserRole.driver => 'Driver',
    UserRole.staff => 'Station Staff',
    UserRole.admin => 'Admin',
    UserRole.scanner => 'Battery Scanner',
  };

  String get tagline => switch (this) {
    UserRole.customer => 'Fastest swap. Smartest route.',
    UserRole.driver => 'Move energy without delays.',
    UserRole.staff => 'Zero downtime operations.',
    UserRole.admin => 'Live control of the grid.',
    UserRole.scanner => 'Track every cell in motion.',
  };

  IconData get icon => switch (this) {
    UserRole.customer => Icons.person_outline_rounded,
    UserRole.driver => Icons.local_shipping_outlined,
    UserRole.staff => Icons.engineering_outlined,
    UserRole.admin => Icons.dashboard_outlined,
    UserRole.scanner => Icons.qr_code_scanner_rounded,
  };

  bool get prefersDarkMode => switch (this) {
    UserRole.customer => false,
    UserRole.driver ||
    UserRole.staff ||
    UserRole.admin ||
    UserRole.scanner => true,
  };

  String get homeRoute => switch (this) {
    UserRole.customer => '/customer/home',
    UserRole.driver => '/driver/dashboard',
    UserRole.staff => '/staff/dashboard',
    UserRole.admin => '/admin/control',
    UserRole.scanner => '/scanner',
  };
}

@immutable
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.role,
    this.userId,
    this.userName,
  });

  final bool isAuthenticated;
  final UserRole? role;
  final String? userId;
  final String? userName;

  AuthState copyWith({
    bool? isAuthenticated,
    UserRole? role,
    String? userId,
    String? userName,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void login(UserRole role, {String? userId, String? userName}) {
    state = AuthState(
      isAuthenticated: true,
      role: role,
      userId: userId ?? 'user_${role.name}',
      userName: userName ?? role.label,
    );
  }

  void logout() {
    state = const AuthState();
  }

  void switchRole(UserRole role) {
    state = state.copyWith(role: role);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
