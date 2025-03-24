// lib/models/stats_model.dart

class UserStats {
  final TimeZoneInfo timeZone;
  final CurrentTime currentTime;
  final DailyProgress dailyProgress;
  final DayStats todayStats;
  final PeriodStats thirtyDaysStats;
  final PeriodStats sevenDaysStats;
  final List<DailyBreakdown> dailyBreakdown;
  final AverageSessionTime averageSessionTime;
  final StreakInfo streak;

  UserStats({
    required this.timeZone,
    required this.currentTime,
    required this.dailyProgress,
    required this.todayStats,
    required this.sevenDaysStats,
    required this.thirtyDaysStats,
    required this.dailyBreakdown,
    required this.averageSessionTime,
    required this.streak,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    // Parse daily breakdown list
    final List<DailyBreakdown> breakdownList = [];
    if (json['dailyBreakdown'] != null) {
      for (var item in json['dailyBreakdown']) {
        breakdownList.add(DailyBreakdown.fromJson(item));
      }
    }

    return UserStats(
      timeZone: TimeZoneInfo.fromJson(json['timeZone']),
      currentTime: CurrentTime.fromJson(json['currentTime']),
      dailyProgress: DailyProgress.fromJson(json['dailyProgress']),
      todayStats: DayStats.fromJson(json['todayStats']),
      thirtyDaysStats: PeriodStats.fromJson(json['thirtyDaysStats']),
      sevenDaysStats: PeriodStats.fromJson(json['sevenDaysStats']),
      dailyBreakdown: breakdownList,
      averageSessionTime: AverageSessionTime.fromJson(json['averageSessionTime']),
      streak: StreakInfo.fromJson(json['streak']),
    );
  }
}

class TimeZoneInfo {
  final String name;

  TimeZoneInfo({required this.name});

  factory TimeZoneInfo.fromJson(dynamic json) {
    if (json is String) {
      return TimeZoneInfo(name: json);
    }
    return TimeZoneInfo(name: json?['name'] ?? 'UTC');
  }
}

class CurrentTime {
  final String server;
  final String userTimezone;
  final String date;
  final String time;

  CurrentTime({
    required this.server,
    required this.userTimezone,
    required this.date,
    required this.time,
  });

  factory CurrentTime.fromJson(Map<String, dynamic> json) {
    return CurrentTime(
      server: json['server'] ?? '',
      userTimezone: json['userTimezone'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}

class DailyProgress {
  final int totalMinutes;
  final int sessionCount;
  final int goalMinutes;

  DailyProgress({
    required this.totalMinutes,
    required this.sessionCount,
    required this.goalMinutes,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      totalMinutes: json['totalMinutes'] ?? 0,
      sessionCount: json['sessionCount'] ?? 0,
      goalMinutes: json['goalMinutes'] ?? 0,
    );
  }

  // Calculate progress percentage capped at 100%
  double get progressPercentage => (totalMinutes / goalMinutes).clamp(0.0, 1.0);
}

class DayStats {
  final double totalHours;
  final int totalMinutes;
  final int sessionCount;

  DayStats({
    required this.totalHours,
    required this.totalMinutes,
    required this.sessionCount,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) {
    return DayStats(
      totalHours: json['totalHours']?.toDouble() ?? 0.0,
      totalMinutes: json['totalMinutes'] ?? 0,
      sessionCount: json['sessionCount'] ?? 0,
    );
  }
}

class PeriodStats {
  final double totalHours;
  final int totalMinutes;
  final int sessionCount;
  final double averageDailyHours;
  final int days;

  PeriodStats({
    required this.totalHours,
    required this.totalMinutes,
    required this.sessionCount,
    required this.averageDailyHours,
    required this.days,
  });

  factory PeriodStats.fromJson(Map<String, dynamic> json) {
    return PeriodStats(
      totalHours: json['totalHours']?.toDouble() ?? 0.0,
      totalMinutes: json['totalMinutes'] ?? 0,
      sessionCount: json['sessionCount'] ?? 0,
      averageDailyHours: json['averageDailyHours']?.toDouble() ?? 0.0,
      days: json['days'] ?? 0,
    );
  }
}

class DailyBreakdown {
  final String date;
  final String dayOfWeek;
  final double totalHours;
  final int totalMinutes;
  final int sessionCount;
  final int daysAgo;

  DailyBreakdown({
    required this.date,
    required this.dayOfWeek,
    required this.totalHours,
    required this.totalMinutes,
    required this.sessionCount,
    required this.daysAgo,
  });

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) {
    return DailyBreakdown(
      date: json['date'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      totalHours: json['totalHours']?.toDouble() ?? 0.0,
      totalMinutes: json['totalMinutes'] ?? 0,
      sessionCount: json['sessionCount'] ?? 0,
      daysAgo: json['daysAgo'] ?? 0,
    );
  }
}

class AverageSessionTime {
  final int averageMinutesPerSession;
  final double averageHoursPerSession;
  final int totalSessions;

  AverageSessionTime({
    required this.averageMinutesPerSession,
    required this.averageHoursPerSession,
    required this.totalSessions,
  });

  factory AverageSessionTime.fromJson(Map<String, dynamic> json) {
    return AverageSessionTime(
      averageMinutesPerSession: json['averageMinutesPerSession'] ?? 0,
      averageHoursPerSession: json['averageHoursPerSession']?.toDouble() ?? 0.0,
      totalSessions: json['totalSessions'] ?? 0,
    );
  }

  // Format average session time as a string (e.g., "45 min" or "1.5 hrs")
  String get formattedAvgTime {
    if (averageMinutesPerSession < 60) {
      return "$averageMinutesPerSession min";
    } else {
      return "${averageHoursPerSession.toStringAsFixed(1)} hrs";
    }
  }
}

class StreakInfo {
  final int currentStreak;
  final int longestStreak;

  StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
  });

  factory StreakInfo.fromJson(Map<String, dynamic> json) {
    return StreakInfo(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }
}