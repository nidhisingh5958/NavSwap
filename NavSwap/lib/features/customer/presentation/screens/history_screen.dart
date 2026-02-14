import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock/mock_booking_history_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BookingHistory> _allBookings = [];
  List<BookingHistory> _completedBookings = [];
  List<BookingHistory> _cancelledBookings = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHistory() {
    setState(() {
      _allBookings = MockBookingHistoryData.getBookingHistory();
      _completedBookings = MockBookingHistoryData.getCompletedBookings();
      _cancelledBookings = MockBookingHistoryData.getCancelledBookings();
      _stats = MockBookingHistoryData.getBookingStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Booking History'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _loadHistory();
        },
        child: Column(
          children: [
            // Statistics Card
            _buildStatisticsCard(),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryList(_allBookings, 'No bookings yet'),
                  _buildHistoryList(
                      _completedBookings, 'No completed bookings'),
                  _buildHistoryList(
                      _cancelledBookings, 'No cancelled bookings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history,
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
                      'Your History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Most visited: ${MockBookingHistoryData.getMostVisitedStation()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Swaps',
                  '${_stats['totalSwaps']}',
                  Icons.swap_horiz_rounded,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Spent',
                  '\$${_stats['totalAmount']?.toStringAsFixed(0) ?? '0'}',
                  Icons.attach_money_rounded,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Avg Rating',
                  '${(_stats['averageRating'] ?? 0).toStringAsFixed(1)}★',
                  Icons.star_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistoryList(List<BookingHistory> bookings, String emptyMessage) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(BookingHistory booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(booking),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: booking.status == 'completed'
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      booking.status == 'completed'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: booking.getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.station.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.getBookingDateString(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: booking.getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.getStatusText(),
                      style: TextStyle(
                        color: booking.getStatusColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              if (booking.status == 'completed') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.queue_rounded,
                          'Position',
                          '#${booking.queuePosition}',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.timer_outlined,
                          'Wait Time',
                          '${booking.actualWaitTime}m',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.attach_money,
                          'Price',
                          '\$${booking.transactionAmount.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Rating
                if (booking.rating != null) ...[
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < booking.rating!
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber.shade700,
                          size: 18,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${booking.rating}.0',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      if (booking.feedback != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            booking.feedback!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Battery Info
                if (booking.batterySwapped != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.battery_charging_full,
                            color: Colors.blue.shade700, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Swapped: ${booking.batterySwapped} → ${booking.batteryReceived}',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              if (booking.status == 'cancelled') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.red.shade700, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Reason: ${booking.cancellationReason ?? 'Not specified'}',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showBookingDetails(BookingHistory booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Booking Details',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Booking ID: ${booking.id}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                // Station Info
                _buildDetailRow(
                    'Station', booking.station.name, Icons.electric_bolt),
                const SizedBox(height: 12),
                _buildDetailRow('Date', booking.getBookingDateString(),
                    Icons.calendar_today),
                const SizedBox(height: 12),
                _buildDetailRow(
                    'Status', booking.getStatusText(), Icons.info_outline),

                if (booking.status == 'completed') ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Queue Position', '#${booking.queuePosition}',
                      Icons.queue),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                      'Wait Time',
                      '${booking.actualWaitTime} min (Est: ${booking.estimatedWaitTime} min)',
                      Icons.timer),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                      'Amount',
                      '\$${booking.transactionAmount.toStringAsFixed(2)}',
                      Icons.attach_money),
                  if (booking.batterySwapped != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Battery Swap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        'Swapped', booking.batterySwapped!, Icons.battery_std),
                    const SizedBox(height: 12),
                    _buildDetailRow('Received', booking.batteryReceived!,
                        Icons.battery_charging_full),
                  ],
                  if (booking.rating != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Your Rating',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < booking.rating!
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber.shade700,
                          size: 28,
                        );
                      }),
                    ),
                    if (booking.feedback != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        booking.feedback!,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ],

                if (booking.status == 'cancelled' &&
                    booking.cancellationReason != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Cancellation Reason',
                      booking.cancellationReason!, Icons.cancel),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                if (booking.status == 'completed') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/customer/queue', extra: {
                          'stationId': booking.station.id,
                          'userId': 'USR_001',
                        });
                      },
                      icon: const Icon(Icons.repeat),
                      label: const Text('Book Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
