class ApiConstants {
  // Base URLs
  static const String apiGatewayBaseUrl =
      'https://lang-continues-aqua-hoping.trycloudflare.com:3000 ';

  // API Endpoints - Gateway (3000)
  static const String healthEndpoint = '/health';
  static const String recommendEndpoint = '/recommend';
  static const String stationScoreEndpoint = '/station';
  static const String stationHealthEndpoint = '/station';

  // API Endpoints - Recommendation Service
  static const String recordSelectionEndpoint = '/recommend';
  static const String submitFeedbackEndpoint = '/recommend';
  static const String recommendationHealthEndpoint = '/recommend/health';

  // API Endpoints - Ingestion Service
  static const String ingestStationEndpoint = '/ingest/station';
  static const String ingestHealthEndpoint = '/ingest/user-context';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
