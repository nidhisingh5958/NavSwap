import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../providers/recommendation_provider.dart';

class StationMapScreen extends ConsumerStatefulWidget {
  const StationMapScreen({super.key});

  @override
  ConsumerState<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends ConsumerState<StationMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  StationRecommendation? _selectedStation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recommendationProvider.notifier).fetchRecommendations();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkersAndCamera();
  }

  void _updateMarkersAndCamera() {
    final state = ref.read(recommendationProvider);

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationProvider);

    ref.listen<RecommendationState>(recommendationProvider, (previous, next) {
      if (next.userLocation != null && !next.isLoading) {
        _updateMarkersAndCamera();
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(recommendationProvider.notifier).fetchRecommendations();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          state.userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.userLocation!.latitude,
                      state.userLocation!.longitude,
                    ),
                    zoom: 13.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

          // Loading Overlay
          if (state.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Recommended Station Card
          if (state.recommendedStation != null && _selectedStation == null)
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

          // Selected Station Card
          if (_selectedStation != null)
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

          // Request ID Display
          if (state.requestId != null && _selectedStation == null)
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
        ],
      ),
    );
  }
}

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
