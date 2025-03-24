import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../themes/app_colors.dart';

class ProfilePictureSectionWidget extends StatelessWidget {
  final UserProfile userData;
  final bool isEditing;
  final VoidCallback onChangeProfilePicture;
  final Widget? customImageWidget;

  const ProfilePictureSectionWidget({
    Key? key,
    required this.userData,
    required this.isEditing,
    required this.onChangeProfilePicture,
    this.customImageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture with edit button
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary, // Use theme color
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: customImageWidget != null
                      ? customImageWidget!
                      : Image.network(
                    userData.profilePicture,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to a placeholder if the image fails to load
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onChangeProfilePicture,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Use theme color
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.card(context), // Use theme color for white border
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),

          // User name
          Text(
            userData.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context), // Use theme color
            ),
          ),
          const SizedBox(height: 4),

          // Username
          Text(
            '@${userData.username}',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
        ],
      ),
    );
  }
}