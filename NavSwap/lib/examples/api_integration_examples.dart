/// NAVSWAP API INTEGRATION EXAMPLES
///
/// This file demonstrates how to use the integrated EV Charging Platform APIs
/// in your Flutter app.
///
/// DO NOT import this file in production code - it's for reference only.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:navswap_app/features/customer/providers/service_providers.dart';
import 'package:navswap_app/features/transporter/providers/service_providers.dart';
import 'package:navswap_app/features/customer/data/models/recommendation_models.dart';
import 'package:navswap_app/features/customer/data/models/queue_models.dart';
import 'package:navswap_app/features/transporter/data/models/delivery_models.dart';
import 'package:navswap_app/features/customer/data/services/recommendation_service.dart';

// ==================== CUSTOMER EXAMPLES ====================

/// Example: Get charging station recommendations
class RecommendationExample extends ConsumerWidget {
  const RecommendationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final service = ref.read(recommendationServiceProvider);

        try {
          // Method 1: GET request with query parameters
          final response = await service.getRecommendations(
            userId: 'USR_001',
            lat: 37.7749,
            lon: -122.4194,
            batteryLevel: 25,
            chargerType: 'fast',
            maxWaitTime: 15,
            maxDistance: 10,
            limit: 5,
          );

          // Parse response using model
          final recommendation = RecommendationResponse.fromJson(response);

          if (recommendation.success) {
            // Access data
            print('Request ID: ${recommendation.data.requestId}');
            print(
                'Recommendations: ${recommendation.data.recommendations.length}');

            // Show first recommendation
            if (recommendation.data.recommendations.isNotEmpty) {
              final station = recommendation.data.recommendations.first;
              print('Top station: ${station.stationName}');
              print('Score: ${station.score}');
              print('Wait time: ${station.estimatedWaitTime} minutes');
              print('Distance: ${station.estimatedDistance} km');
            }

            // Save requestId for later use (selection/feedback)
            final requestId = recommendation.data.requestId;

            // Record station selection when user picks one
            await service.recordSelection(
              requestId: requestId,
              stationId: recommendation.data.recommendations.first.stationId,
            );

            // Submit feedback after charging
            await service.submitFeedback(
              requestId: requestId,
              rating: 5, // 1-5 rating
            );
          }
        } catch (e) {
          print('Error getting recommendations: $e');
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: const Text('Get Recommendations'),
    );
  }
}

/// Example: Join battery swap queue with QR code
class QueueExample extends ConsumerWidget {
  const QueueExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final service = ref.read(queueServiceProvider);

        try {
          // User arrives at station and joins queue
          final response = await service.joinQueue(
            stationId: 'ST_101',
            userId: 'USR_001',
          );

          // Parse response
          final queueResponse = QueueResponse.fromJson(response);

          if (queueResponse.success) {
            // QR code data and image path
            final qrCode = queueResponse.qrCode;
            final qrImagePath = queueResponse.qrImagePath;

            print('QR Code: $qrCode');
            print('QR Image: $qrImagePath');

            // Display QR code to user
            // They will show this to station staff

            // Queue entry details
            final entry = queueResponse.entry;
            print('Queue entry ID: ${entry?.id}');
            print('Status: ${entry?.status}'); // 'waiting'
          }
        } catch (e) {
          print('Error joining queue: $e');
        }
      },
      child: const Text('Join Queue'),
    );
  }
}

/// Example: Report a station fault
class FaultReportExample extends ConsumerWidget {
  const FaultReportExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final service = ref.read(faultServiceProvider);

        try {
          // Report a critical fault
          final response = await service.reportFault(
            stationId: 'ST_101',
            reportedBy: 'USR_001',
            faultLevel: 'critical', // 'low', 'medium', 'high', 'critical'
            description: 'Charger not responding, error code E502',
          );

          if (response['success']) {
            // Check if ticket was created (only for critical faults)
            if (response['ticketCreated'] == true) {
              final ticket = response['ticket'];
              print('Ticket created: ${ticket['id']}');
              print('Status: ${ticket['status']}');

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Critical fault reported. Ticket created.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fault reported successfully.'),
                ),
              );
            }
          }
        } catch (e) {
          print('Error reporting fault: $e');
        }
      },
      child: const Text('Report Fault'),
    );
  }
}

/// Example: Get station information
class StationInfoExample extends ConsumerWidget {
  const StationInfoExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final service = ref.read(stationServiceProvider);

