/// Model for station score response
class StationScoreResponse {
  final bool success;
  final StationScore? data;
  final ResponseMeta? meta;

  StationScoreResponse({
    required this.success,
    this.data,
    this.meta,
  });

  factory StationScoreResponse.fromJson(Map<String, dynamic> json) {
    return StationScoreResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? StationScore.fromJson(json['data']) : null,
      meta: json['meta'] != null ? ResponseMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data!.toJson(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }
}

class StationScore {
  final String stationId;
  final double overallScore;
  final ComponentScores componentScores;
  final int rank;
  final double confidence;
  final int timestamp;

  StationScore({
    required this.stationId,
    required this.overallScore,
    required this.componentScores,
    required this.rank,
    required this.confidence,
    required this.timestamp,
  });

  factory StationScore.fromJson(Map<String, dynamic> json) {
    return StationScore(
      stationId: json['stationId'] ?? '',
      overallScore: (json['overallScore'] ?? 0).toDouble(),
      componentScores: ComponentScores.fromJson(json['componentScores'] ?? {}),
      rank: json['rank'] ?? 0,
      confidence: (json['confidence'] ?? 0).toDouble(),
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'overallScore': overallScore,
      'componentScores': componentScores.toJson(),
      'rank': rank,
      'confidence': confidence,
      'timestamp': timestamp,
    };
  }
}

class ComponentScores {
  final double waitTimeScore;
  final double availabilityScore;
  final double reliabilityScore;
  final double distanceScore;
  final double energyStabilityScore;

  ComponentScores({
    required this.waitTimeScore,
    required this.availabilityScore,
    required this.reliabilityScore,
    required this.distanceScore,
    required this.energyStabilityScore,
  });

  factory ComponentScores.fromJson(Map<String, dynamic> json) {
    return ComponentScores(
      waitTimeScore: (json['waitTimeScore'] ?? 0).toDouble(),
      availabilityScore: (json['availabilityScore'] ?? 0).toDouble(),
      reliabilityScore: (json['reliabilityScore'] ?? 0).toDouble(),
      distanceScore: (json['distanceScore'] ?? 0).toDouble(),
      energyStabilityScore: (json['energyStabilityScore'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waitTimeScore': waitTimeScore,
      'availabilityScore': availabilityScore,
      'reliabilityScore': reliabilityScore,
      'distanceScore': distanceScore,
      'energyStabilityScore': energyStabilityScore,
    };
  }
}

/// Model for station health response
class StationHealthResponse {
  final bool success;
  final StationHealth? data;

  StationHealthResponse({
    required this.success,
    this.data,
  });

  factory StationHealthResponse.fromJson(Map<String, dynamic> json) {
    return StationHealthResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? StationHealth.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class StationHealth {
  final String stationId;
  final String status; // 'operational', 'degraded', 'offline', 'maintenance'
  final String lastMaintenanceDate;
  final double uptimePercentage;
  final List<Alert> activeAlerts;
  final int healthScore;
  final int timestamp;

  StationHealth({
    required this.stationId,
    required this.status,
    required this.lastMaintenanceDate,
    required this.uptimePercentage,
    required this.activeAlerts,
    required this.healthScore,
    required this.timestamp,
  });

  factory StationHealth.fromJson(Map<String, dynamic> json) {
    return StationHealth(
      stationId: json['stationId'] ?? '',
      status: json['status'] ?? 'operational',
      lastMaintenanceDate: json['lastMaintenanceDate'] ?? '',
      uptimePercentage: (json['uptimePercentage'] ?? 0).toDouble(),
      activeAlerts: (json['activeAlerts'] as List<dynamic>?)
              ?.map((e) => Alert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      healthScore: json['healthScore'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'status': status,
      'lastMaintenanceDate': lastMaintenanceDate,
      'uptimePercentage': uptimePercentage,
      'activeAlerts': activeAlerts.map((e) => e.toJson()).toList(),
      'healthScore': healthScore,
      'timestamp': timestamp,
    };
  }
}

class Alert {
  final String id;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String message;
  final String createdAt;

  Alert({
    required this.id,
    required this.severity,
    required this.message,
    required this.createdAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      severity: json['severity'] ?? 'low',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'severity': severity,
      'message': message,
      'createdAt': createdAt,
    };
  }
}

class ResponseMeta {
  final int timestamp;
  final String freshness;

  ResponseMeta({
    required this.timestamp,
    required this.freshness,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) {
    return ResponseMeta(
      timestamp: json['timestamp'] ?? 0,
      freshness: json['freshness'] ?? 'live',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'freshness': freshness,
    };
  }
}
