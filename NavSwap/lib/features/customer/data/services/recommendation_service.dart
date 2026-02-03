import 'package:dio/dio.dart';

class RecommendationService {
  final Dio _dio;

  RecommendationService(this._dio);

  Future<Map<String, dynamic>> getRecommendations({
    required String userId,
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(
        '/recommend',
        queryParameters: {
          'userId': userId,
          'lat': lat,
          'lon': lon,
        },
      );
      return response.data;
    } catch (e) {
      print('Error getting recommendations: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCachedRecommendation(String requestId) async {
    try {
      final response = await _dio.get('/recommend/$requestId');
      return response.data;
    } catch (e) {
      print('Error getting cached recommendation: $e');
      rethrow;
    }
  }
}