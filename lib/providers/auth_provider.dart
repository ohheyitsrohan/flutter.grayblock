import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth state class
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Create a Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    state = state.copyWith(isLoading: true);

    try {
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _authService.loginWithEmail(email, password);

      if (result['success']) {
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result['message'],
        );
      }

      return result;
    } catch (e) {
      debugPrint('Login error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );

      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String? name) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _authService.register(email, password, name);

      state = state.copyWith(isLoading: false);

      return result;
    } catch (e) {
      debugPrint('Registration error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );

      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _authService.resetPassword(email);

      state = state.copyWith(isLoading: false);

      return result;
    } catch (e) {
      debugPrint('Password reset error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );

      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();

      state = state.copyWith(
        isAuthenticated: false,
        user: null,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Map<String, dynamic>> googleSignIn() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _authService.signInWithGoogle();

      if (result['success']) {
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }

      return result;
    } catch (e) {
      debugPrint('Google Sign In error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );

      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    return await _authService.getAuthHeaders();
  }
}

// Create a StateNotifierProvider for auth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});