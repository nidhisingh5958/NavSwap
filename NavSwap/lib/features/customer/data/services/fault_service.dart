import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling station fault reporting
class FaultService {
  final Dio _dio;

  FaultService(this._dio);

  /// Report a station fault
  /// Critical faults automatically create tickets
  ///
  /// [stationId] - Station identifier
  /// [reportedBy] - User ID reporting the fault
  /// [faultLevel] - Fault severity: 'low', 'medium', 'high', or 'critical'
  /// [description] - Description of the fault
  ///
  /// Returns ticket information if created (for critical faults)
  Future<Map<String, dynamic>> reportFault({
    required String stationId,
    required String reportedBy,
    required String faultLevel,
    required String description,
  }) async {
    try {
      // Validate fault level
      final validLevels = ['low', 'medium', 'high', 'critical'];
      if (!validLevels.contains(faultLevel.toLowerCase())) {
        throw ArgumentError(
            'faultLevel must be one of: ${validLevels.join(", ")}');
      }

      final response = await _dio.post(
        ApiConstants.reportFault,
        data: {
          'stationId': stationId,
          'reportedBy': reportedBy,
          'faultLevel': faultLevel,
          'description': description,
        },
      );
      return response.data;
    } catch (e) {
      print('Error reporting fault: $e');
      rethrow;
    }
  }

  /// Manually raise a fault ticket (admin/staff only)
  ///
  /// [stationId] - Station identifier
  /// [reportedBy] - Staff/admin ID
  /// [faultLevel] - Fault severity: 'low', 'medium', 'high', or 'critical'
  /// [description] - Description of the fault
  ///
  /// Returns created ticket information
  Future<Map<String, dynamic>> createTicket({
    required String stationId,
    required String reportedBy,
    required String faultLevel,
    required String description,
  }) async {
    try {
      // Validate fault level
      final validLevels = ['low', 'medium', 'high', 'critical'];
      if (!validLevels.contains(faultLevel.toLowerCase())) {
        throw ArgumentError(
            'faultLevel must be one of: ${validLevels.join(", ")}');
      }

      final response = await _dio.post(
        ApiConstants.createTicket,
        data: {
          'stationId': stationId,
          'reportedBy': reportedBy,
          'faultLevel': faultLevel,
          'description': description,
        },
      );
      return response.data;
    } catch (e) {
      print('Error creating ticket: $e');
      rethrow;
    }
  }
}
