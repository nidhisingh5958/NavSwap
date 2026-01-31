import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_icons.dart';
import 'status_indicator.dart';

class StationCard extends StatelessWidget {
  const StationCard({
    super.key,
    required this.rank,
    required this.name,
    required this.distance,
    required this.aiScore,
    required this.waitTime,
    required this.availability,
    required this.reliability,
    this.trafficDensity,
    this.onTap,
    this.onWhyThis,
  });

  final int rank;
  final String name;
  final String distance;
  final int aiScore;
  final String waitTime;
  final int availability;
  final int reliability;
  final String? trafficDensity;
  final VoidCallback? onTap;
  final VoidCallback? onWhyThis;

  StatusType get _status {
    if (aiScore >= 90) return StatusType.healthy;
    if (aiScore >= 70) return StatusType.warning;
    return StatusType.critical;
  }

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
            color: isDark ? AppColors.steel : AppColors.ink.withOpacity(0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _status.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _status.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.headlineSmall),
                      Text(distance, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _status.color,
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: Text(
                    '$aiScore',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metrics row
            Row(
              children: [
                _MetricChip(
                  icon: AppIcons.time,
                  label: 'Wait',
                  value: waitTime,
                ),
                const SizedBox(width: AppSpacing.sm),
                _MetricChip(
                  icon: AppIcons.battery,
                  label: 'Available',
                  value: '$availability%',
                  status: availability > 50
                      ? StatusType.healthy
                      : StatusType.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                _MetricChip(
                  icon: AppIcons.check,
                  label: 'Reliable',
                  value: '$reliability%',
                  status: reliability > 80
                      ? StatusType.healthy
                      : StatusType.warning,
                ),
              ],
            ),
            if (trafficDensity != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Traffic: $trafficDensity',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),

            // Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onWhyThis,
                  icon: const Icon(AppIcons.ai, size: 16),
                  label: const Text('Why this station?'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Icon(
                  AppIcons.arrowRight,
                  size: 18,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    this.status,
  });

  final IconData icon;
  final String label;
  final String value;
  final StatusType? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = status?.color ?? theme.textTheme.bodyMedium?.color;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: theme.textTheme.bodySmall?.color),
                const SizedBox(width: 4),
                Text(label, style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
