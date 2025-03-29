import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the current user's name and split it into first and last name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      final userProfile = userProfileService.currentUserProfile;
      if (userProfile != null) {
        final nameParts = userProfile.displayName.split(' ');
        _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
        _lastNameController.text = nameParts.length > 1 
            ? nameParts.sublist(1).join(' ') 
            : '';
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
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
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: UnderlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: UnderlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveName,
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
    );
  }

  void _saveName() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First name cannot be empty')),
      );
      return;
    }

    // Combine first and last name
    final fullName = lastName.isEmpty 
        ? firstName 
        : '$firstName $lastName';

    // Update the user's display name
    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
    userProfileService.updateDisplayName(fullName).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name updated to: $fullName')),
      );
    });
  }
}
