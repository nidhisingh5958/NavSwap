class Task {
  const Task({
    required this.id,
    required this.title,
    required this.detail,
    required this.etaMinutes,
  });

  final String id;
  final String title;
  final String detail;
  final int etaMinutes;
}
