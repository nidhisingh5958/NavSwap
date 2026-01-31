import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class StaffManagementScreen extends ConsumerWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Staff Panel',
      subtitle: 'Diversion Control',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'Staffing Summary'),
          _StaffRow(
            station: 'Central',
            current: 2,
            optimal: 4,
            status: StatusType.critical,
          ),
          _StaffRow(
            station: 'Harbor',
            current: 3,
            optimal: 2,
            status: StatusType.healthy,
          ),
          _StaffRow(
            station: 'Downtown',
            current: 3,
            optimal: 3,
            status: StatusType.healthy,
          ),
          _StaffRow(
            station: 'Airport',
            current: 2,
            optimal: 3,
            status: StatusType.warning,
          ),
          _StaffRow(
            station: 'East',
            current: 1,
            optimal: 2,
            status: StatusType.warning,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'AI Diversion Suggestions'),
          const InsightCard(
            title: 'Harbor → Central',
            description:
                'Move 1 staff from Harbor (surplus) to Central (shortage). ETA impact: +8 min swap time if not actioned.',
            status: StatusType.warning,
            actionLabel: 'Execute',
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'On-Call Activation',
            description:
                'Activate 1 on-call staff for East station. Predicted queue surge at 18:00.',
            status: StatusType.info,
            actionLabel: 'Activate',
          ),
        ],
      ),
    );
  }
}

class _StaffRow extends StatelessWidget {
  const _StaffRow({
    required this.station,
    required this.current,
    required this.optimal,
    required this.status,
  });

  final String station;
  final int current;
  final int optimal;
  final StatusType status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diff = current - optimal;
    final diffStr = diff > 0 ? '+$diff' : '$diff';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(station, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              '$current / $optimal',
              style: theme.textTheme.labelMedium,
            ),
          ),
          StatusBadge(label: diffStr, status: status),
        ],
      ),
    );
  }
}
