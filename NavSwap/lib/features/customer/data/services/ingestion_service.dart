import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling data ingestion operations
class IngestionService {
  final Dio _dio;

  IngestionService(this._dio);

  /// Ingest real-time telemetry data from charging stations
  ///
  /// [stationId] - Station identifier
  /// [queueLength] - Current queue length (optional)
  /// [avgServiceTime] - Average service time in minutes (optional)
  /// [availableChargers] - Available charger count (optional)
  /// [totalChargers] - Total charger count (optional)
  /// [faultRate] - Fault rate 0-1 (optional)
  /// [availablePower] - Available power in kW (optional)
  /// [maxCapacity] - Maximum capacity in kW (optional)
  ///
  /// Returns 202 Accepted with ingestion confirmation
  Future<Map<String, dynamic>> ingestStationTelemetry({
    required String stationId,
    int? queueLength,
    double? avgServiceTime,
    int? availableChargers,
    int? totalChargers,
    double? faultRate,
    double? availablePower,
    double? maxCapacity,
  }) async {
    try {
      final data = {
        'stationId': stationId,
        if (queueLength != null) 'queueLength': queueLength,
        if (avgServiceTime != null) 'avgServiceTime': avgServiceTime,
        if (availableChargers != null) 'availableChargers': availableChargers,
        if (totalChargers != null) 'totalChargers': totalChargers,
        if (faultRate != null) 'faultRate': faultRate,
        if (availablePower != null) 'availablePower': availablePower,
        if (maxCapacity != null) 'maxCapacity': maxCapacity,
      };

      final response = await _dio.post(
        ApiConstants.ingestStation,
        data: data,
      );
      return response.data;
    } catch (e) {
      print('Error ingesting station telemetry: $e');
      rethrow;
    }
  }

  /// Ingest telemetry for multiple stations at once
  ///
  /// [stations] - List of station telemetry data
  ///
  /// Returns batch ingestion results with success/failure counts
  Future<Map<String, dynamic>> ingestStationBatch({
    required List<Map<String, dynamic>> stations,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.ingestStationBatch,
        data: {'stations': stations},
      );
      return response.data;
    } catch (e) {
      print('Error ingesting station batch: $e');
      rethrow;
    }
  }

  /// Ingest station health status
  /// Must be called before GET /station/{id}/health will return data
  ///
  /// [stationId] - Station identifier
  /// [status] - Status: 'operational', 'degraded', 'offline', 'maintenance'
  /// [lastMaintenanceDate] - Last maintenance date (YYYY-MM-DD)
  /// [uptimePercentage] - Uptime percentage (0-100)
  /// [activeAlerts] - Array of active alerts
  /// [healthScore] - Health score (0-100)
  /// [timestamp] - Unix timestamp
  Future<Map<String, dynamic>> ingestStationHealth({
    required String stationId,
    required String status,
    required String lastMaintenanceDate,
    required double uptimePercentage,
    required List<dynamic> activeAlerts,
    required int healthScore,
    required int timestamp,
  }) async {
    try {
      // Validate status
      final validStatuses = [
        'operational',
        'degraded',
        'offline',
        'maintenance'
      ];
      if (!validStatuses.contains(status.toLowerCase())) {
        throw ArgumentError(
            'status must be one of: ${validStatuses.join(", ")}');
      }

      final response = await _dio.post(
        ApiConstants.ingestHealth,
        data: {
          'stationId': stationId,
          'status': status,
          'lastMaintenanceDate': lastMaintenanceDate,
          'uptimePercentage': uptimePercentage,
          'activeAlerts': activeAlerts,
          'healthScore': healthScore,
          'timestamp': timestamp,
        },
      );
      return response.data;
    } catch (e) {
      print('Error ingesting station health: $e');
      rethrow;
    }
  }

  /// Ingest user context for personalized recommendations
  ///
  /// [userId] - User identifier
  /// [sessionId] - Session identifier
  /// [latitude] - Current latitude
  /// [longitude] - Current longitude
  /// [vehicleType] - Vehicle model
  /// [batteryLevel] - Battery percentage (0-100)
  /// [preferredChargerType] - Preferred charger type: 'fast', 'standard', 'any'
  /// [maxWaitTime] - Max acceptable wait time in minutes
  /// [maxDistance] - Max acceptable distance in km
  /// [timestamp] - Unix timestamp
  Future<Map<String, dynamic>> ingestUserContext({
    required String userId,
    required String sessionId,
    required double latitude,
    required double longitude,
    required String vehicleType,
    required int batteryLevel,
    required String preferredChargerType,
    required int maxWaitTime,
    required double maxDistance,
    required int timestamp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.ingestUserContext,
        data: {
          'userId': userId,
          'sessionId': sessionId,
          'currentLocation': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'vehicleType': vehicleType,
          'batteryLevel': batteryLevel,
          'preferredChargerType': preferredChargerType,
          'maxWaitTime': maxWaitTime,
          'maxDistance': maxDistance,
          'timestamp': timestamp,
        },
      );
      return response.data;
    } catch (e) {
      print('Error ingesting user context: $e');
      rethrow;
    }
  }

  /// Ingest power grid status data
  ///
  /// [gridId] - Grid identifier
  /// [region] - Region name
  /// [currentLoad] - Current load in kW
  /// [maxCapacity] - Maximum capacity in kW
  /// [loadPercentage] - Load percentage (0-100)
  /// [peakHours] - Whether it's peak hours
  /// [pricePerKwh] - Price per kWh
  /// [timestamp] - Unix timestamp
  Future<Map<String, dynamic>> ingestGridStatus({
    required String gridId,
    required String region,
    required double currentLoad,
    required double maxCapacity,
    required double loadPercentage,
    required bool peakHours,
    required double pricePerKwh,
    required int timestamp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.ingestGrid,
        data: {
          'gridId': gridId,
          'region': region,
          'currentLoad': currentLoad,
          'maxCapacity': maxCapacity,
          'loadPercentage': loadPercentage,
          'peakHours': peakHours,
          'pricePerKwh': pricePerKwh,
          'timestamp': timestamp,
        },
      );
      return response.data;
    } catch (e) {
      print('Error ingesting grid status: $e');
      rethrow;
    }
  }
}
