import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';

/// Service for handling battery delivery operations (Driver/Transporter)
class DeliveryService {
  final Dio _dio;

  DeliveryService(this._dio);

  /// Create delivery job and alert nearby drivers
  ///
  /// [batteryId] - Battery identifier
  /// [fromShopId] - Source shop/warehouse identifier
  /// [toStationId] - Destination station identifier
  ///
  /// Returns delivery job details and alert confirmation
  Future<Map<String, dynamic>> createDeliveryAlert({
    required String batteryId,
    required String fromShopId,
    required String toStationId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deliveryAlert,
        data: {
          'batteryId': batteryId,
          'fromShopId': fromShopId,
          'toStationId': toStationId,
        },
      );
      return response.data;
    } catch (e) {
      print('Error creating delivery alert: $e');
      rethrow;
    }
  }

  /// Driver accepts a delivery job
  ///
  /// [deliveryId] - Delivery job identifier
  /// [driverId] - Driver identifier
  ///
  /// Returns updated delivery details with assigned driver
  /// Note: If delivery is already accepted, returns 400 error
  Future<Map<String, dynamic>> acceptDelivery({
    required String deliveryId,
    required String driverId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deliveryAccept,
        data: {
          'deliveryId': deliveryId,
          'driverId': driverId,
        },
      );
      return response.data;
    } catch (e) {
      print('Error accepting delivery: $e');
      rethrow;
    }
  }

  /// Admin confirms delivery completion
  ///
  /// [deliveryId] - Delivery job identifier
  ///
  /// Returns updated delivery status
  Future<Map<String, dynamic>> confirmDelivery({
    required String deliveryId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deliveryConfirm,
        data: {
          'deliveryId': deliveryId,
        },
      );
      return response.data;
    } catch (e) {
      print('Error confirming delivery: $e');
      rethrow;
    }
  }

  /// Get all deliveries for a specific driver
  ///
  /// [driverId] - Driver identifier
  ///
  /// Returns list of deliveries assigned to the driver
  Future<Map<String, dynamic>> getDriverDeliveries({
    required String driverId,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getDriverDeliveries(driverId),
      );
      return response.data;
    } catch (e) {
      print('Error getting driver deliveries: $e');
      rethrow;
    }
  }

  /// Get all deliveries (admin only)
  ///
  /// Returns list of all deliveries in the system
  Future<Map<String, dynamic>> getAllDeliveries() async {
    try {
      final response = await _dio.get(
        ApiConstants.getAllDeliveries,
      );
      return response.data;
    } catch (e) {
      print('Error getting all deliveries: $e');
      rethrow;
    }
  }
}
