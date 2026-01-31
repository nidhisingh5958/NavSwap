import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class LogisticsScreen extends ConsumerWidget {
  const LogisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Logistics',
      subtitle: 'Fleet Operations',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Active',
                value: '8',
                subtitle: 'drivers on route',
                status: StatusType.healthy,
              ),
              DataPanel(
                label: 'Pending',
                value: '5',
                subtitle: 'tasks queued',
                status: StatusType.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Active Transport Jobs'),
          const TaskCard(
            id: 'T-4521',
            pickup: 'NavSwap North',
            dropoff: 'NavSwap Central',
            batteryCount: 18,
            eta: '24 min',
            priority: 'High',
          ),
          const SizedBox(height: AppSpacing.md),
          const TaskCard(
            id: 'T-4522',
            pickup: 'NavSwap Harbor',
            dropoff: 'NavSwap Downtown',
            batteryCount: 12,
            eta: '35 min',
            priority: 'Normal',
          ),
          const SizedBox(height: AppSpacing.md),
          const TaskCard(
            id: 'T-4523',
            pickup: 'NavSwap Airport',
            dropoff: 'NavSwap East',
            batteryCount: 24,
            eta: '45 min',
            priority: 'Critical',
            hasFaultWarning: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'AI Recommendations'),
          const InsightCard(
            title: 'Route Optimization',
            description:
                'Combine T-4522 and T-4524 for a 15% efficiency gain. Shared route overlap detected.',
            status: StatusType.info,
            actionLabel: 'Apply',
          ),
        ],
      ),
    );
  }
}
