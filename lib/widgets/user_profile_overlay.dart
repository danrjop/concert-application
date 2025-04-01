import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../services/other_user_profile_service.dart';
import 'user_profile_options_sheet.dart';

class UserProfileOverlay extends StatefulWidget {
  final String userId;
  final Function() onClose;
  
  const UserProfileOverlay({
    Key? key,
    required this.userId,
    required this.onClose,
  }) : super(key: key);
  
  /// Static method to show the user profile overlay
  static void show(BuildContext context, String userId) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return UserProfileOverlay(
          userId: userId,
          onClose: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0), // Transparent barrier
    );
  }

  @override
  _UserProfileOverlayState createState() => _UserProfileOverlayState();
}

class _UserProfileOverlayState extends State<UserProfileOverlay> with SingleTickerProviderStateMixin {
  // Tab controller for Recent Activity and Taste Profile tabs
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Schedule the fetch after the current build is complete
    Future.microtask(() {
      if (mounted) {
        final otherUserService = Provider.of<OtherUserProfileService>(context, listen: false);
        otherUserService.fetchUserProfile(widget.userId);
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to create a properly sized overlay
    final size = MediaQuery.of(context).size;
    
    return Consumer<OtherUserProfileService>(
      builder: (context, otherUserService, child) {
        final userProfile = otherUserService.getUserProfile(widget.userId);
        final isLoading = otherUserService.isLoading;
        
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              // We don't need a semi-transparent background for a full-screen overlay
              
              // Profile overlay content - full screen
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SafeArea(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildProfileContent(context, userProfile),
                  ),
                ),
              ),
              
              // Navigation and action buttons are now part of the profile content
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildProfileContent(BuildContext context, UserProfile? userProfile) {
    if (userProfile == null) {
      return const Center(
        child: Text('User profile not found'),
      );
    }
    
    return Column(
      children: [
        // App bar with user's username
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button on the left
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: widget.onClose,
              ),
              
              // Username in the center
              Expanded(
                child: Center(
                  child: Text(
                    userProfile.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              
              // Share and options buttons on the right
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sharing ${userProfile.username}\'s profile')),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Show the options bottom sheet
                  if (userProfile != null) {
                    UserProfileOptionsSheet.show(
                      context, 
                      userProfile.id ?? 'unknown',
                      userProfile.username,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        
        // Profile section with image and info
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          child: Column(
            children: [
              // Profile picture and user info in a row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userProfile.profilePhotoUrl != null
                        ? AssetImage(userProfile.profilePhotoUrl!)
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
                          userProfile.displayName,
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
                                  '${userProfile.followers}',
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
                                  '${userProfile.following}',
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
                                  '# ${userProfile.rank}',
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
              
              // Bio section, if available
              if (userProfile.bio != null && userProfile.bio!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userProfile.bio!,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Follow and Message buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Follow Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement follow functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Following ${userProfile.username}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Follow'),
                  ),
                  
                  const SizedBox(width: 15), // Spacing between buttons
                  
                  // Message Button
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement messaging functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Messaging ${userProfile.username}')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueGrey,
                      side: const BorderSide(color: Colors.blueGrey),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Message'),
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
          leading: Icon(Icons.check_circle_outline),
          title: const Text('Been'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement navigation to user's Been list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing ${userProfile.username}\'s Been list')),
            );
          },
        ),
        
        // Divider
        const Divider(height: 1, thickness: 1),
        
        // Bookmarks list item
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: const Text('Bookmarks'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement navigation to user's Bookmarks
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing ${userProfile.username}\'s Bookmarks')),
            );
          },
        ),
        
        // Divider
        const Divider(height: 1, thickness: 1),
        
        // Add spacing between buttons and tab bar
        const SizedBox(height: 16),
        
        // TabBar for Recent Activity and Taste Profile
        Expanded(
          child: Column(
            children: [
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
                indicatorColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
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
      ],
    );
  }
}
