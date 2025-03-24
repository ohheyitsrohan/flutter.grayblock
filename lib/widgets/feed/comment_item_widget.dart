import 'package:flutter/material.dart';
import '../../models/comment_model.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class CommentItemWidget extends StatelessWidget {
  final Comment comment;
  final Function(String, String) onReply;

  const CommentItemWidget({
    Key? key,
    required this.comment,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Comment
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                comment.avatar,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Comment Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment Bubble
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.inactiveControl(context), // Use theme colors
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.user,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.text(context), // Use theme colors
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text(context), // Use theme colors
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary(context), // Use theme colors
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reply Button
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4),
                    child: GestureDetector(
                      onTap: () => onReply(comment.id, comment.user),
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary, // Use theme colors
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Replies
        if (comment.replies.isNotEmpty)
          _buildReplies(context),

        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildReplies(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 46, top: 8),
      child: Column(
        children: comment.replies.map((reply) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply User Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    reply.avatar,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),

                // Reply Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.inactiveControl(context), // Use theme colors
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply.user,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.text(context), // Use theme colors
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reply.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text(context), // Use theme colors
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reply.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary(context), // Use theme colors
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}