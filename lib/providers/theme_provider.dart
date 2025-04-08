import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  late String _key;
  bool _isDark = false;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    final email = Hive.box('authBox').get('loggedInEmail') ?? '';
    _key = 'isDarkMode_$email';
    _isDark = Hive.box('authBox').get(_key) ?? false;
    debugPrint("🎨 Theme loaded: $_key = $_isDark");

  }

  bool get isDarkMode => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    Hive.box('authBox').put(_key, _isDark);
    notifyListeners();
  }

  void reloadThemeForNewUser() {
    _loadTheme();
    notifyListeners();
  }
}
