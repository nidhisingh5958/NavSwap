import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exceptions.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/ai_inference_service.dart';
import '../models/station_model.dart';

abstract class CustomerRemoteDataSource {
  Future<RecommendationModel> getRecommendations({
    required String userId,
    required double latitude,
    required double longitude,
    String? vehicleType,
    int? batteryLevel,
  });

  Future<void> recordStationSelection({
    required String requestId,
    required String stationId,
  });

  Future<void> submitFeedback({
    required String requestId,
    required int rating,
  });

  Future<StationScoreModel> getStationScore(String stationId);
  Future<StationHealthModel> getStationHealth(String stationId);
  
  /// Get AI predictions for a station (on-device inference)
  Future<StationPredictions?> getAIPredictions(String stationId, Map<String, double> features);
}


class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final DioService dioService;

  CustomerRemoteDataSourceImpl(this.dioService);

  @override
  Future<RecommendationModel> getRecommendations({
    required String userId,
    required double latitude,
    required double longitude,
    String? vehicleType,
    int? batteryLevel,
  }) async {
    try {
      final response = await dioService.gateway.get(
        ApiConstants.recommendEndpoint,
        queryParameters: {
          'userId': userId,
          'lat': latitude,
          'lon': longitude,
          if (vehicleType != null) 'vehicleType': vehicleType,
          if (batteryLevel != null) 'batteryLevel': batteryLevel,
          'limit': 5,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return RecommendationModel.fromJson(data);
      }
      throw ServerException(
        message: 'Failed to get recommendations',
        originalException: response,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> recordStationSelection({
    required String requestId,
    required String stationId,
  }) async {
    try {
      await dioService.recommendation.post(
        '${ApiConstants.recordSelectionEndpoint}/$requestId/select',
        data: {'stationId': stationId},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> submitFeedback({
    required String requestId,
    required int rating,
  }) async {
    try {
      await dioService.recommendation.post(
        '${ApiConstants.submitFeedbackEndpoint}/$requestId/feedback',
        data: {'rating': rating},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<StationScoreModel> getStationScore(String stationId) async {
    try {
      final response = await dioService.gateway.get(
        '${ApiConstants.stationScoreEndpoint}/$stationId/score',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return StationScoreModel.fromJson(data);
      }
      throw ServerException(
        message: 'Failed to get station score',
        originalException: response,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<StationHealthModel> getStationHealth(String stationId) async {
    try {
      final response = await dioService.gateway.get(
        '${ApiConstants.stationHealthEndpoint}/$stationId/health',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return StationHealthModel.fromJson(data);
      }
      throw ServerException(
        message: 'Failed to get station health',
        originalException: response,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  ApiException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException(
        message: 'Connection timeout. Please try again.',
        originalException: e,
      );
    }
    return ServerException(
      message: e.message ?? 'An error occurred',
      originalException: e,
    );
  }

  /// Get AI predictions using on-device ONNX models
  @override
  Future<StationPredictions?> getAIPredictions(
    String stationId, 
    Map<String, double> features,
  ) async {
    try {
      final aiService = AIInferenceService();
      await aiService.initialize();
      return await aiService.getStationPredictions(features);
    } catch (e) {
      print('⚠️ On-device AI prediction failed: $e');
      return null;
    }
  }
}
