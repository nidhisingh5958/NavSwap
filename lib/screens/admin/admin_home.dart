import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/top_alert_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/info_chip.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CONTROL GRID',
      subtitle: 'Admin command',
      child: Column(
        children: [
          const TopAlertBanner(
            message: 'Inventory alert: East bay forecasted to drop below 20%.',
            severity: 'critical',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const SectionHeader(title: 'Live traffic map'),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const Center(child: Text('TRAFFIC • TRANSPORT FLOWS')),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Transport tasks'),
                const AiInsightCard(
                  title: 'Fleet priority',
                  summary: 'Reassign 3 drivers to Downtown for peak demand.',
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Staff diversion'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        InfoChip(
                          label: 'Central',
                          value: 'Need 2 staff',
                          isCritical: true,
                        ),
                        InfoChip(label: 'Harbor', value: 'Surplus 1'),
                        InfoChip(label: 'Airport', value: 'Balanced'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'AI alert feed'),
                const AiInsightCard(
                  title: 'Stock model',
                  summary:
                      'Order 120 cells for Saturday surge; auto-approve recommended.',
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
