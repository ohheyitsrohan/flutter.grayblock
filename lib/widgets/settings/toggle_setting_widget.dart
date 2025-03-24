// lib/widgets/settings/toggle_setting_widget.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class ToggleSettingWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final Function(bool) onChanged;

  const ToggleSettingWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider(context), // Use the new helper
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text(context), // For dark mode visibility
                  ),
                ),
                if (description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary(context), // Updated for visibility
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Toggle switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.inactiveControl(context),
          ),
        ],
      ),
    );
  }
}