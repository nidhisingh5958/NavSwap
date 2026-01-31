import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class FaultsScreen extends ConsumerWidget {
  const FaultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Fault Alerts',
      subtitle: 'Maintenance Tasks',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'Critical'),
          _FaultCard(
            title: 'Battery Rack 4B',
            description:
                'Charging connector showing intermittent faults. Inspection required.',
            priority: 'Critical',
            timeAgo: '15 min ago',
            status: StatusType.critical,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Pending'),
          _FaultCard(
            title: 'Bay 2 Scanner',
            description:
                'QR scanner calibration needed. Scanning accuracy reduced.',
            priority: 'Medium',
            timeAgo: '2 hours ago',
            status: StatusType.warning,
          ),
          const SizedBox(height: AppSpacing.md),
          _FaultCard(
            title: 'Ventilation Unit',
            description: 'Filter replacement due. Scheduled maintenance.',
            priority: 'Low',
            timeAgo: '1 day ago',
            status: StatusType.info,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Resolved Today'),
          _FaultCard(
            title: 'Bay 1 Display',
            description: 'Display replaced. System operational.',
            priority: 'Resolved',
            timeAgo: '4 hours ago',
            status: StatusType.healthy,
            isResolved: true,
          ),
        ],
      ),
    );
  }
}

class _FaultCard extends StatelessWidget {
  const _FaultCard({
    required this.title,
    required this.description,
    required this.priority,
    required this.timeAgo,
    required this.status,
    this.isResolved = false,
  });

  final String title;
  final String description;
  final String priority;
  final String timeAgo;
  final StatusType status;
  final bool isResolved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isResolved
              ? theme.dividerColor
              : status.color.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isResolved ? Icons.check_circle : Icons.error_outline,
                size: 20,
                color: status.color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(title, style: theme.textTheme.headlineSmall),
              ),
              StatusBadge(label: priority, status: status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(timeAgo, style: theme.textTheme.bodySmall),
              const Spacer(),
              if (!isResolved)
                TextButton(onPressed: () {}, child: const Text('Take Action')),
            ],
          ),
        ],
      ),
    );
  }
}
