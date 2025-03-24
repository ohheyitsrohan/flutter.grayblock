class WeeklyData {
  final String day;
  final double hours;

  WeeklyData({required this.day, required this.hours});

  // Mock data
  static List<WeeklyData> getMockData() {
    return [
      WeeklyData(day: "Mon", hours: 2.5),
      WeeklyData(day: "Tue", hours: 1.8),
      WeeklyData(day: "Wed", hours: 3.0),
      WeeklyData(day: "Thu", hours: 2.2),
      WeeklyData(day: "Fri", hours: 3.2),
      WeeklyData(day: "Sat", hours: 1.5),
      WeeklyData(day: "Sun", hours: 0.8),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'hours': hours,
    };
  }

  static double getTotalHours(List<WeeklyData> data) {
    return data.fold(0, (sum, item) => sum + item.hours);
  }

  static double getMaxHours(List<WeeklyData> data) {
    return data.map((item) => item.hours).reduce(
            (value, element) => value > element ? value : element);
  }
}