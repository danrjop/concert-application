import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../constants/app_constants.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOGO',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        // Use theme-aware colors
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                final mainNavState = context.findAncestorStateOfType<MainNavigationScreenState>();
                mainNavState?.openSidebar();
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                // Instead of pushing a new screen, we'll switch to the search tab
                // Get the MainNavigationScreen state and update the selected index
                final MainNavigationScreenState? mainNavState = 
                    context.findAncestorStateOfType<MainNavigationScreenState>();
                    
                if (mainNavState != null) {
                  mainNavState.onItemTapped(1); // 1 is the index for search tab
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppConstants.darkGreyColor 
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                for (int i = 0; i < 6; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: const Text('Label'),
                      backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? AppConstants.darkGreyColor 
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey[800]! 
                            : Colors.grey[300]!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[800]! 
                    : Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppConstants.darkSurfaceColor 
                    : Theme.of(context).cardColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 28),
                      const SizedBox(width: 16),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Feed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TEMPORARY: Button to navigate to user profile demo
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/user_profile_demo');
                  },
                  child: const Text('User Profiles Demo'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                PostCard(
                  username: 'Helena',
                  groupName: 'Group name',
                  timeAgo: '3 min ago',
                  description: 'Post description',
                  likes: 21,
                  comments: 4,
                  userId: 'user1', // Added user ID
                  imageUrl: null,
                ),
                const SizedBox(height: 16),
                PostCard(
                  username: 'Daniel',
                  groupName: 'Group name',
                  timeAgo: '2 hrs ago',
                  description: 'Body text for a post. Since it\'s a social app, sometimes it\'s a hot take, and sometimes it\'s...',
                  likes: 0,
                  comments: 0,
                  userId: 'user2', // Added user ID
                  imageUrl: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
