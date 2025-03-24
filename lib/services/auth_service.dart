import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // Updated GoogleSignIn initialization with clientId
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // The client ID is optional for Android but can help ensure consistency
    clientId: '121211868876-o761k1hr72e78p148ko57rafskn8nkgh.apps.googleusercontent.com',
  );

  // Base URL configuration
  String get _baseUrl {
    // Use your actual deployed Next.js app URL here
    return 'https://staging.grayblock.io/api/auth/flutter';
  }

  // Email Login with CSRF Token Handling
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      debugPrint('Attempting login with email: $email');
      debugPrint('Using backend URL: $_baseUrl');

      // First, get CSRF token
      final csrfResponse = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('CSRF Response Status Code: ${csrfResponse.statusCode}');

      // Extract CSRF token from response body
      final csrfData = json.decode(csrfResponse.body);
      final csrfToken = csrfData['csrfToken'];

      if (csrfToken == null) {
        debugPrint('Failed to extract CSRF token');
        return {
          'success': false,
          'message': 'Authentication failed: Could not get CSRF token',
        };
      }

      // For debugging
      debugPrint('CSRF Token received: ${csrfToken.substring(0, 10)}...'); // Just showing first 10 chars for security

      // Perform login (temporarily without CSRF token for testing)
      final loginResponse = await http.post(
        Uri.parse('$_baseUrl?action=signin'),
        headers: {
          'Content-Type': 'application/json',
          // Include the token in the header
          'X-CSRF-Token': csrfToken,
        },
        body: json.encode({
          'email': email,
          'password': password,
          // Also include the token in the body as a fallback
          'csrfToken': csrfToken,
        }),
      );

      debugPrint('Login Response Status Code: ${loginResponse.statusCode}');
      if (loginResponse.statusCode != 200) {
        debugPrint('Login Response Body: ${loginResponse.body}');
      }

      // Handle different response scenarios
      switch (loginResponse.statusCode) {
        case 200:
          try {
            final data = json.decode(loginResponse.body);

            // Store the JWT token
            await _storage.write(key: 'auth_token', value: data['token']);

            // Store user data
            if (data['user'] != null) {
              final user = UserModel.fromJson(data['user']);
              await _storage.write(key: 'user_data', value: json.encode(user.toJson()));
            }

            return {
              'success': true,
              'message': 'Login successful',
              'token': data['token'],
              'user': data['user']
            };
          } catch (e) {
            debugPrint('Error processing response: $e');
            return {
              'success': false,
              'message': 'Invalid response format',
            };
          }

        case 401:
          return {
            'success': false,
            'message': 'Invalid credentials',
          };

        case 403:
          return {
            'success': false,
            'message': 'CSRF token validation failed',
          };

        default:
          return {
            'success': false,
            'message': 'Login failed: ${loginResponse.body}',
          };
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Improved Google Sign-In with better error handling
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Step 1: Enable detailed logging
      debugPrint('Starting Google Sign-In process');

      // Step 2: Attempt sign-in with proper error handling
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('Google Sign-In cancelled by user');
        return {
          'success': false,
          'message': 'Google Sign-In cancelled',
        };
      }

      // Step 3: Log account info for debugging
      debugPrint('Google account info:');
      debugPrint('Email: ${googleUser.email}');
      debugPrint('Display Name: ${googleUser.displayName}');
      debugPrint('ID: ${googleUser.id}');

      // Step 4: Get authentication with better error handling
      GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleUser.authentication;
        debugPrint('Successfully obtained Google authentication');
      } catch (e) {
        debugPrint('Error getting Google authentication: $e');
        return {
          'success': false,
          'message': 'Failed to authenticate with Google: ${e.toString()}',
        };
      }

      // Step 5: Validate tokens are present
      if (googleAuth.idToken == null) {
        debugPrint('ID token is null - this is a critical error');
        return {
          'success': false,
          'message': 'Google authentication failed: No ID token received',
        };
      }

      // Step 6: Log token information (first few characters only for security)
      debugPrint('Google ID Token: ${googleAuth.idToken!.substring(0, min(10, googleAuth.idToken!.length))}...');
      if (googleAuth.accessToken != null) {
        debugPrint('Google Access Token: ${googleAuth.accessToken!.substring(0, min(10, googleAuth.accessToken!.length))}...');
      } else {
        debugPrint('Google Access Token: null');
      }

      // Step 7: Log API call details
      debugPrint('Sending tokens to server: $_baseUrl?action=google-signin');

      final response = await http.post(
        Uri.parse('$_baseUrl?action=google-signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken ?? '',
        }),
      );

      // Step 8: Log response details
      debugPrint('Google Sign-In Response Status: ${response.statusCode}');
      debugPrint('Google Sign-In Response Body: ${response.body}');

      switch (response.statusCode) {
        case 200:
          try {
            final data = json.decode(response.body);

            if (data['success'] != true) {
              debugPrint('Server returned success:false in response');
              return {
                'success': false,
                'message': data['error'] ?? 'Server validation failed',
              };
            }

            // Store the JWT token
            await _storage.write(key: 'auth_token', value: data['token']);

            // Store user data
            if (data['user'] != null) {
              final user = UserModel.fromJson(data['user']);
              await _storage.write(key: 'user_data', value: json.encode(user.toJson()));
            }

            return {
              'success': true,
              'message': 'Google Sign-In successful',
              'token': data['token'],
              'user': data['user']
            };
          } catch (e) {
            debugPrint('Error processing response: $e');
            return {
              'success': false,
              'message': 'Invalid response format: ${e.toString()}',
            };
          }

        case 400:
        case 401:
          try {
            final data = json.decode(response.body);
            return {
              'success': false,
              'message': data['error'] ?? 'Authentication failed',
            };
          } catch (e) {
            return {
              'success': false,
              'message': 'Authentication failed with status ${response.statusCode}',
            };
          }

        default:
          debugPrint('Unexpected response: ${response.body}');
          return {
            'success': false,
            'message': 'Google Sign-In failed with status ${response.statusCode}',
          };
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Helper function to get min value
  int min(int a, int b) => a < b ? a : b;

  // Register new user
  Future<Map<String, dynamic>> register(String email, String password, String? name) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?action=register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      debugPrint('Registration Response Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Registration successful',
          'user': data['user']
        };
      } else {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      debugPrint('Registration Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      debugPrint('Attempting password reset for email: $email');
      debugPrint('Using backend URL: $_baseUrl');

      // First, get CSRF token
      final csrfResponse = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('CSRF Response Status Code: ${csrfResponse.statusCode}');

      // Extract CSRF token from response body
      final csrfData = json.decode(csrfResponse.body);
      final csrfToken = csrfData['csrfToken'];

      if (csrfToken == null) {
        debugPrint('Failed to extract CSRF token');
        return {
          'success': false,
          'message': 'Password reset failed: Could not get CSRF token',
        };
      }

      // For debugging
      debugPrint('CSRF Token received: ${csrfToken.substring(0, 10)}...'); // Just showing first 10 chars for security

      // Perform password reset request
      final resetResponse = await http.post(
        Uri.parse('$_baseUrl?action=reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        body: json.encode({
          'email': email,
          'csrfToken': csrfToken,
        }),
      );

      debugPrint('Password Reset Response Status Code: ${resetResponse.statusCode}');

      // Handle different response scenarios
      switch (resetResponse.statusCode) {
        case 200:
          return {
            'success': true,
            'message': 'Password reset email sent successfully',
          };

        case 404:
          return {
            'success': false,
            'message': 'Email not found',
          };

        case 403:
          return {
            'success': false,
            'message': 'CSRF token validation failed',
          };

        default:
          try {
            final data = json.decode(resetResponse.body);
            return {
              'success': false,
              'message': data['error'] ?? 'Password reset failed',
            };
          } catch (e) {
            return {
              'success': false,
              'message': 'Password reset failed with status ${resetResponse.statusCode}',
            };
          }
      }
    } catch (e) {
      debugPrint('Password Reset Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Logout Method
  Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        await http.post(
          Uri.parse('$_baseUrl?action=logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      debugPrint('Logout attempt failed: $e');
    } finally {
      // Clear stored auth data regardless of server response
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
      await _googleSignIn.signOut();
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      return false;
    }

    // Check if token is expired
    try {
      final bool isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        // Clean up expired token
        await _storage.delete(key: 'auth_token');
        return false;
      }

      // Optionally validate token with server
      final validationResponse = await http.post(
        Uri.parse('$_baseUrl?action=validate-token'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (validationResponse.statusCode == 200) {
        final data = json.decode(validationResponse.body);
        return data['isValid'] == true;
      }

      return false;
    } catch (e) {
      debugPrint('Token validation error: $e');
      return false;
    }
  }

  // Get current user token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: 'user_data');

      if (userData != null) {
        return UserModel.fromJson(json.decode(userData));
      }

      // If user data not found in storage, try to decode from token
      final token = await getToken();

      if (token != null) {
        try {
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          return UserModel(
            id: decodedToken['id'],
            email: decodedToken['email'],
            name: decodedToken['name'],
            username: decodedToken['username'],
            profileImage: decodedToken['image'],
          );
        } catch (e) {
          debugPrint('Error decoding token: $e');
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Helper method to create Authorization header
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }
}