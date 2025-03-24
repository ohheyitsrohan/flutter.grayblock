// lib/providers/leaderboard_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_user.dart';

// Create a provider for the LeaderboardService
final leaderboardServiceProvider = Provider<LeaderboardService>((ref) {
  return LeaderboardService(ref);
});

// Define leaderboard status enum
enum LeaderboardStatus { initial, loading, loaded, error }

// Leaderboard state class
class LeaderboardState {
  final List<LeaderboardUser> users;
  final int? userRank;
  final LeaderboardStatus status;
  final String? errorMessage;
  final String currentType;
  final String currentTimeFilter;
  final dynamic userStats; // Add user stats to the state

  LeaderboardState({
    this.users = const [],
    this.userRank,
    this.status = LeaderboardStatus.initial,
    this.errorMessage,
    this.currentType = 'studyHours',
    this.currentTimeFilter = 'allTime',
    this.userStats,
  });

  LeaderboardState copyWith({
    List<LeaderboardUser>? users,
    int? userRank,
    LeaderboardStatus? status,
    String? errorMessage,
    String? currentType,
    String? currentTimeFilter,
    dynamic userStats,
  }) {
    return LeaderboardState(
      users: users ?? this.users,
      userRank: userRank ?? this.userRank,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentType: currentType ?? this.currentType,
      currentTimeFilter: currentTimeFilter ?? this.currentTimeFilter,
      userStats: userStats ?? this.userStats,
    );
  }
}

// Leaderboard state notifier
class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final LeaderboardService _leaderboardService;

  LeaderboardNotifier(this._leaderboardService) : super(LeaderboardState());

  // Fetch leaderboard data
  Future<void> fetchLeaderboard({
    String? leaderboardType,
    String? timeFilter,
  }) async {
    // Use provided parameters or current state
    final type = leaderboardType ?? state.currentType;
    final filter = timeFilter ?? state.currentTimeFilter;

    // Update state to indicate loading
    state = state.copyWith(
      status: LeaderboardStatus.loading,
      currentType: type,
      currentTimeFilter: filter,
    );

    try {
      // Fetch leaderboard users for the table
      final users = await _leaderboardService.getLeaderboard(
        leaderboardType: type,
        timeFilter: filter,
      );

      // Try to get user rank and stats from stats API first
      final userRankData = await _leaderboardService.getUserRankFromStats(
        leaderboardType: type,
        timeFilter: filter,
      );

      // If stats API failed, fall back to the leaderboard API
      if (userRankData['rank'] == null) {
        final fallbackData = await _leaderboardService.getUserRankAndStats(
          leaderboardType: type,
          timeFilter: filter,
        );

        userRankData['rank'] = fallbackData['rank'];
        userRankData['stats'] = fallbackData['stats'];
      }

      // Update state with fetched data
      state = state.copyWith(
        users: users,
        userRank: userRankData['rank'],
        userStats: userRankData['stats'],
        status: LeaderboardStatus.loaded,
      );
    } catch (e) {
      debugPrint('Error in leaderboard notifier: $e');
      state = state.copyWith(
        status: LeaderboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Update leaderboard type
  void updateLeaderboardType(String type) {
    if (type != state.currentType) {
      fetchLeaderboard(leaderboardType: type, timeFilter: state.currentTimeFilter);
    }
  }

  // Update time filter
  void updateTimeFilter(String filter) {
    if (filter != state.currentTimeFilter) {
      fetchLeaderboard(leaderboardType: state.currentType, timeFilter: filter);
    }
  }

  // Get user stats as a formatted string
  String getUserStatsFormatted() {
    if (state.userStats == null) {
      return '-';
    }

    if (state.currentType == 'studyHours') {
      return '${state.userStats} hrs';
    } else {
      return '${state.userStats} days';
    }
  }
}

// Create a StateNotifierProvider for leaderboard
final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, LeaderboardState>((ref) {
  final leaderboardService = ref.watch(leaderboardServiceProvider);
  return LeaderboardNotifier(leaderboardService);
});