import 'package:flutter/material.dart';

class UserProfileOptionsSheet extends StatelessWidget {
  final String userId;
  final String username;
  final bool isFollowing;

  const UserProfileOptionsSheet({
    Key? key,
    required this.userId,
    required this.username,
    this.isFollowing = true, // Default to true for demo purposes
  }) : super(key: key);

  /// Static method to show the options bottom sheet
  static void show(BuildContext context, String userId, String username, {bool isFollowing = true}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return UserProfileOptionsSheet(
          userId: userId,
          username: username,
          isFollowing: isFollowing,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sheet handle indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Profile info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: const AssetImage('assets/flower.png'),
                ),
                const SizedBox(width: 16),
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          
          // Unfollow option (shown only if following)
          if (isFollowing)
            ListTile(
              leading: const Icon(Icons.person_remove_outlined),
              title: const Text('Unfollow'),
              onTap: () {
                // Handle unfollow
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unfollowed $username')),
                );
                Navigator.pop(context);
              },
            ),
          
          // Remove follower option (assuming they follow you)
          ListTile(
            leading: const Icon(Icons.remove_circle_outline),
            title: const Text('Remove follower'),
            onTap: () {
              // Handle remove follower
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed $username as a follower')),
              );
              Navigator.pop(context);
            },
          ),
          
          // Mute option
          ListTile(
            leading: const Icon(Icons.volume_off_outlined),
            title: const Text('Mute'),
            onTap: () {
              // Handle mute
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Muted $username')),
              );
              Navigator.pop(context);
            },
          ),
          
          // Block option
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: Text(
              'Block',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              // Show confirmation dialog before blocking
              _showBlockConfirmationDialog(context);
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Block User'),
          content: Text(
            'Are you sure you want to block $username? They will not be able to find your profile, posts, or contact you.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Handle block
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Blocked $username')),
                );
              },
              child: Text(
                'BLOCK',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
