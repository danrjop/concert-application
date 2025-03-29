import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../utils/image_helper.dart';
import 'settings/account_information_screen.dart';
import 'edit_name_screen.dart';
import 'edit_username_screen.dart';
import 'edit_bio_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final userProfile = userProfileService.currentUserProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Picture Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showPhotoOptions(context, 'profile');
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: userProfile?.profilePhotoUrl != null
                            ? AssetImage(userProfile!.profilePhotoUrl!)
                            : const AssetImage('assets/flower.png'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Profile and Background Photo Edit Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Edit Profile Photo text button
              GestureDetector(
                onTap: () {
                  _showPhotoOptions(context, 'profile');
                },
                child: const Text(
                  'Edit Profile Photo',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(width: 20), // Spacing between buttons
              
              // Edit Background button
              GestureDetector(
                onTap: () {
                  _showPhotoOptions(context, 'background');
                },
                child: const Text(
                  'Edit Background',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          
          // Display Name Section
          _buildEditOption(
            context: context,
            title: 'Edit Name',
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditNameScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          // Username Section
          _buildEditOption(
            context: context,
            title: 'Edit Username',
            icon: Icons.alternate_email,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditUsernameScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          // Bio Section
          _buildEditOption(
            context: context,
            title: 'Edit Bio',
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditBioScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          // Account Settings Section
          _buildEditOption(
            context: context,
            title: 'Account Settings',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInformationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showPhotoOptions(BuildContext context, String photoType) {
    String title = photoType == 'profile'
        ? 'Change Profile Photo'
        : 'Change Background Photo';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // This would integrate with image picker in a real app
                  final userProfileService = Provider.of<UserProfileService>(context, listen: false);
                  
                  // Get image from gallery
                  ImageHelper.getImage(context, ImageSource.gallery).then((imagePath) {
                    if (imagePath != null) {
                      if (photoType == 'profile') {
                        userProfileService.updateProfilePhoto(imagePath);
                      } else if (photoType == 'background') {
                        userProfileService.updateBackgroundPhoto(imagePath);
                      }
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$photoType photo updated')),
                      );
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  // This would integrate with camera in a real app
                  final userProfileService = Provider.of<UserProfileService>(context, listen: false);
                  
                  // Get image from camera
                  ImageHelper.getImage(context, ImageSource.camera).then((imagePath) {
                    if (imagePath != null) {
                      if (photoType == 'profile') {
                        userProfileService.updateProfilePhoto(imagePath);
                      } else if (photoType == 'background') {
                        userProfileService.updateBackgroundPhoto(imagePath);
                      }
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$photoType photo updated')),
                      );
                    }
                  });
                },
              ),
              if (photoType == 'profile') // Only show remove option for profile photo
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Current Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    // Remove the profile photo
                    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
                    userProfileService.updateProfilePhoto(null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$photoType photo removed')),
                    );
                  },
                ),
              if (photoType == 'background') // Color option for background
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Use Default Color'),
                  onTap: () {
                    Navigator.pop(context);
                    // Reset to default color
                    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
                    userProfileService.updateBackgroundPhoto(null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Background reset to default color')),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
