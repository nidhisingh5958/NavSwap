import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/flash_job_notification.dart';

class TransporterDashboard extends StatefulWidget {
  final UserProfile user;
  final TransporterStats stats;
  final List<TransportJob> activeJobs;

  const TransporterDashboard({
    super.key,
    required this.user,
    required this.stats,
    required this.activeJobs,
  });

  @override
  State<TransporterDashboard> createState() => _TransporterDashboardState();
}

class _TransporterDashboardState extends State<TransporterDashboard> {
  void _showFlashJob(TransportJob job) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => FlashJobNotification(
        job: job,
        onAccept: () {
          // Handle job acceptance
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job accepted! Navigate to pickup location.'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        },
        onReject: () {
          // Handle job rejection
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job declined.'),
            ),
          );
        },
      ),
    );
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
                _buildHeader(),
                const SizedBox(height: 24),
                _buildPerformanceCard(),
                const SizedBox(height: 24),
                _buildTierBadge(),
                const SizedBox(height: 32),
                const SectionHeader(title: 'Active Tasks'),
                const SizedBox(height: 16),
                _buildActiveTasks(),
                const SizedBox(height: 32),
                _buildEarningsSection(),
                const SizedBox(height: 32),
                _buildEfficiencyTips(),
                const SizedBox(height: 24),
                _buildTestFlashJobButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
            ),
            Text(
              widget.user.name,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow,
          ),
          child: const Icon(
            Icons.local_shipping,
            color: AppTheme.accentOrange,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard() {
    return GradientCard(
      gradient: AppTheme.orangeGradient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.stats.efficiencyScore.toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildPerfMetric(
                  icon: Icons.stars,
                  value: '₹${widget.stats.todayCredits}',
                  label: 'Credits Earned',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildPerfMetric(
                  icon: Icons.check_circle,
                  value: '${widget.stats.deliveriesCompleted}',
                  label: 'Deliveries',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildPerfMetric(
                  icon: Icons.star,
                  value: '${widget.stats.performanceRating.toStringAsFixed(1)}',
                  label: 'Rating',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerfMetric({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTierBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.stats.tierColor.withOpacity(0.3),
            widget.stats.tierColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.stats.tierColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.stats.tierColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.stats.tierLabel} Tier',
                  style: TextStyle(
                    color: widget.stats.tierColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Keep up the great work!',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textTertiary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTasks() {
    if (widget.activeJobs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inbox,
              color: AppTheme.textTertiary.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'No active tasks',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flash jobs will appear here',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: widget.activeJobs.map((job) => _buildTaskCard(job)).toList(),
    );
  }

  Widget _buildTaskCard(TransportJob job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusChip(
                label: job.priorityLabel,
                color: job.priorityColor,
              ),
              Text(
                '₹${job.estimatedCredits}',
                style: const TextStyle(
                  color: AppTheme.accentGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTaskLocation(
            icon: Icons.circle,
            label: 'Pickup',
            location: job.pickupStationName,
            address: job.pickupAddress,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 2,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.accentBlue,
                    AppTheme.accentBlue.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTaskLocation(
            icon: Icons.location_on,
            label: 'Drop',
            location: job.dropStationName,
            address: job.dropAddress,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTaskDetail(
                  icon: Icons.battery_charging_full,
                  value: '${job.batteryCount}',
                  label: 'Batteries',
                ),
              ),
              Expanded(
                child: _buildTaskDetail(
                  icon: Icons.route,
                  value: '${job.distance.toStringAsFixed(1)} km',
                  label: 'Distance',
                ),
              ),
              Expanded(
                child: _buildTaskDetail(
                  icon: Icons.schedule,
                  value: '${job.etaMinutes} min',
                  label: 'ETA',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Start navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
              ),
              child: const Text('Start Navigation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskLocation({
    required IconData icon,
    required String label,
    required String location,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accentBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetail({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
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

  Widget _buildEarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Earnings History'),
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
                    'Total Earnings',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${widget.stats.totalEarnings}',
                    style: const TextStyle(
                      color: AppTheme.accentGreen,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2,
                children: [
                  _buildEarningsStat('Today', '₹${widget.stats.todayCredits}'),
                  _buildEarningsStat('This Week', '₹${widget.stats.todayCredits * 5}'),
                  _buildEarningsStat('This Month', '₹${widget.stats.totalEarnings}'),
                  _buildEarningsStat('Avg/Day', '₹${(widget.stats.totalEarnings / 30).toInt()}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'AI Efficiency Tips'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentBlue.withOpacity(0.15),
                AppTheme.accentBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Optimize Your Routes',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Peak hours are 4-7 PM. Accept jobs during this window to maximize your earnings by up to 30%.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestFlashJobButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // Create a test job
          final testJob = TransportJob(
            id: 'test_123',
            pickupStationName: 'Central Station',
            pickupAddress: '123 Main Street, Downtown',
            dropStationName: 'East Hub',
            dropAddress: '456 Park Avenue, East Side',
            batteryCount: 8,
            distance: 5.2,
            estimatedCredits: 450,
            createdAt: DateTime.now(),
            priority: JobPriority.urgent,
            status: JobStatus.pending,
            etaMinutes: 15,
          );
          _showFlashJob(testJob);
        },
        icon: const Icon(Icons.flash_on),
        label: const Text('Test Flash Job Notification'),
      ),
    );
  }
}
