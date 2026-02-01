import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models/station_score_model.dart';
import '../domain/models/station_health_model.dart';
import '../domain/models/station_predictions_model.dart';

class StationApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<StationScoreModel?> getStationScore(String stationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/station/$stationId/score'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StationScoreModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching station score: $e');
      return null;
    }
  }

  Future<StationHealthModel?> getStationHealth(String stationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/station/$stationId/health'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StationHealthModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching station health: $e');
      return null;
    }
  }

  Future<StationPredictionsModel?> getStationPredictions(
      String stationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/station/$stationId/predictions'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StationPredictionsModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching station predictions: $e');
      return null;
    }
  }
}
