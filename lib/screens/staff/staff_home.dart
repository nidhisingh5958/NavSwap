import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/top_alert_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/info_chip.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FAULT GUARD',
      subtitle: 'Station staff',
      child: Column(
        children: [
          const TopAlertBanner(
            message: 'Queue length rising: deploy staff to bay 3.',
            severity: 'warning',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const SectionHeader(title: 'Station dashboard'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        InfoChip(label: 'Queue', value: '12 vehicles'),
                        InfoChip(label: 'Batteries', value: '64 available'),
                        InfoChip(
                          label: 'Staff',
                          value: '2 on shift',
                          isCritical: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Fault alerts'),
                const AiInsightCard(
                  title: 'Maintenance task',
                  summary: 'Battery rack 4B needs inspection within 2 hours.',
                  status: 'critical',
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'AI recommended actions'),
                const AiInsightCard(
                  title: 'Staff diversion',
                  summary:
                      'Move 1 operator from South Dock to Central by 17:00.',
                  status: 'warning',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
