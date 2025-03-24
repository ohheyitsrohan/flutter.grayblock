import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Fixed import path

class ProfileModal extends StatelessWidget {
  final String userName;
  final VoidCallback onDismiss;
  final VoidCallback? onProfileSelected;
  final VoidCallback? onSettingsSelected;
  final VoidCallback? onLogoutSelected;

  const ProfileModal({
    Key? key,
    required this.userName,
    required this.onDismiss,
    this.onProfileSelected,
    this.onSettingsSelected,
    this.onLogoutSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Material widget to ensure it's rendered above everything
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {}, // Prevent tap through
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.card(context), // Use theme color
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.modalHandle(context), // Use theme color
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: AppColors.primary, // Use theme color
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    // Using a placeholder image from assets or an icon instead of network image
                                    child: Container(
                                      color: AppColors.inactiveControl(context), // Use theme color
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.primary, // Use theme color
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text(context), // Use theme color
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'user@example.com',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary(context), // Use theme color
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.person_outline,
                              label: 'View Profile',
                              isLogout: false,
                              onTap: onProfileSelected,
                            ),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.settings_outlined,
                              label: 'Settings',
                              isLogout: false,
                              onTap: onSettingsSelected,
                            ),
                            const SizedBox(height: 8),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.logout_outlined,
                              label: 'Logout',
                              isLogout: true,
                              onTap: onLogoutSelected,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isLogout,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          onDismiss();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: !isLogout
              ? Border(
            bottom: BorderSide(
              color: AppColors.divider(context), // Use theme color
              width: 1,
            ),
          )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isLogout
                    ? AppColors.iconBackground(context, AppColors.danger) // Use theme helper with danger
                    : AppColors.iconBackground(context, AppColors.primary), // Use theme helper with primary
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: isLogout
                    ? AppColors.danger // Use theme color
                    : AppColors.primary, // Use theme color
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isLogout
                    ? AppColors.danger // Use theme color
                    : AppColors.text(context), // Use theme color
                fontWeight: isLogout ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (!isLogout)
              Icon(
                Icons.chevron_right,
                color: AppColors.border(context), // Use theme color
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}