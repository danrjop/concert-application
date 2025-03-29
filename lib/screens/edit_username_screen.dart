import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  _EditUsernameScreenState createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isUsernameAvailable = false;
  bool _isCheckingUsername = false;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    // Get the current user's username
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      final userProfile = userProfileService.currentUserProfile;
      if (userProfile != null) {
        _currentUsername = userProfile.username;
        _usernameController.text = _currentUsername;
        // Initially, the current username is considered available
        _isUsernameAvailable = true;
      }
    });

    // Add a listener to check username availability when user types
    _usernameController.addListener(_checkUsernameAvailability);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_checkUsernameAvailability);
    _usernameController.dispose();
    super.dispose();
  }

  // This method would normally call an API to check if the username is available
  // For demo purposes, we'll simulate a check
  void _checkUsernameAvailability() {
    final username = _usernameController.text.trim();
    
    // Don't check if the username is the same as the current one
    if (username == _currentUsername) {
      setState(() {
        _isUsernameAvailable = true;
        _isCheckingUsername = false;
      });
      return;
    }

    // Don't check empty usernames
    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = false;
        _isCheckingUsername = false;
      });
      return;
    }

    // Simulate checking username
    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = false;
    });

    // Simulate an API call with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
          // For demo, we'll say any username not equal to 'taken' is available
          _isUsernameAvailable = username != 'taken';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Username'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  '@',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: const UnderlineInputBorder(),
                      suffixIcon: _isCheckingUsername
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            )
                          : _usernameController.text.isNotEmpty
                              ? Icon(
                                  _isUsernameAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _isUsernameAvailable
                                      ? Colors.green
                                      : Colors.red,
                                )
                              : null,
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Choose a username that others can use to find you. You can change it anytime.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isUsernameAvailable && !_isCheckingUsername
                  ? _saveUsername
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Save'),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  void _saveUsername() {
    final username = _usernameController.text.trim();
    
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty')),
      );
      return;
    }

    // Update the user's username
    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
    userProfileService.updateUsername(username).then((_) {
      _currentUsername = username; // Update the current username
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username updated to: @$username')),
      );
    });
  }
}
