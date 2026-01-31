class ApiConstants {
  // Base URLs
  static const String apiGatewayBaseUrl = 'http://localhost:3000';
  static const String recommendationServiceUrl = 'http://localhost:3005';
  static const String ingestionServiceUrl = 'http://localhost:3001';

  // API Endpoints - Gateway (3000)
  static const String healthEndpoint = '/health';
  static const String recommendEndpoint = '/recommend';
  static const String stationScoreEndpoint = '/station';
  static const String stationHealthEndpoint = '/station';

  // API Endpoints - Recommendation Service (3005)
  static const String recordSelectionEndpoint = '/recommend';
  static const String submitFeedbackEndpoint = '/recommend';

  // API Endpoints - Ingestion Service (3001)
  static const String ingestStationEndpoint = '/ingest/station';
  static const String ingestHealthEndpoint = '/ingest/health';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
