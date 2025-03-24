// lib/config/api_config.dart
class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'https://staging.grayblock.io/api';

  // Auth endpoints
  static const String login = 'auth/flutter?action=signin';
  static const String googleSignIn = 'auth/flutter?action=google-signin';
  static const String register = 'auth/flutter?action=register';
  static const String logout = 'auth/flutter?action=logout';
  static const String validateToken = 'auth/flutter?action=validate-token';
  static const String resetPassword = 'auth/flutter?action=reset-password';
  static const String csrfToken = 'auth/flutter';

  // Profile endpoints
  static const String profile = 'profile';
  static const String uploadProfileImage = 'profile/upload-image';

  // Leaderboard endpoints
  static const String leaderboard = 'leaderboard';
  static const String leaderboardUserRank = 'leaderboard/rank';

  // Stats endpoints
  static const String stats = 'stats';
  static const String userGoals = 'user/goals';

  // Helper method to get full URL for an endpoint
  static String getUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }
}