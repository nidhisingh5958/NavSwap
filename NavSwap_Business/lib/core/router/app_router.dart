import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/queue/presentation/screens/queue_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/faults/presentation/screens/faults_screen.dart';
import '../../features/actions/presentation/screens/actions_screen.dart';
import '../../features/scanner/presentation/screens/scanner_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String?;
          return OtpScreen(phoneNumber: phone ?? '');
        },
      ),
      GoRoute(
        path: '/staff/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/staff/queue',
        builder: (context, state) => const QueueScreen(),
      ),
      GoRoute(
        path: '/staff/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/staff/faults',
        builder: (context, state) => const FaultsScreen(),
      ),
      GoRoute(
        path: '/staff/actions',
        builder: (context, state) => const ActionsScreen(),
      ),
      GoRoute(
        path: '/staff/scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/staff/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/staff/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
});
