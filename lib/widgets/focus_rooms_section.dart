import 'package:flutter/material.dart';
import '../themes/app_colors.dart'; // Import AppColors

class FocusRoomsSection extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<double> translateAnimation;

  const FocusRoomsSection({
    Key? key,
    required this.opacityAnimation,
    required this.translateAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: Transform.translate(
        offset: Offset(0, translateAnimation.value),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // No background color needed here as it's transparent
            ),
            child: Column(
              children: [
                Text(
                  'Join our focus room to study or work amongst users from across the world',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(context), // Use theme color
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Use theme color
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View All Rooms',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
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