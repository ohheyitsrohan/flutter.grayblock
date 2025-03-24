class PostUser {
  final String name;
  final String avatar;

  PostUser({
    required this.name,
    required this.avatar,
  });
}

class Post {
  final String id;
  final PostUser user;
  final String content;
  final String? image;
  final String time;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.user,
    required this.content,
    this.image,
    required this.time,
    required this.likes,
    required this.comments,
  });

  Post copyWith({
    String? id,
    PostUser? user,
    String? content,
    String? image,
    String? time,
    int? likes,
    int? comments,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      image: image ?? this.image,
      time: time ?? this.time,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  // Mock data for posts
  static List<Post> getMockPosts() {
    return [
      Post(
        id: '1',
        user: PostUser(
          name: 'Emma Watson',
          avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
        ),
        content: 'Just finished a 3-hour study session on quantum mechanics. My brain is fried but it feels so good to make progress! 📚✨',
        time: '2 hours ago',
        likes: 24,
        comments: 2,
      ),
      Post(
        id: '2',
        user: PostUser(
          name: 'James Rodriguez',
          avatar: 'https://randomuser.me/api/portraits/men/42.jpg',
        ),
        content: 'Looking for study partners for the upcoming calculus exam. Anyone interested in joining a virtual study group this weekend?',
        time: '5 hours ago',
        likes: 18,
        comments: 1,
      ),
      Post(
        id: '3',
        user: PostUser(
          name: 'Sophia Chen',
          avatar: 'https://randomuser.me/api/portraits/women/33.jpg',
        ),
        content: 'I\'ve been using the Pomodoro technique for the past week and my productivity has skyrocketed! 25 minutes of focused work followed by a 5-minute break is the perfect rhythm for me. Highly recommend trying it out if you struggle with staying focused.',
        time: '1 day ago',
        likes: 42,
        comments: 0,
      ),
      Post(
        id: '4',
        user: PostUser(
          name: 'Michael Brown',
          avatar: 'https://randomuser.me/api/portraits/men/22.jpg',
        ),
        content: 'Just hit a 30-day study streak! Consistency really is key. What are your longest study streaks?',
        time: '2 days ago',
        likes: 56,
        comments: 1,
      ),
      Post(
        id: '5',
        user: PostUser(
          name: 'Jessica Parker',
          avatar: 'https://randomuser.me/api/portraits/women/28.jpg',
        ),
        content: 'Found this perfect study spot today! The view is incredible and the coffee is amazing. ☕',
        image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2FmZSUyMHN0dWR5fGVufDB8fDB8fA%3D%3D&w=1000&q=80',
        time: '6 hours ago',
        likes: 89,
        comments: 1,
      ),
      Post(
        id: '6',
        user: PostUser(
          name: 'Ryan Thompson',
          avatar: 'https://randomuser.me/api/portraits/men/67.jpg',
        ),
        content: 'My study setup for finals week. Ready to crush these exams! 💪',
        image: 'https://images.unsplash.com/photo-1598499073513-5b6a22d9e9cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
        time: '1 day ago',
        likes: 72,
        comments: 0,
      ),
    ];
  }
}