// lib/services/stats_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../providers/auth_provider.dart';
import '../models/stats_model.dart';
import '../models/goals_model.dart';
import '../models/weekly_data.dart';

class StatsService {
  final Ref _ref;

  StatsService(this._ref);

  // Fetch user stats
  Future<UserStats> fetchUserStats() async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse(ApiConfig.getUrl(ApiConfig.stats)),
        headers: authHeaders,
      );

      debugPrint('Stats response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserStats.fromJson(responseData);
      } else {
        // Handle error responses
        debugPrint('Stats API error: ${response.body}');
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching stats: $e');
      throw Exception('Failed to load stats: $e');
    }
  }

  // Fetch user goals
  Future<UserGoals> fetchUserGoals() async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse(ApiConfig.getUrl(ApiConfig.userGoals)),
        headers: authHeaders,
      );

      debugPrint('Goals response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserGoals.fromJson(responseData);
      } else {
        // Handle error responses
        debugPrint('Goals API error: ${response.body}');
        throw Exception('Failed to load goals: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
      throw Exception('Failed to load goals: $e');
    }
  }

  // Update weekly goal
  Future<UserGoals> updateWeeklyGoal(int weeklyGoalHours) async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Prepare request payload
      final payload = {
        'weeklyGoalHours': weeklyGoalHours,
      };

      // Make API request
      final response = await http.put(
        Uri.parse(ApiConfig.getUrl(ApiConfig.userGoals)),
        headers: {
          ...authHeaders,
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      debugPrint('Goal update response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserGoals.fromJson(responseData);
      } else {
        // Handle error responses
        debugPrint('Goal update API error: ${response.body}');
        throw Exception('Failed to update goal: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating goal: $e');
      throw Exception('Failed to update goal: $e');
    }
  }

  // Convert daily breakdown to WeeklyData model for charts
  List<WeeklyData> convertToWeeklyData(List<DailyBreakdown> dailyBreakdown) {
    return dailyBreakdown.map((day) {
      return WeeklyData(
        day: day.dayOfWeek.substring(0, 3), // Convert to three-letter day
        hours: day.totalHours,
      );
    }).toList();
  }
}