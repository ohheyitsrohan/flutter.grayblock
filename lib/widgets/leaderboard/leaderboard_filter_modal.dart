// lib/widgets/leaderboard/leaderboard_filter_modal.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class LeaderboardFilterModal extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterSelected;
  final VoidCallback onClose;

  const LeaderboardFilterModal({
    Key? key,
    required this.currentFilter,
    required this.onFilterSelected,
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card(context), // Use theme color
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.modalHandle(context), // Use theme color
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal title
                  Text(
                    'Select Time Range',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter options
                  _buildFilterOption(context, 'allTime', 'All Time'),
                  _buildFilterOption(context, 'monthly', 'Monthly'),
                  _buildFilterOption(context, 'weekly', 'Weekly'),

                  // Close button
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onClose,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.background(context), // Use theme color
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String filter, String label) {
    final bool isSelected = currentFilter == filter;

    return GestureDetector(
      onTap: () => onFilterSelected(filter),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.iconBackground(context, AppColors.primary) : Colors.transparent, // Use theme color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? AppColors.primary : AppColors.text(context), // Use theme color
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