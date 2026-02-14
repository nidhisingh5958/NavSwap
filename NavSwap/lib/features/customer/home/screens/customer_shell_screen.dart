import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerShellScreen extends StatefulWidget {
  final Widget child;

  const CustomerShellScreen({
    super.key,
    required this.child,
  });

  @override
  State<CustomerShellScreen> createState() => _CustomerShellScreenState();
}

class _CustomerShellScreenState extends State<CustomerShellScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: '/customer/home',
    ),
    _NavItem(
      icon: Icons.location_on_outlined,
      selectedIcon: Icons.location_on,
      label: 'Stations',
      route: '/customer/stations',
    ),
    _NavItem(
      icon: Icons.queue_outlined,
      selectedIcon: Icons.queue,
      label: 'Queue',
      route: '/customer/queue',
    ),
    _NavItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'History',
      route: '/customer/history',
    ),
    _NavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
      route: '/customer/profile',
    ),
  ];

  void _updateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _navItems.indexWhere((item) => item.route == location);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
            context.go(_navItems[index].route);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          destinations: _navItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/customer/ai-chat'),
        tooltip: 'AI Assistant',
        elevation: 6,
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
