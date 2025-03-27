import 'package:flutter/material.dart';

class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://mqrktkviabljvjktpaox.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xcmt0a3ZpYWJsanZqa3RwYW94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5NTEzNDUsImV4cCI6MjA1ODUyNzM0NX0.ntNWeUCWepaILWS_Tt96ygxKmhkjHY67vL8VQv0VDNQ';
  
  // Theme Colors
  static const Color primaryColor = Colors.blueGrey;
  static const Color secondaryColor = Color(0xFF90A4AE);
  static const Color accentColor = Color(0xFF607D8B);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color lightGrey = Color(0xFFEEEEEE);
  
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
