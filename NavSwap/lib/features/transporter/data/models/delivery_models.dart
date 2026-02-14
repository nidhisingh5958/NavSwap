/// Model for delivery job response
class DeliveryResponse {
  final bool success;
  final Delivery? delivery;
  final List<Delivery>? deliveries;
  final String? message;

  DeliveryResponse({
    required this.success,
    this.delivery,
    this.deliveries,
    this.message,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      success: json['success'] ?? false,
      delivery:
          json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null,
      deliveries: json['deliveries'] != null
          ? (json['deliveries'] as List<dynamic>)
              .map((e) => Delivery.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (delivery != null) 'delivery': delivery!.toJson(),
      if (deliveries != null)
        'deliveries': deliveries!.map((e) => e.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}

class Delivery {
  final String id;
  final String batteryId;
  final String fromShopId;
  final String toStationId;
  final String status; // 'pending', 'accepted', 'delivered'
  final String? assignedDriverId;
  final String requestedAt;
  final String? acceptedAt;
  final String? deliveredAt;

  Delivery({
    required this.id,
    required this.batteryId,
    required this.fromShopId,
    required this.toStationId,
    required this.status,
    this.assignedDriverId,
    required this.requestedAt,
    this.acceptedAt,
    this.deliveredAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] ?? '',
      batteryId: json['batteryId'] ?? '',
      fromShopId: json['fromShopId'] ?? '',
      toStationId: json['toStationId'] ?? '',
      status: json['status'] ?? 'pending',
      assignedDriverId: json['assignedDriverId'],
      requestedAt: json['requestedAt'] ?? '',
      acceptedAt: json['acceptedAt'],
      deliveredAt: json['deliveredAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batteryId': batteryId,
      'fromShopId': fromShopId,
      'toStationId': toStationId,
      'status': status,
      if (assignedDriverId != null) 'assignedDriverId': assignedDriverId,
      'requestedAt': requestedAt,
      if (acceptedAt != null) 'acceptedAt': acceptedAt,
      if (deliveredAt != null) 'deliveredAt': deliveredAt,
    };
  }
}
