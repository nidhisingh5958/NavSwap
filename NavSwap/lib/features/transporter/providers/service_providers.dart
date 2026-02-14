import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/dio_service.dart';
import '../data/services/delivery_service.dart';

// ==================== TRANSPORTER SERVICE PROVIDERS ====================

/// Provider for Delivery Service
/// Manages battery delivery operations for drivers/transporters
final deliveryServiceProvider = Provider<DeliveryService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return DeliveryService(dioService.gateway);
});
