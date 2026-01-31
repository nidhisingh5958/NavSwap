import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(letterSpacing: 2.4),
            ),
          ),
          if (action != null)
            Text(
              action!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.fog,
                letterSpacing: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
