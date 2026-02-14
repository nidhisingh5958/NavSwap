import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock/mock_stations.dart';

class StationMapScreen extends StatefulWidget {
  const StationMapScreen({super.key});

  @override
  State<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends State<StationMapScreen> {
  MockStationData? _selectedStation;
  final TextEditingController _searchController = TextEditingController();

  // User location coordinates
  double _userLat = 37.7749;
  double _userLng = -122.4194;

  List<MockStationData> _nearestStations = [];

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStations() {
    setState(() {
      _nearestStations = MockStationsData.getNearestStations(
        latitude: _userLat,
        longitude: _userLng,
        limit: 12,
      );
    });
  }

  void _selectStation(MockStationData station) {
    setState(() {
      _selectedStation = station;
    });
  }

  void _performSearch() {
    // Mock search - in real app would geocode the location
    final location = _searchController.text.trim();
    if (location.isEmpty) return;

    // Mock: Change user location based on search
    // For demo, just reload same stations
    _loadStations();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching near: $location'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToQueue(MockStationData station) {
    context.push('/customer/queue?stationId=${station.id}&userId=USR_001');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Mock Map
          _buildMockMap(),

          // Search Bar at Top
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: _buildSearchBar(),
          ),

          // Selected Station Details (Bottom)
          if (_selectedStation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildStationDetailsCard(_selectedStation!),
            ),

          // Legend (Bottom Left)
          if (_selectedStation == null)
            Positioned(
              bottom: 16,
              left: 16,
              child: _buildLegend(),
            ),

          // Station Count (Bottom Right)
          if (_selectedStation == null)
            Positioned(
              bottom: 16,
              right: 16,
              child: _buildStationCount(),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.blue.shade700),
              onPressed: _performSearch,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockMap() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade50,
            Colors.green.shade50,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Grid lines for "streets"
          CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(),
          ),

          // User Location Marker
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - 20,
            top: MediaQuery.of(context).size.height * 0.6 - 20,
            child: _buildUserLocationMarker(),
          ),

          // Station Markers
          ..._buildStationMarkers(),

          // Route Line (if station selected)
          if (_selectedStation != null)
            CustomPaint(
              size: Size.infinite,
              painter: _RoutePainter(
                startX: MediaQuery.of(context).size.width * 0.5,
                startY: MediaQuery.of(context).size.height * 0.6,
                endX: MediaQuery.of(context).size.width *
                    _getStationOffsetX(_selectedStation!),
                endY: MediaQuery.of(context).size.height *
                    _getStationOffsetY(_selectedStation!),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildStationMarkers() {
    final markers = <Widget>[];

    for (int i = 0; i < _nearestStations.length; i++) {
      final station = _nearestStations[i];
      final offsetX = _getStationOffsetX(station);
      final offsetY = _getStationOffsetY(station);

      markers.add(
        Positioned(
          left: MediaQuery.of(context).size.width * offsetX - 20,
          top: MediaQuery.of(context).size.height * offsetY - 20,
          child: _buildStationMarker(station),
        ),
      );
    }

    return markers;
  }

  // Generate pseudo-random but consistent positions for stations
  double _getStationOffsetX(MockStationData station) {
    final hash = station.id.hashCode;
    return 0.2 + ((hash % 60) / 100.0); // Range: 0.2 to 0.8
  }

  double _getStationOffsetY(MockStationData station) {
    final hash = station.id.hashCode;
    return 0.15 + ((hash % 50) / 100.0); // Range: 0.15 to 0.65
  }

  Widget _buildUserLocationMarker() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }

  Widget _buildStationMarker(MockStationData station) {
    final isSelected = _selectedStation?.id == station.id;
    final hasSlots = station.availableSlots > 3;

    return GestureDetector(
      onTap: () => _selectStation(station),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green
                  : hasSlots
                      ? Colors.blue.shade700
                      : Colors.orange.shade700,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.electric_bolt,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Selected',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStationDetailsCard(MockStationData station) {
    final routeDistance = station.distance;
    final routeTime = (routeDistance * 3).round(); // Mock: 3 min per km

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Station Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade700],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$routeDistance km away • $routeTime min drive',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedStation = null;
                    });
                  },
                ),
              ],
            ),
          ),

          // Station Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        Icons.people_alt_rounded,
                        'Queue',
                        '${station.waitTime} people',
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.timer_outlined,
                        'Wait Time',
                        '~${station.waitTime} min',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        Icons.battery_charging_full_rounded,
                        'Available',
                        '${station.availableSlots}/${station.totalSlots} slots',
                        station.availableSlots > 5 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.star_rounded,
                        'Rating',
                        '${station.reliability}/5.0',
                        Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Add to Queue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToQueue(station),
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                    label: const Text(
                      'Add to Queue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.blue.shade700, 'Available'),
          const SizedBox(height: 4),
          _buildLegendItem(Colors.orange.shade700, 'Limited'),
          const SizedBox(height: 4),
          _buildLegendItem(Colors.green, 'Selected'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStationCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Text(
            '${_nearestStations.length} Stations',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for map grid
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for route line
class _RoutePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  _RoutePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(startX, startY);

    // Create a curved path
    final midX = (startX + endX) / 2;
    final midY = (startY + endY) / 2;
    final controlOffset = 50.0;

    path.quadraticBezierTo(
      midX - controlOffset,
      midY,
      endX,
      endY,
    );

    // Draw route line
    final dashPaint = Paint()
      ..color = Colors.blue.shade700
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, dashPaint);

    // Draw arrow at end
    final arrowPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    arrowPath.moveTo(endX, endY);
    arrowPath.lineTo(endX - 10, endY - 15);
    arrowPath.lineTo(endX + 10, endY - 15);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
