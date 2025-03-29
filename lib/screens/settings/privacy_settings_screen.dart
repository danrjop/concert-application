import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  _PrivacySettingsScreenState createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _privateAccount = false;
  bool _locationSharing = true;
  bool _showActivityStatus = true;
  bool _readReceipts = true;
  bool _allowTagging = true;
  bool _showRecentActivity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Account Privacy
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'ACCOUNT PRIVACY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Private Account'),
            subtitle: const Text('Only approved followers can see your content'),
            value: _privateAccount,
            onChanged: (bool value) {
              setState(() {
                _privateAccount = value;
              });
            },
            secondary: const Icon(Icons.lock_outline),
          ),
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('Blocked Accounts'),
            subtitle: const Text('Manage users who cannot see your content'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to blocked accounts
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Blocked Accounts')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: const Text('Hidden Content'),
            subtitle: const Text('Manage content you\'ve hidden'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to hidden content
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hidden Content')),
              );
            },
          ),
          const Divider(),

          // Location Privacy
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'LOCATION PRIVACY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Location Sharing'),
            subtitle: const Text('Show your concert locations on your profile'),
            value: _locationSharing,
            onChanged: (bool value) {
              setState(() {
                _locationSharing = value;
              });
            },
            secondary: const Icon(Icons.location_on_outlined),
          ),
          ListTile(
            leading: const Icon(Icons.location_searching_outlined),
            title: const Text('Location History'),
            subtitle: const Text('Manage your location history data'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to location history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location History')),
              );
            },
          ),
          const Divider(),

          // Interaction Privacy
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'INTERACTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Activity Status'),
            subtitle: const Text('Show when you\'re active in the app'),
            value: _showActivityStatus,
            onChanged: (bool value) {
              setState(() {
                _showActivityStatus = value;
              });
            },
            secondary: const Icon(Icons.access_time_outlined),
          ),
          SwitchListTile(
            title: const Text('Read Receipts'),
            subtitle: const Text('Show others when you\'ve read their messages'),
            value: _readReceipts,
            onChanged: (bool value) {
              setState(() {
                _readReceipts = value;
              });
            },
            secondary: const Icon(Icons.done_all_outlined),
          ),
          SwitchListTile(
            title: const Text('Allow Tagging'),
            subtitle: const Text('Let others tag you in their content'),
            value: _allowTagging,
            onChanged: (bool value) {
              setState(() {
                _allowTagging = value;
              });
            },
            secondary: const Icon(Icons.tag_outlined),
          ),
          SwitchListTile(
            title: const Text('Show Recent Activity'),
            subtitle: const Text('Allow others to see your recent activity'),
            value: _showRecentActivity,
            onChanged: (bool value) {
              setState(() {
                _showRecentActivity = value;
              });
            },
            secondary: const Icon(Icons.history_outlined),
          ),
          const Divider(),

          // Data & Privacy
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'DATA & PRIVACY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Download Your Data'),
            subtitle: const Text('Request a copy of your data'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to data download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download Your Data')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy')),
              );
            },
          ),
        ],
      ),
    );
  }
}
