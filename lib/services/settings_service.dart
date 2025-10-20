import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/app_settings.dart';

class SettingsService {
  static const String _settingsFileName = 'app_settings.json';
  static SettingsService? _instance;
  File? _settingsFile;
  AppSettings? _cachedSettings;

  SettingsService._();

  static Future<SettingsService> getInstance() async {
    if (_instance == null) {
      _instance = SettingsService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final appDir = Directory(path.join(directory.path, 'AttendanceApp'));
      
      // Create directory if it doesn't exist
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      
      _settingsFile = File(path.join(appDir.path, _settingsFileName));
      await loadSettings();
    } catch (e) {
      print('Error initializing settings: $e');
      _cachedSettings = AppSettings();
    }
  }

  Future<AppSettings> loadSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    try {
      if (_settingsFile != null && await _settingsFile!.exists()) {
        final String settingsJson = await _settingsFile!.readAsString();
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        _cachedSettings = AppSettings.fromJson(json);
        return _cachedSettings!;
      }
    } catch (e) {
      print('Error loading settings: $e');
    }

    // Return default settings if none exist
    _cachedSettings = AppSettings();
    return _cachedSettings!;
  }

  Future<bool> saveSettings(AppSettings settings) async {
    try {
      if (_settingsFile == null) {
        await _init();
      }
      
      final String settingsJson = jsonEncode(settings.toJson());
      await _settingsFile!.writeAsString(settingsJson);
      _cachedSettings = settings;
      return true;
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  Future<bool> updateTotalGroups(int count) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(totalGroups: count);
    return await saveSettings(updatedSettings);
  }

  Future<bool> toggleDarkMode() async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(darkMode: !settings.darkMode);
    return await saveSettings(updatedSettings);
  }

  Future<bool> updateBackupPath(String path) async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(backupPath: path);
    return await saveSettings(updatedSettings);
  }

  Future<bool> toggleBackup() async {
    final settings = await loadSettings();
    final updatedSettings = settings.copyWith(enableBackup: !settings.enableBackup);
    return await saveSettings(updatedSettings);
  }

  Future<void> clearSettings() async {
    try {
      if (_settingsFile != null && await _settingsFile!.exists()) {
        await _settingsFile!.delete();
      }
      _cachedSettings = null;
    } catch (e) {
      print('Error clearing settings: $e');
    }
  }

  // Quick access to current settings
  AppSettings? get currentSettings => _cachedSettings;
}
