import 'package:flutter/material.dart';
import '../screens/admin/admin_home.dart';
import '../screens/customer/customer_home.dart';
import '../screens/driver/driver_home.dart';
import '../screens/scanner/scanner_home.dart';
import '../screens/staff/staff_home.dart';

class AppRoutes {
  static const customer = '/customer';
  static const driver = '/driver';
  static const staff = '/staff';
  static const admin = '/admin';
  static const scanner = '/scanner';

  static Map<String, WidgetBuilder> get map => {
    customer: (_) => const CustomerHomeScreen(),
    driver: (_) => const DriverHomeScreen(),
    staff: (_) => const StaffHomeScreen(),
    admin: (_) => const AdminHomeScreen(),
    scanner: (_) => const ScannerHomeScreen(),
  };
}
