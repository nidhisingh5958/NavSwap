import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class ActionsScreen extends ConsumerWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'AI Actions',
      subtitle: 'Recommended Operations',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'Pending Actions'),
          _ActionCard(
            title: 'Staff Redeployment',
            description: 'Move 1 operator from South Dock to Central by 17:00.',
            reason: 'Queue expected to peak at 18 vehicles.',
            status: StatusType.warning,
            confidence: 92,
          ),
          const SizedBox(height: AppSpacing.md),
          _ActionCard(
            title: 'Battery Rotation',
            description: 'Rotate stock from bay 2 to bay 1.',
            reason: 'Bay 1 has 40% higher throughput efficiency.',
            status: StatusType.info,
            confidence: 87,
          ),
          const SizedBox(height: AppSpacing.md),
          _ActionCard(
            title: 'Preemptive Maintenance',
            description: 'Schedule bay 3 charger maintenance for tonight.',
            reason: 'Efficiency metrics dropping. Avoid peak hour downtime.',
            status: StatusType.info,
            confidence: 78,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Completed'),
          _ActionCard(
            title: 'Inventory Reorder',
            description: 'Order 24 replacement cells.',
            reason: 'Stock levels predicted to drop below threshold.',
            status: StatusType.healthy,
            confidence: 95,
            isCompleted: true,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.reason,
    required this.status,
    required this.confidence,
    this.isCompleted = false,
  });

  final String title;
  final String description;
  final String reason;
  final StatusType status;
  final int confidence;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: status.color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(title, style: theme.textTheme.headlineSmall),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$confidence%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 14,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(reason, style: theme.textTheme.bodySmall)),
              ],
            ),
          ),
          if (!isCompleted) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Dismiss'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const StatusIndicator(status: StatusType.healthy),
                const SizedBox(width: AppSpacing.sm),
                Text('Completed', style: theme.textTheme.labelMedium),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
