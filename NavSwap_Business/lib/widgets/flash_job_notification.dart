import 'package:flutter/material.dart';
import 'dart:async';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class FlashJobNotification extends StatefulWidget {
  final TransportJob job;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FlashJobNotification({
    super.key,
    required this.job,
    required this.onAccept,
    required this.onReject,
  });

  @override
  State<FlashJobNotification> createState() => _FlashJobNotificationState();
}

class _FlashJobNotificationState extends State<FlashJobNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  int _remainingSeconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
    
    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _autoReject();
      }
    });
  }

  void _autoReject() {
    _controller.reverse().then((_) {
      widget.onReject();
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.black.withOpacity(0.85),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_slideAnimation),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Timer Ring
                        _buildTimerRing(),
                        const SizedBox(height: 32),
                        
                        // Job Card
                        _buildJobCard(),
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerRing() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: _remainingSeconds / 10,
              strokeWidth: 6,
              backgroundColor: AppTheme.secondaryDark,
              valueColor: AlwaysStoppedAnimation<Color>(
                _remainingSeconds > 5
                    ? AppTheme.accentBlue
                    : AppTheme.accentOrange,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_remainingSeconds',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'seconds',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8C5A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'FLASH JOB AVAILABLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                StatusChip(
                  label: widget.job.priorityLabel,
                  color: Colors.white,
                  outlined: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Route Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildLocationRow(
                    icon: Icons.circle,
                    label: 'Pickup',
                    location: widget.job.pickupStationName,
                    address: widget.job.pickupAddress,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Container(
                        width: 2,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLocationRow(
                    icon: Icons.location_on,
                    label: 'Drop',
                    location: widget.job.dropStationName,
                    address: widget.job.dropAddress,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Job Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.battery_charging_full,
                  value: '${widget.job.batteryCount}',
                  label: 'Batteries',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildDetailItem(
                  icon: Icons.route,
                  value: '${widget.job.distance.toStringAsFixed(1)} km',
                  label: 'Distance',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildDetailItem(
                  icon: Icons.stars,
                  value: '₹${widget.job.estimatedCredits}',
                  label: 'Credits',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _timer?.cancel();
              _controller.reverse().then((_) {
                widget.onReject();
                Navigator.of(context).pop();
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text(
              'Reject',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _timer?.cancel();
              _controller.reverse().then((_) {
                widget.onAccept();
                Navigator.of(context).pop();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text(
              'Accept',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
