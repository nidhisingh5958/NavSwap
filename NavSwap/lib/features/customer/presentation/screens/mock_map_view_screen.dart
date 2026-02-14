import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MockMapViewScreen extends StatefulWidget {
  const MockMapViewScreen({super.key});

  @override
  State<MockMapViewScreen> createState() => _MockMapViewScreenState();
}

class _MockMapViewScreenState extends State<MockMapViewScreen> {
  MockStation? _selectedStation;
  late MockStation _recommendedStation;
  final List<MockStation> _allStations = [];

  @override
  void initState() {
    super.initState();
    _initializeStations();
    _recommendedStation = _allStations.first;
  }

  void _initializeStations() {
    _allStations.addAll([
      MockStation(
        id: 'st_001',
        name: 'Downtown SwapHub',
        offsetX: 0.5,
        offsetY: 0.4,
        distance: 1.2,
        queueLength: 3,
        openTime: '06:00 AM',
        closeTime: '11:00 PM',
        availableSlots: 5,
        totalSlots: 10,
        estimatedWaitTime: 8,
        isRecommended: true,
      ),
      MockStation(
        id: 'st_002',
        name: 'Marina Power Station',
        offsetX: 0.3,
        offsetY: 0.2,
        distance: 3.5,
        queueLength: 1,
        openTime: '24/7',
        closeTime: '24/7',
        availableSlots: 8,
        totalSlots: 12,
        estimatedWaitTime: 3,
        isRecommended: false,
      ),
      MockStation(
        id: 'st_003',
        name: 'Mission SwapStop',
        offsetX: 0.4,
        offsetY: 0.6,
        distance: 2.1,
        queueLength: 5,
        openTime: '07:00 AM',
        closeTime: '10:00 PM',
        availableSlots: 2,
        totalSlots: 8,
        estimatedWaitTime: 15,
        isRecommended: false,
      ),
      MockStation(
        id: 'st_004',
        name: 'SoMa Rapid Swap',
        offsetX: 0.6,
        offsetY: 0.5,
        distance: 1.8,
        queueLength: 4,
        openTime: '05:00 AM',
        closeTime: '12:00 AM',
        availableSlots: 4,
        totalSlots: 10,
        estimatedWaitTime: 12,
        isRecommended: false,
      ),
      MockStation(
        id: 'st_005',
        name: 'Tech Central Hub',
        offsetX: 0.7,
        offsetY: 0.3,
        distance: 2.9,
        queueLength: 2,
        openTime: '06:00 AM',
        closeTime: '11:00 PM',
        availableSlots: 6,
        totalSlots: 15,
        estimatedWaitTime: 5,
        isRecommended: false,
      ),
      MockStation(
        id: 'st_006',
        name: 'Financial Plaza',
        offsetX: 0.55,
        offsetY: 0.35,
        distance: 1.5,
        queueLength: 6,
        openTime: '06:00 AM',
        closeTime: '09:00 PM',
        availableSlots: 3,
        totalSlots: 16,
        estimatedWaitTime: 18,
        isRecommended: false,
      ),
    ]);
  }

  void _selectStation(MockStation station) {
    setState(() {
      _selectedStation = station;
    });
  }

  void _navigateToQueue(MockStation station) {
    // Navigate to queue screen with station details
    context.push('/customer/queue?stationId=${station.id}&userId=USR_001');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mock Map Background
          _buildMockMap(),

          // Recommended Station Banner (Top)
          if (_selectedStation == null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: _buildRecommendedStationBanner(),
            ),

          // Selected Station Details (Bottom)
          if (_selectedStation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildStationDetailsCard(_selectedStation!),
            ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),

          // Close Selected Station Button
          if (_selectedStation != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () {
                  setState(() {
                    _selectedStation = null;
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
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

          // User Location
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - 20,
            top: MediaQuery.of(context).size.height * 0.7 - 20,
            child: _buildUserLocationMarker(),
          ),

          // Station Markers
          ..._allStations.map((station) {
            return Positioned(
              left: MediaQuery.of(context).size.width * station.offsetX - 20,
              top: MediaQuery.of(context).size.height * station.offsetY - 20,
              child: _buildStationMarker(station),
            );
          }),

          // Route Line (if station selected)
          if (_selectedStation != null)
            CustomPaint(
              size: Size.infinite,
              painter: _RoutePainter(
                startX: MediaQuery.of(context).size.width * 0.5,
                startY: MediaQuery.of(context).size.height * 0.7,
                endX: MediaQuery.of(context).size.width *
                    _selectedStation!.offsetX,
                endY: MediaQuery.of(context).size.height *
                    _selectedStation!.offsetY,
              ),
            ),
        ],
      ),
    );
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

  Widget _buildStationMarker(MockStation station) {
    final isSelected = _selectedStation?.id == station.id;
    final isRecommended = station.id == _recommendedStation.id;

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
                  : isRecommended
                      ? Colors.amber
                      : Colors.red,
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
          if (isRecommended && _selectedStation == null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Best',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendedStationBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade600, Colors.amber.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _selectStation(_recommendedStation),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'RECOMMENDED FOR YOU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_recommendedStation.distance} km',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _recommendedStation.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.access_time,
                      '${_recommendedStation.estimatedWaitTime} min',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.people,
                      '${_recommendedStation.queueLength} in queue',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.battery_charging_full,
                      '${_recommendedStation.availableSlots}/${_recommendedStation.totalSlots}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToQueue(_recommendedStation),
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationDetailsCard(MockStation station) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        station.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (station.id == _recommendedStation.id)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Best',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$routeDistance km away • $routeTime min drive',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Station Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Operating Hours
                _buildDetailRow(
                  Icons.access_time_rounded,
                  'Operating Hours',
                  '${station.openTime} - ${station.closeTime}',
                  Colors.blue,
                ),
                const Divider(height: 24),

                // Queue Information
                _buildDetailRow(
                  Icons.people_alt_rounded,
                  'Current Queue',
                  '${station.queueLength} people waiting',
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.timer_outlined,
                  'Estimated Wait',
                  '~${station.estimatedWaitTime} minutes',
                  Colors.green,
                ),
                const Divider(height: 24),

                // Availability
                _buildDetailRow(
                  Icons.battery_charging_full_rounded,
                  'Available Slots',
                  '${station.availableSlots} of ${station.totalSlots} slots free',
                  station.availableSlots > 5 ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 20),

                // Route Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.route, color: Colors.blue.shade700, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Optimized Route',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Via Main St • $routeDistance km • $routeTime min',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                    ],
                  ),
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
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

    // Draw dashed line effect
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

// Mock Station Model
class MockStation {
  final String id;
  final String name;
  final double offsetX; // 0.0 to 1.0 (percentage of screen width)
  final double offsetY; // 0.0 to 1.0 (percentage of screen height)
  final double distance; // in km
  final int queueLength;
  final String openTime;
  final String closeTime;
  final int availableSlots;
  final int totalSlots;
  final int estimatedWaitTime; // in minutes
  final bool isRecommended;

  MockStation({
    required this.id,
    required this.name,
    required this.offsetX,
    required this.offsetY,
    required this.distance,
    required this.queueLength,
    required this.openTime,
    required this.closeTime,
    required this.availableSlots,
    required this.totalSlots,
    required this.estimatedWaitTime,
    required this.isRecommended,
  });
}
