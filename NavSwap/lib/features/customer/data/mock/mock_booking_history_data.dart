import 'package:flutter/material.dart';
import '../mock/mock_stations.dart';

/// Mock Booking History Data
class MockBookingHistoryData {
  /// Model for booking history entry
  static List<BookingHistory> getBookingHistory() {
    final stations = MockStationsData.getAllStations();

    return [
      BookingHistory(
        id: 'BOOK_001',
        station: stations[0], // Downtown SwapHub
        bookingDate: DateTime.now().subtract(const Duration(days: 2)),
        swapDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'completed',
        queuePosition: 4,
        actualWaitTime: 12,
        estimatedWaitTime: 8,
        batterySwapped: 'BAT_45678',
        batteryReceived: 'BAT_78901',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Quick and efficient service!',
      ),
      BookingHistory(
        id: 'BOOK_002',
        station: stations[4], // Tech Central Hub
        bookingDate: DateTime.now().subtract(const Duration(days: 5)),
        swapDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'completed',
        queuePosition: 2,
        actualWaitTime: 5,
        estimatedWaitTime: 5,
        batterySwapped: 'BAT_34567',
        batteryReceived: 'BAT_67890',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Excellent location and fast service',
      ),
      BookingHistory(
        id: 'BOOK_003',
        station: stations[2], // Marina Power Station
        bookingDate: DateTime.now().subtract(const Duration(days: 7)),
        swapDate: DateTime.now().subtract(const Duration(days: 7)),
        status: 'completed',
        queuePosition: 1,
        actualWaitTime: 3,
        estimatedWaitTime: 3,
        batterySwapped: 'BAT_23456',
        batteryReceived: 'BAT_56789',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Great amenities and location',
      ),
      BookingHistory(
        id: 'BOOK_004',
        station: stations[3], // SoMa Rapid Swap
        bookingDate: DateTime.now().subtract(const Duration(days: 10)),
        swapDate: DateTime.now().subtract(const Duration(days: 10)),
        status: 'completed',
        queuePosition: 5,
        actualWaitTime: 15,
        estimatedWaitTime: 12,
        batterySwapped: 'BAT_12345',
        batteryReceived: 'BAT_45678',
        transactionAmount: 5.00,
        rating: 4,
        feedback: 'Good service, slightly longer wait than expected',
      ),
      BookingHistory(
        id: 'BOOK_005',
        station: stations[0], // Downtown SwapHub
        bookingDate: DateTime.now().subtract(const Duration(days: 14)),
        swapDate: DateTime.now().subtract(const Duration(days: 14)),
        status: 'completed',
        queuePosition: 3,
        actualWaitTime: 10,
        estimatedWaitTime: 8,
        batterySwapped: 'BAT_11111',
        batteryReceived: 'BAT_22222',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Always reliable',
      ),
      BookingHistory(
        id: 'BOOK_006',
        station: stations[5], // Hayes Valley Express
        bookingDate: DateTime.now().subtract(const Duration(days: 18)),
        swapDate: DateTime.now().subtract(const Duration(days: 18)),
        status: 'completed',
        queuePosition: 4,
        actualWaitTime: 11,
        estimatedWaitTime: 10,
        batterySwapped: 'BAT_33333',
        batteryReceived: 'BAT_44444',
        transactionAmount: 5.00,
        rating: 4,
        feedback: 'Nice cafe nearby',
      ),
      BookingHistory(
        id: 'BOOK_007',
        station: stations[6], // Richmond Quick Swap
        bookingDate: DateTime.now().subtract(const Duration(days: 21)),
        swapDate: DateTime.now().subtract(const Duration(days: 21)),
        status: 'completed',
        queuePosition: 2,
        actualWaitTime: 6,
        estimatedWaitTime: 6,
        batterySwapped: 'BAT_55555',
        batteryReceived: 'BAT_66666',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Very fast service',
      ),
      BookingHistory(
        id: 'BOOK_008',
        station: stations[1], // Mission SwapStop
        bookingDate: DateTime.now().subtract(const Duration(days: 25)),
        swapDate: DateTime.now().subtract(const Duration(days: 25)),
        status: 'completed',
        queuePosition: 6,
        actualWaitTime: 18,
        estimatedWaitTime: 15,
        batterySwapped: 'BAT_77777',
        batteryReceived: 'BAT_88888',
        transactionAmount: 5.00,
        rating: 3,
        feedback: 'Wait time was longer than expected',
      ),
      BookingHistory(
        id: 'BOOK_009',
        station: stations[4], // Tech Central Hub
        bookingDate: DateTime.now().subtract(const Duration(days: 30)),
        swapDate: DateTime.now().subtract(const Duration(days: 30)),
        status: 'completed',
        queuePosition: 1,
        actualWaitTime: 4,
        estimatedWaitTime: 5,
        batterySwapped: 'BAT_99999',
        batteryReceived: 'BAT_00000',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Perfect experience',
      ),
      BookingHistory(
        id: 'BOOK_010',
        station: stations[0], // Downtown SwapHub
        bookingDate: DateTime.now().subtract(const Duration(days: 35)),
        swapDate: DateTime.now().subtract(const Duration(days: 35)),
        status: 'completed',
        queuePosition: 3,
        actualWaitTime: 9,
        estimatedWaitTime: 8,
        batterySwapped: 'BAT_AAAAA',
        batteryReceived: 'BAT_BBBBB',
        transactionAmount: 5.00,
        rating: 5,
        feedback: 'Great as always',
      ),
      BookingHistory(
        id: 'BOOK_011',
        station: stations[2], // Marina Power Station
        bookingDate: DateTime.now().subtract(const Duration(hours: 2)),
        swapDate: null,
        status: 'cancelled',
        queuePosition: 5,
        actualWaitTime: 0,
        estimatedWaitTime: 10,
        batterySwapped: null,
        batteryReceived: null,
        transactionAmount: 0.00,
        rating: null,
        feedback: null,
        cancellationReason: 'Changed plans',
      ),
    ];
  }

