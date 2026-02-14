import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Mock data service for swap stations with realistic coordinates
class MockStationsData {
  /// Sample stations with realistic lat/lng near San Francisco Bay Area
  static List<MockStationData> getAllStations() => [
        // Downtown SF
        MockStationData(
          id: 'st_001',
          name: 'Downtown SwapHub',
          latitude: 37.7749,
          longitude: -122.4194,
          availableSlots: 5,
          totalSlots: 10,
          waitTime: 8,
          reliability: 4.8,
          amenities: ['Wifi', 'Charging', 'Café'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Downtown+SwapHub',
        ),
        // Mission District
        MockStationData(
          id: 'st_002',
          name: 'Mission SwapStop',
          latitude: 37.7599,
          longitude: -122.4148,
          availableSlots: 2,
          totalSlots: 8,
          waitTime: 15,
          reliability: 4.5,
          amenities: ['Parking', 'Restroom'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Mission+SwapStop',
        ),
        // Marina District
        MockStationData(
          id: 'st_003',
          name: 'Marina Power Station',
          latitude: 37.8024,
          longitude: -122.4351,
          availableSlots: 8,
          totalSlots: 12,
          waitTime: 3,
          reliability: 4.9,
          amenities: ['Wifi', 'Parking', 'Restaurant'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Marina+Power',
        ),
        // SoMa
        MockStationData(
          id: 'st_004',
          name: 'SoMa Rapid Swap',
          latitude: 37.7749,
          longitude: -122.3979,
          availableSlots: 4,
          totalSlots: 10,
          waitTime: 12,
          reliability: 4.6,
          amenities: ['Wifi', 'Charging', 'Lounge'],
          imageUrl: 'https://via.placeholder.com/300x200?text=SoMa+Rapid',
        ),
        // SOMA Tech Hub
        MockStationData(
          id: 'st_005',
          name: 'Tech Central Hub',
          latitude: 37.7849,
          longitude: -122.3879,
          availableSlots: 6,
          totalSlots: 15,
          waitTime: 5,
          reliability: 4.7,
          amenities: ['Wifi', 'Parking', 'Café', 'Charging'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Tech+Central',
        ),
        // Hayes Valley
        MockStationData(
          id: 'st_006',
          name: 'Hayes Valley Express',
          latitude: 37.7765,
          longitude: -122.4284,
          availableSlots: 3,
          totalSlots: 8,
          waitTime: 10,
          reliability: 4.4,
          amenities: ['Café', 'Restroom'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Hayes+Valley',
        ),
        // Richmond District
        MockStationData(
          id: 'st_007',
          name: 'Richmond Quick Swap',
          latitude: 37.7694,
          longitude: -122.4862,
          availableSlots: 7,
          totalSlots: 12,
          waitTime: 6,
          reliability: 4.8,
          amenities: ['Parking', 'Wifi'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Richmond+Quick',
        ),
        // Sunset District
        MockStationData(
          id: 'st_008',
          name: 'Sunset Energy Center',
          latitude: 37.7594,
          longitude: -122.4862,
          availableSlots: 9,
          totalSlots: 14,
          waitTime: 2,
          reliability: 4.9,
          amenities: ['Parking', 'Wifi', 'Charging', 'Café'],
          imageUrl: 'https://via.placeholder.com/300x200?text=Sunset+Energy',
        ),
      ];

  /// Get nearest stations from a given location
  static List<MockStationData> getNearestStations({
    required double latitude,
    required double longitude,
    int limit = 5,
  }) {
    final allStations = getAllStations();

    // Calculate distances
    final stationsWithDistance = allStations.map((station) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        station.latitude,
        station.longitude,
      );
      return MapEntry(station, distance);
    }).toList();

    // Sort by distance and return limited list
    stationsWithDistance.sort((a, b) => a.value.compareTo(b.value));
    return stationsWithDistance
        .take(limit)
        .map((entry) => entry.key.copyWith(distance: entry.value))
        .toList();
  }

  /// Get recommended station (best combination of distance, wait time, and availability)
  static MockStationData getRecommendedStation({
    required double latitude,
    required double longitude,
  }) {
    final allStations = getAllStations();

    // Calculate score for each station
    final stationsWithScore = allStations.map((station) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        station.latitude,
        station.longitude,
      );

      // Score calculation: lower is better
      // Distance weight: 40%, Wait time weight: 30%, Availability weight: 30%
      final availabilityRatio = station.availableSlots / station.totalSlots;
      final score = (distance * 0.4) +
          (station.waitTime * 0.3) +
          ((1 - availabilityRatio) * 100 * 0.3);

      return MapEntry(station.copyWith(distance: distance), score);
    }).toList();

    stationsWithScore.sort((a, b) => a.value.compareTo(b.value));
    return stationsWithScore.first.key;
  }

  /// Calculate distance between two coordinates using Haversine formula
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371; // Earth's radius in km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    // Using dart:math for trigonometric functions
    final sinDLat2 = math.sin(dLat / 2);
    final sinDLon2 = math.sin(dLon / 2);
    final lat1Rad = _toRad(lat1);
    final lat2Rad = _toRad(lat2);

    final a = sinDLat2 * sinDLat2 +
        math.cos(lat1Rad) * math.cos(lat2Rad) * sinDLon2 * sinDLon2;

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  static double _toRad(double degree) {
    return degree * (math.pi / 180);
  }
}

/// Mock station data model
class MockStationData {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distance; // in km
  final int availableSlots;
  final int totalSlots;
  final int waitTime; // in minutes
  final double reliability; // 1-5 rating
  final List<String> amenities;
  final String imageUrl;

  MockStationData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.distance = 0,
    required this.availableSlots,
    required this.totalSlots,
    required this.waitTime,
    required this.reliability,
    required this.amenities,
    required this.imageUrl,
  });

  MockStationData copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? distance,
    int? availableSlots,
    int? totalSlots,
    int? waitTime,
    double? reliability,
    List<String>? amenities,
    String? imageUrl,
  }) {
    return MockStationData(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      availableSlots: availableSlots ?? this.availableSlots,
      totalSlots: totalSlots ?? this.totalSlots,
      waitTime: waitTime ?? this.waitTime,
      reliability: reliability ?? this.reliability,
      amenities: amenities ?? this.amenities,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  LatLng get latLng => LatLng(latitude, longitude);
}
