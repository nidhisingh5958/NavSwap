import '../mock/mock_stations.dart';

/// Mock Favorites Data for most visited stations
class MockFavoritesData {
  /// Model for favorite station entry
  static List<FavoriteStation> getFavoriteStations() {
    return [
      FavoriteStation(
        station: MockStationsData.getAllStations()[0], // Downtown SwapHub
        visitCount: 24,
        lastVisited: DateTime.now().subtract(const Duration(days: 2)),
        isFavorite: true,
        totalSwaps: 24,
        averageWaitTime: 8,
        savedAsQuickAccess: true,
      ),
      FavoriteStation(
        station: MockStationsData.getAllStations()[4], // Tech Central Hub
        visitCount: 18,
        lastVisited: DateTime.now().subtract(const Duration(days: 5)),
        isFavorite: true,
        totalSwaps: 18,
        averageWaitTime: 5,
        savedAsQuickAccess: true,
      ),
      FavoriteStation(
        station: MockStationsData.getAllStations()[2], // Marina Power Station
        visitCount: 15,
        lastVisited: DateTime.now().subtract(const Duration(days: 7)),
        isFavorite: true,
        totalSwaps: 15,
        averageWaitTime: 3,
        savedAsQuickAccess: false,
      ),
      FavoriteStation(
        station: MockStationsData.getAllStations()[3], // SoMa Rapid Swap
        visitCount: 12,
        lastVisited: DateTime.now().subtract(const Duration(days: 10)),
        isFavorite: true,
        totalSwaps: 12,
        averageWaitTime: 12,
        savedAsQuickAccess: true,
      ),
      FavoriteStation(
        station: MockStationsData.getAllStations()[6], // Richmond Quick Swap
        visitCount: 9,
        lastVisited: DateTime.now().subtract(const Duration(days: 15)),
        isFavorite: true,
        totalSwaps: 9,
        averageWaitTime: 6,
        savedAsQuickAccess: false,
      ),
      FavoriteStation(
        station: MockStationsData.getAllStations()[5], // Hayes Valley Express
        visitCount: 7,
        lastVisited: DateTime.now().subtract(const Duration(days: 20)),
        isFavorite: true,
        totalSwaps: 7,
        averageWaitTime: 10,
        savedAsQuickAccess: false,
      ),
    ];
  }

  /// Get most visited station
  static FavoriteStation getMostVisitedStation() {
    return getFavoriteStations().first;
  }

  /// Get recently visited favorites
  static List<FavoriteStation> getRecentlyVisited({int limit = 3}) {
    final favorites = getFavoriteStations();
    favorites.sort((a, b) => b.lastVisited.compareTo(a.lastVisited));
    return favorites.take(limit).toList();
  }

  /// Get quick access stations
  static List<FavoriteStation> getQuickAccessStations() {
    return getFavoriteStations()
        .where((fav) => fav.savedAsQuickAccess)
        .toList();
  }

  /// Get total visits across all favorites
  static int getTotalVisits() {
    return getFavoriteStations().fold(0, (sum, fav) => sum + fav.visitCount);
  }

  /// Get favorite station statistics
  static Map<String, dynamic> getFavoriteStats() {
    final favorites = getFavoriteStations();
    final totalVisits = getTotalVisits();
    final avgWaitTime = favorites.isEmpty
        ? 0
        : favorites.fold(0, (sum, fav) => sum + fav.averageWaitTime) ~/
            favorites.length;

    return {
      'totalFavorites': favorites.length,
      'totalVisits': totalVisits,
      'averageWaitTime': avgWaitTime,
      'quickAccessCount': getQuickAccessStations().length,
      'mostVisited': getMostVisitedStation().station.name,
    };
  }
}

/// Model class for favorite station
class FavoriteStation {
  final MockStationData station;
  final int visitCount;
  final DateTime lastVisited;
  final bool isFavorite;
  final int totalSwaps;
  final int averageWaitTime;
  final bool savedAsQuickAccess;

  FavoriteStation({
    required this.station,
    required this.visitCount,
    required this.lastVisited,
    this.isFavorite = true,
    required this.totalSwaps,
    required this.averageWaitTime,
    this.savedAsQuickAccess = false,
  });

  /// Get formatted last visited string
  String getLastVisitedString() {
    final now = DateTime.now();
    final difference = now.difference(lastVisited);

    if (difference.inDays == 0) {
      return 'Today';
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

  /// Get visit frequency description
  String getVisitFrequency() {
    if (visitCount >= 20) {
      return 'Very Frequent';
    } else if (visitCount >= 10) {
      return 'Frequent';
    } else if (visitCount >= 5) {
      return 'Regular';
    } else {
      return 'Occasional';
    }
  }
}
