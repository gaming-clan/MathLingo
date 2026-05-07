class UserProgress {
  const UserProgress({
    required this.totalPoints,
    required this.averageAccuracy,
  });

  const UserProgress.empty()
    : totalPoints = 0,
      averageAccuracy = 0;

  final int totalPoints;
  final double averageAccuracy;

  double totalPointsProgress({int targetPoints = 100}) {
    if (targetPoints <= 0) {
      return 0;
    }
    return (totalPoints / targetPoints).clamp(0.0, 1.0);
  }

  double accuracyProgress() {
    return (averageAccuracy / 100).clamp(0.0, 1.0);
  }
}