class Station {
  const Station({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.waitMinutes,
    required this.batteryAvailability,
    required this.reliabilityScore,
  });

  final String id;
  final String name;
  final double distanceKm;
  final int waitMinutes;
  final int batteryAvailability;
  final double reliabilityScore;
}
