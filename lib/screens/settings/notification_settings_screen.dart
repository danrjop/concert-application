import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _concertNotificationsEnabled = true;
  bool _newFollowersEnabled = true;
  bool _messageNotificationsEnabled = true;
  bool _systemUpdatesEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // General Notification Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'GENERAL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive notifications on your device'),
            value: _pushNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _pushNotificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications_outlined),
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: _emailNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _emailNotificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.email_outlined),
          ),
          const Divider(),

          // Notification Types
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'NOTIFICATION TYPES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Concerts & Events'),
            subtitle: const Text('Updates about concerts and events'),
            value: _concertNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _concertNotificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.event_outlined),
          ),
          SwitchListTile(
            title: const Text('New Followers'),
            subtitle: const Text('When someone follows you'),
            value: _newFollowersEnabled,
            onChanged: (bool value) {
              setState(() {
                _newFollowersEnabled = value;
              });
            },
            secondary: const Icon(Icons.person_add_outlined),
          ),
          SwitchListTile(
            title: const Text('Messages'),
            subtitle: const Text('When you receive new messages'),
            value: _messageNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _messageNotificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.message_outlined),
          ),
          SwitchListTile(
            title: const Text('System Updates'),
            subtitle: const Text('App updates and announcements'),
            value: _systemUpdatesEnabled,
            onChanged: (bool value) {
              setState(() {
                _systemUpdatesEnabled = value;
              });
            },
            secondary: const Icon(Icons.system_update_outlined),
          ),
          const Divider(),

          // Device Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'DEVICE SETTINGS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound with notifications'),
            value: _soundEnabled,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            secondary: const Icon(Icons.volume_up_outlined),
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate with notifications'),
            value: _vibrationEnabled,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
            secondary: const Icon(Icons.vibration_outlined),
          ),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: const Text('Quiet Hours'),
            subtitle: const Text('Set times when notifications are silenced'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to quiet hours settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quiet Hours settings')),
              );
            },
          ),
        ],
      ),
    );
  }
}
