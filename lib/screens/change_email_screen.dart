import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _currentEmail = '';

  @override
  void initState() {
    super.initState();
    // Get the current user's email
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      final userProfile = userProfileService.currentUserProfile;
      if (userProfile != null) {
        _currentEmail = userProfile.email;
        _emailController.text = _currentEmail;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Current Email:',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  _currentEmail,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email Address',
                  hintText: 'Enter your new email',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  if (value == _currentEmail) {
                    return 'New email must be different from current email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'We will send a verification link to your new email address. You\'ll need to verify it before the change takes effect.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
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
      ),
    );
  }

  void _saveEmail() {
    if (_formKey.currentState!.validate()) {
      final newEmail = _emailController.text.trim();
      
      // In a real app, you would typically:
      // 1. Send a verification email to the new address
      // 2. Update the email only after verification
      
      // For demo purposes, we'll update it directly
      // In a real app, you'd likely show a "verification sent" screen instead
      
      // Update the user's email
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      
      // This method would need to be added to UserProfileService
      // For now, we'll just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification sent to: $newEmail')),
      );
      
      Navigator.pop(context);
    }
  }
}
