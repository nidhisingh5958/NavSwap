import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'models/models.dart';
import 'screens/customer_home_screen.dart';
import 'screens/transporter_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const NavSwapApp());
}

class NavSwapApp extends StatelessWidget {
  const NavSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavSwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppSelector(),
    );
  }
}

class AppSelector extends StatefulWidget {
  const AppSelector({super.key});

  @override
  State<AppSelector> createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  UserType _selectedType = UserType.customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.electric_bolt,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'NavSwap',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Smart EV Battery Swap Platform',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildRoleSelector(),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _selectedType == UserType.customer
                            ? CustomerHomeScreen(
                                user: _getSampleCustomer(),
                                recommendedStation: _getSampleStation(),
                                recentSwaps: _getSampleSwapHistory(),
                              )
                            : TransporterDashboard(
                                user: _getSampleTransporter(),
                                stats: _getSampleTransporterStats(),
                                activeJobs: _getSampleJobs(),
                              ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleOption(
              type: UserType.customer,
              icon: Icons.person,
              label: 'Customer',
              description: 'Find swap stations',
            ),
          ),
          Expanded(
            child: _buildRoleOption(
              type: UserType.transporter,
              icon: Icons.local_shipping,
              label: 'Transporter',
              description: 'Deliver batteries',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required UserType type,
    required IconData icon,
    required String label,
    required String description,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.heroGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textTertiary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: isSelected ? Colors.white70 : AppTheme.textTertiary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Sample Data Generators
  UserProfile _getSampleCustomer() {
    return UserProfile(
      name: 'Rajesh Kumar',
      email: 'rajesh@example.com',
      userType: UserType.customer,
      totalSwaps: 42,
      totalCO2Saved: 156.8,
      totalMinutesSaved: 284,
      favoriteStations: [
        'Central Hub',
        'Green Valley Station',
      ],
    );
  }

  UserProfile _getSampleTransporter() {
    return UserProfile(
      name: 'Priya Sharma',
      email: 'priya@example.com',
      userType: UserType.transporter,
    );
  }

  Station _getSampleStation() {
    return Station(
      id: 'station_1',
      name: 'Central Hub',
      address: '123 MG Road, Connaught Place, Delhi',
      latitude: 28.6304,
      longitude: 77.2177,
      availableBatteries: 8,
      totalCapacity: 12,
      currentQueue: 2,
      reliabilityScore: 94.5,
      predictedWaitMinutes: 8,
      aiScore: 92.0,
    );
  }

  List<SwapHistory> _getSampleSwapHistory() {
    return [
      SwapHistory(
        id: 'swap_1',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        stationName: 'Central Hub',
        duration: 7,
        co2Saved: 3.2,
      ),
      SwapHistory(
        id: 'swap_2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        stationName: 'Green Valley Station',
        duration: 12,
        co2Saved: 4.1,
      ),
      SwapHistory(
        id: 'swap_3',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        stationName: 'East Hub',
        duration: 9,
        co2Saved: 3.5,
      ),
    ];
  }

  TransporterStats _getSampleTransporterStats() {
    return TransporterStats(
      todayCredits: 1250,
      deliveriesCompleted: 5,
      efficiencyScore: 92.5,
      tier: TransporterTier.gold,
      performanceRating: 4.8,
      totalEarnings: 15750,
      achievements: [
        'Top Performer',
        'Fast Delivery',
        'Customer Favorite',
      ],
    );
  }

  List<TransportJob> _getSampleJobs() {
    return [
      TransportJob(
        id: 'job_1',
        pickupStationName: 'Central Hub',
        pickupAddress: '123 MG Road, Connaught Place',
        dropStationName: 'East Hub',
        dropAddress: '456 Park Street, East Delhi',
        batteryCount: 6,
        distance: 8.5,
        estimatedCredits: 380,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        priority: JobPriority.high,
        status: JobStatus.accepted,
        etaMinutes: 22,
      ),
    ];
  }
}
