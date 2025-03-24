import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_outlined,
            size: 50,
            color: AppColors.textSecondary(context), // Use theme color
          ),
          const SizedBox(height: 15),
          Text(
            'No rooms found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text(context), // Use theme color
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary(context), // Use theme color
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}