import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class CreatePostWidget extends StatelessWidget {
  final String postText;
  final Function(String) onPostTextChanged;
  final VoidCallback onPost;

  const CreatePostWidget({
    Key? key,
    required this.postText,
    required this.onPostTextChanged,
    required this.onPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context), // Use theme colors
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://randomuser.me/api/portraits/men/32.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          // Input Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text Input
                TextField(
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(color: AppColors.textSecondary(context)), // Use theme colors
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.text(context), // Use theme colors
                  ),
                  onChanged: onPostTextChanged,
                  controller: TextEditingController(text: postText),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Attach Image Button
                    IconButton(
                      icon: Icon(
                        Icons.image_outlined,
                        color: AppColors.primary, // Use theme colors
                        size: 24,
                      ),
                      onPressed: () {
                        // Image attachment functionality would go here
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    // Post Button
                    TextButton(
                      onPressed: postText.trim().isNotEmpty ? onPost : null,
                      style: TextButton.styleFrom(
                        backgroundColor: postText.trim().isNotEmpty
                            ? AppColors.primary // Use theme colors
                            : AppColors.inactiveControl(context), // Use theme colors
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}