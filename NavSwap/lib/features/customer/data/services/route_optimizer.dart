import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Route optimization service for finding the most efficient path
class RouteOptimizer {
  /// Calculate optimal route polyline between user and destination station
  /// Returns list of LatLng points representing the route
  static List<LatLng> calculateOptimalRoute({
    required LatLng userLocation,
    required LatLng destinationLocation,
    List<LatLng> waypoints = const [],
  }) {
    if (waypoints.isEmpty) {
      // Simple straight line route (in production, use Google Directions API)
      return _generateCurvedRoute(userLocation, destinationLocation);
    }

    // Multi-point route optimization using nearest neighbor algorithm
    return _optimizeMultiPointRoute(
      userLocation,
      destinationLocation,
      waypoints,
    );
  }

  /// Generate a curved route path (simulates actual road routing)
  static List<LatLng> _generateCurvedRoute(LatLng start, LatLng end) {
    final route = <LatLng>[start];

    final latDiff = end.latitude - start.latitude;
    final lngDiff = end.longitude - start.longitude;

    // Create intermediate points for a curved path
    const steps = 20;
    for (int i = 1; i < steps; i++) {
      final fraction = i / steps;

      // Add some curve using a sine wave offset
      final offset = math.sin(fraction * math.pi) * 0.002;

      final lat = start.latitude + (latDiff * fraction);
      final lng = start.longitude + (lngDiff * fraction) + offset;

      route.add(LatLng(lat, lng));
    }

    route.add(end);
    return route;
  }

  /// Optimize multi-point route using nearest neighbor algorithm
  static List<LatLng> _optimizeMultiPointRoute(
    LatLng start,
    LatLng destination,
    List<LatLng> waypoints,
  ) {
    final route = <LatLng>[start];
    final remainingPoints = List<LatLng>.from(waypoints);
    var currentPoint = start;

    // Nearest neighbor algorithm
    while (remainingPoints.isNotEmpty) {
      var nearest = remainingPoints[0];
      var minDistance = _calculateDistance(currentPoint, nearest);

      for (final point in remainingPoints) {
        final distance = _calculateDistance(currentPoint, point);
        if (distance < minDistance) {
          nearest = point;
          minDistance = distance;
        }
      }

      route.add(nearest);
      remainingPoints.remove(nearest);
      currentPoint = nearest;
    }

    route.add(destination);
    return route;
  }

  /// Calculate great circle distance between two points using Haversine formula
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371; // Earth's radius in km
    final dLat = _toRad(point2.latitude - point1.latitude);
    final dLng = _toRad(point2.longitude - point1.longitude);

    final sinDLat2 = math.sin(dLat / 2);
    final sinDLng2 = math.sin(dLng / 2);
    final lat1Rad = _toRad(point1.latitude);
    final lat2Rad = _toRad(point2.latitude);

    final a = sinDLat2 * sinDLat2 +
        math.cos(lat1Rad) * math.cos(lat2Rad) * sinDLng2 * sinDLng2;

    final c = 2 * math.asin(math.sqrt(a));
    return R * c;
  }

  /// Convert degrees to radians
  static double _toRad(double degree) => degree * math.pi / 180;

  /// Calculate estimated time to reach destination
  static Duration getEstimatedTime({
    required LatLng userLocation,
    required LatLng destinationLocation,
  }) {
    final distance = _calculateDistance(userLocation, destinationLocation);
    // Assume average speed of 30 km/h in urban areas
    final hours = distance / 30;
    return Duration(minutes: (hours * 60).toInt());
  }

  /// Calculate total distance for a route
  static double getTotalDistance(List<LatLng> route) {
    double totalDistance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      totalDistance += _calculateDistance(route[i], route[i + 1]);
    }
    return totalDistance;
  }
}

/// Data class for route details
class RouteDetails {
  final List<LatLng> polylinePoints;
  final double totalDistance; // in km
  final Duration estimatedTime;
  final String polylineColor;
  final double polylineWidth;

  RouteDetails({
    required this.polylinePoints,
    required this.totalDistance,
    required this.estimatedTime,
    this.polylineColor = '#1976D2',
    this.polylineWidth = 5,
  });

  /// Format route details for display
  String getDistanceString() => '${totalDistance.toStringAsFixed(1)} km';

  String getTimeString() {
    if (estimatedTime.inHours > 0) {
      return '${estimatedTime.inHours}h ${estimatedTime.inMinutes % 60}m';
    }
    return '${estimatedTime.inMinutes} min';
  }
}
