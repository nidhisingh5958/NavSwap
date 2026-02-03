import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/dio_service.dart';
import '../data/services/recommendation_service.dart';
import 'package:geolocator/geolocator.dart';

final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return RecommendationService(dioService.gateway);
});

class RecommendationState {
  final bool isLoading;
  final List<StationRecommendation> stations;
  final StationRecommendation? recommendedStation;
  final String? requestId;
  final Position? userLocation;
  final String? error;

  RecommendationState({
    this.isLoading = false,
    this.stations = const [],
    this.recommendedStation,
    this.requestId,
    this.userLocation,
    this.error,
  });

  RecommendationState copyWith({
    bool? isLoading,
    List<StationRecommendation>? stations,
    StationRecommendation? recommendedStation,
    String? requestId,
    Position? userLocation,
    String? error,
  }) {
    return RecommendationState(
      isLoading: isLoading ?? this.isLoading,
      stations: stations ?? this.stations,
      recommendedStation: recommendedStation ?? this.recommendedStation,
      requestId: requestId ?? this.requestId,
      userLocation: userLocation ?? this.userLocation,
      error: error ?? this.error,
    );
  }
}

class StationRecommendation {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final double distance;
  final int queueLength;
  final int availableBatteries;
  final bool isRecommended;

  StationRecommendation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.distance,
    required this.queueLength,
    required this.availableBatteries,
    this.isRecommended = false,
  });

  factory StationRecommendation.fromJson(Map<String, dynamic> json) {
    return StationRecommendation(
      id: json['id'] ?? json['stationId'] ?? '',
      name: json['name'] ?? 'Unknown Station',
      lat: (json['lat'] ?? json['latitude'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? json['longitude'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      queueLength: json['queueLength'] ?? 0,
      availableBatteries: json['availableBatteries'] ?? 0,
      isRecommended: json['isRecommended'] ?? false,
    );
  }
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  final RecommendationService _service;

  RecommendationNotifier(this._service) : super(RecommendationState());

  Future<void> fetchRecommendations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get user location
      final position = await _getCurrentLocation();
      
      if (position == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Unable to get location',
        );
        return;
      }

      // Fetch recommendations
      final response = await _service.getRecommendations(
        userId: 'user_123', // Replace with actual user ID
        lat: position.latitude,
        lon: position.longitude,
      );

      final stations = (response['stations'] as List?)
          ?.map((s) => StationRecommendation.fromJson(s))
          .toList() ?? [];

      final recommended = response['recommended'] != null
          ? StationRecommendation.fromJson(response['recommended'])
          : (stations.isNotEmpty ? stations.first : null);

      state = state.copyWith(
        isLoading: false,
        stations: stations,
        recommendedStation: recommended,
        requestId: response['requestId'],
        userLocation: position,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch recommendations: $e',
      );
    }
  }

  Future<void> fetchCachedRecommendation(String requestId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _service.getCachedRecommendation(requestId);

      final stations = (response['stations'] as List?)
          ?.map((s) => StationRecommendation.fromJson(s))
          .toList() ?? [];

      final recommended = response['recommended'] != null
          ? StationRecommendation.fromJson(response['recommended'])
          : null;

      state = state.copyWith(
        isLoading: false,
        stations: stations,
        recommendedStation: recommended,
        requestId: requestId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch cached recommendation: $e',
      );
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
  final service = ref.watch(recommendationServiceProvider);
  return RecommendationNotifier(service);
});