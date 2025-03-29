import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/main_navigation_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('User Name'),
            accountEmail: const Text('user@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/flower.png'), // Replace with actual profile image
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            onDetailsPressed: () {
              // Close the drawer
              Navigator.pop(context);

              // Navigate to profile
              final MainNavigationScreenState? mainNavState = 
                  context.findAncestorStateOfType<MainNavigationScreenState>();
                  
              if (mainNavState != null) {
                mainNavState.onItemTapped(4); // 4 is the index for profile tab
              }
            },
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
              // TODO: Navigate to settings page
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
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to home city page
            },
          ),
          ListTile(
            leading: const Icon(Icons.password_outlined),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to change password page
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
}
