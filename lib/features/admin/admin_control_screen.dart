import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class AdminControlScreen extends ConsumerWidget {
  const AdminControlScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Control Grid',
      subtitle: 'System Command',
      alertBanner: const AlertBanner(
        message: 'Inventory alert: East bay forecasted to drop below 20%',
        status: StatusType.critical,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Global metrics
          const SectionHeader(title: 'System Overview'),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Stations',
                value: '12',
                subtitle: 'online',
                status: StatusType.healthy,
                icon: Icons.ev_station,
              ),
              DataPanel(
                label: 'Fleet',
                value: '8',
                subtitle: 'active drivers',
                status: StatusType.healthy,
                icon: Icons.local_shipping,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Swaps',
                value: '347',
                subtitle: 'today',
                icon: Icons.swap_horiz,
              ),
              DataPanel(
                label: 'Alerts',
                value: '3',
                subtitle: 'pending',
                status: StatusType.warning,
                icon: Icons.warning_amber,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Traffic table
          SectionHeader(
            title: 'Station Congestion',
            action: 'View All',
            onAction: () => context.push('/admin/logistics'),
          ),
          _CongestionTable(),
          const SizedBox(height: AppSpacing.xl),

          // Staff panel
          SectionHeader(
            title: 'Staff Diversion',
            action: 'Manage',
            onAction: () => context.push('/admin/staff'),
          ),
          const DataPanelRow(
            panels: [
              DataPanel(
                label: 'Central',
                value: '-2',
                subtitle: 'staff needed',
                status: StatusType.critical,
              ),
              DataPanel(
                label: 'Harbor',
                value: '+1',
                subtitle: 'surplus',
                status: StatusType.healthy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // AI alerts
          SectionHeader(
            title: 'AI Alert Feed',
            action: 'View All',
            onAction: () => context.push('/admin/alerts'),
          ),
          const InsightCard(
            title: 'Stock Model',
            description:
                'Order 120 cells for Saturday surge. Auto-approve recommended.',
            status: StatusType.warning,
            actionLabel: 'Approve',
          ),
          const SizedBox(height: AppSpacing.md),
          const InsightCard(
            title: 'Fleet Optimization',
            description:
                'Reassign 3 drivers to Downtown for peak demand at 17:00.',
            status: StatusType.info,
            actionLabel: 'Execute',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.push('/admin/logistics');
          if (index == 2) context.push('/admin/staff');
          if (index == 3) context.push('/admin/alerts');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Control',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.hub), label: 'Logistics'),
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Staff'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}

class _CongestionTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stations = [
      ('Central', 'High', StatusType.critical, '12', '64%'),
      ('Harbor', 'Medium', StatusType.warning, '8', '78%'),
      ('Downtown', 'Low', StatusType.healthy, '4', '91%'),
      ('Airport', 'Medium', StatusType.warning, '9', '72%'),
      ('East', 'Critical', StatusType.critical, '15', '45%'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadius),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Station', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  child: Text('Traffic', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  child: Text('Queue', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  child: Text('Battery', style: theme.textTheme.labelSmall),
                ),
              ],
            ),
          ),
          // Rows
          ...stations.map(
            (s) => _TableRow(
              station: s.$1,
              traffic: s.$2,
              status: s.$3,
              queue: s.$4,
              battery: s.$5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.station,
    required this.traffic,
    required this.status,
    required this.queue,
    required this.battery,
  });

  final String station;
  final String traffic;
  final StatusType status;
  final String queue;
  final String battery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(station, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: StatusBadge(label: traffic, status: status),
          ),
          Expanded(child: Text(queue, style: theme.textTheme.bodyMedium)),
          Expanded(child: Text(battery, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
