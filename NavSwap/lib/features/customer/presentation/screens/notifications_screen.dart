import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTabChip('All'),
                _buildTabChip('Queue'),
                _buildTabChip('Stations'),
                _buildTabChip('Offers'),
                _buildTabChip('System'),
              ],
            ),
          ),

          const Divider(height: 1),

          // Notifications List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNotificationCard(
                  Icons.notifications_active,
                  'Queue Update',
                  'You\'re next in queue at Station Alpha!',
                  '2 min ago',
                  Colors.blue,
                  isUnread: true,
                ),
                _buildNotificationCard(
                  Icons.warning_amber,
                  'Station Alert',
                  'Station Beta is experiencing delays',
                  '15 min ago',
                  Colors.orange,
                  isUnread: true,
                ),
                _buildNotificationCard(
                  Icons.local_offer,
                  'Special Offer',
                  'Get 20% off your next 5 swaps!',
                  '1 hour ago',
                  Colors.green,
                ),
                _buildNotificationCard(
                  Icons.check_circle,
                  'Swap Complete',
                  'Your battery swap at Station Alpha is complete',
                  '3 hours ago',
                  Colors.teal,
                ),
                _buildNotificationCard(
                  Icons.star,
                  'Achievement Unlocked',
                  'You\'ve completed 50 swaps! Claim your reward.',
                  '1 day ago',
                  Colors.amber,
                ),
                _buildNotificationCard(
                  Icons.system_update,
                  'System Update',
                  'NavSwap app has been updated to v2.1',
                  '2 days ago',
                  Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label) {
    final isSelected = _selectedTab == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedTab = label;
          });
        },
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
        backgroundColor: const Color.fromARGB(141, 238, 238, 238),
        selectedColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildNotificationCard(
    IconData icon,
    String title,
    String message,
    String timestamp,
    Color color, {
    bool isUnread = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnread ? Colors.blue[50] : null,
      child: InkWell(
        onTap: () {
          // Navigate to related screen or mark as read
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
