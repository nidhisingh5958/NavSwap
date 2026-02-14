import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling battery swap queue management
class QueueService {
  final Dio _dio;

  QueueService(this._dio);

  /// User confirms arrival at station and receives QR code for queue entry
  ///
  /// [stationId] - Station identifier
  /// [userId] - User identifier
  ///
  /// Returns QR code, image path, and queue entry details
  Future<Map<String, dynamic>> joinQueue({
    required String stationId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.queueJoin,
        data: {
          'stationId': stationId,
          'userId': userId,
        },
      );
      return response.data;
    } catch (e) {
      print('Error joining queue: $e');
      rethrow;
    }
  }

  /// Station staff verifies user's QR code and updates queue status
  ///
  /// [qrCode] - The QR code received when joining the queue
  ///
  /// Returns updated queue entry and current queue status
  Future<Map<String, dynamic>> verifyQrCode({
    required String qrCode,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.queueVerify,
        data: {
          'qrCode': qrCode,
        },
      );
      return response.data;
    } catch (e) {
      print('Error verifying QR code: $e');
      rethrow;
    }
  }

  /// Mark battery swap as complete and dequeue user
  ///
  /// [qrCode] - The QR code of the user who completed the swap
  ///
  /// Returns updated queue entry and current queue status
  Future<Map<String, dynamic>> completeSwap({
    required String qrCode,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.queueSwap,
        data: {
          'qrCode': qrCode,
        },
      );
      return response.data;
    } catch (e) {
      print('Error completing swap: $e');
      rethrow;
    }
  }

  /// Get current queue status (if available in future API updates)
  Future<Map<String, dynamic>> getQueueStatus() async {
    try {
      final response = await _dio.get('/queue/status');
      return response.data;
    } catch (e) {
      print('Error getting queue status: $e');
      rethrow;
    }
  }

  /// Leave queue (if available in future API updates)
  Future<void> leaveQueue() async {
    try {
      await _dio.post('/queue/leave');
    } catch (e) {
      print('Error leaving queue: $e');
      rethrow;
    }
  }
}
