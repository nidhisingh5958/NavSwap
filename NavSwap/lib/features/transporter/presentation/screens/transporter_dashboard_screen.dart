import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navswap_app/features/transporter/presentation/screens/task_list_screen.dart';
import 'transporter_history_screen.dart';
import 'transporter_profile_screen.dart';

class TransporterDashboardScreen extends ConsumerStatefulWidget {
  const TransporterDashboardScreen({super.key});

  @override
  ConsumerState<TransporterDashboardScreen> createState() =>
      _TransporterDashboardScreenState();
}

class _TransporterDashboardScreenState
    extends ConsumerState<TransporterDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardContent(),
    const TaskListScreen(), // Updated from placeholder
    const TransporterHistoryScreen(),
    const TransporterProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isCompact = width < 360;
            final horizontalPadding = isCompact ? 8.0 : 16.0;
            final verticalPadding = isCompact ? 6.0 : 8.0;

            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.center,
                spacing: isCompact ? 8 : 12,
                children: [
                  _navItem(Icons.dashboard, 'Dashboard', 0,
                      isCompact: isCompact),
                  _navItem(Icons.task, 'Tasks', 1, isCompact: isCompact),
                  _navItem(Icons.history, 'History', 2, isCompact: isCompact),
                  _navItem(Icons.person, 'Profile', 3, isCompact: isCompact),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index,
      {bool isCompact = false}) {
    final isSelected = _selectedIndex == index;
    final iconSize = isCompact ? 20.0 : 24.0;
    final hPad = isCompact ? 10.0 : 16.0;
    final vPad = isCompact ? 6.0 : 8.0;
    final fontSize = isCompact ? 12.0 : 14.0;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : const Color(0xFF6B6B6B),
                size: iconSize),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back',
                    style: Theme.of(context).textTheme.bodySmall),
                Text('Transporter',
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {}),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsCard(),
                const SizedBox(height: 24),
                Text('Active Tasks',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                _buildTaskCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Credits Today', '₹2,450'),
              Container(width: 1, height: 40, color: Colors.white30),
              _statItem('Deliveries', '12'),
              Container(width: 1, height: 40, color: Colors.white30),
              _statItem('Efficiency', '94%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTaskCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Task #1234',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('In Progress',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(children: [
            Icon(Icons.arrow_upward, size: 16),
            SizedBox(width: 4),
            Text('Pickup: Station Alpha')
          ]),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.arrow_downward, size: 16),
            SizedBox(width: 4),
            Text('Drop: Station Beta')
          ]),
          const SizedBox(height: 12),
          LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF000000))),
          const SizedBox(height: 8),
          const Text('60% Complete',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
        ],
      ),
    );
  }
}
