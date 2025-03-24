// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../providers/theme_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/settings/section_header_widget.dart';
import '../widgets/settings/theme_options_widget.dart';
import '../widgets/settings/toggle_setting_widget.dart';
import '../widgets/settings/navigation_setting_widget.dart';
import '../widgets/settings/logout_button_widget.dart';
import '../widgets/settings/app_info_widget.dart';
import '../widgets/settings/settings_selection_modal.dart';
import '../widgets/settings/change_password_modal.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late SettingsModel settings;

  // Modal visibility states
  bool profileVisibilityModalVisible = false;
  bool notificationPreferencesModalVisible = false;
  bool languageModalVisible = false;
  bool blockedUsersModalVisible = false;
  bool changePasswordModalVisible = false;
  bool deleteAccountModalVisible = false;

  // Options for selection modals
  final List<String> profileVisibilityOptions = ['public', 'friends', 'private'];
  final List<String> languageOptions = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese', 'Arabic', 'Russian'];
  final List<String> notificationTypes = ['Mentions', 'Direct Messages', 'Friend Requests', 'Group Invites', 'System Updates'];
  final Map<String, bool> notificationPreferences = {
    'Mentions': true,
    'Direct Messages': true,
    'Friend Requests': true,
    'Group Invites': false,
    'System Updates': true,
  };
  final List<String> blockedUsers = ['user123', 'spammer456', 'baduser789'];

  @override
  void initState() {
    super.initState();

    // Initialize settings
    final themeState = ref.read(themeProvider);
    settings = SettingsModel(
      theme: themeState.themeMode,
      pushNotifications: true,
      emailNotifications: true,
      profileVisibility: 'public',
      showOnlineStatus: true,
      language: 'English',
    );
  }

  void _updatePushNotifications(bool value) {
    setState(() {
      settings = settings.copyWith(pushNotifications: value);
    });
  }

  void _updateEmailNotifications(bool value) {
    setState(() {
      settings = settings.copyWith(emailNotifications: value);
    });
  }

  void _updateShowOnlineStatus(bool value) {
    setState(() {
      settings = settings.copyWith(showOnlineStatus: value);
    });
  }

  void _updateProfileVisibility(String value) {
    setState(() {
      settings = settings.copyWith(profileVisibility: value);
      profileVisibilityModalVisible = false;
    });
  }

  void _updateLanguage(String value) {
    setState(() {
      settings = settings.copyWith(language: value);
      languageModalVisible = false;
    });
  }

  void _updateNotificationPreference(String type, bool value) {
    setState(() {
      notificationPreferences[type] = value;
    });
  }

  void _removeBlockedUser(String username) {
    setState(() {
      blockedUsers.remove(username);
    });
  }

  void _showModal(String modalType) {
    setState(() {
      switch (modalType) {
        case 'profileVisibility':
          profileVisibilityModalVisible = true;
          break;
        case 'notificationPreferences':
          notificationPreferencesModalVisible = true;
          break;
        case 'language':
          languageModalVisible = true;
          break;
        case 'blockedUsers':
          blockedUsersModalVisible = true;
          break;
        case 'changePassword':
          changePasswordModalVisible = true;
          break;
        case 'deleteAccount':
          deleteAccountModalVisible = true;
          break;
      }
    });
  }

  void _hideModal(String modalType) {
    setState(() {
      switch (modalType) {
        case 'profileVisibility':
          profileVisibilityModalVisible = false;
          break;
        case 'notificationPreferences':
          notificationPreferencesModalVisible = false;
          break;
        case 'language':
          languageModalVisible = false;
          break;
        case 'blockedUsers':
          blockedUsersModalVisible = false;
          break;
        case 'changePassword':
          changePasswordModalVisible = false;
          break;
        case 'deleteAccount':
          deleteAccountModalVisible = false;
          break;
      }
    });
  }

  String _getProfileVisibilityDescription() {
    switch (settings.profileVisibility) {
      case 'public':
        return 'Your profile is visible to everyone';
      case 'friends':
        return 'Your profile is visible to friends only';
      case 'private':
        return 'Your profile is private';
      default:
        return '';
    }
  }

  String _getProfileVisibilityDisplayName(String value) {
    switch (value) {
      case 'public':
        return 'Public';
      case 'friends':
        return 'Friends Only';
      case 'private':
        return 'Private';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode from provider
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Theme.of(context).iconTheme.color),
                        onPressed: widget.onBack,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Main content in a scrollable area
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Theme Section
                          _buildSection(
                            'Theme',
                            const ThemeOptionsWidget(),
                          ),

                          // Notifications Section
                          _buildSection(
                            'Notifications',
                            Column(
                              children: [
                                ToggleSettingWidget(
                                  title: 'Push Notifications',
                                  description: 'Receive push notifications for important updates',
                                  value: settings.pushNotifications,
                                  onChanged: _updatePushNotifications,
                                ),
                                ToggleSettingWidget(
                                  title: 'Email Notifications',
                                  description: 'Receive email notifications for important updates',
                                  value: settings.emailNotifications,
                                  onChanged: _updateEmailNotifications,
                                ),
                                NavigationSettingWidget(
                                  title: 'Notification Preferences',
                                  description: 'Customize which notifications you receive',
                                  icon: Icons.notifications_outlined,
                                  iconColor: AppColors.primary,
                                  onTap: () => _showModal('notificationPreferences'),
                                ),
                              ],
                            ),
                          ),

                          // Privacy Section
                          _buildSection(
                            'Privacy',
                            Column(
                              children: [
                                NavigationSettingWidget(
                                  title: 'Profile Visibility',
                                  description: _getProfileVisibilityDescription(),
                                  icon: Icons.shield_outlined,
                                  iconColor: AppColors.primary,
                                  onTap: () => _showModal('profileVisibility'),
                                ),
                                ToggleSettingWidget(
                                  title: 'Show Online Status',
                                  description: 'Allow others to see when you are online',
                                  value: settings.showOnlineStatus,
                                  onChanged: _updateShowOnlineStatus,
                                ),
                                NavigationSettingWidget(
                                  title: 'Blocked Users',
                                  description: 'Manage your list of blocked users',
                                  icon: Icons.person_remove_outlined,
                                  iconColor: AppColors.danger,
                                  onTap: () => _showModal('blockedUsers'),
                                ),
                              ],
                            ),
                          ),

                          // Account Section
                          _buildSection(
                            'Account',
                            Column(
                              children: [
                                NavigationSettingWidget(
                                  title: 'Change Password',
                                  description: 'Update your account password',
                                  icon: Icons.lock_outline,
                                  iconColor: AppColors.primary,
                                  onTap: () => _showModal('changePassword'),
                                ),
                                NavigationSettingWidget(
                                  title: 'Language',
                                  description: settings.language,
                                  icon: Icons.language,
                                  iconColor: AppColors.primary,
                                  onTap: () => _showModal('language'),
                                ),
                                NavigationSettingWidget(
                                  title: 'Delete Account',
                                  description: 'Permanently delete your account and all data',
                                  icon: Icons.delete_outline,
                                  iconColor: AppColors.danger,
                                  onTap: () => _showModal('deleteAccount'),
                                ),
                              ],
                            ),
                          ),

                          // Logout Button
                          const LogoutButtonWidget(),

                          // App Info
                          const AppInfoWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Modals
            if (profileVisibilityModalVisible)
              SettingsSelectionModal(
                title: 'Profile Visibility',
                options: profileVisibilityOptions,
                currentValue: settings.profileVisibility,
                getDisplayName: _getProfileVisibilityDisplayName,
                onSelect: _updateProfileVisibility,
                onCancel: () => _hideModal('profileVisibility'),
              ),

            if (languageModalVisible)
              SettingsSelectionModal(
                title: 'Select Language',
                options: languageOptions,
                currentValue: settings.language,
                onSelect: _updateLanguage,
                onCancel: () => _hideModal('language'),
              ),

            if (notificationPreferencesModalVisible)
              _buildNotificationPreferencesModal(),

            if (blockedUsersModalVisible)
              _buildBlockedUsersModal(),

            if (changePasswordModalVisible)
              ChangePasswordModal(
                onCancel: () => _hideModal('changePassword'),
                onSave: (oldPass, newPass) {
                  // In a real app, this would handle password change
                  print('Password change: $oldPass -> $newPass');
                  _hideModal('changePassword');
                },
              ),

            if (deleteAccountModalVisible)
              _buildDeleteAccountConfirmation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05
            ),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text(context),
              ),
            ),
            const SizedBox(height: 15),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPreferencesModal() {
    return GestureDetector(
      onTap: () => _hideModal('notificationPreferences'),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.modalHandle(context),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal title
                  Text(
                    'Notification Preferences',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notification toggles
                  ...notificationTypes.map((type) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.text(context),
                              ),
                            ),
                            Switch(
                              value: notificationPreferences[type] ?? false,
                              onChanged: (value) => _updateNotificationPreference(type, value),
                              activeColor: AppColors.primary,
                              activeTrackColor: AppColors.primary.withOpacity(0.5),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: AppColors.inactiveControl(context),
                            ),
                          ],
                        ),
                      ),
                  ).toList(),

                  // Close button
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _hideModal('notificationPreferences'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockedUsersModal() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _hideModal('blockedUsers'),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.modalHandle(context),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal title
                  Text(
                    'Blocked Users',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Blocked users list
                  blockedUsers.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'You haven\'t blocked any users',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  )
                      : Column(
                    children: blockedUsers.map((username) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.text(context),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeBlockedUser(username),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.iconBackground(context, AppColors.danger),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Unblock',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ).toList(),
                  ),

                  // Close button
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _hideModal('blockedUsers'),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.getColor(
                          context,
                          lightModeColor: const Color(0xFFF8F9FA),
                          darkModeColor: Colors.grey[800]!,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.border(context),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountConfirmation() {
    return GestureDetector(
      onTap: () => _hideModal('deleteAccount'),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.iconBackground(context, AppColors.danger),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.danger,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title and message
                  Text(
                    'Delete Account?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This action cannot be undone. All your data will be permanently deleted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary(context),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: TextButton(
                          onPressed: () => _hideModal('deleteAccount'),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.getColor(
                              context,
                              lightModeColor: const Color(0xFFF8F9FA),
                              darkModeColor: Colors.grey[800]!,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.border(context),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Delete button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle delete account
                            print('Delete account confirmed');
                            _hideModal('deleteAccount');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}