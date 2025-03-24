// lib/widgets/header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../themes/app_colors.dart'; // Import AppColors
import '../providers/profile_providers.dart'; // Import profile providers

class HeaderWidget extends ConsumerWidget {
  final String userName;
  final VoidCallback onAvatarTap;
  final bool isAuthenticated;
  final VoidCallback? onLogin;

  const HeaderWidget({
    Key? key,
    required this.userName,
    required this.onAvatarTap,
    this.isAuthenticated = false,
    this.onLogin,
  }) : super(key: key);

  // Current date formatting
  String get _currentDate {
    final now = DateTime.now();
    final formatter = DateFormat('EEE dd MMMM');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get profile data from Riverpod
    final profileState = ref.watch(profileProvider);
    final userData = profileState.profile;

    // Determine profile image to display
    Widget profileImage;

    if (userData != null && userData.profilePicture.isNotEmpty) {
      // Use user's profile picture if available
      profileImage = Image.network(
        userData.profilePicture,
        width: 46,
        height: 46,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a placeholder if the image fails to load
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 25,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // Fallback to default image if no profile data or empty profile picture
      profileImage = Image.network(
        'https://randomuser.me/api/portraits/men/32.jpg',
        width: 46,
        height: 46,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a placeholder if the default image fails to load
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 25,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentDate,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary(context), // Use theme color
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                // Use the actual profile name if available
                'Hello, ${userData?.name ?? userName}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text(context), // Use theme color
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: isAuthenticated ? onAvatarTap : onLogin,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.primary, // Use theme color
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: profileImage,
                  ),
                  // Green status dot removed
                  // Show a login indicator if not authenticated
                  if (!isAuthenticated)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.danger, // Use theme color
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.background(context), // Use theme color
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.login,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}