# NavSwap API Integration Guide

This guide explains how to use the integrated EV Charging Platform APIs in the NavSwap Flutter application.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Setup](#setup)
- [Customer Features](#customer-features)
- [Transporter/Driver Features](#transporterdriver-features)
- [API Services](#api-services)
- [Models](#models)
- [Error Handling](#error-handling)
- [Examples](#examples)

---

## Overview

The NavSwap app integrates with a comprehensive EV Charging Platform backend that provides:

- **AI-powered station recommendations** based on location, battery level, and preferences
- **Battery swap queue management** with QR code verification
- **Delivery management** for battery transporters/drivers
- **Real-time station data** including scores, health, and predictions
- **Fault reporting** for station issues

All APIs are organized into feature-specific services with proper type-safe models.

---

## Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # All API endpoint constants
│   └── services/
│       └── dio_service.dart             # Dio HTTP client configuration
│
├── features/
│   ├── customer/
│   │   ├── data/
│   │   │   ├── models/                  # Response models
│   │   │   │   ├── recommendation_models.dart
│   │   │   │   ├── queue_models.dart
│   │   │   │   ├── station_models.dart
│   │   │   │   └── fault_models.dart
│   │   │   └── services/                # API services
│   │   │       ├── recommendation_service.dart
│   │   │       ├── queue_service.dart
│   │   │       ├── station_service.dart
│   │   │       ├── fault_service.dart
│   │   │       └── ingestion_service.dart
│   │   └── providers/
│   │       └── service_providers.dart   # Riverpod providers
│   │
│   └── transporter/
│       ├── data/
│       │   ├── models/
│       │   │   └── delivery_models.dart
│       │   └── services/
│       │       └── delivery_service.dart
│       └── providers/
│           └── service_providers.dart
│
└── examples/
    └── api_integration_examples.dart     # Usage examples
```

---

## Setup

### 1. API Configuration

Update the base URL in `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String apiGatewayBaseUrl = 'http://localhost:3000';
  // ... or your production URL
}
```

### 2. Import Providers

In your feature files, import the service providers:

```dart
// For customer features
import 'package:navswap_app/features/customer/providers/service_providers.dart';

// For transporter features
import 'package:navswap_app/features/transporter/providers/service_providers.dart';
```

---

## Customer Features

### 1. Station Recommendations

Get AI-powered charging station recommendations:

```dart
class RecommendationsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(recommendationServiceProvider);
    
    return FutureBuilder(
      future: service.getRecommendations(
        userId: 'USR_001',
        lat: 37.7749,
        lon: -122.4194,
        batteryLevel: 25,
        chargerType: 'fast',
        maxWaitTime: 15,
        maxDistance: 10,
        limit: 5,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final response = RecommendationResponse.fromJson(snapshot.data!);
          return ListView.builder(
            itemCount: response.data.recommendations.length,
            itemBuilder: (context, index) {
              final station = response.data.recommendations[index];
              return StationCard(station: station);
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

#### Recording Selection & Feedback

When user selects a station:

```dart
final service = ref.read(recommendationServiceProvider);

// Record selection
await service.recordSelection(
  requestId: savedRequestId,
  stationId: selectedStation.stationId,
);

// Submit feedback (1-5 rating)
await service.submitFeedback(
  requestId: savedRequestId,
  rating: 5,
);
```

### 2. Queue Management

Join queue and get QR code:

```dart
final queueService = ref.read(queueServiceProvider);

// User arrives at station
final response = await queueService.joinQueue(
  stationId: 'ST_101',
  userId: 'USR_001',
);

final queueResponse = QueueResponse.fromJson(response);

if (queueResponse.success) {
  // Display QR code to user
  final qrCode = queueResponse.qrCode;
  final qrImagePath = queueResponse.qrImagePath;
  
  // Show QR code widget
  QRCodeWidget(
    data: qrCode,
    imagePath: qrImagePath,
  );
}
```

### 3. Station Information

Get real-time station data:

```dart
final stationService = ref.read(stationServiceProvider);

// Get station score
final scoreResponse = await stationService.getStationScore('ST_101');
final score = StationScoreResponse.fromJson(scoreResponse);

// Get station health
final healthResponse = await stationService.getStationHealth('ST_101');
final health = StationHealthResponse.fromJson(healthResponse);

// Get AI predictions
final predictions = await stationService.getStationPredictions('ST_101');
```

### 4. Fault Reporting

Report station issues:

```dart
final faultService = ref.read(faultServiceProvider);

// Report a fault
final response = await faultService.reportFault(
  stationId: 'ST_101',
  reportedBy: 'USR_001',
  faultLevel: 'critical', // 'low', 'medium', 'high', 'critical'
  description: 'Charger not responding, error code E502',
);

final reportResponse = FaultReportResponse.fromJson(response);

if (reportResponse.ticketCreated == true) {
  // Ticket was created for critical fault
  final ticket = reportResponse.ticket;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Fault Reported'),
      content: Text('Ticket #${ticket.id} created'),
    ),
  );
}
```

---

## Transporter/Driver Features

### Delivery Management

#### View Available Deliveries

```dart
final deliveryService = ref.read(deliveryServiceProvider);

// Get deliveries for this driver
final response = await deliveryService.getDriverDeliveries(
  driverId: 'DRV_001',
);

final deliveryResponse = DeliveryResponse.fromJson(response);

if (deliveryResponse.success) {
  final deliveries = deliveryResponse.deliveries ?? [];
  
  return ListView.builder(
    itemCount: deliveries.length,
    itemBuilder: (context, index) {
      final delivery = deliveries[index];
      return DeliveryCard(
        id: delivery.id,
        from: delivery.fromShopId,
        to: delivery.toStationId,
        status: delivery.status,
        battery: delivery.batteryId,
      );
    },
  );
}
```

#### Accept Delivery

```dart
// Driver accepts a delivery job
final response = await deliveryService.acceptDelivery(
  deliveryId: 'DELIV_xyz789',
  driverId: 'DRV_001',
);

if (response['success']) {
  showSnackBar(context, 'Delivery accepted! Admin has been notified.');
}
```

---

## API Services

### Available Services

| Service | Provider | Purpose |
|---------|----------|---------|
| `RecommendationService` | `recommendationServiceProvider` | Get station recommendations |
| `QueueService` | `queueServiceProvider` | Manage battery swap queue |
| `StationService` | `stationServiceProvider` | Get station data & predictions |
| `FaultService` | `faultServiceProvider` | Report faults & create tickets |
| `IngestionService` | `ingestionServiceProvider` | Ingest telemetry data |
| `DeliveryService` | `deliveryServiceProvider` | Manage deliveries (driver) |

### Service Methods

#### RecommendationService

```dart
// Get recommendations
getRecommendations({userId, lat, lon, ...}) → Map<String, dynamic>

// Get recommendations (POST)
getRecommendationsPost({userId, latitude, longitude, ...}) → Map<String, dynamic>

// Get cached recommendation
getCachedRecommendation(requestId) → Map<String, dynamic>

// Record station selection
recordSelection({requestId, stationId}) → Map<String, dynamic>

// Submit feedback
submitFeedback({requestId, rating}) → Map<String, dynamic>
```

#### QueueService

```dart
// Join queue
joinQueue({stationId, userId}) → Map<String, dynamic>

// Verify QR code (staff use)
verifyQrCode({qrCode}) → Map<String, dynamic>

// Complete swap (staff use)
completeSwap({qrCode}) → Map<String, dynamic>
```

#### StationService

```dart
// Get station score
getStationScore(stationId) → Map<String, dynamic>

// Get station health
getStationHealth(stationId) → Map<String, dynamic>

// Get AI predictions
getStationPredictions(stationId) → Map<String, dynamic>
```

#### DeliveryService

```dart
// Get driver deliveries
getDriverDeliveries({driverId}) → Map<String, dynamic>

// Accept delivery
acceptDelivery({deliveryId, driverId}) → Map<String, dynamic>

// Confirm delivery (admin)
confirmDelivery({deliveryId}) → Map<String, dynamic>
```

---

## Models

### Response Models

All API responses have corresponding Dart models with `fromJson` and `toJson` methods:

```dart
// Recommendation models
RecommendationResponse
RecommendationData
RankedStation
LoadForecast
FaultPrediction

// Queue models
QueueResponse
QueueEntry

// Station models
StationScoreResponse
StationScore
StationHealthResponse
StationHealth

// Delivery models
DeliveryResponse
Delivery

// Fault models
FaultReportResponse
FaultTicket
```

### Example Usage

```dart
// Parse API response into model
final json = await service.getRecommendations(...);
final recommendation = RecommendationResponse.fromJson(json);

// Access typed data
final firstStation = recommendation.data.recommendations.first;
print(firstStation.stationName);
print(firstStation.score);
print(firstStation.estimatedWaitTime);
```

---

## Error Handling

### Handling API Errors

```dart
import 'package:dio/dio.dart';

try {
  final response = await service.getRecommendations(...);
  // Success
} on DioException catch (e) {
  if (e.response != null) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data;
    
    switch (statusCode) {
      case 400:
        // Bad request - validation error
        showError('Invalid request: ${errorData['message']}');
        break;
      case 404:
        // Not found
        showError('Resource not found');
        break;
      case 429:
        // Rate limited
        showError('Too many requests. Please wait.');
        break;
      case 500:
        // Server error
        showError('Server error. Please try again later.');
        break;
      default:
        showError('Error: ${errorData['message']}');
    }
  } else {
    // Network error
    showError('Network error. Check your connection.');
  }
} catch (e) {
  // Other errors
  showError('Unexpected error: $e');
}
```

### Common Error Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process response |
| 202 | Accepted | Request queued |
| 400 | Bad Request | Check parameters |
| 404 | Not Found | Resource doesn't exist |
| 429 | Rate Limited | Wait and retry |
| 500 | Server Error | Retry later |
| 503 | Unavailable | System not ready |

---

## Examples

Complete usage examples are available in:

**`lib/examples/api_integration_examples.dart`**

This file includes:
- Customer examples (recommendations, queue, faults)
- Driver examples (deliveries)
- State management patterns
- Error handling patterns

---

## Best Practices

### 1. Cache Request IDs

```dart
// Save requestId for later use
final response = await service.getRecommendations(...);
final requestId = response['data']['requestId'];
await prefs.setString('lastRequestId', requestId);
```

### 2. Use Models for Type Safety

```dart
// ✅ Good - Type safe
final recommendation = RecommendationResponse.fromJson(json);
final score = recommendation.data.recommendations.first.score;

// ❌ Avoid - No type checking
final score = json['data']['recommendations'][0]['score'];
```

### 3. Handle Loading States

```dart
final recommendations = ref.watch(recommendationsProvider);

recommendations.when(
  data: (data) => StationList(data),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
);
```

### 4. Implement Retry Logic

```dart
Future<T> retryRequest<T>(Future<T> Function() request, {int maxRetries = 3}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await request();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: 2 * (i + 1)));
    }
  }
  throw Exception('Max retries exceeded');
}
```

---

## API Documentation

For complete API documentation, see:

- [Frontend Integration Guide](../docs/INTEGRATION_GUIDE.md)
- [API Reference](../docs/API_REFERENCE.md)

---

## Support

For questions or issues:
1. Check the examples in `lib/examples/api_integration_examples.dart`
2. Review error logs in debug mode (Dio logger is enabled)
3. Consult the backend API documentation

---

## Changelog

### v1.0.0 (2024-01-28)
- Initial API integration
- Customer features (recommendations, queue, faults)
- Transporter features (deliveries)
- Complete type-safe models
- Comprehensive error handling
