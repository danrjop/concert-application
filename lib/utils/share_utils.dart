import 'package:flutter/material.dart';

class ShareUtils {
  // Share to Instagram
  static void shareToInstagram(BuildContext context, String message) {
    // This would use platform channels to open Instagram
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Share to TikTok
  static void shareToTikTok(BuildContext context, String message) {
    // This would use platform channels to open TikTok
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Share as message
  static void shareAsMessage(BuildContext context, String message) {
    // This would use platform channels to open messaging app
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Share QR code
  static void shareQRCode(BuildContext context, String message) {
    // This would generate and share a QR code
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
