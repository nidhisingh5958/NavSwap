import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'station_detail_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final UserProfile user;
  final Station recommendedStation;
  final List<SwapHistory> recentSwaps;

  const CustomerHomeScreen({
    super.key,
    required this.user,
    required this.recommendedStation,
    required this.recentSwaps,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(context),
                const SizedBox(height: 24),
                _buildAIRecommendationCard(context),
                const SizedBox(height: 32),
                const SectionHeader(title: 'Your Impact'),
                const SizedBox(height: 16),
                _buildPersonalMetrics(),
                const SizedBox(height: 32),
                const SectionHeader(title: 'Recent Swaps'),
                const SizedBox(height: 16),
                _buildRecentSwaps(),
                const SizedBox(height: 32),
                _buildFavoriteStations(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GradientCard(
      gradient: AppTheme.heroGradient,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()}, ${user.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your Smart Swap Assistant',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.electric_bolt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildQuickStat(
                icon: Icons.repeat,
                value: '${user.totalSwaps}',
                label: 'Swaps',
              ),
              const SizedBox(width: 24),
              _buildQuickStat(
                icon: Icons.access_time,
                value: '${user.totalMinutesSaved}m',
                label: 'Saved',
              ),
              const SizedBox(width: 24),
              _buildQuickStat(
                icon: Icons.eco,
                value: '${user.totalCO2Saved.toInt()}kg',
                label: 'CO₂',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAIRecommendationCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StationDetailScreen(station: recommendedStation),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.darkGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AI Recommended',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.accentGreen,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recommendedStation.aiScore.toInt()}',
                          style: const TextStyle(
                            color: AppTheme.accentGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                recommendedStation.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppTheme.textTertiary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      recommendedStation.address,
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStationMetric(
                      icon: Icons.schedule,
                      value: '${recommendedStation.predictedWaitMinutes} min',
                      label: 'Wait Time',
                      color: AppTheme.accentBlue,
                    ),
                  ),
                  Expanded(
                    child: _buildStationMetric(
                      icon: Icons.battery_charging_full,
                      value: '${recommendedStation.batteryAvailability.toInt()}%',
                      label: 'Available',
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  Expanded(
                    child: _buildStationMetric(
                      icon: Icons.verified,
                      value: '${recommendedStation.reliabilityScore.toInt()}%',
                      label: 'Reliable',
                      color: AppTheme.accentYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  _showWhyThisStation(context);
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppTheme.accentBlue,
                ),
                label: const Text(
                  'Why this station?',
                  style: TextStyle(
                    color: AppTheme.accentBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationMetric({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalMetrics() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        MetricCard(
          label: 'Total Swaps',
          value: user.totalSwaps.toString(),
          icon: Icons.repeat,
          color: AppTheme.accentBlue,
        ),
        MetricCard(
          label: 'Time Saved',
          value: '${user.totalMinutesSaved}m',
          icon: Icons.access_time,
          color: AppTheme.accentGreen,
        ),
        MetricCard(
          label: 'CO₂ Reduced',
          value: '${user.totalCO2Saved.toInt()}kg',
          icon: Icons.eco,
          color: AppTheme.accentGreen,
        ),
        MetricCard(
          label: 'Favorites',
          value: user.favoriteStations.length.toString(),
          icon: Icons.favorite,
          color: AppTheme.accentOrange,
        ),
      ],
    );
  }

  Widget _buildRecentSwaps() {
    if (recentSwaps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No swaps yet. Start your journey!',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentSwaps.take(3).map((swap) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.accentGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      swap.stationName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${swap.duration} minutes • ${swap.co2Saved.toStringAsFixed(1)}kg CO₂ saved',
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(swap.timestamp),
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteStations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Favorite Stations'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: user.favoriteStations.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite stations yet',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                )
              : Column(
                  children: user.favoriteStations.map((station) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppTheme.accentOrange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            station,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}';
  }

  void _showWhyThisStation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why This Station?',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildReasonItem(
              icon: Icons.schedule,
              title: 'Minimal Wait Time',
              description: 'Only ${recommendedStation.predictedWaitMinutes} min predicted wait based on current traffic',
            ),
            _buildReasonItem(
              icon: Icons.battery_charging_full,
              title: 'High Availability',
              description: '${recommendedStation.batteryAvailability.toInt()}% batteries available right now',
            ),
            _buildReasonItem(
              icon: Icons.verified,
              title: 'Reliable Service',
              description: '${recommendedStation.reliabilityScore.toInt()}% reliability score from user feedback',
            ),
            _buildReasonItem(
              icon: Icons.location_on,
              title: 'Convenient Location',
              description: 'Based on your usual routes and preferences',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.accentBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
