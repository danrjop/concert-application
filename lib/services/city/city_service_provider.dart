import 'package:flutter/material.dart';
import 'city_service.dart';
import 'city_service_fallback.dart';
import '../../models/city.dart';

enum CityServiceMode {
  api,     // Use the Supabase API
  fallback // Use the local fallback list
}

class CityServiceProvider extends ChangeNotifier {
  final CityService _apiService = CityService();
  final CityServiceFallback _fallbackService = CityServiceFallback();
  
  // Default to fallback mode during development
  CityServiceMode _mode = CityServiceMode.fallback;
  
  // Constructor with optional mode parameter
  CityServiceProvider({CityServiceMode mode = CityServiceMode.fallback}) {
    _mode = mode;
  }
  
  // Get the current mode
  CityServiceMode get mode => _mode;
  
  // Change the service mode
  void setMode(CityServiceMode newMode) {
    if (_mode != newMode) {
      _mode = newMode;
      notifyListeners();
    }
  }
  
  // Search cities using the appropriate service
  Future<List<City>> searchCities(String query) async {
    if (_mode == CityServiceMode.api) {
      return await _apiService.searchCities(query);
    } else {
      return await _fallbackService.searchCities(query);
    }
  }
  
  // Get city by ID
  Future<City?> getCityById(String id) async {
    if (_mode == CityServiceMode.api) {
      return await _apiService.getCityById(id);
    } else {
      return await _fallbackService.getCityById(id);
    }
  }
  
  // Get popular cities
  Future<List<City>> getPopularCities() async {
    if (_mode == CityServiceMode.api) {
      return await _apiService.getPopularCities();
    } else {
      return await _fallbackService.getPopularCities();
    }
  }
}
