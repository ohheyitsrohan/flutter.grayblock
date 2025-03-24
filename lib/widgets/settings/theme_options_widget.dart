// lib/widgets/settings/theme_options_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../themes/app_colors.dart';

class ThemeOptionsWidget extends ConsumerWidget {
  const ThemeOptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final currentTheme = themeState.themeMode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Light theme option
        _buildThemeOption(
          context,
          'light',
          Icons.wb_sunny_outlined,
          'Light',
          currentTheme,
          ref,
        ),

        // Dark theme option
        _buildThemeOption(
          context,
          'dark',
          Icons.nightlight_round,
          'Dark',
          currentTheme,
          ref,
        ),

        // System theme option
        _buildThemeOption(
          context,
          'system',
          Icons.settings_outlined,
          'System',
          currentTheme,
          ref,
        ),
      ],
    );
  }

  Widget _buildThemeOption(BuildContext context, String theme, IconData icon, String label, String currentTheme, WidgetRef ref) {
    final bool isSelected = currentTheme == theme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(themeProvider.notifier).setThemeMode(theme),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border(context),
              width: 1,
            ),
            color: isSelected
                ? AppColors.iconBackground(context, AppColors.primary, opacity: 0.2)
                : Colors.transparent,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}