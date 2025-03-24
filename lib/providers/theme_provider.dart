// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme state class
class ThemeState {
  final String themeMode;
  ThemeState({this.themeMode = 'dark'});

  ThemeState copyWith({String? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  bool isDarkMode() {
    if (themeMode == 'system') {
      // Get system brightness
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    }
    return themeMode == 'dark';
  }
}

// Create a provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'Initialize SharedPreferences before accessing it'
  );
});

// Theme state notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  final SharedPreferences _prefs;
  final String key = "theme";

  ThemeNotifier(this._prefs) : super(ThemeState()) {
    _loadFromPrefs();
  }

  _loadFromPrefs() {
    final themeMode = _prefs.getString(key) ?? 'dark';
    state = state.copyWith(themeMode: themeMode);
  }

  _saveToPrefs() {
    _prefs.setString(key, state.themeMode);
  }

  void setThemeMode(String themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _saveToPrefs();
  }
}

// Create a StateNotifierProvider for theme state
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

// Helper provider to directly get whether dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeState = ref.watch(themeProvider);
  return themeState.isDarkMode();
});

// Helper provider to get the ThemeMode enum
final themeModeProvider = Provider<ThemeMode>((ref) {
  final themeState = ref.watch(themeProvider);
  switch (themeState.themeMode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
    default:
      return ThemeMode.dark;
  }
});