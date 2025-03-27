import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/post.dart';

class SupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // ===== Auth Methods =====
  Future<User?> getCurrentUser() async {
    try {
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) return null;

      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .single();

      return User.fromJson(response);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Create profile entry
        await _supabaseClient.from('profiles').insert({
          'id': response.user!.id,
          'username': username,
          'display_name': username,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  // ===== Post Methods =====
  Future<List<Post>> getFeedPosts() async {
    try {
      final response = await _supabaseClient
          .from('posts')
          .select('*, profiles(username)')
          .order('created_at', ascending: false)
          .limit(10);

      // Transform the response into Post objects
      return response.map<Post>((post) {
        return Post.fromJson({
          ...post,
          'username': post['profiles']['username'],
        });
      }).toList();
    } catch (e) {
      print('Error getting feed posts: $e');
      return [];
    }
  }

  Future<bool> createPost({
    required String description,
    String? groupId,
    String? imageUrl,
  }) async {
    try {
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) return false;

      await _supabaseClient.from('posts').insert({
        'user_id': authUser.id,
        'description': description,
        'group_id': groupId,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  // ===== User Profile Methods =====
  Future<bool> updateProfile({
    required String displayName,
    String? profileImageUrl,
  }) async {
    try {
      final authUser = _supabaseClient.auth.currentUser;
      if (authUser == null) return false;

      await _supabaseClient.from('profiles').update({
        'display_name': displayName,
        'profile_image_url': profileImageUrl,
      }).eq('id', authUser.id);

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Add other methods as needed for your application
}
