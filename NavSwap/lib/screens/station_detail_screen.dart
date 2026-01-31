import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStationInfo(),
                  const SizedBox(height: 24),
                  _buildLiveMetrics(),
                  const SizedBox(height: 24),
                  _buildWaitForecast(),
                  const SizedBox(height: 24),
                  _buildBatteryAvailability(),
                  const SizedBox(height: 24),
                  _buildReliabilityMeter(),
                  const SizedBox(height: 32),
                  _buildActionButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primaryDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusChip(
                    label: station.statusLabel,
                    color: station.statusColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          station.address,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.people,
            value: '${station.currentQueue}',
            label: 'In Queue',
            color: AppTheme.accentBlue,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.textTertiary.withOpacity(0.3),
          ),
          _buildInfoItem(
            icon: Icons.battery_charging_full,
            value: '${station.availableBatteries}/${station.totalCapacity}',
            label: 'Batteries',
            color: AppTheme.accentGreen,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.textTertiary.withOpacity(0.3),
          ),
          _buildInfoItem(
            icon: Icons.schedule,
            value: '${station.predictedWaitMinutes}',
            label: 'Minutes',
            color: AppTheme.accentYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Live Queue Indicator'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.darkGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current Wait Time',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${station.predictedWaitMinutes} min',
                    style: const TextStyle(
                      color: AppTheme.accentGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomProgressBar(
                value: 1 - (station.currentQueue / 10),
                color: AppTheme.accentGreen,
                height: 12,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQueueStatus('Low', AppTheme.accentGreen),
                  _buildQueueStatus('Medium', AppTheme.accentYellow),
                  _buildQueueStatus('High', AppTheme.accentOrange),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueueStatus(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWaitForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Wait Time Forecast'),
        Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.textTertiary.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}m',
                        style: const TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final hours = ['9AM', '12PM', '3PM', '6PM', '9PM'];
                      if (value.toInt() >= 0 && value.toInt() < hours.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            hours[value.toInt()],
                            style: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 4,
              minY: 0,
              maxY: 20,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 8),
                    const FlSpot(1, 15),
                    const FlSpot(2, 12),
                    FlSpot(3, station.predictedWaitMinutes.toDouble()),
                    const FlSpot(4, 6),
                  ],
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentBlue, AppTheme.accentGreen],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentBlue.withOpacity(0.3),
                        AppTheme.accentGreen.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Battery Availability'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Now',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${station.availableBatteries} / ${station.totalCapacity}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomProgressBar(
                value: station.batteryAvailability / 100,
                color: AppTheme.accentGreen,
                height: 12,
                label: 'Battery Level',
              ),
              const SizedBox(height: 20),
              Row(
                children: List.generate(
                  station.totalCapacity,
                  (index) => Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < station.availableBatteries
                            ? AppTheme.accentGreen
                            : AppTheme.secondaryDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: index < station.availableBatteries
                          ? const Icon(
                              Icons.battery_charging_full,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReliabilityMeter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Reliability Score'),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReliabilityScore(
                score: station.reliabilityScore,
                size: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReliabilityItem(
                    label: 'Service Quality',
                    value: 95,
                  ),
                  const SizedBox(height: 12),
                  _buildReliabilityItem(
                    label: 'Uptime',
                    value: 98,
                  ),
                  const SizedBox(height: 12),
                  _buildReliabilityItem(
                    label: 'User Rating',
                    value: station.reliabilityScore.toInt(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReliabilityItem({
    required String label,
    required int value,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: CustomProgressBar(
            value: value / 100,
            color: AppTheme.accentGreen,
            height: 6,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to swap screen
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text(
          'Navigate to Station',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
