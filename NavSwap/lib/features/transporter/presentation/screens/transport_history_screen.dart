import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransportHistoryScreen extends ConsumerStatefulWidget {
  const TransportHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransportHistoryScreen> createState() =>
      _TransportHistoryScreenState();
}

class _TransportHistoryScreenState
    extends ConsumerState<TransportHistoryScreen> {
  String _selectedFilter = 'All Time';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport History'),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: InputDecoration(
                      labelText: 'Time Period',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'All Time', child: Text('All Time')),
                      DropdownMenuItem(
                          value: 'This Month', child: Text('This Month')),
                      DropdownMenuItem(
                          value: 'This Week', child: Text('This Week')),
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Summary Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Total Tasks', '127'),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _buildSummaryItem('Total Earnings', '\$5,420'),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _buildSummaryItem('Avg Time', '28 min'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 20,
              itemBuilder: (context, index) {
                return _buildHistoryCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(int index) {
    final isToday = index < 3;
    final date = isToday
        ? 'Today, ${9 + index}:30 AM'
        : '${DateTime.now().subtract(Duration(days: index)).day} Jan, ${9 + (index % 12)}:30 AM';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Task #${2000 - index}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+\$${40 + (index % 20) * 3}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                const Text('Station Alpha', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                const Icon(Icons.location_on, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                const Text('Station Beta', style: TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                    Icons.battery_charging_full, '${12 + (index % 8)} units'),
                _buildInfoChip(Icons.timer, '${25 + (index % 15)} min'),
                _buildInfoChip(
                  Icons.check_circle,
                  'Completed',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label,
      {Color color = Colors.grey}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
