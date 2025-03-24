import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class ProfilePictureModalWidget extends StatelessWidget {
  final VoidCallback onCancel;

  const ProfilePictureModalWidget({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
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
                color: AppColors.card(context), // Use theme color
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
                      color: AppColors.modalHandle(context), // Use theme color
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal title
                  Text(
                    'Profile Picture',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options
                  _buildPictureOption(context, 'Take Photo', Icons.camera_alt_outlined),
                  Divider(height: 1, color: AppColors.divider(context)), // Use theme color
                  _buildPictureOption(context, 'Choose from Gallery', Icons.image_outlined),
                  const SizedBox(height: 20),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.getColor(
                          context,
                          lightModeColor: AppColors.lightInactiveControl,
                          darkModeColor: AppColors.darkInactiveControl,
                        ), // Use theme color
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.border(context), // Use theme color
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.text(context), // Use theme color
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

  Widget _buildPictureOption(BuildContext context, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Here you would typically implement the camera or gallery functionality
        // For now, just dismiss the modal
        onCancel();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: AppColors.primary, // Use theme color
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text(context), // Use theme color
              ),
            ),
          ],
        ),
      ),
    );
  }
}