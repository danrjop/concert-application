import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  _AppearanceSettingsScreenState createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Default';
  String _selectedFontSize = 'Medium';
  
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];
  final List<String> _themes = ['Default', 'Dark', 'Light', 'Blue', 'Purple'];
  final List<String> _fontSizes = ['Small', 'Medium', 'Large', 'Extra Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Theme Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'THEME',
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
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Theme'),
            subtitle: Text(_selectedTheme),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSelectionDialog(
                context,
                'Select Theme',
                _themes,
                _selectedTheme,
                (value) {
                  setState(() {
                    _selectedTheme = value;
                  });
                  // TODO: Implement theme change
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Theme changed to: $value')),
                  );
                },
              );
            },
          ),
          const Divider(),

          // Language Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'LANGUAGE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSelectionDialog(
                context,
                'Select Language',
                _languages,
                _selectedLanguage,
                (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  // TODO: Implement language change
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Language changed to: $value')),
                  );
                },
              );
            },
          ),
          const Divider(),

          // Text Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'TEXT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Font Size'),
            subtitle: Text(_selectedFontSize),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSelectionDialog(
                context,
                'Select Font Size',
                _fontSizes,
                _selectedFontSize,
                (value) {
                  setState(() {
                    _selectedFontSize = value;
                  });
                  // TODO: Implement font size change
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Font size changed to: $value')),
                  );
                },
              );
            },
          ),
          const Divider(),

          // Interface Settings
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'INTERFACE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_customize_outlined),
            title: const Text('Home Screen Layout'),
            subtitle: const Text('Customize your home screen'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to home screen layout settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home Screen Layout settings')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_agenda_outlined),
            title: const Text('List View Style'),
            subtitle: const Text('Compact or expanded view'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to list view style settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('List View Style settings')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(
    BuildContext context,
    String title,
    List<String> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<String>(
                  title: Text(options[index]),
                  value: options[index],
                  groupValue: currentValue,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    if (value != null) {
                      onChanged(value);
                    }
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
}
