import 'package:flutter/material.dart';
import '../models/weekly_data.dart';
import '../themes/app_colors.dart'; // Import AppColors

class WeeklyProgressChart extends StatelessWidget {
  final List<WeeklyData> weeklyData;
  final String filterOption;
  final Animation<double> progressAnimation;
  final Animation<double> opacityAnimation;
  final Animation<double> translateAnimation;
  final VoidCallback onFilterTap;

  const WeeklyProgressChart({
    Key? key,
    required this.weeklyData,
    required this.filterOption,
    required this.progressAnimation,
    required this.opacityAnimation,
    required this.translateAnimation,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxHours = WeeklyData.getMaxHours(weeklyData);

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
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text(context), // Use theme color
                      ),
                    ),
                    GestureDetector(
                      onTap: onFilterTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: AppColors.iconBackground(context, AppColors.primary), // Use theme color with helper
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              filterOption,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary, // Use theme color
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
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
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      // Y-axis labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${maxHours.toStringAsFixed(1)}h',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context), // Use theme color
                            ),
                          ),
                          Text(
                            '${(maxHours / 2).toStringAsFixed(1)}h',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context), // Use theme color
                            ),
                          ),
                          Text(
                            '0h',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context), // Use theme color
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Bars
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            weeklyData.length,
                                (index) {
                              final item = weeklyData[index];
                              final double barHeight = item.hours / maxHours;
                              final bool isToday = item.day == "Fri";

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 160,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        height: 160 * barHeight * progressAnimation.value,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: isToday
                                              ? AppColors.primary // Use theme color
                                              : AppColors.primary.withOpacity(0.5), // Lighter version with opacity
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.day,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                      color: isToday
                                          ? AppColors.primary // Use theme color
                                          : AppColors.textSecondary(context), // Use theme color
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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