  /// Get completed bookings only
  static List<BookingHistory> getCompletedBookings() {
    return getBookingHistory()
        .where((booking) => booking.status == 'completed')
        .toList();
  }

  /// Get cancelled bookings
  static List<BookingHistory> getCancelledBookings() {
    return getBookingHistory()
        .where((booking) => booking.status == 'cancelled')
        .toList();
  }

  /// Get bookings by date range
  static List<BookingHistory> getBookingsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return getBookingHistory()
        .where((booking) =>
            booking.bookingDate.isAfter(startDate) &&
            booking.bookingDate.isBefore(endDate))
        .toList();
  }

  /// Get booking statistics
  static Map<String, dynamic> getBookingStats() {
    final allBookings = getBookingHistory();
    final completedBookings = getCompletedBookings();
    final cancelledBookings = getCancelledBookings();

    final totalAmount = completedBookings.fold(
        0.0, (sum, booking) => sum + booking.transactionAmount);
    final avgWaitTime = completedBookings.isEmpty
        ? 0
        : completedBookings.fold(
                0, (sum, booking) => sum + booking.actualWaitTime) ~/
            completedBookings.length;
    final avgRating = completedBookings.where((b) => b.rating != null).isEmpty
        ? 0.0
        : completedBookings
                .where((b) => b.rating != null)
                .fold(0.0, (sum, booking) => sum + booking.rating!) /
            completedBookings.where((b) => b.rating != null).length;

    return {
      'totalBookings': allBookings.length,
      'completedBookings': completedBookings.length,
      'cancelledBookings': cancelledBookings.length,
      'totalAmount': totalAmount,
      'averageWaitTime': avgWaitTime,
      'averageRating': avgRating,
      'totalSwaps': completedBookings.length,
    };
  }

  /// Get most visited station from history
  static String getMostVisitedStation() {
    final bookings = getCompletedBookings();
    final stationCounts = <String, int>{};

    for (var booking in bookings) {
      final stationName = booking.station.name;
      stationCounts[stationName] = (stationCounts[stationName] ?? 0) + 1;
    }

    if (stationCounts.isEmpty) return 'N/A';

    return stationCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get monthly booking count
  static Map<int, int> getMonthlyBookingCounts() {
    final bookings = getBookingHistory();
    final monthlyCounts = <int, int>{};

    for (var booking in bookings) {
      final month = booking.bookingDate.month;
      monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    }

    return monthlyCounts;
  }
}

/// Model class for booking history
class BookingHistory {
  final String id;
  final MockStationData station;
  final DateTime bookingDate;
  final DateTime? swapDate;
  final String status; // 'completed', 'cancelled', 'in_progress'
  final int queuePosition;
  final int actualWaitTime; // in minutes
  final int estimatedWaitTime; // in minutes
  final String? batterySwapped;
  final String? batteryReceived;
  final double transactionAmount;
  final int? rating; // 1-5 stars
  final String? feedback;
  final String? cancellationReason;

  BookingHistory({
    required this.id,
    required this.station,
    required this.bookingDate,
    this.swapDate,
    required this.status,
    required this.queuePosition,
    required this.actualWaitTime,
    required this.estimatedWaitTime,
    this.batterySwapped,
    this.batteryReceived,
    required this.transactionAmount,
    this.rating,
    this.feedback,
    this.cancellationReason,
  });

  /// Get formatted booking date string
  String getBookingDateString() {
    final now = DateTime.now();
    final difference = now.difference(bookingDate);

    if (difference.inDays == 0) {
      return 'Today at ${bookingDate.hour}:${bookingDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  /// Get status color
  Color getStatusColor() {
    switch (status) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'in_progress':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  /// Get status display text
  String getStatusText() {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
        return 'In Progress';
      default:
        return 'Unknown';
    }
  }

  /// Get wait time accuracy
  String getWaitTimeAccuracy() {
    if (actualWaitTime == estimatedWaitTime) {
      return 'Accurate';
    } else if (actualWaitTime < estimatedWaitTime) {
      return 'Faster than expected';
    } else {
      return 'Longer than expected';
    }
  }
}
