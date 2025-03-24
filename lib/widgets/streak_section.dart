import 'package:flutter/material.dart';
import '../themes/app_colors.dart'; // Import AppColors

class StreakSection extends StatelessWidget {
  final int streakMinutes;
  final int streakGoal;
  final Animation<double> animation;
  final Animation<double> cardAnimation;
  final Animation<double> translateAnimation;

  const StreakSection({
    Key? key,
    required this.streakMinutes,
    required this.streakGoal,
    required this.animation,
    required this.cardAnimation,
    required this.translateAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: cardAnimation.value,
      child: Transform.translate(
        offset: Offset(0, translateAnimation.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // No background color needed here
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.iconBackground(context, AppColors.danger), // Use theme color with helper
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: AppColors.danger, // Use theme color
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Streak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context), // Use theme color
                            ),
                          ),
                          Text(
                            '$streakMinutes/$streakGoal mins',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text(context), // Use theme color
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: animation.value,
                        backgroundColor: AppColors.inactiveControl(context), // Use theme color
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.danger, // Use theme color
                        ),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}