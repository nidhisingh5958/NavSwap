import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling EV charging station recommendations
class RecommendationService {
  final Dio _dio;

  RecommendationService(this._dio);

  /// Get charging station recommendations based on user location and preferences
  ///
  /// [userId] - User identifier
  /// [lat] - User's latitude
  /// [lon] - User's longitude
  /// [vehicleType] - Optional vehicle model
  /// [batteryLevel] - Optional battery percentage (0-100)
  /// [chargerType] - Optional: 'fast', 'standard', or 'any'
  /// [maxWaitTime] - Optional max wait time in minutes
  /// [maxDistance] - Optional max distance in kilometers
  /// [limit] - Optional number of results (1-20, default: 5)
  Future<Map<String, dynamic>> getRecommendations({
    required String userId,
    required double lat,
    required double lon,
    String? vehicleType,
    int? batteryLevel,
    String? chargerType,
    int? maxWaitTime,
    double? maxDistance,
    int? limit,
  }) async {
    try {
      final queryParams = {
        'userId': userId,
        'lat': lat,
        'lon': lon,
        if (vehicleType != null) 'vehicleType': vehicleType,
        if (batteryLevel != null) 'batteryLevel': batteryLevel,
        if (chargerType != null) 'chargerType': chargerType,
        if (maxWaitTime != null) 'maxWaitTime': maxWaitTime,
        if (maxDistance != null) 'maxDistance': maxDistance,
        if (limit != null) 'limit': limit,
      };

      final response = await _dio.get(
        ApiConstants.recommendEndpoint,
        queryParameters: queryParams,
      );
      return response.data;
    } catch (e) {
      print('Error getting recommendations: $e');
      rethrow;
    }
  }

  /// Get recommendations via POST (same as GET but with body)
  /// Better for complex requests
  Future<Map<String, dynamic>> getRecommendationsPost({
    required String userId,
    required double latitude,
    required double longitude,
    String? vehicleType,
    int? batteryLevel,
    String? preferredChargerType,
    int? maxWaitTime,
    double? maxDistance,
    int? limit,
  }) async {
    try {
      final body = {
        'userId': userId,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        },
        if (vehicleType != null) 'vehicleType': vehicleType,
        if (batteryLevel != null) 'batteryLevel': batteryLevel,
        if (preferredChargerType != null)
          'preferredChargerType': preferredChargerType,
        if (maxWaitTime != null) 'maxWaitTime': maxWaitTime,
        if (maxDistance != null) 'maxDistance': maxDistance,
        if (limit != null) 'limit': limit,
      };

      final response = await _dio.post(
        ApiConstants.recommendEndpoint,
        data: body,
      );
      return response.data;
    } catch (e) {
      print('Error getting recommendations (POST): $e');
      rethrow;
    }
  }

  /// Retrieve a cached recommendation by request ID
  /// Cache expires after 5 minutes
  Future<Map<String, dynamic>> getCachedRecommendation(String requestId) async {
    try {
      final response =
          await _dio.get(ApiConstants.getCachedRecommendation(requestId));
      return response.data;
    } catch (e) {
      print('Error getting cached recommendation: $e');
      rethrow;
    }
  }

  /// Record when user selects a station from recommendations
  /// Use for analytics and model improvement
  ///
  /// [requestId] - The request ID from the recommendation response
  /// [stationId] - The selected station ID
  Future<Map<String, dynamic>> recordSelection({
    required String requestId,
    required String stationId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.recordSelection(requestId),
        data: {'stationId': stationId},
      );
      return response.data;
    } catch (e) {
      print('Error recording selection: $e');
      rethrow;
    }
  }

  /// Submit feedback on recommendation quality
  ///
  /// [requestId] - The request ID from the recommendation response
  /// [rating] - Rating from 1 (poor) to 5 (excellent)
  Future<Map<String, dynamic>> submitFeedback({
    required String requestId,
    required int rating,
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw ArgumentError('Rating must be between 1 and 5');
      }

      final response = await _dio.post(
        ApiConstants.submitFeedback(requestId),
        data: {'rating': rating},
      );
      return response.data;
    } catch (e) {
      print('Error submitting feedback: $e');
      rethrow;
    }
  }
}
