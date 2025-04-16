// IMPORTS FLUTTER MATERIAL PACKAGE FOR THEME AND WIDGET UTILITIES
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR LOCAL USER PREFERENCES STORAGE
import 'package:hive_flutter/hive_flutter.dart';

// DEFINES THEME PROVIDER CLASS FOR HANDLING DARK/LIGHT MODE
class ThemeProvider extends ChangeNotifier {
  // STORES THE CURRENT THEME MODE (DEFAULTS TO SYSTEM)
  ThemeMode _themeMode = ThemeMode.system;

  // ACCESS TO HIVE BOX THAT STORES USER PREFERENCES
  final _box = Hive.box('authBox');

  // EXPOSES CURRENT THEME MODE
  ThemeMode get themeMode => _themeMode;

  // TOGGLES BETWEEN DARK MODE AND LIGHT MODE
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); // TRIGGERS UI REBUILD
  }

  // SETS THE THEME MODE MANUALLY
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // TRIGGERS UI REBUILD
  }

  // LOADS THEME PREFERENCE BASED ON THE CURRENT LOGGED-IN USER
  void reloadThemeForNewUser() {
    final email = _box.get('loggedInEmail') ?? ''; // GETS CURRENT USER EMAIL
    final isDark = _box.get('isDarkMode_$email', defaultValue: false); // CHECKS IF DARK MODE IS ENABLED
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light; // SETS THEME BASED ON SAVED VALUE
  }
}