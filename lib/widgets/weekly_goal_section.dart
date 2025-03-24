import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../themes/app_colors.dart'; // Import AppColors

class WeeklyGoalSection extends StatelessWidget {
  final int weeklyGoal;
  final double totalHoursThisWeek;
  final Animation<double> progressAnimation;
  final Animation<double> opacityAnimation;
  final Animation<double> translateAnimation;
  final VoidCallback onEditGoal;

  const WeeklyGoalSection({
    Key? key,
    required this.weeklyGoal,
    required this.totalHoursThisWeek,
    required this.progressAnimation,
    required this.opacityAnimation,
    required this.translateAnimation,
    required this.onEditGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: Transform.translate(
        offset: Offset(0, translateAnimation.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.card(context), // Use theme color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weekly Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text(context), // Use theme color
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditGoal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: AppColors.iconBackground(context, AppColors.primary), // Use theme color with helper
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Edit Goal',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary, // Use theme color
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.edit_outlined,
                              color: AppColors.primary, // Use theme color
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Left side - Circle progress
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 8.0,
                        percent: progressAnimation.value,
                        center: Text(
                          '${(progressAnimation.value * 100).round()}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text(context), // Use theme color
                          ),
                        ),
                        progressColor: AppColors.primary, // Use theme color
                        backgroundColor: AppColors.inactiveControl(context), // Use theme color
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 1500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right side - Goal details
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.background(context), // Use theme color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildGoalDetailRow(context, 'Goal:', '$weeklyGoal hours'),
                            const SizedBox(height: 12),
                            _buildGoalDetailRow(
                              context,
                              'Studied:',
                              '${totalHoursThisWeek.toStringAsFixed(1)} hours',
                            ),
                            const SizedBox(height: 12),
                            _buildGoalDetailRow(
                              context,
                              'Remaining:',
                              '${(weeklyGoal - totalHoursThisWeek).clamp(0.0, double.infinity).toStringAsFixed(1)} hours',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary(context), // Use theme color
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.text(context), // Use theme color
          ),
        ),
      ],
    );
  }
}