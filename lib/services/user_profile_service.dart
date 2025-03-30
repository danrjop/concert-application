import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/city.dart';

class UserProfileService extends ChangeNotifier {
  UserProfile? _currentUserProfile;
  
  // Constructor to initialize the service
  UserProfileService() {
    _loadUserProfile();
  }
  
  // Load user profile from SharedPreferences
  Future<void> _loadUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userProfileJson = prefs.getString('userProfile');
      
      if (userProfileJson != null) {
        // Load profile from shared preferences
        _currentUserProfile = UserProfile.fromJson(json.decode(userProfileJson));
      } else {
        // Initialize with default values if no saved profile exists
        _currentUserProfile = UserProfile(
          id: 'user123',
          displayName: 'Display Name',
          username: 'username',
          email: 'user@example.com',
          bio: 'This is my bio.',
          followers: 100,
          following: 100,
          rank: 100,
        );
        // Save the default profile
        _saveUserProfile();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }
  
  // Save user profile to SharedPreferences
  Future<void> _saveUserProfile() async {
    try {
      if (_currentUserProfile != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userProfile', json.encode(_currentUserProfile!.toJson()));
      }
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  // Get current user profile
  UserProfile? get currentUserProfile => _currentUserProfile;

  // Update profile photo
  Future<void> updateProfilePhoto(String? photoUrl) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        profilePhotoUrl: photoUrl,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Update background photo
  Future<void> updateBackgroundPhoto(String? photoUrl) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        backgroundPhotoUrl: photoUrl,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Update display name
  Future<void> updateDisplayName(String displayName) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        displayName: displayName,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Update username
  Future<void> updateUsername(String username) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        username: username,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Update bio
  Future<void> updateBio(String bio) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        bio: bio,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Legacy method for updating just the city name
  Future<void> updateHomeCity(String homeCity) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        homeCityName: homeCity,
        homeCityDisplay: homeCity,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }
  
  // Update home city with a City object
  Future<void> updateHomeCityWithObject(City city) async {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        homeCityId: city.id,
        homeCityName: city.name,
        homeCityDisplay: city.displayName,
      );
      notifyListeners();
      _saveUserProfile(); // Save changes to shared preferences
    }
  }

  // Update all profile fields
  Future<void> updateProfile(UserProfile updatedProfile) async {
    _currentUserProfile = updatedProfile;
    notifyListeners();
    _saveUserProfile(); // Save changes to shared preferences
  }
}
