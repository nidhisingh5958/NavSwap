import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpsScaffold(
      title: 'Find Station',
      subtitle: 'AI-ranked stations near you',
      alertBanner: const AlertBanner(
        message: 'Best station identified with 94% reliability score',
        status: StatusType.healthy,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SectionHeader(title: 'Top Stations'),
          const SizedBox(height: AppSpacing.sm),
          StationCard(
            rank: 1,
            name: 'NavSwap Central',
            distance: '2.4 km',
            aiScore: 94,
            waitTime: '6 min',
            availability: 86,
            reliability: 92,
            trafficDensity: 'Low',
            onTap: () => context.push('/customer/station/central'),
            onWhyThis: () => _showAiExplanation(context),
          ),
          const SizedBox(height: AppSpacing.md),
          StationCard(
            rank: 2,
            name: 'NavSwap Harbor',
            distance: '3.1 km',
            aiScore: 88,
            waitTime: '9 min',
            availability: 72,
            reliability: 89,
            trafficDensity: 'Medium',
            onTap: () => context.push('/customer/station/harbor'),
            onWhyThis: () => _showAiExplanation(context),
          ),
          const SizedBox(height: AppSpacing.md),
          StationCard(
            rank: 3,
            name: 'NavSwap Airport',
            distance: '5.8 km',
            aiScore: 76,
            waitTime: '4 min',
            availability: 91,
            reliability: 85,
            trafficDensity: 'High',
            onTap: () => context.push('/customer/station/airport'),
            onWhyThis: () => _showAiExplanation(context),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'AI Assistant'),
          InsightCard(
            title: 'Ask NavSwap AI',
            description:
                'Get personalized recommendations for the fastest swap experience based on your location and preferences.',
            actionLabel: 'Start Chat',
            onAction: () => context.push('/customer/ai-chat'),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: 'Recent Swaps',
            action: 'View All',
            onAction: () => context.push('/customer/history'),
          ),
          InsightCard(
            title: 'Last Swap',
            description: 'NavSwap Harbor • 4 min wait • 92% availability',
            status: StatusType.healthy,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.push('/customer/ai-chat');
          if (index == 2) context.push('/customer/history');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ev_station),
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  void _showAiExplanation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why This Station?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const InsightCard(
              title: 'AI Analysis',
              description:
                  'This station scores highest due to: shortest wait time (6 min), high battery availability (86%), and excellent reliability history (92%). Traffic conditions are favorable for a quick arrival.',
              status: StatusType.info,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