        try {
          // Get station score
          final scoreResponse = await service.getStationScore('ST_101');
          if (scoreResponse['success']) {
            final score = scoreResponse['data'];
            print('Overall score: ${score['overallScore']}');
            print(
                'Wait time score: ${score['componentScores']['waitTimeScore']}');
          }

          // Get station health
          final healthResponse = await service.getStationHealth('ST_101');
          if (healthResponse['success']) {
            final health = healthResponse['data'];
            print(
                'Status: ${health['status']}'); // operational/degraded/offline
            print('Uptime: ${health['uptimePercentage']}%');
            print('Health score: ${health['healthScore']}');
          }

          // Get AI predictions
          final predictions = await service.getStationPredictions('ST_101');
          if (predictions['success']) {
            final loadForecast = predictions['data']['loadForecast'];
            final faultPrediction = predictions['data']['faultPrediction'];

            print('Predicted load: ${loadForecast['predictedLoad']}');
            print(
                'Peak hours: ${loadForecast['peakTimeStart']} - ${loadForecast['peakTimeEnd']}');
            print('Fault probability: ${faultPrediction['faultProbability']}');
            print(
                'Risk level: ${faultPrediction['riskLevel']}'); // low/medium/high
          }
        } catch (e) {
          print('Error getting station info: $e');
        }
      },
      child: const Text('Get Station Info'),
    );
  }
}

// ==================== TRANSPORTER/DRIVER EXAMPLES ====================

/// Example: Driver accepts and manages deliveries
class DeliveryExample extends ConsumerWidget {
  const DeliveryExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Get available deliveries
        ElevatedButton(
          onPressed: () async {
            final service = ref.read(deliveryServiceProvider);

            try {
              // Get all deliveries for this driver
              final response = await service.getDriverDeliveries(
                driverId: 'DRV_001',
              );

              final deliveryResponse = DeliveryResponse.fromJson(response);

              if (deliveryResponse.success) {
                final deliveries = deliveryResponse.deliveries ?? [];

                print('You have ${deliveries.length} deliveries');

                for (var delivery in deliveries) {
                  print('Delivery ID: ${delivery.id}');
                  print(
                      'Status: ${delivery.status}'); // pending/accepted/delivered
                  print('From: ${delivery.fromShopId}');
                  print('To: ${delivery.toStationId}');
                  print('Battery: ${delivery.batteryId}');
                }
              }
            } catch (e) {
              print('Error getting deliveries: $e');
            }
          },
          child: const Text('Get My Deliveries'),
        ),

        const SizedBox(height: 16),

        // Accept a delivery
        ElevatedButton(
          onPressed: () async {
            final service = ref.read(deliveryServiceProvider);

            try {
              // Driver accepts a delivery job
              final response = await service.acceptDelivery(
                deliveryId: 'DELIV_xyz789',
                driverId: 'DRV_001',
              );

              if (response['success']) {
                final delivery = response['delivery'];
                print('Delivery accepted!');
                print('Status: ${delivery['status']}'); // 'accepted'
                print('Accepted at: ${delivery['acceptedAt']}');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Delivery accepted! Admin has been notified.'),
                  ),
                );
              }
            } catch (e) {
              print('Error accepting delivery: $e');
              // Handle error (e.g., delivery already accepted)
            }
          },
          child: const Text('Accept Delivery'),
        ),
      ],
    );
  }
}

// ==================== USAGE IN STATE MANAGEMENT ====================

/// Example: Using services in a StateNotifier
class RecommendationNotifier
    extends StateNotifier<AsyncValue<RecommendationResponse>> {
  final RecommendationService _service;

  RecommendationNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> fetchRecommendations({
    required String userId,
    required double lat,
    required double lon,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final response = await _service.getRecommendations(
        userId: userId,
        lat: lat,
        lon: lon,
        limit: 5,
      );
      return RecommendationResponse.fromJson(response);
    });
  }

  Future<void> selectStation({
    required String requestId,
    required String stationId,
  }) async {
    try {
      await _service.recordSelection(
        requestId: requestId,
        stationId: stationId,
      );
    } catch (e) {
      print('Error recording selection: $e');
    }
  }
}

final recommendationsProvider = StateNotifierProvider<RecommendationNotifier,
    AsyncValue<RecommendationResponse>>((ref) {
  final service = ref.watch(recommendationServiceProvider);
  return RecommendationNotifier(service);
});

// ==================== ERROR HANDLING ====================

/// Example: Proper error handling
class ErrorHandlingExample extends ConsumerWidget {
  const ErrorHandlingExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final service = ref.read(recommendationServiceProvider);

        try {
          final response = await service.getRecommendations(
            userId: 'USR_001',
            lat: 37.7749,
            lon: -122.4194,
          );

          // Success handling
          print('Success: $response');
        } on DioException catch (e) {
          // Handle Dio-specific errors
          if (e.response != null) {
            final statusCode = e.response?.statusCode;
            final errorData = e.response?.data;

            switch (statusCode) {
              case 400:
                print('Bad request: ${errorData['message']}');
                break;
              case 404:
                print('Not found: ${errorData['message']}');
                break;
              case 429:
                print('Rate limited. Please wait.');
                break;
              case 500:
                print('Server error. Please try again later.');
                break;
              default:
                print('Error: ${errorData['message']}');
            }
          } else {
            // Network error
            print('Network error: ${e.message}');
          }
        } catch (e) {
          // Handle other errors
          print('Unexpected error: $e');
        }
      },
      child: const Text('Test with Error Handling'),
    );
  }
}
