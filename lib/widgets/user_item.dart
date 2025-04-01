import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/user_profile_overlay.dart';

class UserItem extends StatelessWidget {
  final String userId;
  final String username;
  final String? photoUrl;
  
  const UserItem({
    Key? key,
    required this.userId,
    required this.username,
    this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showUserProfileOverlay(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            // User avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: photoUrl != null 
                  ? AssetImage(photoUrl!)
                  : const AssetImage('assets/flower.png'),
            ),
            
            const SizedBox(width: 16),
            
            // Username
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            
            const Spacer(),
            
            // Arrow icon
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
  
  void _showUserProfileOverlay(BuildContext context) {
    // Show the overlay using the static method
    UserProfileOverlay.show(context, userId);
  }
}
