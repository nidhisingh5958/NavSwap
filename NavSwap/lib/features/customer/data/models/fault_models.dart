/// Model for fault report response
class FaultReportResponse {
  final bool success;
  final bool? ticketCreated;
  final FaultTicket? ticket;
  final String? message;

  FaultReportResponse({
    required this.success,
    this.ticketCreated,
    this.ticket,
    this.message,
  });

  factory FaultReportResponse.fromJson(Map<String, dynamic> json) {
    return FaultReportResponse(
      success: json['success'] ?? false,
      ticketCreated: json['ticketCreated'],
      ticket:
          json['ticket'] != null ? FaultTicket.fromJson(json['ticket']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (ticketCreated != null) 'ticketCreated': ticketCreated,
      if (ticket != null) 'ticket': ticket!.toJson(),
      if (message != null) 'message': message,
    };
  }
}

class FaultTicket {
  final String id;
  final String stationId;
  final String reportedBy;
  final String faultLevel; // 'low', 'medium', 'high', 'critical'
  final String description;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String createdAt;
  final String updatedAt;

  FaultTicket({
    required this.id,
    required this.stationId,
    required this.reportedBy,
    required this.faultLevel,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaultTicket.fromJson(Map<String, dynamic> json) {
    return FaultTicket(
      id: json['id'] ?? '',
      stationId: json['stationId'] ?? '',
      reportedBy: json['reportedBy'] ?? '',
      faultLevel: json['faultLevel'] ?? 'low',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'reportedBy': reportedBy,
      'faultLevel': faultLevel,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
