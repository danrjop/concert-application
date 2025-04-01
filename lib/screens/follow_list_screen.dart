import 'package:flutter/material.dart';
import '../widgets/user_item.dart';

class FollowListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> users;
  
  const FollowListScreen({
    Key? key,
    required this.title,
    required this.users,
  }) : super(key: key);

  // Factory constructor for creating a followers screen
  factory FollowListScreen.followers({Key? key}) {
    return FollowListScreen(
      key: key,
      title: 'Followers',
      users: [
        {'id': 'user1', 'username': 'janesmith', 'photoUrl': 'assets/flower.png'},
        {'id': 'user2', 'username': 'johndoe', 'photoUrl': 'assets/flower.png'},
        {'id': 'user3', 'username': 'sarahconnor', 'photoUrl': 'assets/flower.png'},
        {'id': 'user4', 'username': 'michaelscott', 'photoUrl': 'assets/flower.png'},
        {'id': 'user5', 'username': 'pambeesly', 'photoUrl': 'assets/flower.png'},
      ],
    );
  }
  
  // Factory constructor for creating a following screen
  factory FollowListScreen.following({Key? key}) {
    return FollowListScreen(
      key: key,
      title: 'Following',
      users: [
        {'id': 'user2', 'username': 'johndoe', 'photoUrl': 'assets/flower.png'},
        {'id': 'user6', 'username': 'jimhalpert', 'photoUrl': 'assets/flower.png'},
        {'id': 'user7', 'username': 'dwightschrute', 'photoUrl': 'assets/flower.png'},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return UserItem(
            userId: user['id']!,
            username: user['username']!,
            photoUrl: user['photoUrl'],
          );
        },
      ),
    );
  }
}
