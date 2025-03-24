import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class ProfileInfoSectionWidget extends StatelessWidget {
  final UserProfile userData;
  final bool isEditing;
  final Function(String, String) onFieldChanged;
  final VoidCallback onGenderPressed;
  final VoidCallback onLanguagePressed;
  final VoidCallback onCountryPressed;
  final VoidCallback onIndustryPressed;

  const ProfileInfoSectionWidget({
    Key? key,
    required this.userData,
    required this.isEditing,
    required this.onFieldChanged,
    required this.onGenderPressed,
    required this.onLanguagePressed,
    required this.onCountryPressed,
    required this.onIndustryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card(context), // Use theme color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text(context), // Use theme color
            ),
          ),
          const SizedBox(height: 20),

          // Render appropriate fields based on edit mode
          if (isEditing) ...[
            _buildInputField(context, 'Name', userData.name, 'name'),
            _buildInputField(context, 'Username', userData.username, 'username'),
            _buildInputField(context, 'Email', userData.email, 'email', keyboardType: TextInputType.emailAddress),
            _buildInputField(context, 'Phone', userData.phone, 'phone', keyboardType: TextInputType.phone),
            _buildInputField(context, 'Date of Birth', userData.dateOfBirth, 'dateOfBirth'),

            _buildSelectableField(context, 'Gender', userData.gender, onGenderPressed),
            _buildSelectableField(context, 'Language', userData.language, onLanguagePressed),
            _buildSelectableField(context, 'Country', userData.country, onCountryPressed),
            _buildSelectableField(context, 'Industry', userData.industry, onIndustryPressed),

            _buildBioField(context, userData.bio),
          ] else ...[
            _buildDisplayField(context, 'Name', userData.name),
            _buildDisplayField(context, 'Username', userData.username),
            _buildDisplayField(context, 'Email', userData.email),
            _buildDisplayField(context, 'Phone', userData.phone),
            _buildDisplayField(context, 'Date of Birth', userData.dateOfBirth),
            _buildDisplayField(context, 'Gender', userData.gender),
            _buildDisplayField(context, 'Language', userData.language),
            _buildDisplayField(context, 'Country', userData.country),
            _buildDisplayField(context, 'Industry', userData.industry),
            _buildDisplayBio(context, userData.bio),
          ],
        ],
      ),
    );
  }

  Widget _buildDisplayField(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text(context), // Use theme color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayBio(BuildContext context, String bio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bio',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bio,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text(context), // Use theme color
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, String value, String fieldName, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: value),
            onChanged: (newValue) => onFieldChanged(fieldName, newValue),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border(context), // Use theme color
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border(context), // Use theme color
                  width: 1,
                ),
              ),
              filled: Theme.of(context).brightness == Brightness.dark,
              fillColor: Theme.of(context).brightness == Brightness.dark ?
              AppColors.darkSurface : null, // Dark mode fill color
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text(context), // Use theme color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableField(BuildContext context, String label, String value, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border(context), // Use theme color
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).brightness == Brightness.dark ?
                AppColors.darkSurface : null, // Dark mode fill color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.textSecondary(context), // Use theme color
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioField(BuildContext context, String bio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bio',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme color
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: bio),
            onChanged: (newValue) => onFieldChanged('bio', newValue),
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border(context), // Use theme color
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border(context), // Use theme color
                  width: 1,
                ),
              ),
              filled: Theme.of(context).brightness == Brightness.dark,
              fillColor: Theme.of(context).brightness == Brightness.dark ?
              AppColors.darkSurface : null, // Dark mode fill color
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text(context), // Use theme color
            ),
          ),
        ],
      ),
    );
  }
}