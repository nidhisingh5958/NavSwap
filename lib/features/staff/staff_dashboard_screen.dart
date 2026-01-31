import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Station Ops',
      subtitle: 'NavSwap Central',
      alertBanner: const AlertBanner(
        message: 'Queue length rising: deploy staff to bay 3',
        status: StatusType.warning,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Live data panels
          const SectionHeader(title: 'Live Status'),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Queue',
                value: '12',
                subtitle: 'vehicles waiting',
                status: StatusType.warning,
                icon: Icons.people_outline,
              ),
              DataPanel(
                label: 'Batteries',
                value: '64',
                subtitle: 'available',
                status: StatusType.healthy,
                icon: Icons.battery_charging_full,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Staff',
                value: '2',
                subtitle: 'on shift',
                status: StatusType.critical,
                icon: Icons.badge,
              ),
              DataPanel(
                label: 'Faults',
                value: '1',
                subtitle: 'pending',
                status: StatusType.critical,
                icon: Icons.error_outline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Fault alerts
          SectionHeader(
            title: 'Fault Alerts',
            action: 'View All',
            onAction: () => context.push('/staff/faults'),
          ),
          const InsightCard(
            title: 'Maintenance Required',
            description:
                'Battery rack 4B needs inspection within 2 hours. Charging connector showing intermittent faults.',
            status: StatusType.critical,
            actionLabel: 'View Details',
          ),
          const SizedBox(height: AppSpacing.xl),

          // AI Actions
          SectionHeader(
            title: 'AI Recommended Actions',
            action: 'View All',
            onAction: () => context.push('/staff/actions'),
          ),
          const InsightCard(
            title: 'Staff Redeployment',
            description:
                'Move 1 operator from South Dock to Central by 17:00. Queue expected to peak at 18 vehicles.',
            status: StatusType.warning,
            actionLabel: 'Accept',
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Battery Rotation',
            description:
                'Rotate stock from bay 2 to bay 1. Bay 1 has higher throughput.',
            status: StatusType.info,
            actionLabel: 'Accept',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.push('/staff/faults');
          if (index == 2) context.push('/staff/actions');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber),
            label: 'Faults',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI Actions',
          ),
        ],
      ),
    );
  }
}
