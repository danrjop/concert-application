import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../widgets/app_drawer.dart';
import 'edit_profile_screen.dart';
import 'main_navigation_screen.dart';
import 'memories_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final userProfile = userProfileService.currentUserProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile?.username ?? 'User Name', style: const TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              // TODO: Implement add functionality
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                final mainNavState = context.findAncestorStateOfType<MainNavigationScreenState>();
                mainNavState?.openSidebar();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile section with image and info in a row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              children: [
                // Profile picture and user info in a row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: userProfile?.profilePhotoUrl != null
                          ? AssetImage(userProfile!.profilePhotoUrl!)
                          : const AssetImage('assets/flower.png'),
                    ),
                    
                    const SizedBox(width: 20), // Spacing between image and info
                    
                    // Column with display name and stats
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display name
                          Text(
                            userProfile?.displayName ?? 'Display Name',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Follower stats in a row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Followers
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${userProfile?.followers ?? 100}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const Text('Followers'),
                                ],
                              ),
                              
                              const SizedBox(width: 24), // Spacing between stats
                              
                              // Following
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${userProfile?.following ?? 100}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const Text('Following'),
                                ],
                              ),
                              
                              const SizedBox(width: 24), // Spacing between stats
                              
                              // Rank
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '# ${userProfile?.rank ?? 100}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const Text('Rank'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Edit Profile and Share Profile buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                    
                    const SizedBox(width: 15), // Spacing between buttons
                    
                    // Share Profile Button
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement share profile functionality
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueGrey,
                        side: const BorderSide(color: Colors.blueGrey),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Share Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Been list item
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Been'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              final mainNavState = context.findAncestorStateOfType<MainNavigationScreenState>();
              if (mainNavState != null) {
                mainNavState.navigateToMemoriesWithTab(1); // 1 is the index for Been tab
              }
            },
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Bookmarks list item
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Bookmarks'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              final mainNavState = context.findAncestorStateOfType<MainNavigationScreenState>();
              if (mainNavState != null) {
                mainNavState.navigateToMemoriesWithTab(2); // 2 is the index for Want to go tab
              }
            },
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Add spacing between buttons and tab bar
          const SizedBox(height: 16),
          
          // TabBar and TabBarView for Recent Activity and Taste Profile
          Expanded(
            child: Column(
              children: [
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Recent Activity'),
                    Tab(text: 'Taste Profile'),
                  ],
                ),
                
                // Tab Bar View - Content area
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      // Recent Activity Tab Content
                      Center(
                        child: Text('Recent Activity Content'),
                      ),
                      // Taste Profile Tab Content
                      Center(
                        child: Text('Taste Profile Content'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // No spacer needed since we're using Expanded
          
          // Home indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
