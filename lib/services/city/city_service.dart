import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/city.dart';

class CityService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  // Fetch cities based on search query with improved text search
  Future<List<City>> searchCities(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Use text search for better results
      // This uses the search_vector column we created in our schema
      final response = await _supabaseClient
          .from('cities')
          .select()
          .textSearch('search_vector', query)
          .limit(20);
      
      return response.map<City>((data) => City.fromJson(data)).toList();
    } catch (e) {
      print('Error searching cities: $e');
      
      // Fallback to simple search if text search fails
      try {
        final response = await _supabaseClient
            .from('cities')
            .select()
            .ilike('name', '%$query%')
            .limit(20);
        
        return response.map<City>((data) => City.fromJson(data)).toList();
      } catch (fallbackError) {
        print('Fallback search also failed: $fallbackError');
        return [];
      }
    }
  }

  // Get city by ID
  Future<City?> getCityById(String id) async {
    try {
      final response = await _supabaseClient
          .from('cities')
          .select()
          .eq('id', id)
          .single();
      
      return City.fromJson(response);
    } catch (e) {
      print('Error getting city by ID: $e');
      return null;
    }
  }

  // Get popular cities - could be enhanced with a popularity metric in the future
  Future<List<City>> getPopularCities() async {
    try {
      // Currently just returns a limited number of cities
      // Could be improved with a 'popular' flag or visit count in the future
      final response = await _supabaseClient
          .from('cities')
          .select()
          .order('name')
          .limit(20);
      
      return response.map<City>((data) => City.fromJson(data)).toList();
    } catch (e) {
      print('Error getting popular cities: $e');
      return [];
    }
  }
  
  // Get cities by country
  Future<List<City>> getCitiesByCountry(String country) async {
    try {
      final response = await _supabaseClient
          .from('cities')
          .select()
          .eq('country', country)
          .order('name')
          .limit(50);
      
      return response.map<City>((data) => City.fromJson(data)).toList();
    } catch (e) {
      print('Error getting cities by country: $e');
      return [];
    }
  }
  
  // Get cities by state/province
  Future<List<City>> getCitiesByRegion({String? state, String? province}) async {
    try {
      PostgrestFilterBuilder query = _supabaseClient
          .from('cities')
          .select();
          
      if (state != null) {
        query = query.eq('state', state);
      } else if (province != null) {
        query = query.eq('province', province);
      } else {
        // If neither is provided, return empty list
        return [];
      }
      
      final response = await query.order('name').limit(50);
      return response.map<City>((data) => City.fromJson(data)).toList();
    } catch (e) {
      print('Error getting cities by region: $e');
      return [];
    }
  }
}
