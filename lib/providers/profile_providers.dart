import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/user_model.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

// Define profile status enum
enum ProfileStatus { initial, loading, loaded, error }

// Profile state class
class ProfileState {
  final UserProfile? profile;
  final ProfileStatus status;
  final String? errorMessage;

  ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfile? profile,
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Profile state notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final StateNotifierProviderRef<ProfileNotifier, ProfileState> ref;
  final ApiService _apiService = ApiService();

  ProfileNotifier(this.ref) : super(ProfileState());

  Future<void> fetchProfile() async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);

      try {
        final data = await _apiService.get(ApiConfig.profile);
        final userProfile = UserProfile.fromJson(data);

        state = state.copyWith(
          profile: userProfile,
          status: ProfileStatus.loaded,
        );
      } catch (e) {
        debugPrint('Error fetching profile: $e');
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString(),
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to fetch profile: ${e.toString()}',
      );
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);

      try {
        final data = await _apiService.put(
          ApiConfig.profile,
          updatedProfile.toJson(),
        );

        final userProfile = UserProfile.fromJson(data);

        state = state.copyWith(
          profile: userProfile,
          status: ProfileStatus.loaded,
        );
      } catch (e) {
        debugPrint('Error updating profile: $e');
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString(),
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);

      final headers = await _apiService.getAuthHeaders();

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.getUrl(ApiConfig.uploadProfileImage)),
      );

      // Add authorization headers
      headers.forEach((key, value) {
        request.headers[key] = value;
      });

      // Determine content type based on file extension
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      String contentType;

      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'gif':
          contentType = 'image/gif';
          break;
        default:
          contentType = 'image/jpeg'; // Default
      }

      // Add the file
      request.files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          imageFile.path,
          contentType: MediaType.parse(contentType),
        ),
      );

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final imageUrl = data['imageUrl'];

        // Update profile with new image URL if we have a current profile
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(
            profilePicture: imageUrl,
          );

          state = state.copyWith(
            profile: updatedProfile,
            status: ProfileStatus.loaded,
          );
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: errorData['message'] ?? errorData['error'] ?? 'Failed to upload image',
          );
        } catch (e) {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'Failed to upload image (${response.statusCode})',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to upload profile picture: ${e.toString()}',
      );
    }
  }

  // Update field in current profile
  void updateField(String field, String value) {
    if (state.profile == null) return;

    final updatedProfile = state.profile!.copyWith(
      name: field == 'name' ? value : state.profile!.name,
      username: field == 'username' ? value : state.profile!.username,
      email: field == 'email' ? value : state.profile!.email,
      phone: field == 'phone' ? value : state.profile!.phone,
      dateOfBirth: field == 'dateOfBirth' ? value : state.profile!.dateOfBirth,
      gender: field == 'gender' ? value : state.profile!.gender,
      language: field == 'language' ? value : state.profile!.language,
      country: field == 'country' ? value : state.profile!.country,
      industry: field == 'industry' ? value : state.profile!.industry,
      bio: field == 'bio' ? value : state.profile!.bio,
    );

    state = state.copyWith(profile: updatedProfile);
  }
}

// Create a StateNotifierProvider for profile
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

// Provider for tracking if profile is in edit mode
final profileEditingProvider = StateProvider<bool>((ref) => false);

// Provider for temporary profile picture
final profilePictureProvider = StateProvider<File?>((ref) => null);