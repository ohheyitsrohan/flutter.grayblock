import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class CommentInputWidget extends StatelessWidget {
  final String commentText;
  final Function(String) onCommentTextChanged;
  final VoidCallback onAddComment;
  final bool isReply;

  const CommentInputWidget({
    Key? key,
    required this.commentText,
    required this.onCommentTextChanged,
    required this.onAddComment,
    this.isReply = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.divider(context), // Use theme colors
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://randomuser.me/api/portraits/men/32.jpg',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          // Text Input
          Expanded(
            child: TextField(
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                hintText: isReply ? 'Write a reply...' : 'Write a comment...',
                hintStyle: TextStyle(color: AppColors.textSecondary(context)), // Use theme colors
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 15,
                ),
                filled: true,
                fillColor: AppColors.inactiveControl(context), // Use theme colors
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 14, color: AppColors.text(context)), // Use theme colors
              controller: TextEditingController(text: commentText)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: commentText.length),
                ),
              onChanged: onCommentTextChanged,
            ),
          ),
          const SizedBox(width: 10),

          // Send Button
          GestureDetector(
            onTap: commentText.trim().isNotEmpty ? onAddComment : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: commentText.trim().isNotEmpty
                    ? AppColors.primary // Use theme colors
                    : AppColors.inactiveControl(context), // Use theme colors
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.send,
                size: 20,
                color: commentText.trim().isNotEmpty
                    ? Colors.white
                    : AppColors.textSecondary(context), // Use theme colors
              ),
            ),
          ),
        ],
      ),
    );
  }
}