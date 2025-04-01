import 'package:flutter/material.dart';
import '../widgets/user_profile_card.dart';

class UserProfileDemoScreen extends StatelessWidget {
  const UserProfileDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People You May Know'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          // Example user profiles
          UserProfileCard(
            userId: 'user1',
            username: 'janesmith',
            displayName: 'Jane Smith',
            profilePhotoUrl: 'assets/flower.png',
            bio: 'Music lover and concert enthusiast',
          ),
          
          UserProfileCard(
            userId: 'user2',
            username: 'johndoe',
            displayName: 'John Doe',
            profilePhotoUrl: 'assets/flower.png',
            bio: 'Rock and jazz fan. I travel for good music!',
          ),
          
          UserProfileCard(
            userId: 'user3',
            username: 'sarahconnor',
            displayName: 'Sarah Connor',
            profilePhotoUrl: 'assets/flower.png',
            bio: 'EDM enthusiast and festival goer',
          ),
          
          UserProfileCard(
            userId: 'user4',
            username: 'michaelscott',
            displayName: 'Michael Scott',
            profilePhotoUrl: 'assets/flower.png',
            bio: 'That\'s what she said!',
          ),
        ],
      ),
    );
  }
}
