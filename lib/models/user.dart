class User {
  final String id;
  final String username;
  final String displayName;
  final String? profileImageUrl;
  final int followersCount;
  final int followingCount;
  final int rank;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.profileImageUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.rank = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      displayName: json['display_name'] ?? json['username'],
      profileImageUrl: json['profile_image_url'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'profile_image_url': profileImageUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'rank': rank,
    };
  }
}
