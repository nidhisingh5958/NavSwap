class ApiConstants {
  // Base URLs
  static const String apiGatewayBaseUrl =
      'https://lang-continues-aqua-hoping.trycloudflare.com:3000';
  // static const String recommendationServiceBaseUrl = 'http://localhost:3005';
  // static const String ingestionServiceBaseUrl = 'http://localhost:3001';
  // static const String aiServiceBaseUrl = 'http://localhost:8081';

  // ==================== HEALTH & STATUS ====================
  static const String healthEndpoint = '/health';
  static const String readyEndpoint = '/ready';

  // ==================== RECOMMENDATIONS ====================
  static const String recommendEndpoint = '/recommend';
  static String getCachedRecommendation(String requestId) =>
      '/recommend/$requestId';
  static String recordSelection(String requestId) =>
      '/recommend/$requestId/select';
  static String submitFeedback(String requestId) =>
      '/recommend/$requestId/feedback';

  // ==================== STATION DATA ====================
  static String getStationScore(String stationId) =>
      '/station/$stationId/score';
  static String getStationHealth(String stationId) =>
      '/station/$stationId/health';
  static String getStationPredictions(String stationId) =>
      '/station/$stationId/predictions';

  // ==================== QUEUE MANAGEMENT ====================
  static const String queueJoin = '/queue/join';
  static const String queueVerify = '/queue/verify';
  static const String queueSwap = '/queue/swap';

  // ==================== DELIVERY MANAGEMENT (Driver/Transporter) ====================
  static const String deliveryAlert = '/delivery/alert';
  static const String deliveryAccept = '/delivery/accept';
  static const String deliveryConfirm = '/delivery/confirm';
  static String getDriverDeliveries(String driverId) =>
      '/driver/$driverId/deliveries';
  static const String getAllDeliveries = '/admin/deliveries';

  // ==================== FAULT MANAGEMENT ====================
  static const String reportFault = '/fault/report';
  static const String createTicket = '/ticket/manual';
  static const String getAllTickets = '/admin/tickets';

  // ==================== DATA INGESTION ====================
  static const String ingestStation = '/ingest/station';
  static const String ingestStationBatch = '/ingest/station/batch';
  static const String ingestHealth = '/ingest/health';
  static const String ingestUserContext = '/ingest/user-context';
  static const String ingestGrid = '/ingest/grid';

  // ==================== AI PREDICTIONS ====================
  static const String aiLoadForecast = '/ai/load-forecast';
  static const String aiFaultProbability = '/ai/fault-probability';
  static const String aiBatchPredict = '/ai/batch-predict';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
