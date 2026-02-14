import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock/mock_stations.dart';
import '../../data/services/route_optimizer.dart';
import '../../providers/recommendation_provider.dart';
import '../widgets/route_display_widget.dart';

class StationMapScreen extends ConsumerStatefulWidget {
  const StationMapScreen({super.key});

  @override
  ConsumerState<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends ConsumerState<StationMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  StationRecommendation? _selectedStation;
  RouteDetails? _selectedRoute;
  bool _useMockData = false;
  MockStationData? _selectedMockStation;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    try {
      // Try to fetch real recommendations
      ref.read(recommendationProvider.notifier).fetchRecommendations();
    } catch (e) {
      // Fallback to mock data on error
      _useFallbackMockData();
    }
  }

  void _useFallbackMockData() {
    setState(() {
      _useMockData = true;
      // Default user location (San Francisco)
      _userLocation = const LatLng(37.7749, -122.4194);
    });

    _updateMarkersWithMockData();

    // Show snackbar indicating mock data usage
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Using offline map data. Some features may be limited.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _updateMarkersWithMockData() {
    if (_userLocation == null) return;

    final nearestStations = MockStationsData.getNearestStations(
      latitude: _userLocation!.latitude,
      longitude: _userLocation!.longitude,
      limit: 8,
    );

    final newMarkers = <Marker>{};

    // Add user location marker
    newMarkers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    // Add station markers
    for (final station in nearestStations) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(station.id),
          position: station.latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            station.id == _selectedMockStation?.id
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: '${station.distance.toStringAsFixed(1)} km away',
          ),
          onTap: () {
            _selectMockStation(station);
          },
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });

    // Animate camera to show user location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 13.0),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _selectMockStation(MockStationData station) {
    setState(() {
      _selectedMockStation = station;
    });

    // Calculate and display route
    if (_userLocation != null) {
      final routePoints = RouteOptimizer.calculateOptimalRoute(
        userLocation: _userLocation!,
        destinationLocation: station.latLng,
      );

      final estimatedTime = RouteOptimizer.getEstimatedTime(
        userLocation: _userLocation!,
        destinationLocation: station.latLng,
      );

      final totalDistance = RouteOptimizer.getTotalDistance(routePoints);

      setState(() {
        _selectedRoute = RouteDetails(
          polylinePoints: routePoints,
          totalDistance: totalDistance,
          estimatedTime: estimatedTime,
        );

        // Add polyline to map
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId(station.id),
            points: routePoints,
            width: 5,
            color: const Color(0xFF1976D2),
            geodesic: true,
            patterns: [
              PatternItem.dash(20),
              PatternItem.gap(10),
            ],
          ),
        );
      });

      // Animate camera to show route
      _animateCameraToShowRoute(routePoints);
    }
  }

  void _animateCameraToShowRoute(List<LatLng> route) {
    if (route.isEmpty || _mapController == null) return;

    double minLat = route[0].latitude;
    double maxLat = route[0].latitude;
    double minLng = route[0].longitude;
    double maxLng = route[0].longitude;

    for (final point in route) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_useMockData) {
      // Map will be updated by the listener
    } else {
      _updateMarkersWithMockData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationProvider);

    ref.listen<RecommendationState>(recommendationProvider, (previous, next) {
      if (next.userLocation != null && !next.isLoading) {
        setState(() {
          _useMockData = false;
          _userLocation = LatLng(
            next.userLocation!.latitude,
            next.userLocation!.longitude,
          );
        });
        _updateMarkersFromState(next);
      }

      if (next.error != null) {
        _useFallbackMockData();
      }
    });

    // Use mock data if no user location from provider
    if (!_useMockData && state.userLocation == null) {
      // Check if we should fallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.userLocation == null && !_useMockData) {
          _useFallbackMockData();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _useMockData ? 'Nearby Stations (Offline)' : 'Nearby Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _useMockData
                ? () => _useFallbackMockData()
                : () {
                    ref
                        .read(recommendationProvider.notifier)
                        .fetchRecommendations();
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          (_userLocation == null && !_useMockData)
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _userLocation ?? const LatLng(37.7749, -122.4194),
                    zoom: 13.0,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

          // Loading Overlay
          if (state.isLoading && !_useMockData)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Route Info Card - Mock Data
          if (_selectedRoute != null && _useMockData)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: RouteInfoWidget(
                distance: _selectedRoute!.getDistanceString(),
                estimatedTime: _selectedRoute!.getTimeString(),
                onNavigate: _selectedMockStation != null
                    ? () {
                        _showMockStationDetails(_selectedMockStation!);
                      }
                    : null,
              ),
            ),

          // Selected Mock Station Card
          if (_selectedMockStation != null && _useMockData)
            Positioned(
              bottom: _selectedRoute != null ? 120 : 16,
              left: 16,
              right: 16,
              child: _MockStationDetailsCard(
                station: _selectedMockStation!,
                onClose: () {
                  setState(() {
                    _selectedMockStation = null;
                    _selectedRoute = null;
                    _polylines.clear();
                  });
                },
                onNavigate: () {
                  _showMockStationDetails(_selectedMockStation!);
                },
              ),
            ),

          // Recommended Station Card - Real Data
          if (state.recommendedStation != null &&
              _selectedStation == null &&
              !_useMockData)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _RecommendedStationCard(
                station: state.recommendedStation!,
                requestId: state.requestId,
                onNavigate: () {
                  context.push(
                      '/customer/station/${state.recommendedStation!.id}');
                },
              ),
            ),

          // Selected Station Card - Real Data
          if (_selectedStation != null && !_useMockData)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _StationDetailsCard(
                station: _selectedStation!,
                isRecommended:
                    _selectedStation!.id == state.recommendedStation?.id,
                onClose: () {
                  setState(() {
                    _selectedStation = null;
                  });
                },
                onNavigate: () {
                  context.push('/customer/station/${_selectedStation!.id}');
                },
              ),
            ),

          // Request ID Display - Real Data
          if (state.requestId != null &&
              _selectedStation == null &&
              !_useMockData)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Request ID: ${state.requestId}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        // Copy to clipboard
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Offline Indicator
          if (_useMockData)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Offline Mode - Using Mock Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _updateMarkersFromState(RecommendationState state) {
    if (state.userLocation == null) return;

    final newMarkers = <Marker>{};

    // Add user location marker
    newMarkers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(
          state.userLocation!.latitude,
          state.userLocation!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    // Add station markers
    for (final station in state.stations) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.lat, station.lon),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            station.isRecommended || station.id == state.recommendedStation?.id
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: '${station.distance.toStringAsFixed(1)} km away',
          ),
          onTap: () {
            setState(() {
              _selectedStation = station;
            });
          },
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });

    // Move camera to show user location
    if (_mapController != null && state.userLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            state.userLocation!.latitude,
            state.userLocation!.longitude,
          ),
          13.0,
        ),
      );
    }
  }

  void _showMockStationDetails(MockStationData station) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => _MockStationDetailsBottomSheet(station: station),
    );
  }
}

