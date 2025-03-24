class CommentReply {
  final String commentId;
  final String userName;

  CommentReply({
    required this.commentId,
    required this.userName,
  });
}

class Reply {
  final String id;
  final String user;
  final String avatar;
  final String text;
  final String time;

  Reply({
    required this.id,
    required this.user,
    required this.avatar,
    required this.text,
    required this.time,
  });
}

class Comment {
  final String id;
  final String user;
  final String avatar;
  final String text;
  final String time;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.user,
    required this.avatar,
    required this.text,
    required this.time,
    required this.replies,
  });

  Comment copyWith({
    String? id,
    String? user,
    String? avatar,
    String? text,
    String? time,
    List<Reply>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      user: user ?? this.user,
      avatar: avatar ?? this.avatar,
      text: text ?? this.text,
      time: time ?? this.time,
      replies: replies ?? this.replies,
    );
  }

  // Mock comment data structure with replies
  static Map<String, List<Comment>> getMockComments() {
    return {
      '1': [
        Comment(
          id: '1-1',
          user: 'Alex Johnson',
          avatar: 'https://randomuser.me/api/portraits/men/55.jpg',
          text: 'This is so inspiring! Keep up the good work!',
          time: '1 hour ago',
          replies: [
            Reply(
                id: '1-1-1',
                user: 'Emma Watson',
                avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
                text: 'Thank you so much! It means a lot.',
                time: '45 minutes ago'
            )
          ],
        ),
        Comment(
          id: '1-2',
          user: 'Sarah Miller',
          avatar: 'https://randomuser.me/api/portraits/women/65.jpg',
          text: 'I need to try this technique too!',
          time: '45 minutes ago',
          replies: [],
        ),
      ],
      '2': [
        Comment(
          id: '2-1',
          user: 'David Wilson',
          avatar: 'https://randomuser.me/api/portraits/men/62.jpg',
          text: 'Count me in for the study group!',
          time: '3 hours ago',
          replies: [],
        ),
      ],
      '3': [],
      '4': [
        Comment(
          id: '4-1',
          user: 'Lisa Wang',
          avatar: 'https://randomuser.me/api/portraits/women/72.jpg',
          text: 'My longest streak was 45 days! It really changed my habits.',
          time: '1 day ago',
          replies: [],
        ),
      ],
      '5': [
        Comment(
          id: '5-1',
          user: 'Thomas Green',
          avatar: 'https://randomuser.me/api/portraits/men/38.jpg',
          text: 'Beautiful shot! Where is this?',
          time: '5 hours ago',
          replies: [
            Reply(
                id: '5-1-1',
                user: 'Jessica Parker',
                avatar: 'https://randomuser.me/api/portraits/women/28.jpg',
                text: 'It\'s a little café called "The Study" downtown. They have the best lattes!',
                time: '4 hours ago'
            ),
          ],
        ),
      ],
      '6': [],
    };
  }
}