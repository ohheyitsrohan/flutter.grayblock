// lib/models/leaderboard_user.dart
import 'dart:math' as math;

class LeaderboardUser {
  final String id; // Keep as String to maintain compatibility
  final int userId; // Add userId for API compatibility
  final String username;
  final String avatar;
  final int studyHours;
  final int streakDays;
  final int? rank;
  final double? progress;

  LeaderboardUser({
    required this.id,
    this.userId = 0,
    required this.username,
    required this.avatar,
    required this.studyHours,
    required this.streakDays,
    this.rank,
    this.progress,
  });

  // Create a copy with updated fields
  LeaderboardUser copyWith({
    String? id,
    int? userId,
    String? username,
    String? avatar,
    int? studyHours,
    int? streakDays,
    int? rank,
    double? progress,
  }) {
    return LeaderboardUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      studyHours: studyHours ?? this.studyHours,
      streakDays: streakDays ?? this.streakDays,
      rank: rank ?? this.rank,
      progress: progress ?? this.progress,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'avatar': avatar,
      'studyHours': studyHours,
      'streakDays': streakDays,
      'rank': rank,
      'progress': progress,
    };
  }

  // Create model from JSON
  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    // Extract id, handling both string and int formats
    final idValue = json['id'] ?? '';
    final String stringId = idValue is int ? idValue.toString() : idValue.toString();

    // Extract userId, handling different formats
    final userIdValue = json['userId'] ?? json['id'] ?? 0;
    final int intUserId = userIdValue is String ? int.tryParse(userIdValue) ?? 0 : userIdValue as int;

    return LeaderboardUser(
      id: stringId,
      userId: intUserId,
      username: json['name'] ?? json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      studyHours: json['hours'] != null ? (json['hours'] is int ? json['hours'] : (json['hours'] as num).toInt()) : 0,
      streakDays: json['streak'] != null ? (json['streak'] is int ? json['streak'] : (json['streak'] as num).toInt()) : 0,
      rank: json['rank'] != null ? (json['rank'] is int ? json['rank'] : int.tryParse(json['rank'].toString())) : null,
      progress: json['progress'] != null ? (json['progress'] is double ? json['progress'] : (json['progress'] as num).toDouble()) : null,
    );
  }
}