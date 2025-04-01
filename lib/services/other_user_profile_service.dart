import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/city.dart';

class OtherUserProfileService extends ChangeNotifier {
  Map<String, UserProfile> _userProfiles = {};
  bool _isLoading = false;
  
  // Check if a profile is currently loading
  bool get isLoading => _isLoading;
  
  // Get a specific user profile by ID
  UserProfile? getUserProfile(String userId) {
    return _userProfiles[userId];
  }
  
  // Fetch a user profile by ID
  Future<UserProfile?> fetchUserProfile(String userId) async {
    // If we already have the profile, return it
    if (_userProfiles.containsKey(userId)) {
      return _userProfiles[userId];
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real app, you would make an API call here
      // For development purposes, we'll simulate a network delay and return mock data
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Create a mock user profile
      // In a real application, this would come from your API
      final UserProfile userProfile = _createMockUserProfile(userId);
      
      // Save the profile in our cache
      _userProfiles[userId] = userProfile;
      
      _isLoading = false;
      notifyListeners();
      return userProfile;
    } catch (e) {
      print('Error fetching user profile: $e');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
  
  // Helper to create mock user profiles for development
  UserProfile _createMockUserProfile(String userId) {
    // Different mock data based on user ID to simulate different users
    switch (userId) {
      case 'user1':
        return UserProfile(
          id: 'user1',
          displayName: 'Jane Smith',
          username: 'janesmith',
          email: 'jane@example.com',
          bio: 'Music lover and concert enthusiast',
          profilePhotoUrl: 'assets/flower.png', // Use your default assets
          followers: 245,
          following: 167,
          rank: 42,
          homeCityName: 'New York',
          homeCityDisplay: 'New York, NY, USA',
        );
      case 'user2':
        return UserProfile(
          id: 'user2',
          displayName: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
          bio: 'Rock and jazz fan. I travel for good music!',
          profilePhotoUrl: 'assets/flower.png', // Use your default assets
          followers: 532,
          following: 211,
          rank: 23,
          homeCityName: 'Los Angeles',
          homeCityDisplay: 'Los Angeles, CA, USA',
        );
      default:
        // Generate a random profile for any other ID
        return UserProfile(
          id: userId,
          displayName: 'User $userId',
          username: 'user$userId',
          email: 'user$userId@example.com',
          bio: 'Music enthusiast and concert goer',
          profilePhotoUrl: 'assets/flower.png', // Use your default assets
          followers: 100 + (userId.hashCode % 400), // Random number of followers
          following: 50 + (userId.hashCode % 200), // Random number of following
          rank: 1 + (userId.hashCode % 100), // Random rank
          homeCityName: 'Chicago',
          homeCityDisplay: 'Chicago, IL, USA',
        );
    }
  }
  
  // Clear a specific user from the cache to force a refresh
  void refreshUserProfile(String userId) {
    if (_userProfiles.containsKey(userId)) {
      _userProfiles.remove(userId);
      notifyListeners();
    }
  }
  
  // Clear all cached profiles
  void clearCache() {
    _userProfiles.clear();
    notifyListeners();
  }
}
