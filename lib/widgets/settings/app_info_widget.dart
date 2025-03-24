// lib/widgets/settings/app_info_widget.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Navigate to Terms of Service
                print('Terms of Service pressed');
              },
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Navigate to Privacy Policy
                print('Privacy Policy pressed');
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}