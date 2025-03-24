// lib/services/leaderboard_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/leaderboard_user.dart';
import '../config/api_config.dart';
import '../providers/auth_provider.dart';

class LeaderboardService {
  final Ref _ref;

  LeaderboardService(this._ref);

  // Convert time filter from app format to API format
  String _convertTimeFilter(String timeFilter) {
    switch (timeFilter) {
      case 'weekly':
        return 'week';
      case 'monthly':
        return 'month';
      case 'allTime':
      default:
        return 'all';
    }
  }

  // Convert leaderboard type from app format to API format
  String _convertLeaderboardType(String leaderboardType) {
    switch (leaderboardType) {
      case 'streakDays':
        return 'streak';
      case 'studyHours':
      default:
        return 'hours';
    }
  }

  // Get leaderboard data
  Future<List<LeaderboardUser>> getLeaderboard({
    required String leaderboardType,
    required String timeFilter,
    int limit = 100,
  }) async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Convert parameters to API format
      final apiTimeFilter = _convertTimeFilter(timeFilter);
      final apiLeaderboardType = _convertLeaderboardType(leaderboardType);

      // Build URL with query parameters
      final url = '${ApiConfig.getUrl(ApiConfig.leaderboard)}'
          '?type=$apiLeaderboardType'
          '&timeFilter=$apiTimeFilter'
          '&limit=$limit';

      debugPrint('Fetching leaderboard from: $url');

      // Make API request
      final response = await http.get(
        Uri.parse(url),
        headers: authHeaders,
      );

      debugPrint('Leaderboard response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Convert API response to app model
        final users = responseData.map((data) => LeaderboardUser.fromJson(data)).toList();

        // Get the current user's ID to mark them in the list
        final currentUserId = _ref.read(authProvider).user?.id;

        // If we have the current user's ID, mark their entry
        if (currentUserId != null) {
          for (var i = 0; i < users.length; i++) {
            if (users[i].id == currentUserId ||
                users[i].userId.toString() == currentUserId) {
              // Mark this as the current user by updating their rank property
              users[i] = users[i].copyWith(
                rank: i + 1, // Update rank to match position in list (1-based)
              );
            }
          }
        }

        return users;
      } else {
        // Handle error responses
        debugPrint('Leaderboard API error: ${response.body}');
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching leaderboard: $e');
      return []; // Return empty list on error
    }
  }

  // Get user rank from the stats API
  Future<Map<String, dynamic>> getUserRankFromStats({
    required String leaderboardType,
    required String timeFilter,
  }) async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Directly fetch from stats API to get raw response
      final response = await http.get(
        Uri.parse(ApiConfig.getUrl(ApiConfig.stats)),
        headers: authHeaders,
      );

      if (response.statusCode != 200) {
        return {'rank': null, 'stats': null};
      }

      final responseData = json.decode(response.body);

      // Check if leaderboard data exists in response
      if (responseData == null || responseData['leaderboard'] == null) {
        return {'rank': null, 'stats': null};
      }

      // Extract leaderboard data
      final leaderboardData = responseData['leaderboard'];
      final stats = leaderboardData['stats'];
      final ranks = leaderboardData['ranks'];

      int? rank;
      dynamic value;

      // Get appropriate rank based on leaderboard type and time filter
      if (leaderboardType == 'studyHours') {
        if (timeFilter == 'weekly') {
          rank = ranks['weekly']?['studyHours'];
          value = stats['studyHours'];
        } else if (timeFilter == 'monthly') {
          rank = ranks['monthly']?['studyHours'];
          value = stats['studyHours'];
        } else { // allTime
          rank = ranks['allTime']?['studyHours'];
          value = stats['studyHours'];
        }
      } else { // streakDays
        rank = ranks['streak']?['days'];
        value = stats['streak'];
      }

      return {
        'rank': rank,
        'stats': value,
        'totalUsers': leaderboardData['totalUsers']
      };
    } catch (e) {
      debugPrint('Error fetching user rank from stats: $e');
      return {'rank': null, 'stats': null};
    }
  }

  // Get current user's rank and stats
  Future<Map<String, dynamic>> getUserRankAndStats({
    required String leaderboardType,
    required String timeFilter,
  }) async {
    try {
      // Get auth headers from auth provider
      final authHeaders = await _ref.read(authProvider.notifier).getAuthHeaders();

      // Convert parameters to API format
      final apiTimeFilter = _convertTimeFilter(timeFilter);
      final apiLeaderboardType = _convertLeaderboardType(leaderboardType);

      // Prepare request payload
      final payload = {
        'type': apiLeaderboardType,
        'timeFilter': apiTimeFilter,
      };

      // Make API request
      final response = await http.post(
        Uri.parse(ApiConfig.getUrl(ApiConfig.leaderboardUserRank)),
        headers: {
          ...authHeaders,
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'rank': responseData['rank'],
          'stats': responseData[apiLeaderboardType] ?? 0,
        };
      } else {
        // Handle error responses
        debugPrint('User rank API error: ${response.body}');
        return {'rank': null, 'stats': null};
      }
    } catch (e) {
      debugPrint('Error fetching user rank: $e');
      return {'rank': null, 'stats': null};
    }
  }

  // Get current user's rank (for backwards compatibility)
  Future<int?> getUserRank({
    required String leaderboardType,
    required String timeFilter,
  }) async {
    final result = await getUserRankAndStats(
      leaderboardType: leaderboardType,
      timeFilter: timeFilter,
    );
    return result['rank'];
  }
}