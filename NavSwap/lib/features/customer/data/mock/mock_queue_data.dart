import '../models/queue_models.dart';

/// Mock Queue Data for testing and demonstration
class MockQueueData {
  static final List<QueueEntry> mockQueue = [
    QueueEntry(
      id: 'QUEUE_001',
      stationId: 'STN_001',
      userId: 'USR_101',
      qrCode: 'QR_CODE_101_1234567890',
      status: 'waiting',
      joinedAt: DateTime.now()
          .subtract(const Duration(minutes: 15))
          .toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_002',
      stationId: 'STN_001',
      userId: 'USR_102',
      qrCode: 'QR_CODE_102_2345678901',
      status: 'waiting',
      joinedAt: DateTime.now()
          .subtract(const Duration(minutes: 12))
          .toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_003',
      stationId: 'STN_001',
      userId: 'USR_103',
      qrCode: 'QR_CODE_103_3456789012',
      status: 'verified',
      joinedAt: DateTime.now()
          .subtract(const Duration(minutes: 10))
          .toIso8601String(),
      verifiedAt:
          DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_004',
      stationId: 'STN_001',
      userId: 'USR_001', // Current user
      qrCode: 'QR_CODE_001_USER_CURRENT',
      status: 'waiting',
      joinedAt:
          DateTime.now().subtract(const Duration(minutes: 8)).toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_005',
      stationId: 'STN_001',
      userId: 'USR_104',
      qrCode: 'QR_CODE_104_5678901234',
      status: 'waiting',
      joinedAt:
          DateTime.now().subtract(const Duration(minutes: 6)).toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_006',
      stationId: 'STN_001',
      userId: 'USR_105',
      qrCode: 'QR_CODE_105_6789012345',
      status: 'waiting',
      joinedAt:
          DateTime.now().subtract(const Duration(minutes: 4)).toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_007',
      stationId: 'STN_001',
      userId: 'USR_106',
      qrCode: 'QR_CODE_106_7890123456',
      status: 'waiting',
      joinedAt:
          DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
    ),
    QueueEntry(
      id: 'QUEUE_008',
      stationId: 'STN_001',
      userId: 'USR_107',
      qrCode: 'QR_CODE_107_8901234567',
      status: 'waiting',
      joinedAt:
          DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String(),
    ),
  ];

  static QueueResponse getMockQueueResponse({
    required String userId,
    required String stationId,
  }) {
    // Find user's entry in queue
    final userEntry = mockQueue.firstWhere(
      (entry) => entry.userId == userId,
      orElse: () => QueueEntry(
        id: 'QUEUE_NEW_${DateTime.now().millisecondsSinceEpoch}',
        stationId: stationId,
        userId: userId,
        qrCode: 'QR_CODE_${userId}_${DateTime.now().millisecondsSinceEpoch}',
        status: 'waiting',
        joinedAt: DateTime.now().toIso8601String(),
      ),
    );

    // Calculate position
    final userIndex = mockQueue.indexWhere((e) => e.userId == userId);
    final position = userIndex >= 0 ? userIndex + 1 : mockQueue.length + 1;

    // Calculate busy count (people being served)
    final busyCount = mockQueue.where((e) => e.status == 'verified').length;

    return QueueResponse(
      success: true,
      qrCode: userEntry.qrCode,
      qrImagePath: null,
      entry: userEntry,
      busyCount: busyCount,
      queue: mockQueue,
      message: 'Successfully joined queue at position $position',
    );
  }

  /// Get user's position in queue
  static int getUserPosition(String userId) {
    final index = mockQueue.indexWhere((entry) => entry.userId == userId);
    return index >= 0 ? index + 1 : -1;
  }

  /// Get estimated wait time based on position
  static int getEstimatedWaitTime(String userId) {
    final position = getUserPosition(userId);
    if (position <= 0) return 0;

    // Estimated 3-5 minutes per person
    return position * 4;
  }

  /// Get queue entries before user (people ahead)
  static List<QueueEntry> getEntriesBeforeUser(String userId) {
    final userIndex = mockQueue.indexWhere((entry) => entry.userId == userId);
    if (userIndex <= 0) return [];

    return mockQueue.sublist(0, userIndex);
  }

  /// Get queue entries after user (people behind)
  static List<QueueEntry> getEntriesAfterUser(String userId) {
    final userIndex = mockQueue.indexWhere((entry) => entry.userId == userId);
    if (userIndex < 0 || userIndex >= mockQueue.length - 1) return [];

    return mockQueue.sublist(userIndex + 1);
  }

  /// Get queue statistics
  static Map<String, dynamic> getQueueStats(String stationId) {
    final stationQueue =
        mockQueue.where((e) => e.stationId == stationId).toList();

    return {
      'totalInQueue': stationQueue.length,
      'waiting': stationQueue.where((e) => e.status == 'waiting').length,
      'verified': stationQueue.where((e) => e.status == 'verified').length,
      'swapped': stationQueue.where((e) => e.status == 'swapped').length,
      'averageWaitTime': 4, // minutes
      'currentWaitTime': stationQueue.length * 4, // minutes
    };
  }

  /// Mock user names for display
  static String getUserName(String userId) {
    final userNames = {
      'USR_001': 'You',
      'USR_101': 'John Smith',
      'USR_102': 'Sarah Johnson',
      'USR_103': 'Mike Davis',
      'USR_104': 'Emily Wilson',
      'USR_105': 'David Brown',
      'USR_106': 'Lisa Martinez',
      'USR_107': 'James Taylor',
    };

    return userNames[userId] ?? 'User ${userId.substring(userId.length - 3)}';
  }

  /// Get status color
  static String getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return 'orange';
      case 'verified':
        return 'blue';
      case 'swapped':
        return 'green';
      default:
        return 'grey';
    }
  }

  /// Get status display text
  static String getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'Waiting';
      case 'verified':
        return 'Being Served';
      case 'swapped':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}
