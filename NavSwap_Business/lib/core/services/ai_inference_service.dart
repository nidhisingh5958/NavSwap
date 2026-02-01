/// AI Inference Service for on-device predictions using ONNX Runtime
/// 
/// This service loads ONNX models from assets and runs inference locally
/// without requiring network connectivity.
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

/// Singleton service for AI model inference
class AIInferenceService {
  static final AIInferenceService _instance = AIInferenceService._internal();
  factory AIInferenceService() => _instance;
  AIInferenceService._internal();

  // Model sessions
  OrtSession? _queueModel;
  OrtSession? _waitModel;
  OrtSession? _faultModel;
  OrtSession? _actionModel;

  // Preprocessing parameters
  Map<String, dynamic>? _scalerParams;
  List<String>? _actionLabels;

  bool _isInitialized = false;

  /// Initialize the service and load all models
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize ONNX Runtime environment
      OrtEnv.instance.init();

      // Load models
      _queueModel = await _loadModel('assets/models/queue_model.onnx');
      _waitModel = await _loadModel('assets/models/wait_model.onnx');
      _faultModel = await _loadModel('assets/models/fault_model.onnx');
      _actionModel = await _loadModel('assets/models/action_model.onnx');

      // Load preprocessing parameters
      await _loadScalerParams();
      await _loadLabelEncoder();

      _isInitialized = true;
      print('✅ AI Inference Service initialized');
    } catch (e) {
      print('❌ Failed to initialize AI service: $e');
      rethrow;
    }
  }

  Future<OrtSession?> _loadModel(String assetPath) async {
    try {
      final modelBytes = await rootBundle.load(assetPath);
      final sessionOptions = OrtSessionOptions();
      return OrtSession.fromBuffer(
        modelBytes.buffer.asUint8List(),
        sessionOptions,
      );
    } catch (e) {
      print('⚠️ Could not load model $assetPath: $e');
      return null;
    }
  }

  Future<void> _loadScalerParams() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/models/scaler_params.json');
      _scalerParams = json.decode(jsonStr);
    } catch (e) {
      print('⚠️ Could not load scaler params: $e');
    }
  }

  Future<void> _loadLabelEncoder() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/models/label_encoder.json');
      final data = json.decode(jsonStr);
      _actionLabels = List<String>.from(data['classes']);
    } catch (e) {
      print('⚠️ Could not load label encoder: $e');
    }
  }

  /// Preprocess input features using loaded scaler parameters
  List<double> _preprocess(Map<String, double> features) {
    if (_scalerParams == null) {
      return features.values.toList();
    }

    final mean = List<double>.from(_scalerParams!['mean']);
    final scale = List<double>.from(_scalerParams!['scale']);
    final featureNames = _scalerParams!['feature_names'] as List<dynamic>?;

    List<double> result = [];
    
    if (featureNames != null) {
      for (int i = 0; i < featureNames.length; i++) {
        final name = featureNames[i] as String;
        final value = features[name] ?? 0.0;
        result.add((value - mean[i]) / scale[i]);
      }
    } else {
      int i = 0;
      for (final value in features.values) {
        if (i < mean.length) {
          result.add((value - mean[i]) / scale[i]);
        } else {
          result.add(value);
        }
        i++;
      }
    }

    return result;
  }

  /// Run inference on a model
  Future<List<double>> _runInference(OrtSession? model, List<double> input) async {
    if (model == null) {
      throw Exception('Model not loaded');
    }

    final inputOrt = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(input),
      [1, input.length],
    );

    final inputs = {'float_input': inputOrt};
    final outputs = await model.runAsync(inputs);

    final outputTensor = outputs?.first;
    if (outputTensor == null) {
      throw Exception('No output from model');
    }

    final outputData = outputTensor.value as List;
    inputOrt.release();
    outputs?.forEach((e) => e?.release());

    return outputData.map((e) => (e as num).toDouble()).toList();
  }

  /// Predict queue length for a station
  Future<double> predictQueueLength(Map<String, double> features) async {
    if (!_isInitialized) await initialize();
    
    final input = _preprocess(features);
    final output = await _runInference(_queueModel, input);
    return output.first;
  }

  /// Predict wait time for a station
  Future<double> predictWaitTime(Map<String, double> features) async {
    if (!_isInitialized) await initialize();
    
    final input = _preprocess(features);
    final output = await _runInference(_waitModel, input);
    return output.first;
  }

  /// Predict fault risk for a station
  Future<({int riskLevel, double probability})> predictFaultRisk(
    Map<String, double> features,
  ) async {
    if (!_isInitialized) await initialize();
    
    final input = _preprocess(features);
    final output = await _runInference(_faultModel, input);
    
    if (output.length >= 2) {
      final prob = output[1];
      return (riskLevel: prob > 0.5 ? 1 : 0, probability: prob);
    } else {
      return (riskLevel: output.first.round(), probability: output.first);
    }
  }

  /// Predict recommended action for a station
  Future<({String action, Map<String, double> probabilities})> predictAction(
    Map<String, double> features,
  ) async {
    if (!_isInitialized) await initialize();
    
    final input = _preprocess(features);
    final output = await _runInference(_actionModel, input);
    
    int predictedClass = 0;
    double maxProb = 0;
    Map<String, double> probabilities = {};
    
    if (_actionLabels != null && output.length >= _actionLabels!.length) {
      for (int i = 0; i < _actionLabels!.length; i++) {
        probabilities[_actionLabels![i]] = output[i];
        if (output[i] > maxProb) {
          maxProb = output[i];
          predictedClass = i;
        }
      }
    } else {
      predictedClass = output.first.round();
      probabilities = {'predicted': output.first};
    }
    
    final actionLabel = _actionLabels != null && predictedClass < _actionLabels!.length
        ? _actionLabels![predictedClass]
        : 'NORMAL';
    
    return (action: actionLabel, probabilities: probabilities);
  }

  /// Get all predictions for a station at once
  Future<StationPredictions> getStationPredictions(
    Map<String, double> features,
  ) async {
    final queue = await predictQueueLength(features);
    final wait = await predictWaitTime(features);
    final fault = await predictFaultRisk(features);
    final action = await predictAction(features);

    return StationPredictions(
      predictedQueueLength: queue,
      predictedWaitTime: wait,
      faultRiskLevel: fault.riskLevel,
      faultProbability: fault.probability,
      recommendedAction: action.action,
      actionProbabilities: action.probabilities,
    );
  }

  /// Dispose of resources
  void dispose() {
    _queueModel?.release();
    _waitModel?.release();
    _faultModel?.release();
    _actionModel?.release();
    OrtEnv.instance.release();
    _isInitialized = false;
  }
}

/// Data class for station predictions
class StationPredictions {
  final double predictedQueueLength;
  final double predictedWaitTime;
  final int faultRiskLevel;
  final double faultProbability;
  final String recommendedAction;
  final Map<String, double> actionProbabilities;

  StationPredictions({
    required this.predictedQueueLength,
    required this.predictedWaitTime,
    required this.faultRiskLevel,
    required this.faultProbability,
    required this.recommendedAction,
    required this.actionProbabilities,
  });

  String get faultRiskLabel => faultRiskLevel == 1 ? 'HIGH' : 'LOW';
}

/// Global instance for easy access
final aiInferenceService = AIInferenceService();
