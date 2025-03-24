import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class ProfileHeaderWidget extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onBackPressed;

  const ProfileHeaderWidget({
    Key? key,
    required this.isEditing,
    required this.onEditPressed,
    required this.onCancelPressed,
    required this.onSavePressed,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button and title
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.text(context), // Use theme color
              ),
              onPressed: onBackPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 10),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text(context), // Use theme color
              ),
            ),
          ],
        ),

        // Edit or Save/Cancel buttons
        if (!isEditing)
          _buildEditButton(context)
        else
          _buildEditActions(context),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: onEditPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.iconBackground(context, AppColors.primary), // Use theme color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary, // Use theme color
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.primary, // Use theme color
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditActions(BuildContext context) {
    return Row(
      children: [
        // Cancel button
        GestureDetector(
          onTap: onCancelPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.inactiveControl(context), // Use theme color
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.border(context), // Use theme color
                width: 1,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary(context), // Use theme color
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Save button
        GestureDetector(
          onTap: onSavePressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary, // Use theme color
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}