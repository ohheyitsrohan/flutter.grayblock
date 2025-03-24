import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class PostItemWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onCommentTap;

  const PostItemWidget({
    Key? key,
    required this.post,
    required this.onCommentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildPostHeader(context),

          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              post.content,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.text(context), // Use theme colors
                height: 1.4,
              ),
            ),
          ),

          // Post Image (if any)
          if (post.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          // Post Actions
          _buildPostActions(context),
        ],
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return Row(
      children: [
        // User Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            post.user.avatar,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),

        // User Name and Post Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text(context), // Use theme colors
                ),
              ),
              Text(
                post.time,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary(context), // Use theme colors
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(top: 12),
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
          // Like Button
          _buildActionButton(
            context: context,
            icon: Icons.favorite_outline,
            count: post.likes,
            onTap: () {},
          ),

          const SizedBox(width: 24),

          // Comment Button
          _buildActionButton(
            context: context,
            icon: Icons.chat_bubble_outline,
            count: post.comments,
            onTap: onCommentTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.textSecondary(context), // Use theme colors
          ),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context), // Use theme colors
            ),
          ),
        ],
      ),
    );
  }
}