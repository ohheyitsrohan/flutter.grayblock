import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../widgets/feed/create_post_widget.dart';
import '../widgets/feed/post_item_widget.dart';
import '../widgets/feed/comment_modal_widget.dart';
import '../themes/app_colors.dart'; // Import AppColors

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String postText = '';
  bool commentModalVisible = false;
  Post? selectedPost;
  String commentText = '';
  CommentReply? replyingTo;

  late List<Post> posts;
  late Map<String, List<Comment>> comments;

  @override
  void initState() {
    super.initState();
    // Initialize data
    posts = Post.getMockPosts();
    comments = Comment.getMockComments();
  }

  void openCommentModal(Post post) {
    setState(() {
      selectedPost = post;
      commentModalVisible = true;
      replyingTo = null;
    });
  }

  void closeCommentModal() {
    setState(() {
      commentModalVisible = false;
      selectedPost = null;
      commentText = '';
      replyingTo = null;
    });
  }

  void startReply(String commentId, String userName) {
    setState(() {
      replyingTo = CommentReply(commentId: commentId, userName: userName);
      commentText = '@$userName ';
    });
  }

  void cancelReply() {
    setState(() {
      replyingTo = null;
      commentText = '';
    });
  }

  void updateCommentText(String text) {
    setState(() {
      commentText = text;
    });
  }

  void addComment() {
    if (commentText.trim().isEmpty || selectedPost == null) return;

    if (replyingTo != null) {
      // Add reply to a comment
      final Reply newReply = Reply(
          id: '${replyingTo!.commentId}-${DateTime.now().millisecondsSinceEpoch}',
          user: 'You',
          avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
          text: commentText.replaceFirst('@${replyingTo!.userName} ', ''),
          time: 'Just now'
      );

      setState(() {
        final postId = selectedPost!.id;
        final postComments = List<Comment>.from(comments[postId] ?? []);

        // Find the comment to reply to
        final commentIndex = postComments.indexWhere((comment) => comment.id == replyingTo!.commentId);
        if (commentIndex != -1) {
          // Add reply to the comment
          final updatedReplies = List<Reply>.from(postComments[commentIndex].replies);
          updatedReplies.add(newReply);

          postComments[commentIndex] = postComments[commentIndex].copyWith(
              replies: updatedReplies
          );

          comments[postId] = postComments;
        }
      });
    } else {
      // Add a new top-level comment
      final Comment newComment = Comment(
          id: '${selectedPost!.id}-${DateTime.now().millisecondsSinceEpoch}',
          user: 'You',
          avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
          text: commentText,
          time: 'Just now',
          replies: []
      );

      setState(() {
        final postId = selectedPost!.id;
        comments[postId] = [...(comments[postId] ?? []), newComment];

        // Update comment count in the post
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex] = posts[postIndex].copyWith(
              comments: posts[postIndex].comments + 1
          );
        }
      });
    }

    setState(() {
      commentText = '';
      replyingTo = null;
    });
  }

  void updatePostText(String text) {
    setState(() {
      postText = text;
    });
  }

  void createPost() {
    if (postText.trim().isEmpty) return;

    final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user: PostUser(
          name: 'You',
          avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        ),
        content: postText,
        time: 'Just now',
        likes: 0,
        comments: 0
    );

    setState(() {
      posts = [newPost, ...posts];
      postText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context), // Use theme colors
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme colors
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Post Creation Widget
                  CreatePostWidget(
                    postText: postText,
                    onPostTextChanged: updatePostText,
                    onPost: createPost,
                  ),

                  // Posts List
                  ...posts.map((post) => PostItemWidget(
                    post: post,
                    onCommentTap: () => openCommentModal(post),
                  )).toList(),
                ],
              ),
            ),

            // Comment Modal
            if (commentModalVisible && selectedPost != null)
              CommentModalWidget(
                post: selectedPost!,
                comments: comments[selectedPost!.id] ?? [],
                commentText: commentText,
                replyingTo: replyingTo,
                onClose: closeCommentModal,
                onCommentTextChanged: updateCommentText,
                onAddComment: addComment,
                onStartReply: startReply,
                onCancelReply: cancelReply,
              ),
          ],
        ),
      ),
    );
  }
}