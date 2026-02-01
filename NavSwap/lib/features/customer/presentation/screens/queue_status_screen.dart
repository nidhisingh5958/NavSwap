import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/queue_provider.dart';

class QueueStatusScreen extends ConsumerStatefulWidget {
  const QueueStatusScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends ConsumerState<QueueStatusScreen> {
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Join queue when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(queueStateProvider.notifier).joinQueue();
    });

    // Refresh queue status every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      ref.read(queueStateProvider.notifier).refreshStatus();
    });

    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final queueState = ref.read(queueStateProvider);
    if (queueState.qrExpiry != null) {
      final remaining =
          queueState.qrExpiry!.difference(DateTime.now()).inSeconds;
      if (remaining > 0) {
        setState(() {
          _remainingSeconds = remaining;
        });
      } else {
        // QR expired, refresh
        ref.read(queueStateProvider.notifier).refreshStatus();
      }
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(queueStateProvider);

    if (queueState.isLoading && queueState.qrCode == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Queue Status')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (queueState.error != null && queueState.qrCode == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Queue Status')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(queueState.error!),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(queueStateProvider.notifier).joinQueue(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(queueStateProvider.notifier).refreshStatus();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Queue Progress Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Your Position',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${queueState.position ?? '-'}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Estimated wait time',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${queueState.estimatedWaitTime ?? '-'} minutes',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: queueState.position != null
                            ? 1 - (queueState.position! / 10).clamp(0.0, 1.0)
                            : 0,
                        backgroundColor: Colors.grey[300],
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Queue is moving smoothly',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Station Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Station Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.location_on, 'Station',
                          queueState.stationName ?? 'Station Alpha'),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          Icons.battery_full, 'Battery Availability', '85%'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.speed, 'Queue Speed', 'Normal'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // QR Code Card
              if (queueState.qrCode != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: QrImageView(
                            data: queueState.qrCode!,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Show this QR code at the station',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer,
                                size: 16,
                                color: _remainingSeconds < 60
                                    ? Colors.red
                                    : Colors.orange),
                            const SizedBox(width: 4),
                            const Text(
                              'Expires in: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _remainingSeconds < 60
                                    ? Colors.red
                                    : Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Alerts Card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Station is operating normally. No delays expected.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: queueState.isLoading
                      ? null
                      : () {
                          _showCancelDialog(context);
                        },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Leave Queue'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Queue Information'),
        content: const Text(
          'Your position in the queue is updated in real-time. '
          'The QR code will be needed when it\'s your turn at the station. '
          'Please arrive at the station before your QR code expires.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Queue?'),
        content: const Text(
          'Are you sure you want to leave the queue? You will lose your position.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(queueStateProvider.notifier).leaveQueue();
              if (mounted) {
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
