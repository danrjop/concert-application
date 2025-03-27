class Post {
  final String id;
  final String userId;
  final String username;
  final String? groupId;
  final String? groupName;
  final String description;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final String? imageUrl;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    this.groupId,
    this.groupName,
    required this.description,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      groupId: json['group_id'],
      groupName: json['group_name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'group_id': groupId,
      'group_name': groupName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'image_url': imageUrl,
    };
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hrs ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}
