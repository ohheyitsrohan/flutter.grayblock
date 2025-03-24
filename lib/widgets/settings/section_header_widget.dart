// lib/widgets/settings/section_header_widget.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;

  const SectionHeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.text(context), // Use helper for better visibility
        ),
      ),
    );
  }
}