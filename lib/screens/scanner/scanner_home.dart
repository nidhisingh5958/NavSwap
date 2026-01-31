import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/top_alert_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/ai_insight_card.dart';

class ScannerHomeScreen extends StatelessWidget {
  const ScannerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SCAN GRID',
      subtitle: 'Battery scanner',
      child: Column(
        children: [
          const TopAlertBanner(
            message: 'Scan queue ready. Sync location updates every 2 mins.',
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
                  ),
                  child: const Center(child: Text('QR / BARCODE SCANNER')),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'Battery ID'),
                const AiInsightCard(
                  title: 'NS-4482-AX',
                  summary:
                      'Status: Ready • Location: Central Dock • Last scan 4 mins ago',
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Set ready'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Set repair'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
