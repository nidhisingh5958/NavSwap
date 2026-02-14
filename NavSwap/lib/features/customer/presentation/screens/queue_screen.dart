import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/mock/mock_queue_data.dart';
import '../../data/models/queue_models.dart';
import '../../data/mock/mock_stations.dart';

class QueueScreen extends StatefulWidget {
  final String? stationId;
  final String? userId;

  const QueueScreen({
    super.key,
    this.stationId,
    this.userId,
  });

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  late String _currentUserId;
  late String _currentStationId;
  late QueueResponse _queueResponse;
  late List<QueueEntry> _entriesBeforeUser;
  late List<QueueEntry> _entriesAfterUser;
  late int _userPosition;
  late int _estimatedWaitTime;

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.userId ?? 'USR_001';
    _currentStationId = widget.stationId ?? 'STN_001';
    _loadQueueData();
  }

  void _loadQueueData() {
    setState(() {
      _queueResponse = MockQueueData.getMockQueueResponse(
        userId: _currentUserId,
        stationId: _currentStationId,
      );
      _entriesBeforeUser = MockQueueData.getEntriesBeforeUser(_currentUserId);
      _entriesAfterUser = MockQueueData.getEntriesAfterUser(_currentUserId);
      _userPosition = MockQueueData.getUserPosition(_currentUserId);
      _estimatedWaitTime = MockQueueData.getEstimatedWaitTime(_currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = MockQueueData.getQueueStats(_currentStationId);
    final station = MockStationsData.getAllStations().firstWhere(
      (s) => s.id == _currentStationId,
      orElse: () => MockStationsData.getAllStations().first,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Queue Status'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQueueData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _loadQueueData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Position Card
              _buildPositionCard(),

              const SizedBox(height: 16),

              // Station Info Card
              _buildStationInfoCard(station),

              const SizedBox(height: 16),

              // QR Code Card
              _buildQRCodeCard(),

              const SizedBox(height: 16),

              // Queue Statistics
              _buildQueueStatsCard(stats),

              const SizedBox(height: 16),

              // People Ahead Section
              if (_entriesBeforeUser.isNotEmpty) ...[
                _buildSectionHeader(
                    'People Ahead (${_entriesBeforeUser.length})'),
                const SizedBox(height: 8),
                _buildQueueList(_entriesBeforeUser, isAhead: true),
                const SizedBox(height: 16),
              ],

              // Your Position Indicator
              _buildYourPositionIndicator(),

              const SizedBox(height: 16),

              // People Behind Section
              if (_entriesAfterUser.isNotEmpty) ...[
                _buildSectionHeader(
                    'People Behind (${_entriesAfterUser.length})'),
                const SizedBox(height: 8),
                _buildQueueList(_entriesAfterUser, isAhead: false),
                const SizedBox(height: 16),
              ],

              // Alert Card
              _buildAlertCard(),

              const SizedBox(height: 16),

              // Leave Queue Button
              _buildLeaveQueueButton(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Your Position',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#$_userPosition',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 8),
                child: Text(
                  'of ${_queueResponse.queue?.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Estimated wait: $_estimatedWaitTime min',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _userPosition > 0
                  ? 1 - (_userPosition / (_queueResponse.queue?.length ?? 1))
                  : 0,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfoCard(MockStationData station) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.electric_bolt,
                    color: Colors.blue.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${station.distance} km away',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStationStat(
                    Icons.battery_charging_full,
                    'Available',
                    '${station.availableSlots}/${station.totalSlots}',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStationStat(
                    Icons.people,
                    'In Queue',
                    '${_queueResponse.queue?.length ?? 0}',
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStationStat(
                    Icons.star,
                    'Rating',
                    '${station.reliability}',
                    Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationStat(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Your Swap Token',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: QrImageView(
                data: _queueResponse.qrCode ?? 'NO_QR_CODE',
                version: QrVersions.auto,
                size: 180.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Show this QR code at the station',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'Expires in 15:00',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueStatsCard(Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Queue Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Waiting',
                    '${stats['waiting']}',
                    Colors.orange.shade400,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Being Served',
                    '${stats['verified']}',
                    Colors.blue.shade400,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Avg Wait',
                    '${stats['averageWaitTime']} min',
                    Colors.green.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildQueueList(List<QueueEntry> entries, {required bool isAhead}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade200,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final userName = MockQueueData.getUserName(entry.userId);
          final position = isAhead ? index + 1 : _userPosition + index + 1;
          final waitedTime = DateTime.now()
              .difference(
                DateTime.parse(entry.joinedAt),
              )
              .inMinutes;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(entry.status),
              child: Text(
                '#$position',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            title: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              'Waiting for $waitedTime min • ${MockQueueData.getStatusText(entry.status)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            trailing: _buildStatusBadge(entry.status),
          );
        },
      ),
    );
  }

  Widget _buildYourPositionIndicator() {
    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You are here',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Position #$_userPosition in queue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        MockQueueData.getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return Colors.orange.shade700;
      case 'verified':
        return Colors.blue.shade700;
      case 'swapped':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _buildAlertCard() {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Station is operating normally. Please be ready when your turn approaches.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveQueueButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _showLeaveQueueDialog();
        },
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Leave Queue'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade300, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLeaveQueueDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Queue?'),
        content: const Text(
          'Are you sure you want to leave the queue? You will lose your current position (#4).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have left the queue'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
