import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'History',
      subtitle: 'Your swap timeline',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'This Week'),
          _HistoryItem(
            station: 'NavSwap Harbor',
            date: 'Today, 14:32',
            waitTime: '4 min',
            status: StatusType.healthy,
          ),
          _HistoryItem(
            station: 'NavSwap Central',
            date: 'Yesterday, 09:15',
            waitTime: '7 min',
            status: StatusType.healthy,
          ),
          _HistoryItem(
            station: 'NavSwap Airport',
            date: 'Jan 28, 18:42',
            waitTime: '12 min',
            status: StatusType.warning,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Earlier'),
          _HistoryItem(
            station: 'NavSwap Downtown',
            date: 'Jan 25, 11:20',
            waitTime: '5 min',
            status: StatusType.healthy,
          ),
          _HistoryItem(
            station: 'NavSwap Central',
            date: 'Jan 22, 16:05',
            waitTime: '3 min',
            status: StatusType.healthy,
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.station,
    required this.date,
    required this.waitTime,
    required this.status,
  });

  final String station;
  final String date;
  final String waitTime;
  final StatusType status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.ev_station, color: status.color),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 2),
                Text(date, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(waitTime, style: theme.textTheme.labelLarge),
              const SizedBox(height: 2),
              Text('wait', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
