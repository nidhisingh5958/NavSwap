import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({
    super.key,
    required this.title,
    required this.summary,
    this.status,
  });

  final String title;
  final String summary;
  final String? status;

  Color _statusColor() {
    switch (status) {
      case 'healthy':
        return AppColors.healthy;
      case 'critical':
        return AppColors.critical;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _statusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(letterSpacing: 2),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(summary, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
