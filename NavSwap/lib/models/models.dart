import 'package:flutter/material.dart';

// Station Model
class Station {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int availableBatteries;
  final int totalCapacity;
  final int currentQueue;
  final double reliabilityScore;
  final int predictedWaitMinutes;
  final double aiScore;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.availableBatteries,
    required this.totalCapacity,
    required this.currentQueue,
    required this.reliabilityScore,
    required this.predictedWaitMinutes,
    required this.aiScore,
  });

  double get batteryAvailability => 
      (availableBatteries / totalCapacity) * 100;

  String get statusLabel {
    if (currentQueue > 5) return 'High Load';
    if (availableBatteries < 3) return 'Critical';
    return 'Active';
  }

  Color get statusColor {
    if (currentQueue > 5) return const Color(0xFFFFA726);
    if (availableBatteries < 3) return const Color(0xFFFF6B35);
    return const Color(0xFF2ECC71);
  }
}

// Swap History Model
class SwapHistory {
  final String id;
  final DateTime timestamp;
  final String stationName;
  final int duration;
  final double co2Saved;

  SwapHistory({
    required this.id,
    required this.timestamp,
    required this.stationName,
    required this.duration,
    required this.co2Saved,
  });
}

// Transport Job Model
class TransportJob {
  final String id;
  final String pickupStationName;
  final String pickupAddress;
  final String dropStationName;
  final String dropAddress;
  final int batteryCount;
  final double distance;
  final int estimatedCredits;
  final DateTime createdAt;
  final JobPriority priority;
  final JobStatus status;
  final int etaMinutes;

  TransportJob({
    required this.id,
    required this.pickupStationName,
    required this.pickupAddress,
    required this.dropStationName,
    required this.dropAddress,
    required this.batteryCount,
    required this.distance,
    required this.estimatedCredits,
    required this.createdAt,
    required this.priority,
    required this.status,
    required this.etaMinutes,
  });

  String get priorityLabel {
    switch (priority) {
      case JobPriority.urgent:
        return 'URGENT';
      case JobPriority.high:
        return 'HIGH';
      case JobPriority.normal:
        return 'NORMAL';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case JobPriority.urgent:
        return const Color(0xFFFF6B35);
      case JobPriority.high:
        return const Color(0xFFFFA726);
      case JobPriority.normal:
        return const Color(0xFF4A90E2);
    }
  }
}

enum JobPriority { urgent, high, normal }
enum JobStatus { pending, accepted, inProgress, completed, cancelled }

// User Profile Model
class UserProfile {
  final String name;
  final String email;
  final UserType userType;
  final int totalSwaps;
  final double totalCO2Saved;
  final int totalMinutesSaved;
  final List<String> favoriteStations;

  UserProfile({
    required this.name,
    required this.email,
    required this.userType,
    this.totalSwaps = 0,
    this.totalCO2Saved = 0.0,
    this.totalMinutesSaved = 0,
    this.favoriteStations = const [],
  });
}

enum UserType { customer, transporter }

// Transporter Stats Model
class TransporterStats {
  final int todayCredits;
  final int deliveriesCompleted;
  final double efficiencyScore;
  final TransporterTier tier;
  final double performanceRating;
  final int totalEarnings;
  final List<String> achievements;

  TransporterStats({
    required this.todayCredits,
    required this.deliveriesCompleted,
    required this.efficiencyScore,
    required this.tier,
    required this.performanceRating,
    required this.totalEarnings,
    this.achievements = const [],
  });

  String get tierLabel {
    switch (tier) {
      case TransporterTier.bronze:
        return 'Bronze';
      case TransporterTier.silver:
        return 'Silver';
      case TransporterTier.gold:
        return 'Gold';
      case TransporterTier.platinum:
        return 'Platinum';
    }
  }

  Color get tierColor {
    switch (tier) {
      case TransporterTier.bronze:
        return const Color(0xFFCD7F32);
      case TransporterTier.silver:
        return const Color(0xFFC0C0C0);
      case TransporterTier.gold:
        return const Color(0xFFFFD700);
      case TransporterTier.platinum:
        return const Color(0xFFE5E4E2);
    }
  }
}

enum TransporterTier { bronze, silver, gold, platinum }
