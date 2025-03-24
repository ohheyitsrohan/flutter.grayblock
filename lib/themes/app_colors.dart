// lib/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4361EE);
  static const Color secondary = Color(0xFF4CC9F0);
  static const Color danger = Color(0xFFFF5757);

  // Light mode colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF212529);
  static const Color lightTextSecondary = Color(0xFF6C757D);
  static const Color lightDivider = Color(0xFFE9ECEF);
  static const Color lightCard = Colors.white;
  static const Color lightInactiveControl = Color(0xFFE9ECEF);
  static const Color lightModalHandle = Color(0xFFE9ECEF);
  static const Color lightBorder = Color(0xFFCED4DA);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
  static const Color darkTextSecondary = Color(0xFFD1D1D1); // Lighter for better visibility
  static const Color darkDivider = Color(0xFF3D3D3D); // Lighter divider for dark mode
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkInactiveControl = Color(0xFF4D4D4D); // Lighter for better contrast
  static const Color darkModalHandle = Color(0xFF4D4D4D);
  static const Color darkBorder = Color(0xFF5D5D5D); // Lighter border for dark mode

  // Helper method to get colors based on brightness
  static Color getColor(BuildContext context, {
    required Color lightModeColor,
    required Color darkModeColor,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightModeColor : darkModeColor;
  }

  // Commonly used colors with context awareness
  static Color background(BuildContext context) =>
      getColor(context, lightModeColor: lightBackground, darkModeColor: darkBackground);

  static Color surface(BuildContext context) =>
      getColor(context, lightModeColor: lightSurface, darkModeColor: darkSurface);

  static Color text(BuildContext context) =>
      getColor(context, lightModeColor: lightText, darkModeColor: darkText);

  static Color textSecondary(BuildContext context) =>
      getColor(context, lightModeColor: lightTextSecondary, darkModeColor: darkTextSecondary);

  static Color card(BuildContext context) =>
      getColor(context, lightModeColor: lightCard, darkModeColor: darkCard);

  static Color modalHandle(BuildContext context) =>
      getColor(context, lightModeColor: lightModalHandle, darkModeColor: darkModalHandle);

  static Color border(BuildContext context) =>
      getColor(context, lightModeColor: lightBorder, darkModeColor: darkBorder);

  static Color inactiveControl(BuildContext context) =>
      getColor(context, lightModeColor: lightInactiveControl, darkModeColor: darkInactiveControl);

  static Color divider(BuildContext context) =>
      getColor(context, lightModeColor: lightDivider, darkModeColor: darkDivider);

  // Custom opacity versions
  static Color iconBackground(BuildContext context, Color color, {double opacity = 0.1}) {
    return Theme.of(context).brightness == Brightness.dark
        ? color.withOpacity(opacity * 2) // More visible in dark mode
        : color.withOpacity(opacity);
  }
}