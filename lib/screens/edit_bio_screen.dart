import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key});

  @override
  _EditBioScreenState createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  final TextEditingController _bioController = TextEditingController();
  final int _maxBioLength = 150;
  int _charactersRemaining = 150;

  @override
  void initState() {
    super.initState();
    // Get the current user's bio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      final userProfile = userProfileService.currentUserProfile;
      if (userProfile != null && userProfile.bio != null) {
        _bioController.text = userProfile.bio!;
        _updateCharactersRemaining();
      }
    });

    // Add a listener to update character count when user types
    _bioController.addListener(_updateCharactersRemaining);
  }

  @override
  void dispose() {
    _bioController.removeListener(_updateCharactersRemaining);
    _bioController.dispose();
    super.dispose();
  }

  void _updateCharactersRemaining() {
    setState(() {
      _charactersRemaining = _maxBioLength - _bioController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bio'),
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
              controller: _bioController,
              decoration: const InputDecoration(
                hintText: 'Tell others about yourself...',
                border: UnderlineInputBorder(),
              ),
              maxLength: _maxBioLength,
              maxLines: 5,
              buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) => Container(),
              textCapitalization: TextCapitalization.sentences,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '$_charactersRemaining characters remaining',
                style: TextStyle(
                  color: _charactersRemaining < 20 ? Colors.red : Colors.grey,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveBio,
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

  void _saveBio() {
    final bio = _bioController.text.trim();
    
    // Update the user's bio
    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
    userProfileService.updateBio(bio).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bio updated successfully')),
      );
    });
  }
}
