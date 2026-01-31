import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'AI Alerts',
      subtitle: 'System Intelligence',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'Critical'),
          const InsightCard(
            title: 'Inventory Risk',
            description:
                'East bay forecasted to drop below 20% by 16:00. Immediate transport required.',
            status: StatusType.critical,
            actionLabel: 'Dispatch',
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Warnings'),
          const InsightCard(
            title: 'Stock Model',
            description:
                'Order 120 cells for Saturday surge. Auto-approve recommended to avoid lead time issues.',
            status: StatusType.warning,
            actionLabel: 'Approve',
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Fleet Optimization',
            description:
                'Reassign 3 drivers to Downtown for peak demand at 17:00.',
            status: StatusType.warning,
            actionLabel: 'Execute',
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Informational'),
          const InsightCard(
            title: 'Demand Forecast',
            description:
                'Weekend demand expected to increase 25%. All systems nominal.',
            status: StatusType.info,
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Maintenance Window',
            description:
                'Scheduled maintenance for Harbor station tonight 02:00-04:00. No action required.',
            status: StatusType.info,
          ),
        ],
      ),
    );
  }
}
