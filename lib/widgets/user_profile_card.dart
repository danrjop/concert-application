import 'package:flutter/material.dart';
import '../widgets/user_item.dart';
import '../widgets/user_profile_overlay.dart';

/// A card that displays a user profile and makes it clickable to show the overlay
class UserProfileCard extends StatelessWidget {
  final String userId;
  final String username;
  final String displayName;
  final String? profilePhotoUrl;
  final String? bio;
  
  const UserProfileCard({
    Key? key,
    required this.userId,
    required this.username,
    required this.displayName,
    this.profilePhotoUrl,
    this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Show the user profile overlay using the static method
          UserProfileOverlay.show(context, userId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: profilePhotoUrl != null
                        ? AssetImage(profilePhotoUrl!)
                        : const AssetImage('assets/flower.png'),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Name and username
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '@$username',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icon to indicate it's tappable
                  Icon(
                    Icons.person_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              
              // Bio if available
              if (bio != null && bio!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  bio!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              
              // View profile hint
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Tap to view profile',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
