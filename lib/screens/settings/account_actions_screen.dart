import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class AccountActionsScreen extends StatelessWidget {
  const AccountActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Actions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Account Status
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'ACCOUNT STATUS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: const Text('Account Status'),
            subtitle: const Text('Active'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const Divider(),

          // Temporary Actions
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'TEMPORARY ACTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Pause Account'),
            subtitle: const Text('Temporarily hide your account'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to pause account
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pause Account')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.offline_bolt_outlined),
            title: const Text('Take a Break'),
            subtitle: const Text('Turn off notifications for a set period'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to take a break
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Take a Break')),
              );
            },
          ),
          const Divider(),

          // Permanent Actions
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'PERMANENT ACTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orange),
            title: const Text('Reset Account',
                style: TextStyle(color: Colors.orange)),
            subtitle: const Text('Reset your account to default settings'),
            onTap: () {
              _showResetAccountDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title:
                const Text('Delete Account', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Permanently delete your account'),
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
          const Divider(),

          // Log Out
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'SESSION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.devices_outlined),
            title: const Text('Manage Devices'),
            subtitle: const Text('View and manage logged in devices'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to manage devices
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Manage Devices')),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showResetAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Account'),
          content: const Text(
              'Are you sure you want to reset your account? This will reset all your settings but keep your data.'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('RESET', style: TextStyle(color: Colors.orange)),
              onPressed: () {
                // TODO: Implement account reset logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account has been reset')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Log out user
              Provider.of<AuthService>(context, listen: false).signOut().then(
                  (_) => Navigator.pushReplacementNamed(context, '/login'));
            },
            child: const Text('LOG OUT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
