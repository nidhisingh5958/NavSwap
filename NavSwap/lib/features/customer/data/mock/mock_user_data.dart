import 'package:flutter/material.dart';

/// Mock User Profile Data
class MockUserData {
  static UserProfile getUserProfile() {
    return UserProfile(
      id: 'USR_12345',
      name: 'Alex Johnson',
      email: 'alex.johnson@email.com',
      phone: '+1 (415) 555-0123',
      memberSince: DateTime(2024, 6, 15),
      membershipTier: 'Gold',
      profileImage: null, // Using default avatar
      vehicle: VehicleInfo(
        make: 'Tesla',
        model: 'Model 3',
        year: 2023,
        color: 'Pearl White',
        batteryCapacity: '75 kWh',
        licensePlate: 'CAL-7890',
      ),
      stats: UserStats(
        totalSwaps: 47,
        timeSaved: 6.2, // hours
        co2Saved: 142, // kg
        favoriteStations: 6,
        totalSpent: 235.00,
        averageRating: 4.7,
        rewardsPoints: 1250,
      ),
      preferences: UserPreferences(
        notificationsEnabled: true,
        emailUpdates: true,
        pushNotifications: true,
        locationTracking: true,
        darkMode: false,
        language: 'English',
        distanceUnit: 'miles',
      ),
      paymentMethods: [
        PaymentMethod(
          id: 'pm_1',
          type: 'card',
          last4: '4242',
          cardBrand: 'Visa',
          expiryMonth: 12,
          expiryYear: 2026,
          isDefault: true,
        ),
        PaymentMethod(
          id: 'pm_2',
          type: 'card',
          last4: '8888',
          cardBrand: 'Mastercard',
          expiryMonth: 9,
          expiryYear: 2027,
          isDefault: false,
        ),
      ],
    );
  }

  static List<Achievement> getAchievements() {
    return [
      Achievement(
        id: 'ach_1',
        title: 'Early Adopter',
        description: 'One of the first 1000 users',
        icon: Icons.star,
        unlockedDate: DateTime(2024, 6, 20),
        color: const Color(0xFFFFD700),
      ),
      Achievement(
        id: 'ach_2',
        title: 'Eco Warrior',
        description: 'Saved 100kg of CO₂',
        icon: Icons.eco,
        unlockedDate: DateTime(2025, 11, 5),
        color: const Color(0xFF4CAF50),
      ),
      Achievement(
        id: 'ach_3',
        title: 'Speed Demon',
        description: 'Completed 10 swaps in under 5 minutes',
        icon: Icons.flash_on,
        unlockedDate: DateTime(2025, 12, 15),
        color: const Color(0xFFFF9800),
      ),
      Achievement(
        id: 'ach_4',
        title: 'Gold Member',
        description: 'Reached Gold membership tier',
        icon: Icons.workspace_premium,
        unlockedDate: DateTime(2025, 8, 30),
        color: const Color(0xFFFFD700),
      ),
    ];
  }

  static List<ReferralInfo> getReferrals() {
    return [
      ReferralInfo(
        name: 'Sarah Miller',
        joinDate: DateTime(2025, 10, 12),
        status: 'active',
        rewardEarned: 10.00,
      ),
      ReferralInfo(
        name: 'Mike Chen',
        joinDate: DateTime(2025, 11, 8),
        status: 'active',
        rewardEarned: 10.00,
      ),
      ReferralInfo(
        name: 'Emma Davis',
        joinDate: DateTime(2026, 1, 20),
        status: 'pending',
        rewardEarned: 0.00,
      ),
    ];
  }
}

/// User Profile Model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime memberSince;
  final String membershipTier;
  final String? profileImage;
  final VehicleInfo vehicle;
  final UserStats stats;
  final UserPreferences preferences;
  final List<PaymentMethod> paymentMethods;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
    required this.membershipTier,
    this.profileImage,
    required this.vehicle,
    required this.stats,
    required this.preferences,
    required this.paymentMethods,
  });

  String getMemberSinceString() {
    final now = DateTime.now();
    final difference = now.difference(memberSince);
    final months = (difference.inDays / 30).floor();
    if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    }
    final years = (months / 12).floor();
    return '$years ${years == 1 ? 'year' : 'years'}';
  }

  Color getMembershipColor() {
    switch (membershipTier.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

/// Vehicle Information
class VehicleInfo {
  final String make;
  final String model;
  final int year;
  final String color;
  final String batteryCapacity;
  final String licensePlate;

  VehicleInfo({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.batteryCapacity,
    required this.licensePlate,
  });

  String getDisplayName() {
    return '$year $make $model';
  }
}

/// User Statistics
class UserStats {
  final int totalSwaps;
  final double timeSaved;
  final int co2Saved;
  final int favoriteStations;
  final double totalSpent;
  final double averageRating;
  final int rewardsPoints;

  UserStats({
    required this.totalSwaps,
    required this.timeSaved,
    required this.co2Saved,
    required this.favoriteStations,
    required this.totalSpent,
    required this.averageRating,
    required this.rewardsPoints,
  });

  String getTimeSavedString() {
    return '${timeSaved.toStringAsFixed(1)}h';
  }

  String getCO2SavedString() {
    return '${co2Saved}kg';
  }
}

/// User Preferences
class UserPreferences {
  final bool notificationsEnabled;
  final bool emailUpdates;
  final bool pushNotifications;
  final bool locationTracking;
  final bool darkMode;
  final String language;
  final String distanceUnit;

  UserPreferences({
    required this.notificationsEnabled,
    required this.emailUpdates,
    required this.pushNotifications,
    required this.locationTracking,
    required this.darkMode,
    required this.language,
    required this.distanceUnit,
  });
}

/// Payment Method
class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String cardBrand;
  final int expiryMonth;
  final int expiryYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.cardBrand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  String getDisplayName() {
    return '$cardBrand •••• $last4';
  }

  String getExpiryString() {
    return '${expiryMonth.toString().padLeft(2, '0')}/$expiryYear';
  }
}

/// Achievement
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime unlockedDate;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedDate,
    required this.color,
  });

  String getUnlockedString() {
    final now = DateTime.now();
    final difference = now.difference(unlockedDate);
    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}

/// Referral Information
class ReferralInfo {
  final String name;
  final DateTime joinDate;
  final String status; // 'active', 'pending'
  final double rewardEarned;

  ReferralInfo({
    required this.name,
    required this.joinDate,
    required this.status,
    required this.rewardEarned,
  });

  String getJoinDateString() {
    final now = DateTime.now();
    final difference = now.difference(joinDate);
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'active':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
