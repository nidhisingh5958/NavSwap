import 'package:dio/dio.dart';

class QueueService {
  final Dio _dio;

  QueueService(this._dio);

  Future<Map<String, dynamic>> joinQueue() async {
    try {
      final response = await _dio.post('/queue/join');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQueueStatus() async {
    try {
      final response = await _dio.get('/queue/status');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveQueue() async {
    try {
      await _dio.post('/queue/leave');
    } catch (e) {
      rethrow;
    }
  }
}
