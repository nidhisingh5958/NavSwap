import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Route visualization polyline for Google Maps
class RoutePolyline {
  final String id;
  final List<LatLng> points;
  final Color color;
  final double width;

  RoutePolyline({
    required this.id,
    required this.points,
    this.color = const Color(0xFF1976D2),
    this.width = 5,
  });

  /// Convert to Google Maps Polyline object
  Polyline toGooglePolyline() {
    return Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: color,
      width: width.toInt(),
      geodesic: true,
      patterns: [
        // Add animated dashed pattern
        PatternItem.dash(20),
        PatternItem.gap(10),
      ],
    );
  }
}

/// Route info widget displayed on map
class RouteInfoWidget extends StatelessWidget {
  final String distance;
  final String estimatedTime;
  final VoidCallback? onNavigate;

  const RouteInfoWidget({
    Key? key,
    required this.distance,
    required this.estimatedTime,
    this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        size: 16,
                        color: Color(0xFF1976D2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        estimatedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (onNavigate != null)
                ElevatedButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.navigate_next, size: 18),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Station marker info window widget
class StationMarkerInfo extends StatelessWidget {
  final String name;
  final String distance;
  final int availableSlots;
  final int totalSlots;
  final int waitTime;
  final bool isRecommended;
  final double reliability;

  const StationMarkerInfo({
    Key? key,
    required this.name,
    required this.distance,
    required this.availableSlots,
    required this.totalSlots,
    required this.waitTime,
    this.isRecommended = false,
    required this.reliability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is rendered in a custom marker info window
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  const Text(
                    'Recommended',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatChip(
                icon: Icons.battery_charging_full,
                label: '$availableSlots/$totalSlots',
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.schedule,
                label: '${waitTime}m wait',
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.star,
                label: '${reliability.toStringAsFixed(1)}',
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
