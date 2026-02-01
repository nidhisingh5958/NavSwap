import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/dio_service.dart';
import '../data/services/queue_service.dart';

final queueServiceProvider = Provider<QueueService>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return QueueService(dioService.gateway);
});

final queueStateProvider =
    StateNotifierProvider<QueueStateNotifier, QueueState>((ref) {
  final queueService = ref.watch(queueServiceProvider);
  return QueueStateNotifier(queueService);
});

class QueueState {
  final bool isLoading;
  final String? qrCode;
  final int? position;
  final int? estimatedWaitTime;
  final String? stationName;
  final String? error;
  final DateTime? qrExpiry;

  QueueState({
    this.isLoading = false,
    this.qrCode,
    this.position,
    this.estimatedWaitTime,
    this.stationName,
    this.error,
    this.qrExpiry,
  });

  QueueState copyWith({
    bool? isLoading,
    String? qrCode,
    int? position,
    int? estimatedWaitTime,
    String? stationName,
    String? error,
    DateTime? qrExpiry,
  }) {
    return QueueState(
      isLoading: isLoading ?? this.isLoading,
      qrCode: qrCode ?? this.qrCode,
      position: position ?? this.position,
      estimatedWaitTime: estimatedWaitTime ?? this.estimatedWaitTime,
      stationName: stationName ?? this.stationName,
      error: error ?? this.error,
      qrExpiry: qrExpiry ?? this.qrExpiry,
    );
  }
}

class QueueStateNotifier extends StateNotifier<QueueState> {
  final QueueService _queueService;

  QueueStateNotifier(this._queueService) : super(QueueState());

  Future<void> joinQueue() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _queueService.joinQueue();
      state = state.copyWith(
        isLoading: false,
        qrCode: response['qrCode'],
        position: response['position'],
        estimatedWaitTime: response['estimatedWaitTime'],
        stationName: response['stationName'],
        qrExpiry: DateTime.parse(response['qrExpiry']),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to join queue: $e',
      );
    }
  }

  Future<void> refreshStatus() async {
    try {
      final response = await _queueService.getQueueStatus();
      state = state.copyWith(
        position: response['position'],
        estimatedWaitTime: response['estimatedWaitTime'],
        qrCode: response['qrCode'],
        qrExpiry: DateTime.parse(response['qrExpiry']),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to refresh status: $e');
    }
  }

  Future<void> leaveQueue() async {
    state = state.copyWith(isLoading: true);
    try {
      await _queueService.leaveQueue();
      state = QueueState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to leave queue: $e',
      );
    }
  }
}
