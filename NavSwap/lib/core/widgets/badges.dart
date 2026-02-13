import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A modern badge/chip widget for displaying status or categories
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;
  final double? fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.info,
    this.icon,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case StatusBadgeType.success:
        backgroundColor = const Color(0xFF1A1A1A);
        textColor = const Color(0xFFFFFFFF);
        break;
      case StatusBadgeType.warning:
        backgroundColor = const Color(0xFF3A3A3A);
        textColor = const Color(0xFFFFFFFF);
        break;
      case StatusBadgeType.error:
        backgroundColor = const Color(0xFF000000);
        textColor = const Color(0xFFFFFFFF);
        break;
      case StatusBadgeType.info:
        backgroundColor = const Color(0xFF2A2A2A);
        textColor = const Color(0xFFFFFFFF);
        break;
      case StatusBadgeType.neutral:
        backgroundColor = const Color(0xFFE8E8E8);
        textColor = const Color(0xFF3A3A3A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize! + 2,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeType {
  success,
  warning,
  error,
  info,
  neutral,
}

/// Battery level indicator widget
class BatteryIndicator extends StatelessWidget {
  final int available;
  final int total;
  final bool showLabel;
  final double size;

  const BatteryIndicator({
    super.key,
    required this.available,
    required this.total,
    this.showLabel = true,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (available / total * 100).round();
    final isLow = percentage < 30;
    final isMedium = percentage >= 30 && percentage < 70;

    Color color;
    IconData icon;

    if (isLow) {
      color = const Color(0xFF000000);
      icon = Icons.battery_alert_rounded;
    } else if (isMedium) {
      color = const Color(0xFF5A5A5A);
      icon = Icons.battery_3_bar_rounded;
    } else {
      color = const Color(0xFF333333);
      icon = Icons.battery_full_rounded;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: size,
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            '$available/$total',
            style: GoogleFonts.inter(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

/// Animated availability indicator
class AvailabilityIndicator extends StatefulWidget {
  final bool isAvailable;
  final String? label;
  final double size;

  const AvailabilityIndicator({
    super.key,
    required this.isAvailable,
    this.label,
    this.size = 12,
  });

  @override
  State<AvailabilityIndicator> createState() => _AvailabilityIndicatorState();
}

class _AvailabilityIndicatorState extends State<AvailabilityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isAvailable ? const Color(0xFF000000) : const Color(0xFFB0B0B0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isAvailable ? _scaleAnimation.value : 1.0,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: widget.isAvailable
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          },
        ),
        if (widget.label != null) ...[
          const SizedBox(width: 8),
          Text(
            widget.label!,
            style: GoogleFonts.inter(
              fontSize: widget.size,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

/// Distance badge with icon
class DistanceBadge extends StatelessWidget {
  final String distance;
  final Color? color;

  const DistanceBadge({
    super.key,
    required this.distance,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF1A1A1A)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 14,
            color: color != null ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            distance,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color != null ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
