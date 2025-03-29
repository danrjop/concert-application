class UserProfile {
  String? id;
  String displayName;
  String username;
  String email;
  String? bio;
  String? profilePhotoUrl;
  String? backgroundPhotoUrl;
  int followers;
  int following;
  int rank;

  UserProfile({
    this.id,
    required this.displayName,
    required this.username,
    required this.email,
    this.bio,
    this.profilePhotoUrl,
    this.backgroundPhotoUrl,
    this.followers = 0,
    this.following = 0,
    this.rank = 0,
  });

  // Create a copy of the current user profile with updated fields
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? username,
    String? email,
    String? bio,
    String? profilePhotoUrl,
    String? backgroundPhotoUrl,
    int? followers,
    int? following,
    int? rank,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      backgroundPhotoUrl: backgroundPhotoUrl ?? this.backgroundPhotoUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      rank: rank ?? this.rank,
    );
  }

  // Convert user profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'username': username,
      'email': email,
      'bio': bio,
      'profilePhotoUrl': profilePhotoUrl,
      'backgroundPhotoUrl': backgroundPhotoUrl,
      'followers': followers,
      'following': following,
      'rank': rank,
    };
  }

  // Create user profile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      displayName: json['displayName'] ?? 'Default Name',
      username: json['username'] ?? 'default_username',
      email: json['email'] ?? 'user@example.com',
      bio: json['bio'],
      profilePhotoUrl: json['profilePhotoUrl'],
      backgroundPhotoUrl: json['backgroundPhotoUrl'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }
}
