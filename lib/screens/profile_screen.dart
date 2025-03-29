import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/app_drawer.dart';
import 'main_navigation_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)),
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
          // Profile section with image and stats side by side
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              children: [
                // Display name at the top
                const Text(
                  'Display Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 16),
                
                // Profile picture and stats in row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile picture
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/flower.png'), // Replace with actual image
                    ),
                    
                    // Stats columns
                    Column(
                      children: const [
                        Text(
                          '100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Followers'),
                      ],
                    ),
                    
                    Column(
                      children: const [
                        Text(
                          '100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Following'),
                      ],
                    ),
                    
                    Column(
                      children: const [
                        Text(
                          '# 100',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Rank'),
                      ],
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
                        // TODO: Implement edit profile functionality
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
              // TODO: Navigate to Been page
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
              // TODO: Navigate to Bookmarks page
            },
          ),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
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
