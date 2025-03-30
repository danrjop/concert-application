import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/change_home_city_screen.dart';
import '../utils/image_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final userProfile = userProfileService.currentUserProfile;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Make the entire header area clickable to edit profile or background
          GestureDetector(
            onTap: () {
              _showEditOptions(context, userProfileService);
            },
            child: UserAccountsDrawerHeader(
              accountName: Text(userProfile?.displayName ?? 'User Name'),
              accountEmail: Text(userProfile?.email ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userProfile?.profilePhotoUrl != null
                  ? AssetImage(userProfile!.profilePhotoUrl!)
                  : const AssetImage('assets/flower.png') // Default image
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: userProfile?.backgroundPhotoUrl != null
                  ? DecorationImage(
                      image: AssetImage(userProfile!.backgroundPhotoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: currentIndex == 0 ? Theme.of(context).primaryColor : null,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: currentIndex == 0 ? Theme.of(context).primaryColor : null,
                fontWeight: currentIndex == 0 ? FontWeight.bold : null,
              ),
            ),
            selected: currentIndex == 0,
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Find MainNavigationScreenState and set index to 0 (Home)
              final MainNavigationScreenState? mainNavState = 
                  context.findAncestorStateOfType<MainNavigationScreenState>();
                  
              if (mainNavState != null) {
                mainNavState.onItemTapped(0); // 0 is the index for home tab
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Invitations'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to invitations page
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard_outlined),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to leaderboard page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Goals'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to goals page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to FAQ page
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text('Home City'),
            subtitle: userProfile?.homeCity != null ? Text(userProfile!.homeCity!) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeHomeCityScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.password_outlined),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to privacy policy page
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: currentIndex == 4 ? Theme.of(context).primaryColor : null,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: currentIndex == 4 ? Theme.of(context).primaryColor : null,
                fontWeight: currentIndex == 4 ? FontWeight.bold : null,
              ),
            ),
            selected: currentIndex == 4,
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Find MainNavigationScreenState and set index to 4 (Profile)
              final MainNavigationScreenState? mainNavState = 
                  context.findAncestorStateOfType<MainNavigationScreenState>();
                  
              if (mainNavState != null) {
                mainNavState.onItemTapped(4); // 4 is the index for profile tab
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<AuthService>(context, listen: false).signOut()
                .then((_) => Navigator.pushReplacementNamed(context, '/login'));
            },
          ),
        ],
      ),
    );
  }

  // Method to show edit options
  void _showEditOptions(BuildContext context, UserProfileService userProfileService) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Edit Background'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _showBackgroundOptions(context, userProfileService);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to show background options
  void _showBackgroundOptions(BuildContext context, UserProfileService userProfileService) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Get image from gallery
                  ImageHelper.getImage(context, ImageSource.gallery).then((imagePath) {
                    if (imagePath != null) {
                      userProfileService.updateBackgroundPhoto(imagePath);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Background photo updated')),
                      );
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  // Get image from camera
                  ImageHelper.getImage(context, ImageSource.camera).then((imagePath) {
                    if (imagePath != null) {
                      userProfileService.updateBackgroundPhoto(imagePath);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Background photo updated')),
                      );
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Use Default Color'),
                onTap: () {
                  Navigator.pop(context);
                  // Reset to default color
                  userProfileService.updateBackgroundPhoto(null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Background reset to default color')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
