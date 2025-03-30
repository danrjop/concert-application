import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOption {
  system,
  light,
  dark,
}

class ThemeService extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';
  
  ThemeOption _currentTheme = ThemeOption.dark; // Default to dark theme for concerts
  
  ThemeOption get currentTheme => _currentTheme;

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case ThemeOption.system:
        return ThemeMode.system;
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
    }
  }

  ThemeService() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themePreferenceKey);
      
      if (themeIndex != null) {
        _currentTheme = ThemeOption.values[themeIndex];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  Future<void> setTheme(ThemeOption themeOption) async {
    if (_currentTheme == themeOption) return;

    _currentTheme = themeOption;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, themeOption.index);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  Future<void> toggleDarkMode({required bool isDark}) async {
    await setTheme(isDark ? ThemeOption.dark : ThemeOption.light);
  }
}
