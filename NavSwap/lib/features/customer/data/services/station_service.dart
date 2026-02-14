import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling charging station data
class StationService {
  final Dio _dio;

  StationService(this._dio);

  /// Get real-time score for a specific station
  ///
  /// [stationId] - Station identifier
  ///
  /// Returns overall score, component scores, rank, and confidence
  Future<Map<String, dynamic>> getStationScore(String stationId) async {
    try {
      final response = await _dio.get(
        ApiConstants.getStationScore(stationId),
      );
      return response.data;
    } catch (e) {
      print('Error getting station score: $e');
      rethrow;
    }
  }

  /// Get health status for a station
  ///
  /// [stationId] - Station identifier
  ///
  /// Returns status, maintenance info, uptime, alerts, and health score
  /// Note: Health data must be ingested first via POST /ingest/health
  Future<Map<String, dynamic>> getStationHealth(String stationId) async {
    try {
      final response = await _dio.get(
        ApiConstants.getStationHealth(stationId),
      );
      return response.data;
    } catch (e) {
      print('Error getting station health: $e');
      rethrow;
    }
  }

  /// Get AI predictions for a station
  ///
  /// [stationId] - Station identifier
  ///
  /// Returns load forecast and fault predictions
  Future<Map<String, dynamic>> getStationPredictions(String stationId) async {
    try {
      final response = await _dio.get(
        ApiConstants.getStationPredictions(stationId),
      );
      return response.data;
    } catch (e) {
      print('Error getting station predictions: $e');
      rethrow;
    }
  }

  /// Check system health
  ///
  /// Returns system status and service availability
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await _dio.get(ApiConstants.healthEndpoint);
      return response.data;
    } catch (e) {
      print('Error checking health: $e');
      rethrow;
    }
  }

  /// Check system readiness (Kubernetes-style probe)
  ///
  /// Returns 503 if system is not ready
  Future<Map<String, dynamic>> checkReady() async {
    try {
      final response = await _dio.get(ApiConstants.readyEndpoint);
      return response.data;
    } catch (e) {
      print('Error checking readiness: $e');
      rethrow;
    }
  }
}
