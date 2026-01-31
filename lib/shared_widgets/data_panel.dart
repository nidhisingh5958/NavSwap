import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'status_indicator.dart';

class DataPanel extends StatelessWidget {
  const DataPanel({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.status,
    this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final String? subtitle;
  final StatusType? status;
  final IconData? icon;
  final VoidCallback? onTap;

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
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                if (status != null)
                  StatusIndicator(
                    status: status!,
                    showPulse: status == StatusType.critical,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class DataPanelRow extends StatelessWidget {
  const DataPanelRow({super.key, required this.panels});

  final List<DataPanel> panels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: panels.map((panel) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: panels.last == panel ? 0 : AppSpacing.sm,
            ),
            child: panel,
          ),
        );
      }).toList(),
    );
  }
}
