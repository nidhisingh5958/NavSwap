import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class StationDetailScreen extends ConsumerWidget {
  const StationDetailScreen({super.key, required this.stationId});

  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'NavSwap Central',
      subtitle: 'Station Detail',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Live metrics
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Queue',
                value: '8',
                subtitle: 'vehicles waiting',
                status: StatusType.warning,
                icon: Icons.people_outline,
              ),
              DataPanel(
                label: 'Wait Time',
                value: '6 min',
                subtitle: 'predicted',
                status: StatusType.healthy,
                icon: Icons.access_time,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Batteries',
                value: '86%',
                subtitle: '54 of 63 available',
                status: StatusType.healthy,
                icon: Icons.battery_charging_full,
              ),
              DataPanel(
                label: 'Reliability',
                value: '92%',
                subtitle: 'last 30 days',
                status: StatusType.healthy,
                icon: Icons.verified,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'AI Insights'),
          const InsightCard(
            title: 'Demand Forecast',
            description:
                'Moderate demand expected in the next 2 hours. Current staffing is adequate. No stockout risk detected.',
            status: StatusType.healthy,
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Traffic Advisory',
            description:
                'Route via Main Street recommended. Avoid Harbor Road due to construction.',
            status: StatusType.info,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Navigation'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Directions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                _DirectionStep(
                  step: 1,
                  instruction: 'Head north on Current Street',
                ),
                _DirectionStep(
                  step: 2,
                  instruction: 'Turn right onto Main Street',
                ),
                _DirectionStep(step: 3, instruction: 'Continue for 1.8 km'),
                _DirectionStep(
                  step: 4,
                  instruction: 'NavSwap Central is on your left',
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Estimated arrival: 8 minutes',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Start Navigation'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionStep extends StatelessWidget {
  const _DirectionStep({required this.step, required this.instruction});

  final int step;
  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
