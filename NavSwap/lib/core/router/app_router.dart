import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navswap_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/ai_chatbot_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/customer_profile_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/favorites_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/history_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/notifications_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/queue_status_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/station_detail_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/station_list_screen.dart';
import 'package:navswap_app/features/customer/presentation/screens/station_map_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/performance_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/task_detail_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/task_list_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/transport_history_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/transporter_dashboard_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/transporter_profile_screen.dart';
import 'package:navswap_app/features/transporter/presentation/screens/transporter_verification_screen.dart';

import '../../features/role/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';

// Customer Screens
import '../../features/customer/home/presentation/screens/customer_home_screen.dart';

// Transporter Screens

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/customer/home',
    routes: [
      // Splash & Role Selection
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-select',
        name: 'role-select',
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // Authentication Flow
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'customer';
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'customer';
          return SignupScreen(role: role);
        },
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpScreen(
            phoneNumber: extra['phone'],
          );
        },
      ),
      GoRoute(
        path: '/transporter-verification',
        name: 'transporter-verification',
        builder: (context, state) => const TransporterVerificationScreen(),
      ),
      // GoRoute(
      //   path: '/account-pending',
      //   name: 'account-pending',
      //   builder: (context, state) => const AccountPendingScreen(),
      // ),

      // Customer Routes
      GoRoute(
        path: '/customer/home',
        name: 'customer-home',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/stations',
        name: 'customer-stations',
        builder: (context, state) => const StationMapScreen(),
      ),
      GoRoute(
        path: '/customer/station/:id',
        name: 'customer-station-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StationDetailScreen(stationId: id);
        },
      ),
      GoRoute(
        path: '/customer/queue',
        name: 'customer-queue',
        builder: (context, state) => const QueueStatusScreen(),
      ),
      GoRoute(
        path: '/customer/history',
        name: 'customer-history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        name: 'customer-profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: '/customer/notifications',
        name: 'customer-notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/customer/favorites',
        name: 'customer-favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/customer/ai-chat',
        name: 'customer-ai-chat',
        builder: (context, state) => const AiChatbotScreen(),
      ),

      // Transporter Routes
      GoRoute(
        path: '/transporter/dashboard',
        name: 'transporter-dashboard',
        builder: (context, state) => const TransporterDashboardScreen(),
      ),
      GoRoute(
        path: '/transporter/tasks',
        name: 'transporter-tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/transporter/task/:id',
        name: 'transporter-task-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),
      GoRoute(
        path: '/transporter/history',
        name: 'transporter-history',
        builder: (context, state) => const TransportHistoryScreen(),
      ),
      GoRoute(
        path: '/transporter/profile',
        name: 'transporter-profile',
        builder: (context, state) => const TransporterProfileScreen(),
      ),
      GoRoute(
        path: '/transporter/performance',
        name: 'transporter-performance',
        builder: (context, state) => const PerformanceScreen(),
      ),
    ],
  );
});
