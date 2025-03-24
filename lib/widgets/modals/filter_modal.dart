import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Fixed import path

class FilterModal extends StatelessWidget {
  final String currentOption;
  final Function(String) onSelect;
  final VoidCallback onClose;

  const FilterModal({
    Key? key,
    required this.currentOption,
    required this.onSelect,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.card(context), // Use theme color
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.modalHandle(context), // Use theme color
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Time Range',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFilterOption(context, 'Last 7 days'),
                  _buildFilterOption(context, 'Last 30 days'),
                  _buildFilterOption(context, 'This month'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onClose,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.background(context), // Use theme color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.border(context), // Use theme color
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: AppColors.text(context), // Use theme color
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String option) {
    final bool isSelected = option == currentOption;

    return GestureDetector(
      onTap: () => onSelect(option),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.iconBackground(context, AppColors.primary) // Use theme helper
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? AppColors.primary // Use theme color
                    : AppColors.text(context), // Use theme color
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColors.primary, // Use theme color
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}