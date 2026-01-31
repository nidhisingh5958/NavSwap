import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class DriverDashboardScreen extends ConsumerWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Task Console',
      subtitle: 'Driver Operations',
      alertBanner: const AlertBanner(
        message: 'Emergency reroute available: avoid Dockside congestion',
        status: StatusType.critical,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Status overview
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Active Tasks',
                value: '3',
                status: StatusType.warning,
                icon: Icons.assignment,
              ),
              DataPanel(
                label: 'Completed',
                value: '12',
                subtitle: 'today',
                status: StatusType.healthy,
                icon: Icons.check_circle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Active Tasks'),
          TaskCard(
            id: 'T-4521',
            pickup: 'NavSwap North',
            dropoff: 'NavSwap Central',
            batteryCount: 18,
            eta: '24 min',
            priority: 'High',
            onTap: () => context.push('/driver/task/4521'),
          ),
          const SizedBox(height: AppSpacing.md),
          TaskCard(
            id: 'T-4522',
            pickup: 'NavSwap Harbor',
            dropoff: 'NavSwap Downtown',
            batteryCount: 12,
            eta: '35 min',
            priority: 'Normal',
            onTap: () => context.push('/driver/task/4522'),
          ),
          const SizedBox(height: AppSpacing.md),
          TaskCard(
            id: 'T-4523',
            pickup: 'NavSwap Airport',
            dropoff: 'NavSwap East',
            batteryCount: 24,
            eta: '45 min',
            priority: 'Critical',
            hasFaultWarning: true,
            onTap: () => context.push('/driver/task/4523'),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'AI Guidance'),
          const InsightCard(
            title: 'Rebalancing Model',
            description:
                'Move inventory now to prevent a 14% shortage at Central by 18:00. Prioritize task T-4521.',
            status: StatusType.warning,
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Route Optimization',
            description:
                'Completing T-4521 first allows efficient pickup for T-4522 en route.',
            status: StatusType.info,
          ),
        ],
      ),
    );
  }
}
