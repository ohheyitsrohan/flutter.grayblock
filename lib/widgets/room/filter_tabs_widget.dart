import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class FilterTabsWidget extends StatelessWidget {
  final String activeFilter;
  final Function(String) onFilterChanged;

  const FilterTabsWidget({
    Key? key,
    required this.activeFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildFilterButton(context, 'all', 'All Rooms'),
          const SizedBox(width: 10),
          _buildFilterButton(context, 'my', 'My Rooms'),
          const SizedBox(width: 10),
          _buildFilterButton(context, 'popular', 'Popular'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String filter, String label) {
    final bool isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent, // Use theme color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary(context), // Use theme color
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}