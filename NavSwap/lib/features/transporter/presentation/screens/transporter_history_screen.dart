import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransporterHistoryScreen extends ConsumerStatefulWidget {
  const TransporterHistoryScreen({super.key});

  @override
  ConsumerState<TransporterHistoryScreen> createState() =>
      _TransporterHistoryScreenState();
}

class _TransporterHistoryScreenState
    extends ConsumerState<TransporterHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('History',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  _buildHistoryCard(
                    taskId: '#1234',
                    pickup: 'Station Alpha',
                    drop: 'Station Beta',
                    date: '14 Feb 2026',
                    credits: '₹350',
                    status: 'Completed',
                  ),
                  const SizedBox(height: 12),
                  _buildHistoryCard(
                    taskId: '#1233',
                    pickup: 'Station Gamma',
                    drop: 'Station Delta',
                    date: '13 Feb 2026',
                    credits: '₹280',
                    status: 'Completed',
                  ),
                  const SizedBox(height: 12),
                  _buildHistoryCard(
                    taskId: '#1232',
                    pickup: 'Station Echo',
                    drop: 'Station Foxtrot',
                    date: '12 Feb 2026',
                    credits: '₹420',
                    status: 'Completed',
                  ),
                  const SizedBox(height: 12),
                  _buildHistoryCard(
                    taskId: '#1231',
                    pickup: 'Station Alpha',
                    drop: 'Station Charlie',
                    date: '11 Feb 2026',
                    credits: '₹0',
                    status: 'Cancelled',
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('All'),
          const SizedBox(width: 8),
          _filterChip('Completed'),
          const SizedBox(width: 8),
          _filterChip('Cancelled'),
          const SizedBox(width: 8),
          _filterChip('This Week'),
          const SizedBox(width: 8),
          _filterChip('This Month'),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B6B6B),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String taskId,
    required String pickup,
    required String drop,
    required String date,
    required String credits,
    required String status,
  }) {
    final isCompleted = status == 'Completed';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Task $taskId',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.arrow_upward,
                  size: 16, color: Color(0xFF6B6B6B)),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(pickup, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.arrow_downward,
                  size: 16, color: Color(0xFF6B6B6B)),
              const SizedBox(width: 4),
              Expanded(child: Text(drop, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Color(0xFF6B6B6B)),
                  const SizedBox(width: 4),
                  Text(date,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B6B6B))),
                ],
              ),
              Text(credits,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted
                          ? Colors.green
                          : const Color(0xFF6B6B6B))),
            ],
          ),
        ],
      ),
    );
  }
}
