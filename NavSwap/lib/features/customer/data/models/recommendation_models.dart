/// Model for charging station recommendation response
class RecommendationResponse {
  final bool success;
  final RecommendationData data;
  final ResponseMeta meta;

  RecommendationResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      success: json['success'] ?? false,
      data: RecommendationData.fromJson(json['data'] ?? {}),
      meta: ResponseMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'meta': meta.toJson(),
    };
  }
}

class RecommendationData {
  final String requestId;
  final String userId;
  final List<RankedStation> recommendations;
  final String explanation;
  final String generatedAt;
  final String expiresAt;

  RecommendationData({
    required this.requestId,
    required this.userId,
    required this.recommendations,
    required this.explanation,
    required this.generatedAt,
    required this.expiresAt,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      requestId: json['requestId'] ?? '',
      userId: json['userId'] ?? '',
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => RankedStation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      explanation: json['explanation'] ?? '',
      generatedAt: json['generatedAt'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userId': userId,
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
      'explanation': explanation,
      'generatedAt': generatedAt,
      'expiresAt': expiresAt,
    };
  }
}

class RankedStation {
  final String stationId;
  final String stationName;
  final GeoLocation location;
  final String address;
  final double score;
  final int rank;
  final double estimatedWaitTime;
  final double estimatedDistance;
  final int availableChargers;
  final List<String> chargerTypes;
  final double pricePerKwh;
  final StationFeatures? features;
  final StationPredictions? predictions;

  RankedStation({
    required this.stationId,
    required this.stationName,
    required this.location,
    required this.address,
    required this.score,
    required this.rank,
    required this.estimatedWaitTime,
    required this.estimatedDistance,
    required this.availableChargers,
    required this.chargerTypes,
    required this.pricePerKwh,
    this.features,
    this.predictions,
  });

  factory RankedStation.fromJson(Map<String, dynamic> json) {
    return RankedStation(
      stationId: json['stationId'] ?? '',
      stationName: json['stationName'] ?? '',
      location: GeoLocation.fromJson(json['location'] ?? {}),
      address: json['address'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      rank: json['rank'] ?? 0,
      estimatedWaitTime: (json['estimatedWaitTime'] ?? 0).toDouble(),
      estimatedDistance: (json['estimatedDistance'] ?? 0).toDouble(),
      availableChargers: json['availableChargers'] ?? 0,
      chargerTypes: (json['chargerTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pricePerKwh: (json['pricePerKwh'] ?? 0).toDouble(),
      features: json['features'] != null
          ? StationFeatures.fromJson(json['features'])
          : null,
      predictions: json['predictions'] != null
          ? StationPredictions.fromJson(json['predictions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'stationName': stationName,
      'location': location.toJson(),
      'address': address,
      'score': score,
      'rank': rank,
      'estimatedWaitTime': estimatedWaitTime,
      'estimatedDistance': estimatedDistance,
      'availableChargers': availableChargers,
      'chargerTypes': chargerTypes,
      'pricePerKwh': pricePerKwh,
      if (features != null) 'features': features!.toJson(),
      if (predictions != null) 'predictions': predictions!.toJson(),
    };
  }
}

class GeoLocation {
  final double latitude;
  final double longitude;

  GeoLocation({
    required this.latitude,
    required this.longitude,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class StationFeatures {
  final String stationId;
  final double effectiveWaitTime;
  final double stationReliabilityScore;
  final double energyStabilityIndex;
  final double chargerAvailabilityRatio;

  StationFeatures({
    required this.stationId,
    required this.effectiveWaitTime,
    required this.stationReliabilityScore,
    required this.energyStabilityIndex,
    required this.chargerAvailabilityRatio,
  });

  factory StationFeatures.fromJson(Map<String, dynamic> json) {
    return StationFeatures(
      stationId: json['stationId'] ?? '',
      effectiveWaitTime: (json['effectiveWaitTime'] ?? 0).toDouble(),
      stationReliabilityScore:
          (json['stationReliabilityScore'] ?? 0).toDouble(),
      energyStabilityIndex: (json['energyStabilityIndex'] ?? 0).toDouble(),
      chargerAvailabilityRatio:
          (json['chargerAvailabilityRatio'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'effectiveWaitTime': effectiveWaitTime,
      'stationReliabilityScore': stationReliabilityScore,
      'energyStabilityIndex': energyStabilityIndex,
      'chargerAvailabilityRatio': chargerAvailabilityRatio,
    };
  }
}

class StationPredictions {
  final LoadForecast load;
  final FaultPrediction fault;

  StationPredictions({
    required this.load,
    required this.fault,
  });

  factory StationPredictions.fromJson(Map<String, dynamic> json) {
    return StationPredictions(
      load: LoadForecast.fromJson(json['load'] ?? {}),
      fault: FaultPrediction.fromJson(json['fault'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'load': load.toJson(),
      'fault': fault.toJson(),
    };
  }
}

class LoadForecast {
  final String stationId;
  final double predictedLoad;
  final double confidence;
  final String? peakTimeStart;
  final String? peakTimeEnd;
  final int timestamp;

  LoadForecast({
    required this.stationId,
    required this.predictedLoad,
    required this.confidence,
    this.peakTimeStart,
    this.peakTimeEnd,
    required this.timestamp,
  });

  factory LoadForecast.fromJson(Map<String, dynamic> json) {
    return LoadForecast(
      stationId: json['stationId'] ?? '',
      predictedLoad: (json['predictedLoad'] ?? 0).toDouble(),
      confidence: (json['confidence'] ?? 0).toDouble(),
      peakTimeStart: json['peakTimeStart'],
      peakTimeEnd: json['peakTimeEnd'],
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'predictedLoad': predictedLoad,
      'confidence': confidence,
      if (peakTimeStart != null) 'peakTimeStart': peakTimeStart,
      if (peakTimeEnd != null) 'peakTimeEnd': peakTimeEnd,
      'timestamp': timestamp,
    };
  }
}

class FaultPrediction {
  final String stationId;
  final double faultProbability;
  final String? predictedFaultType;
  final String riskLevel; // 'low', 'medium', 'high'
  final double confidence;
  final int timestamp;

  FaultPrediction({
    required this.stationId,
    required this.faultProbability,
    this.predictedFaultType,
    required this.riskLevel,
    required this.confidence,
    required this.timestamp,
  });

  factory FaultPrediction.fromJson(Map<String, dynamic> json) {
    return FaultPrediction(
      stationId: json['stationId'] ?? '',
      faultProbability: (json['faultProbability'] ?? 0).toDouble(),
      predictedFaultType: json['predictedFaultType'],
      riskLevel: json['riskLevel'] ?? 'low',
      confidence: (json['confidence'] ?? 0).toDouble(),
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'faultProbability': faultProbability,
      if (predictedFaultType != null) 'predictedFaultType': predictedFaultType,
      'riskLevel': riskLevel,
      'confidence': confidence,
      'timestamp': timestamp,
    };
  }
}

class ResponseMeta {
  final int processingTime;
  final bool cacheHit;

  ResponseMeta({
    required this.processingTime,
    required this.cacheHit,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) {
    return ResponseMeta(
      processingTime: json['processingTime'] ?? 0,
      cacheHit: json['cacheHit'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'processingTime': processingTime,
      'cacheHit': cacheHit,
    };
  }
}
