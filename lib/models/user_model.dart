// This file contains both UserModel (for authentication) and UserProfile (for profile UI)
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      profileImage: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'image': profileImage,
    };
  }
}

// User Profile for profile management
class UserProfile {
  String name;
  String username;
  String email;
  String phone;
  String dateOfBirth;
  String gender;
  String language;
  String country;
  String industry;
  String bio;
  String profilePicture;

  UserProfile({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.language,
    required this.country,
    required this.industry,
    required this.bio,
    required this.profilePicture,
  });

  // Create a copy of the current user profile with optional changes
  UserProfile copyWith({
    String? name,
    String? username,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? language,
    String? country,
    String? industry,
    String? bio,
    String? profilePicture,
  }) {
    return UserProfile(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      country: country ?? this.country,
      industry: industry ?? this.industry,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  // Factory constructor to create a UserProfile from the API response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      language: json['language'] ?? 'English',
      country: json['country'] ?? '',
      industry: json['industry'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profilePicture'] ?? json['image'] ?? '',
    );
  }

  // Convert profile to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'country': country,
      'language': language,
      'industry': industry,
      'bio': bio,
      'location': '', // Not used in your UserProfile model, but required by API
      'preferences': {
        'notifications': true, // Default value
        'newsletter': false,   // Default value
      },
      'profilePicture': profilePicture,
    };
  }

  // Create a UserProfile from a UserModel
  static UserProfile fromUserModel(UserModel model) {
    return UserProfile(
      name: model.name ?? 'User',
      username: model.username ?? 'user',
      email: model.email,
      phone: '',  // Default values for fields not in UserModel
      dateOfBirth: '',
      gender: '',
      language: 'English',
      country: '',
      industry: '',
      bio: '',
      profilePicture: model.profileImage ?? '',
    );
  }

  // Mock user data for testing
  static UserProfile getMockUser() {
    return UserProfile(
      name: 'John Doe',
      username: 'johndoe',
      email: 'john.doe@example.com',
      phone: '+1 (555) 123-4567',
      dateOfBirth: '1990-05-15',
      gender: 'Male',
      language: 'English',
      country: 'United States',
      industry: 'Software Development',
      bio: 'Passionate developer and lifelong learner. I enjoy solving complex problems and building useful applications.',
      profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
    );
  }

  // Convert to UserModel format
  UserModel toUserModel() {
    return UserModel(
      id: '',  // This would need to be set properly in a real implementation
      email: email,
      name: name,
      username: username,
      profileImage: profilePicture,
    );
  }
}