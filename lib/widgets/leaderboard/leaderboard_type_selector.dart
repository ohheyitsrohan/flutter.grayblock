// lib/widgets/leaderboard/leaderboard_type_selector.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class LeaderboardTypeSelector extends StatelessWidget {
  final String currentType;
  final Function(String) onTypeSelected;

  const LeaderboardTypeSelector({
    Key? key,
    required this.currentType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          // Study Hours button
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeSelected('studyHours'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentType == 'studyHours'
                      ? AppColors.primary // Use theme color
                      : AppColors.inactiveControl(context), // Use theme color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: currentType == 'studyHours'
                          ? Colors.white
                          : AppColors.textSecondary(context), // Use theme color
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Study Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currentType == 'studyHours'
                            ? Colors.white
                            : AppColors.textSecondary(context), // Use theme color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Streak Days button
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeSelected('streakDays'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentType == 'streakDays'
                      ? AppColors.primary // Use theme color
                      : AppColors.inactiveControl(context), // Use theme color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: currentType == 'streakDays'
                          ? Colors.white
                          : AppColors.textSecondary(context), // Use theme color
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Streak Days',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currentType == 'streakDays'
                            ? Colors.white
                            : AppColors.textSecondary(context), // Use theme color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}