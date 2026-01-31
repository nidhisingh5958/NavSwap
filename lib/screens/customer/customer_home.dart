import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/top_alert_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/info_chip.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DEFINE THE FLOW',
      subtitle: 'Customer mode',
      child: Column(
        children: [
          const TopAlertBanner(
            message: 'Best station identified with 92% reliability.',
            severity: 'healthy',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
                    ),
                  ),
                  child: const Center(child: Text('MAP VIEW • GOOGLE MAPS')),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Best station'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NavSwap Central • 2.4 km',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: const [
                            InfoChip(label: 'Wait time', value: '6 min'),
                            InfoChip(label: 'Availability', value: '86%'),
                            InfoChip(label: 'Reliability', value: '92%'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Why this station?'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'AI assistant'),
                const AiInsightCard(
                  title: 'Chat with NavSwap AI',
                  summary:
                      'Ask for the fastest station, optimal time, or availability by area.',
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'History'),
                const AiInsightCard(
                  title: 'Last swap',
                  summary: 'NavSwap Harbor • 4 mins wait • 92% availability.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
