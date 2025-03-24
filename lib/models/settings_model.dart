class SettingsModel {
  String theme; // 'light', 'dark', or 'system'
  bool pushNotifications;
  bool emailNotifications;
  String profileVisibility; // 'public', 'friends', or 'private'
  bool showOnlineStatus;
  String language;

  SettingsModel({
    required this.theme,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.profileVisibility,
    required this.showOnlineStatus,
    required this.language,
  });

  // Create a copy with optional changes
  SettingsModel copyWith({
    String? theme,
    bool? pushNotifications,
    bool? emailNotifications,
    String? profileVisibility,
    bool? showOnlineStatus,
    String? language,
  }) {
    return SettingsModel(
      theme: theme ?? this.theme,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      language: language ?? this.language,
    );
  }

  // Get default settings
  static SettingsModel getDefaults() {
    return SettingsModel(
      theme: 'system',
      pushNotifications: true,
      emailNotifications: true,
      profileVisibility: 'public',
      showOnlineStatus: true,
      language: 'English',
    );
  }
}