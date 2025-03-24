import 'package:flutter/material.dart';
import '../themes/app_colors.dart'; // Import AppColors

class SessionStatsWidget extends StatelessWidget {
  final int sessionsCompleted;
  final String avgSessionTime;
  final Animation<double> opacityAnimation;
  final Animation<double> translateAnimation;

  const SessionStatsWidget({
    Key? key,
    required this.sessionsCompleted,
    required this.avgSessionTime,
    required this.opacityAnimation,
    required this.translateAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          // Sessions Completed Card
          Expanded(
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(0, translateAnimation.value),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: AppColors.card(context), // Use theme color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          // Use icon background with primary color
                          color: AppColors.iconBackground(context, AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: AppColors.primary, // Use theme color
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$sessionsCompleted',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text(context), // Use theme color
                            ),
                          ),
                          Text(
                            'Sessions',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary(context), // Use theme color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Average Session Time Card
          Expanded(
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(0, translateAnimation.value),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: AppColors.card(context), // Use theme color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          // Use icon background with primary color
                          color: AppColors.iconBackground(context, AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.timer_outlined,
                          color: AppColors.primary, // Use theme color
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            avgSessionTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text(context), // Use theme color
                            ),
                          ),
                          Text(
                            'Avg Session',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary(context), // Use theme color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}