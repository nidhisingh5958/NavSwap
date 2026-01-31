import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_icons.dart';
import 'status_indicator.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.batteryCount,
    required this.eta,
    this.priority,
    this.hasFaultWarning = false,
    this.onTap,
  });

  final String id;
  final String pickup;
  final String dropoff;
  final int batteryCount;
  final String eta;
  final String? priority;
  final bool hasFaultWarning;
  final VoidCallback? onTap;

  StatusType get _priorityStatus => switch (priority?.toLowerCase()) {
    'critical' => StatusType.critical,
    'high' => StatusType.warning,
    'normal' => StatusType.healthy,
    _ => StatusType.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.cardGradientDark
              : AppColors.cardGradientLight,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: hasFaultWarning
                ? AppColors.critical.withOpacity(0.5)
                : (isDark ? AppColors.steel : AppColors.ink.withOpacity(0.08)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  AppIcons.truck,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text('Task $id', style: theme.textTheme.headlineSmall),
                ),
                if (priority != null)
                  StatusBadge(label: priority!, status: _priorityStatus),
                if (hasFaultWarning) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(AppIcons.alert, size: 18, color: AppColors.critical),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Route
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PICKUP', style: theme.textTheme.labelSmall),
                      const SizedBox(height: 2),
                      Text(pickup, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Icon(
                    AppIcons.arrowRight,
                    size: 20,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DROP', style: theme.textTheme.labelSmall),
                      const SizedBox(height: 2),
                      Text(dropoff, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Footer metrics
            Row(
              children: [
                Icon(
                  AppIcons.battery,
                  size: 14,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text('$batteryCount units', style: theme.textTheme.labelMedium),
                const Spacer(),
                Icon(
                  AppIcons.time,
                  size: 14,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text('ETA: $eta', style: theme.textTheme.labelMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
