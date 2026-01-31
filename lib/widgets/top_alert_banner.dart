import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TopAlertBanner extends StatelessWidget {
  const TopAlertBanner({
    super.key,
    required this.message,
    this.severity = 'info',
  });

  final String message;
  final String severity;

  Color _colorForSeverity() {
    switch (severity) {
      case 'critical':
        return AppColors.critical;
      case 'warning':
        return AppColors.warning;
      case 'healthy':
        return AppColors.healthy;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForSeverity();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border(bottom: BorderSide(color: color.withOpacity(0.4))),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
