import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return OpsScaffold(
      title: 'Task T-$taskId',
      subtitle: 'Task Detail',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Task status
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradientDark,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.steel),
            ),
            child: Row(
              children: [
                const StatusIndicator(
                  status: StatusType.warning,
                  size: 12,
                  showPulse: true,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IN PROGRESS', style: theme.textTheme.labelMedium),
                      const SizedBox(height: 2),
                      Text(
                        'Step 2 of 4: En route to pickup',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Route details
          const SectionHeader(title: 'Route'),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Pickup',
                value: 'NavSwap North',
                icon: Icons.upload_rounded,
              ),
              DataPanel(
                label: 'Drop',
                value: 'NavSwap Central',
                icon: Icons.download_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Batteries',
                value: '18',
                subtitle: 'units',
                icon: Icons.battery_charging_full,
              ),
              DataPanel(
                label: 'ETA',
                value: '24 min',
                status: StatusType.healthy,
                icon: Icons.access_time,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Step-by-step flow
          const SectionHeader(title: 'Task Steps'),
          _TaskStep(step: 1, title: 'Task assigned', isComplete: true),
          _TaskStep(step: 2, title: 'En route to pickup', isCurrent: true),
          _TaskStep(step: 3, title: 'Loading batteries'),
          _TaskStep(step: 4, title: 'Delivery complete'),
          const SizedBox(height: AppSpacing.xl),

          // AI guidance
          const SectionHeader(title: 'AI Guidance'),
          const InsightCard(
            title: 'Traffic Advisory',
            description:
                'Moderate traffic on Main Street. Consider alternate route via Park Avenue to save 4 minutes.',
            status: StatusType.info,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Update Status'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _reportIssue(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.critical,
                    side: const BorderSide(color: AppColors.critical),
                  ),
                  child: const Text('Report Issue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _reportIssue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Issue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _IssueOption(label: 'Vehicle breakdown', icon: Icons.warning_amber),
            _IssueOption(label: 'Route blocked', icon: Icons.block),
            _IssueOption(label: 'Battery damage', icon: Icons.battery_alert),
            _IssueOption(label: 'Other emergency', icon: Icons.emergency),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _TaskStep extends StatelessWidget {
  const _TaskStep({
    required this.step,
    required this.title,
    this.isComplete = false,
    this.isCurrent = false,
  });

  final int step;
  final String title;
  final bool isComplete;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isComplete
        ? AppColors.healthy
        : isCurrent
        ? AppColors.warning
        : AppColors.fog;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: isCurrent ? Border.all(color: color, width: 2) : null,
            ),
            child: Center(
              child: isComplete
                  ? Icon(Icons.check, size: 16, color: color)
                  : Text(
                      '$step',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isComplete || isCurrent ? null : AppColors.fog,
                fontWeight: isCurrent ? FontWeight.w600 : null,
              ),
            ),
          ),
          if (isCurrent)
            StatusBadge(label: 'Current', status: StatusType.warning),
        ],
      ),
    );
  }
}

class _IssueOption extends StatelessWidget {
  const _IssueOption({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.critical),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pop(context),
    );
  }
}
