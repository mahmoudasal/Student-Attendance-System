/// Theme Provider - Manages Dark Mode State
/// 
/// Features:
/// - System theme detection
/// - User preference persistence
/// - Smooth theme transitions
/// - Notifies all listeners on theme change

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeModeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  late Box _themeBox;
  bool _isInitialized = false;
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  /// Current theme mode
  ThemeMode get themeMode => _themeMode;
  
  /// Check if initialized
  bool get isInitialized => _isInitialized;
  
  /// Check if dark mode is active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Get system brightness
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  /// Load saved theme preference from Hive
  Future<void> _loadThemePreference() async {
    try {
      // Open Hive box
      _themeBox = await Hive.openBox(_themeBoxName);
      
      // Load saved theme mode (default to system)
      final savedMode = _themeBox.get(_themeModeKey, defaultValue: 'system') as String;
      
      switch (savedMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _themeMode = ThemeMode.system;
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  /// Set theme mode and persist preference
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    
    // Save to Hive
    try {
      String modeString;
      switch (mode) {
        case ThemeMode.light:
          modeString = 'light';
          break;
        case ThemeMode.dark:
          modeString = 'dark';
          break;
        case ThemeMode.system:
          modeString = 'system';
          break;
      }
      
      await _themeBox.put(_themeModeKey, modeString);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
    
    notifyListeners();
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // If system mode, switch to opposite of current system brightness
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      await setThemeMode(
        brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark
      );
    }
  }
  
  /// Reset to system theme
  Future<void> resetToSystem() async {
    await setThemeMode(ThemeMode.system);
  }
  
  /// Get theme mode display name (for UI)
  String getThemeModeName() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'وضع النهار'; // Light mode in Arabic
      case ThemeMode.dark:
        return 'الوضع الليلي'; // Dark mode in Arabic
      case ThemeMode.system:
        return 'تلقائي (النظام)'; // System mode in Arabic
    }
  }
  
  /// Get icon for current theme mode
  IconData getThemeModeIcon() {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
