import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'routes/app_routes.dart';
import 'screens/auth/role_gate.dart';

void main() {
  runApp(const NavSwapApp());
}

class NavSwapApp extends StatelessWidget {
  const NavSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    return AppStateScope(
      notifier: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            title: 'NAVSWAP',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: appState.themeMode,
            routes: AppRoutes.map,
            home: const RoleGateScreen(),
          );
        },
      ),
    );
  }
}
