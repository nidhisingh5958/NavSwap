import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/customer/customer_home_screen.dart';
import '../features/customer/station_detail_screen.dart';
import '../features/customer/history_screen.dart';
import '../features/customer/ai_chat_screen.dart';
import '../features/driver/driver_dashboard_screen.dart';
import '../features/driver/task_detail_screen.dart';
import '../features/staff/staff_dashboard_screen.dart';
import '../features/staff/faults_screen.dart';
import '../features/staff/actions_screen.dart';
import '../features/admin/admin_control_screen.dart';
import '../features/admin/logistics_screen.dart';
import '../features/admin/staff_management_screen.dart';
import '../features/admin/alerts_screen.dart';
import '../features/scanner/scanner_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return authState.role?.homeRoute ?? '/customer/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Customer routes
      GoRoute(
        path: '/customer/home',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/station/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StationDetailScreen(stationId: id);
        },
      ),
      GoRoute(
        path: '/customer/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/customer/ai-chat',
        builder: (context, state) => const AiChatScreen(),
      ),

      // Driver routes
      GoRoute(
        path: '/driver/dashboard',
        builder: (context, state) => const DriverDashboardScreen(),
      ),
      GoRoute(
        path: '/driver/task/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),

      // Staff routes
      GoRoute(
        path: '/staff/dashboard',
        builder: (context, state) => const StaffDashboardScreen(),
      ),
      GoRoute(
        path: '/staff/faults',
        builder: (context, state) => const FaultsScreen(),
      ),
      GoRoute(
        path: '/staff/actions',
        builder: (context, state) => const ActionsScreen(),
      ),

      // Admin routes
      GoRoute(
        path: '/admin/control',
        builder: (context, state) => const AdminControlScreen(),
      ),
      GoRoute(
        path: '/admin/logistics',
        builder: (context, state) => const LogisticsScreen(),
      ),
      GoRoute(
        path: '/admin/staff',
        builder: (context, state) => const StaffManagementScreen(),
      ),
      GoRoute(
        path: '/admin/alerts',
        builder: (context, state) => const AlertsScreen(),
      ),

      // Scanner route
      GoRoute(
        path: '/scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
    ],
  );
});
