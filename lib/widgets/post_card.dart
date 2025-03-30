import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String groupName;
  final String timeAgo;
  final String description;
  final int likes;
  final int comments;
  final String? imageUrl;

  const PostCard({
    super.key,
    required this.username,
    required this.groupName,
    required this.timeAgo,
    required this.description,
    required this.likes,
    required this.comments,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
        color: isDarkMode ? AppConstants.darkSurfaceColor : theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isDarkMode ? AppConstants.darkAccentColor : Colors.grey[300],
                      child: Text(username[0]),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'in $groupName',
                          style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (imageUrl != null)
            Image.asset(
              imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              height: 200,
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 20),
                        const SizedBox(width: 4),
                        Text('$likes likes'),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 20),
                        const SizedBox(width: 4),
                        Text('$comments comments'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
