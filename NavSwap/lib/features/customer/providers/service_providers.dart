import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/dio_service.dart';
import '../data/services/recommendation_service.dart';
import '../data/services/queue_service.dart';
import '../data/services/station_service.dart';
import '../data/services/fault_service.dart';
import '../data/services/ingestion_service.dart';

// ==================== CUSTOMER SERVICE PROVIDERS ====================

/// Provider for Recommendation Service
/// Manages charging station recommendations
final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return RecommendationService(dioService.gateway);
});

/// Provider for Queue Service
/// Manages battery swap queue operations
final queueServiceProvider = Provider<QueueService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return QueueService(dioService.gateway);
});

/// Provider for Station Service
/// Manages station data, scores, health, and predictions
final stationServiceProvider = Provider<StationService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return StationService(dioService.gateway);
});

/// Provider for Fault Service
/// Manages fault reporting and ticket creation
final faultServiceProvider = Provider<FaultService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return FaultService(dioService.gateway);
});

/// Provider for Ingestion Service
/// Manages data ingestion operations
final ingestionServiceProvider = Provider<IngestionService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return IngestionService(dioService.ingestion);
});
