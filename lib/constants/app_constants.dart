import 'package:flutter/material.dart';

class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://mqrktkviabljvjktpaox.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xcmt0a3ZpYWJsanZqa3RwYW94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5NTEzNDUsImV4cCI6MjA1ODUyNzM0NX0.ntNWeUCWepaILWS_Tt96ygxKmhkjHY67vL8VQv0VDNQ';
  
  // Light Theme Colors
  static const Color primaryColor = Colors.blueGrey;
  static const Color secondaryColor = Color(0xFF90A4AE);
  static const Color accentColor = Color(0xFF607D8B);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color lightGrey = Color(0xFFEEEEEE);
  
  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF455A64); // Darker blueGrey
  static const Color darkSecondaryColor = Color(0xFF546E7A); // Darker version of secondaryColor
  static const Color darkAccentColor = Color(0xFF78909C); // Lighter for contrast in dark theme
  static const Color darkBackgroundColor = Color(0xFF121212); // Material dark background
  static const Color darkSurfaceColor = Color(0xFF1E1E1E); // Slightly lighter than background for cards
  static const Color darkTextColor = Colors.white;
  static const Color darkGreyColor = Color(0xFF333333); // For subtle differences in dark theme
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.bold
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.w500
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16
  );
  
  // Border Radius
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(10);
  static final BorderRadius roundedBorderRadius = BorderRadius.circular(20);
  
  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  
  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
