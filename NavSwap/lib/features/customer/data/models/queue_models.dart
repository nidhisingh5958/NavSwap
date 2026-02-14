/// Model for queue entry response
class QueueResponse {
  final bool success;
  final String? qrCode;
  final String? qrImagePath;
  final QueueEntry? entry;
  final int? busyCount;
  final List<QueueEntry>? queue;
  final String? message;

  QueueResponse({
    required this.success,
    this.qrCode,
    this.qrImagePath,
    this.entry,
    this.busyCount,
    this.queue,
    this.message,
  });

  factory QueueResponse.fromJson(Map<String, dynamic> json) {
    return QueueResponse(
      success: json['success'] ?? false,
      qrCode: json['qrCode'],
      qrImagePath: json['qrImagePath'],
      entry: json['entry'] != null ? QueueEntry.fromJson(json['entry']) : null,
      busyCount: json['busyCount'],
      queue: json['queue'] != null
          ? (json['queue'] as List<dynamic>)
              .map((e) => QueueEntry.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (qrCode != null) 'qrCode': qrCode,
      if (qrImagePath != null) 'qrImagePath': qrImagePath,
      if (entry != null) 'entry': entry!.toJson(),
      if (busyCount != null) 'busyCount': busyCount,
      if (queue != null) 'queue': queue!.map((e) => e.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}

class QueueEntry {
  final String id;
  final String stationId;
  final String userId;
  final String? qrCode;
  final String status; // 'waiting', 'verified', 'swapped'
  final String joinedAt;
  final String? verifiedAt;
  final String? swappedAt;

  QueueEntry({
    required this.id,
    required this.stationId,
    required this.userId,
    this.qrCode,
    required this.status,
    required this.joinedAt,
    this.verifiedAt,
    this.swappedAt,
  });

  factory QueueEntry.fromJson(Map<String, dynamic> json) {
    return QueueEntry(
      id: json['id'] ?? '',
      stationId: json['stationId'] ?? '',
      userId: json['userId'] ?? '',
      qrCode: json['qrCode'],
      status: json['status'] ?? 'waiting',
      joinedAt: json['joinedAt'] ?? '',
      verifiedAt: json['verifiedAt'],
      swappedAt: json['swappedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'userId': userId,
      if (qrCode != null) 'qrCode': qrCode,
      'status': status,
      'joinedAt': joinedAt,
      if (verifiedAt != null) 'verifiedAt': verifiedAt,
      if (swappedAt != null) 'swappedAt': swappedAt,
    };
  }
}
