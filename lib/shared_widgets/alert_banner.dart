import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import 'status_indicator.dart';

class AlertBanner extends StatelessWidget {
  const AlertBanner({
    super.key,
    required this.message,
    this.status = StatusType.info,
    this.onDismiss,
    this.action,
  });

  final String message;
  final StatusType status;
  final VoidCallback? onDismiss;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        border: Border(
          bottom: BorderSide(color: status.color.withOpacity(0.25)),
        ),
      ),
      child: Row(
        children: [
          StatusIndicator(
            status: status,
            size: 8,
            showPulse: status == StatusType.critical,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: status.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (action != null) action!,
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, size: 16, color: status.color),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
