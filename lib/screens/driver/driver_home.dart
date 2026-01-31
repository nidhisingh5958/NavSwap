import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/top_alert_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/info_chip.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ACTION TRIG',
      subtitle: 'Driver operations',
      child: Column(
        children: [
          const TopAlertBanner(
            message: 'Emergency reroute available: avoid Dockside congestion.',
            severity: 'critical',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const Center(child: Text('ROUTE MAP • LIVE ETA')),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Task dashboard'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transfer 18 batteries',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: const [
                            InfoChip(label: 'Pickup', value: 'NavSwap North'),
                            InfoChip(label: 'Drop', value: 'NavSwap Central'),
                            InfoChip(label: 'ETA', value: '24 min'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Update status'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'AI task guidance'),
                const AiInsightCard(
                  title: 'Rebalancing model',
                  summary:
                      'Move inventory now to prevent a 14% shortage at Central by 18:00.',
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
