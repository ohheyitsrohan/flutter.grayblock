import 'package:flutter/material.dart';
import '../themes/app_colors.dart'; // Import AppColors

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;
  final String subtext;
  final double cardWidth;
  final Animation<double> opacityAnimation;
  final Animation<double> translateAnimation;
  final VoidCallback? onTap; // Add onTap callback

  const InfoCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
    required this.subtext,
    required this.cardWidth,
    required this.opacityAnimation,
    required this.translateAnimation,
    this.onTap, // Optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the callback if provided
      child: Opacity(
        opacity: opacityAnimation.value,
        child: Transform.translate(
          offset: Offset(0, translateAnimation.value),
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 15.0),
            padding: const EdgeInsets.all(16.0),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: iconBackground,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary(context), // Use theme color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text(context), // Use theme color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtext,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context), // Use theme color
                        ),
                      ),
                    ],
                  ),
                ),
                // Add chevron icon for navigable cards
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.border(context), // Use theme color
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}