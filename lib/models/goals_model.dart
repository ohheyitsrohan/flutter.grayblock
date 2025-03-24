// lib/models/goals_model.dart

class UserGoals {
  final int weeklyGoalHours;

  UserGoals({
    required this.weeklyGoalHours,
  });

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      weeklyGoalHours: json['weeklyGoalHours'] ?? 20, // Default to 20 if not set
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklyGoalHours': weeklyGoalHours,
    };
  }

  // Calculate progress based on current hours
  double calculateProgress(double currentHours) {
    if (weeklyGoalHours <= 0) return 0.0;
    return (currentHours / weeklyGoalHours).clamp(0.0, 1.0);
  }
}