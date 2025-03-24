// lib/providers/stats_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stats_service.dart';
import '../models/stats_model.dart';
import '../models/goals_model.dart';
import '../models/weekly_data.dart';

// Define status enum
enum StatsStatus { initial, loading, loaded, error }

// Stats state class
class StatsState {
  final UserStats? stats;
  final UserGoals? goals;
  final List<WeeklyData> weeklyData;
  final StatsStatus status;
  final String? errorMessage;
  final String timeRange; // 'week', 'month', 'all'

  StatsState({
    this.stats,
    this.goals,
    this.weeklyData = const [],
    this.status = StatsStatus.initial,
    this.errorMessage,
    this.timeRange = 'week',
  });

  StatsState copyWith({
    UserStats? stats,
    UserGoals? goals,
    List<WeeklyData>? weeklyData,
    StatsStatus? status,
    String? errorMessage,
    String? timeRange,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      goals: goals ?? this.goals,
      weeklyData: weeklyData ?? this.weeklyData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      timeRange: timeRange ?? this.timeRange,
    );
  }
}

// Service provider
final statsServiceProvider = Provider<StatsService>((ref) {
  return StatsService(ref);
});

// Stats state notifier
class StatsNotifier extends StateNotifier<StatsState> {
  final StatsService _statsService;

  StatsNotifier(this._statsService) : super(StatsState());

  // Fetch both stats and goals together
  Future<void> fetchStatsAndGoals() async {
    try {
      state = state.copyWith(status: StatsStatus.loading);

      // Fetch both in parallel
      final futures = await Future.wait([
        _statsService.fetchUserStats(),
        _statsService.fetchUserGoals(),
      ]);

      final stats = futures[0] as UserStats;
      final goals = futures[1] as UserGoals;

      // Convert daily breakdown to weekly data
      final weeklyData = _statsService.convertToWeeklyData(stats.dailyBreakdown);

      state = state.copyWith(
        stats: stats,
        goals: goals,
        weeklyData: weeklyData,
        status: StatsStatus.loaded,
      );
    } catch (e) {
      debugPrint('Error fetching stats and goals: $e');
      state = state.copyWith(
        status: StatsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Update weekly goal
  Future<void> updateWeeklyGoal(int weeklyGoalHours) async {
    try {
      // Optimistic update
      final currentGoals = state.goals;
      if (currentGoals != null) {
        final updatedGoals = UserGoals(weeklyGoalHours: weeklyGoalHours);
        state = state.copyWith(goals: updatedGoals);
      }

      // Make API call
      final updatedGoals = await _statsService.updateWeeklyGoal(weeklyGoalHours);

      // Update with actual response
      state = state.copyWith(goals: updatedGoals);
    } catch (e) {
      debugPrint('Error updating weekly goal: $e');
      // Fetch again to restore correct state
      await fetchStatsAndGoals();
    }
  }

  // Change time range for charts
  void changeTimeRange(String timeRange) {
    if (timeRange != state.timeRange) {
      state = state.copyWith(timeRange: timeRange);
    }
  }
}

// Create a StateNotifierProvider for stats
final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final statsService = ref.watch(statsServiceProvider);
  return StatsNotifier(statsService);
});