/// Mock Station Details Card for display on map
class _MockStationDetailsCard extends StatelessWidget {
  final MockStationData station;
  final VoidCallback onClose;
  final VoidCallback onNavigate;

  const _MockStationDetailsCard({
    required this.station,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${station.distance.toStringAsFixed(1)} km away',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _MockStatChip(
                icon: Icons.battery_charging_full,
                label: '${station.availableSlots}/${station.totalSlots}',
                color: Colors.blue,
              ),
              _MockStatChip(
                icon: Icons.schedule,
                label: '${station.waitTime}m wait',
                color: Colors.orange,
              ),
              _MockStatChip(
                icon: Icons.star,
                label: '${station.reliability}',
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: station.amenities
                .map(
                  (amenity) => Chip(
                    label: Text(amenity),
                    labelStyle: const TextStyle(fontSize: 11),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNavigate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('View Full Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MockStatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet showing full details of mock station
class _MockStationDetailsBottomSheet extends StatelessWidget {
  final MockStationData station;

  const _MockStationDetailsBottomSheet({required this.station});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${station.distance.toStringAsFixed(1)} km away',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${station.reliability}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Availability Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Availability',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${station.availableSlots}/${station.totalSlots} Available',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value:
                                    station.availableSlots / station.totalSlots,
                                minHeight: 8,
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Wait Time & Amenities
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.schedule,
                            color: Colors.orange, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '${station.waitTime}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text(
                          'min wait',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '${station.reliability}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          'reliability',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amenities
            if (station.amenities.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: station.amenities
                        .map(
                          (amenity) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 14, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  amenity,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.my_location),
                label: const Text('Navigate to Station'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Original station recommendation classes remain below

class _RecommendedStationCard extends StatelessWidget {
  final StationRecommendation station;
  final String? requestId;
  final VoidCallback onNavigate;

  const _RecommendedStationCard({
    required this.station,
    this.requestId,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Recommended',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${station.distance.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              station.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.people,
                  label: '${station.queueLength} in queue',
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.battery_charging_full,
                  label: '${station.availableBatteries} available',
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNavigate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationDetailsCard extends StatelessWidget {
  final StationRecommendation station;
  final bool isRecommended;
  final VoidCallback onClose;
  final VoidCallback onNavigate;

  const _StationDetailsCard({
    required this.station,
    required this.isRecommended,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (isRecommended)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text(
                          'Recommended',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            Text(
              station.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${station.distance.toStringAsFixed(1)} km away',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.people,
                  label: '${station.queueLength} in queue',
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.battery_charging_full,
                  label: '${station.availableBatteries} available',
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNavigate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
