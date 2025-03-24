import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../models/comment_model.dart';
import 'comment_item_widget.dart';
import 'comment_input_widget.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class CommentModalWidget extends StatelessWidget {
  final Post post;
  final List<Comment> comments;
  final String commentText;
  final CommentReply? replyingTo;
  final VoidCallback onClose;
  final Function(String) onCommentTextChanged;
  final VoidCallback onAddComment;
  final Function(String, String) onStartReply;
  final VoidCallback onCancelReply;

  const CommentModalWidget({
    Key? key,
    required this.post,
    required this.comments,
    required this.commentText,
    required this.replyingTo,
    required this.onClose,
    required this.onCommentTextChanged,
    required this.onAddComment,
    required this.onStartReply,
    required this.onCancelReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {}, // Prevent tap through
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context), // Use theme colors
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Modal Header
                _buildModalHeader(context),

                // Comments List
                Expanded(
                  child: comments.isEmpty
                      ? _buildNoCommentsMessage(context)
                      : _buildCommentsList(),
                ),

                // Replying To Indicator
                if (replyingTo != null)
                  _buildReplyingToIndicator(context),

                // Comment Input
                CommentInputWidget(
                  commentText: commentText,
                  onCommentTextChanged: onCommentTextChanged,
                  onAddComment: onAddComment,
                  isReply: replyingTo != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider(context), // Use theme colors
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text(context), // Use theme colors
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Icon(
              Icons.close,
              size: 24,
              color: AppColors.text(context), // Use theme colors
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCommentsMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No comments yet. Be the first to comment!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary(context), // Use theme colors
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentItemWidget(
          comment: comments[index],
          onReply: (commentId, userName) => onStartReply(commentId, userName),
        );
      },
    );
  }

  Widget _buildReplyingToIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.inactiveControl(context), // Use theme colors
        border: Border(
          top: BorderSide(
            color: AppColors.divider(context), // Use theme colors
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary(context), // Use theme colors
              ),
              children: [
                const TextSpan(text: 'Replying to '),
                TextSpan(
                  text: replyingTo?.userName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary, // Use theme colors
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCancelReply,
            child: Icon(
              Icons.close_rounded,
              size: 20,
              color: AppColors.textSecondary(context), // Use theme colors
            ),
          ),
        ],
      ),
    );
  }
}