import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Status Chip Component
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withOpacity(0.15),
        border: outlined ? Border.all(color: color, width: 1.5) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Gradient Card Component
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double? height;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Metric Card Component
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

// Progress Bar Component
class CustomProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double height;
  final String? label;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.backgroundColor = AppTheme.secondaryDark,
    this.height = 8,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Section Header Component
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                        fontSize: 12,
                      ),
                ),
            ],
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Reliability Score Widget
class ReliabilityScore extends StatelessWidget {
  final double score;
  final double size;

  const ReliabilityScore({
    super.key,
    required this.score,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final color = score >= 90
        ? AppTheme.accentGreen
        : score >= 70
            ? AppTheme.accentYellow
            : AppTheme.accentOrange;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 4,
              backgroundColor: AppTheme.secondaryDark,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${score.toInt()}',
                style: TextStyle(
                  color: color,
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '%',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
