import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning', style: Theme.of(context).textTheme.bodySmall),
                  Text('John Doe', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1A1A1A)),
                  onPressed: () {},
                ),
              ],
            ),
            
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildAICard(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildQuickAction('Queue Status', Icons.timelapse, const Color(0xFFFF6B4A))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickAction('AI Assistant', Icons.psychology, const Color(0xFF4A90E2))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nearby Stations', style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(onPressed: () {}, child: const Text('View All')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._buildStations(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAICard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B4A), Color(0xFFFF8C6B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFFFF6B4A).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Row(children: [Icon(Icons.stars, color: Colors.white, size: 16), SizedBox(width: 4), Text('AI Recommended', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Station Alpha', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [_chip(Icons.location_on, '2.3 km'), const SizedBox(width: 12), _chip(Icons.access_time, '5 min')]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Score', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const Row(children: [Text('9.2', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), Text('/10', style: TextStyle(color: Colors.white70))]),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reliability', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Row(children: [Icon(Icons.star, color: Colors.white, size: 18), Icon(Icons.star, color: Colors.white, size: 18), Icon(Icons.star, color: Colors.white, size: 18), Icon(Icons.star, color: Colors.white, size: 18), Icon(Icons.star_outline, color: Colors.white70, size: 18)]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [Icon(Icons.lightbulb_outline, color: Colors.white, size: 20), SizedBox(width: 8), Expanded(child: Text('Best choice based on location, traffic & availability', style: TextStyle(color: Colors.white, fontSize: 12)))]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFFF6B4A)),
              child: const Text('Join Queue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white, size: 14), const SizedBox(width: 4), Text(text, style: const TextStyle(color: Colors.white, fontSize: 12))]),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 28)), const SizedBox(height: 12), Text(title, textAlign: TextAlign.center)]),
    );
  }

  List<Widget> _buildStations() {
    return [
      _stationCard('Station Beta', '3.5 km', '8 min', 8.5),
      _stationCard('Station Gamma', '4.2 km', '12 min', 7.8),
      _stationCard('Station Delta', '5.0 km', '6 min', 8.9),
    ];
  }

  Widget _stationCard(String name, String dist, String wait, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.ev_station, size: 28)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name), Row(children: [const Icon(Icons.location_on, size: 14), Text(dist), const SizedBox(width: 12), const Icon(Icons.access_time, size: 14), Text(wait)])])), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(score.toString(), style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)))]),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_navItem(Icons.home, 'Home', 0), _navItem(Icons.explore, 'Explore', 1), _navItem(Icons.history, 'History', 2), _navItem(Icons.person_outline, 'Profile', 3)]))),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [Icon(icon, color: isSelected ? Colors.white : const Color(0xFF6B6B6B), size: 24), if (isSelected) ...[const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]]),
      ),
    );
  }
}
