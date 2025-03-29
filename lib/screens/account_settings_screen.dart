import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final userProfile = userProfileService.currentUserProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Account Information Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'ACCOUNT INFORMATION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email Address'),
            subtitle: Text(userProfile?.email ?? 'user@example.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeEmailScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const Divider(),

          // Notifications Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Update notification settings
            },
          ),
          const Divider(),

          // Appearance Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'APPEARANCE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
              // TODO: Implement dark mode toggle
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageSelectionDialog(context);
            },
          ),
          const Divider(),

          // Privacy Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'PRIVACY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to privacy policy page
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to terms of service page
            },
          ),
          const Divider(),

          // Account Actions Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'ACCOUNT ACTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Log Out'),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }


  // Dialog for selecting language
  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<String>(
                  title: Text(_languages[index]),
                  value: _languages[index],
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    // TODO: Implement language change logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to: $_selectedLanguage')),
                    );
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog for logging out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('LOG OUT'),
              onPressed: () {
                Navigator.pop(context);
                Provider.of<AuthService>(context, listen: false).signOut()
                  .then((_) => Navigator.pushReplacementNamed(context, '/login'));
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog for deleting account
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // TODO: Implement account deletion logic
                Navigator.pop(context);
                // After deleting the account, navigate to login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
