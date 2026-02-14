import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('My Tasks',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF6B6B6B)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF6B6B6B)),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _getFilteredTasks();

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No tasks found',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskCard(context, tasks[index], index);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    final allTasks = [
      {
        'id': 'TSK-1001',
        'warehouse': 'Central Warehouse A',
        'warehouseAddress': '123 Industrial Park, Sector 18',
        'station': 'Downtown Swap Station',
        'stationAddress': '45 Main Street, Downtown',
        'batteries': 15,
        'distance': '8.5 km',
        'eta': '25 min',
        'status': 'active',
        'priority': 'high',
        'credits': 450,
      },
      {
        'id': 'TSK-1002',
        'warehouse': 'North Warehouse B',
        'warehouseAddress': '78 Storage Complex, North Zone',
        'station': 'Airport Swap Station',
        'stationAddress': '12 Airport Road, Terminal 2',
        'batteries': 12,
        'distance': '12.3 km',
        'eta': '35 min',
        'status': 'pending',
        'priority': 'normal',
        'credits': 580,
      },
      {
        'id': 'TSK-1003',
        'warehouse': 'South Warehouse C',
        'warehouseAddress': '90 Logistics Hub, South District',
        'station': 'Mall Swap Station',
        'stationAddress': '33 Shopping Plaza, City Center',
        'batteries': 20,
        'distance': '5.2 km',
        'eta': '18 min',
        'status': 'active',
        'priority': 'high',
        'credits': 380,
      },
      {
        'id': 'TSK-1004',
        'warehouse': 'East Warehouse D',
        'warehouseAddress': '56 Distribution Center, East End',
        'station': 'Tech Park Swap Station',
        'stationAddress': '89 Innovation Drive, Tech Park',
        'batteries': 10,
        'distance': '15.7 km',
        'eta': '42 min',
        'status': 'pending',
        'priority': 'normal',
        'credits': 620,
      },
      {
        'id': 'TSK-1005',
        'warehouse': 'West Warehouse E',
        'warehouseAddress': '34 Supply Hub, West Quarter',
        'station': 'University Swap Station',
        'stationAddress': '67 Campus Road, University Area',
        'batteries': 18,
        'distance': '9.8 km',
        'eta': '28 min',
        'status': 'active',
        'priority': 'normal',
        'credits': 490,
      },
    ];

    if (_searchQuery.isEmpty) return allTasks;

    return allTasks.where((task) {
      final query = _searchQuery.toLowerCase();
      return task['id'].toString().toLowerCase().contains(query) ||
          task['warehouse'].toString().toLowerCase().contains(query) ||
          task['station'].toString().toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildTaskCard(
      BuildContext context, Map<String, dynamic> task, int index) {
    final isActive = task['status'] == 'active';
    final isHighPriority = task['priority'] == 'high';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(taskData: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isHighPriority
              ? Border.all(color: Colors.red.withOpacity(0.3), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task['id'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'IN PROGRESS' : 'PENDING',
                    style: TextStyle(
                      color: isActive ? Colors.blue : Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.warehouse, size: 16, color: Color(0xFF6B6B6B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(task['warehouse'],
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.ev_station,
                    size: 16, color: Color(0xFF6B6B6B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(task['station'],
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(Icons.battery_charging_full,
                    '${task['batteries']} units', Colors.green),
                _buildInfoChip(Icons.route, task['distance'], Colors.blue),
                _buildInfoChip(Icons.timer, task['eta'], Colors.orange),
              ],
            ),
            if (isHighPriority) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.priority_high, size: 14, color: Colors.red),
                    SizedBox(width: 4),
                    Text('HIGH PRIORITY',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isActive)
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                else
                  const Text('Ready to start',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                const SizedBox(width: 12),
                Text('₹${task['credits']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
