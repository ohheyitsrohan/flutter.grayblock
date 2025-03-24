import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class SearchBarWidget extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.card(context), // Use theme color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            // Search Icon
            Icon(
              Icons.search_outlined,
              color: AppColors.textSecondary(context), // Use theme color
              size: 20,
            ),
            const SizedBox(width: 10),

            // Text Input
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search rooms or topics...',
                  hintStyle: TextStyle(color: AppColors.textSecondary(context).withOpacity(0.7)), // Use theme color
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.text(context), // Use theme color
                ),
                onChanged: onSearchChanged,
                controller: TextEditingController(text: searchQuery)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: searchQuery.length),
                  ),
              ),
            ),

            // Clear Button (shown only when there's text)
            if (searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => onSearchChanged(''),
                child: Icon(
                  Icons.close,
                  color: AppColors.textSecondary(context), // Use theme color
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}