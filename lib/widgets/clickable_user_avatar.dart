import 'package:flutter/material.dart';
import '../widgets/user_profile_overlay.dart';

/// A clickable user avatar that opens the user profile overlay when tapped
class ClickableUserAvatar extends StatelessWidget {
  final String userId;
  final String? imageUrl;
  final double radius;

  const ClickableUserAvatar({
    Key? key,
    required this.userId,
    this.imageUrl,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UserProfileOverlay.show(context, userId),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl != null
            ? AssetImage(imageUrl!)
            : const AssetImage('assets/flower.png'),
      ),
    );
  }
}
