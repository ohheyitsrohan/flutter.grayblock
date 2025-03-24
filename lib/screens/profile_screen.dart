import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../providers/profile_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile/profile_header_widget.dart';
import '../widgets/profile/profile_picture_section_widget.dart';
import '../widgets/profile/profile_info_section_widget.dart';
import '../themes/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Function() onBack;

  const ProfileScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Modal visibility states
  bool profilePictureModalVisible = false;
  bool genderModalVisible = false;
  bool languageModalVisible = false;
  bool countryModalVisible = false;
  bool industryModalVisible = false;

  // Selection options
  final List<String> genderOptions = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
  final List<String> languageOptions = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese', 'Arabic', 'Russian'];
  final List<String> countryOptions = ['United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Japan', 'China', 'India', 'Brazil'];
  final List<String> industryOptions = [
    'Software Development',
    'Healthcare',
    'Education',
    'Finance',
    'Marketing',
    'Design',
    'Engineering',
    'Research',
    'Hospitality',
    'Retail'
  ];

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  // Toggle edit mode
  void toggleEditMode() {
    final isEditing = ref.read(profileEditingProvider);
    ref.read(profileEditingProvider.notifier).state = !isEditing;

    // If cancelling edit, reset the profile to the original state
    if (isEditing) {
      ref.read(profileProvider.notifier).fetchProfile();
    }
  }

  // Handle save profile changes
  void handleSaveProfile() async {
    final profile = ref.read(profileProvider).profile;
    if (profile != null) {
      // First, upload the profile picture if a new one has been selected
      final profilePicture = ref.read(profilePictureProvider);
      if (profilePicture != null) {
        await ref.read(profileProvider.notifier).uploadProfilePicture(profilePicture);
        ref.read(profilePictureProvider.notifier).state = null;
      }

      // Then update the profile
      await ref.read(profileProvider.notifier).updateProfile(profile);

      // Turn off edit mode
      ref.read(profileEditingProvider.notifier).state = false;
    }
  }

  // Handle cancel profile editing
  void handleCancelEdit() {
    ref.read(profileProvider.notifier).fetchProfile();
    ref.read(profileEditingProvider.notifier).state = false;
    ref.read(profilePictureProvider.notifier).state = null;
  }

  // Update field
  void updateEditData(String field, String value) {
    ref.read(profileProvider.notifier).updateField(field, value);
  }

  // Show profile picture modal
  void showProfilePictureModal() {
    setState(() {
      profilePictureModalVisible = true;
    });
  }

  // Handle modal visibility
  void showModal(String modalType) {
    setState(() {
      switch (modalType) {
        case 'gender':
          genderModalVisible = true;
          break;
        case 'language':
          languageModalVisible = true;
          break;
        case 'country':
          countryModalVisible = true;
          break;
        case 'industry':
          industryModalVisible = true;
          break;
      }
    });
  }

  void hideModal(String modalType) {
    setState(() {
      switch (modalType) {
        case 'profilePicture':
          profilePictureModalVisible = false;
          break;
        case 'gender':
          genderModalVisible = false;
          break;
        case 'language':
          languageModalVisible = false;
          break;
        case 'country':
          countryModalVisible = false;
          break;
        case 'industry':
          industryModalVisible = false;
          break;
      }
    });
  }

  // Handle profile picture selection
  Future<void> handleProfilePicture(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        // Store the selected image file
        ref.read(profilePictureProvider.notifier).state = File(image.path);
      }

      // Hide the modal
      hideModal('profilePicture');
    } catch (e) {
      debugPrint('Error picking image: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  // Build the profile picture modal
  Widget _buildProfilePictureModal() {
    return GestureDetector(
      onTap: () => hideModal('profilePicture'),
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
                  _buildPictureOption('Take Photo', Icons.camera_alt_outlined, () {
                    handleProfilePicture(ImageSource.camera);
                  }),
                  Divider(height: 1, color: AppColors.divider(context)), // Use theme color
                  _buildPictureOption('Choose from Gallery', Icons.image_outlined, () {
                    handleProfilePicture(ImageSource.gallery);
                  }),
                  const SizedBox(height: 20),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => hideModal('profilePicture'),
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

  Widget _buildPictureOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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

  // Build the selection modal
  Widget _buildSelectionModal({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelect,
    required VoidCallback onCancel,
  }) {
    return GestureDetector(
      onTap: onCancel, // Dismiss when tapping outside
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
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
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options list
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options.map((option) {
                          final bool isSelected = option == currentValue;

                          return GestureDetector(
                            onTap: () => onSelect(option),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.iconBackground(context, AppColors.primary) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected ? AppColors.primary : AppColors.textSecondary(context),
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: AppColors.primary, // Use theme color
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Cancel button
                  const SizedBox(height: 12),
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

  @override
  Widget build(BuildContext context) {
    // Watch profile state
    final profileState = ref.watch(profileProvider);
    final isEditing = ref.watch(profileEditingProvider);
    final profilePicture = ref.watch(profilePictureProvider);

    // Handle loading state
    if (profileState.status == ProfileStatus.loading && profileState.profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    // Handle error state
    if (profileState.status == ProfileStatus.error) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red, // Using Colors.red instead of AppColors.error
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profileState.errorMessage ?? 'Please try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.read(profileProvider.notifier).fetchProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Get user data
    final userData = profileState.profile ?? UserProfile.getMockUser();

    // Determine which profile picture to display
    String profilePictureUrl = userData.profilePicture;
    Widget profileImageWidget;

    if (profilePicture != null) {
      // Show the local file image if a new profile picture was selected
      profileImageWidget = Image.file(
        profilePicture,
        fit: BoxFit.cover,
      );
    } else {
      // Show the network image from the user data
      profileImageWidget = Image.network(
        profilePictureUrl,
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
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and edit button
                    ProfileHeaderWidget(
                      isEditing: isEditing,
                      onEditPressed: toggleEditMode,
                      onCancelPressed: handleCancelEdit,
                      onSavePressed: handleSaveProfile,
                      onBackPressed: widget.onBack,
                    ),

                    // Profile Picture Section
                    ProfilePictureSectionWidget(
                      userData: userData,
                      isEditing: isEditing,
                      onChangeProfilePicture: showProfilePictureModal,
                      customImageWidget: profilePicture != null ? profileImageWidget : null,
                    ),

                    // Profile Information Section - Center it when not in editing mode
                    Center(
                      child: Container(
                        width: isEditing ? double.infinity : MediaQuery.of(context).size.width * 0.85,
                        child: ProfileInfoSectionWidget(
                          userData: userData,
                          isEditing: isEditing,
                          onFieldChanged: updateEditData,
                          onGenderPressed: () => showModal('gender'),
                          onLanguagePressed: () => showModal('language'),
                          onCountryPressed: () => showModal('country'),
                          onIndustryPressed: () => showModal('industry'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modals
            if (profilePictureModalVisible)
              _buildProfilePictureModal(),

            if (genderModalVisible)
              _buildSelectionModal(
                title: 'Select Gender',
                options: genderOptions,
                currentValue: userData.gender,
                onSelect: (value) {
                  updateEditData('gender', value);
                  hideModal('gender');
                },
                onCancel: () => hideModal('gender'),
              ),

            if (languageModalVisible)
              _buildSelectionModal(
                title: 'Select Language',
                options: languageOptions,
                currentValue: userData.language,
                onSelect: (value) {
                  updateEditData('language', value);
                  hideModal('language');
                },
                onCancel: () => hideModal('language'),
              ),

            if (countryModalVisible)
              _buildSelectionModal(
                title: 'Select Country',
                options: countryOptions,
                currentValue: userData.country,
                onSelect: (value) {
                  updateEditData('country', value);
                  hideModal('country');
                },
                onCancel: () => hideModal('country'),
              ),

            if (industryModalVisible)
              _buildSelectionModal(
                title: 'Select Industry',
                options: industryOptions,
                currentValue: userData.industry,
                onSelect: (value) {
                  updateEditData('industry', value);
                  hideModal('industry');
                },
                onCancel: () => hideModal('industry'),
              ),
          ],
        ),
      ),
    );
  }
}