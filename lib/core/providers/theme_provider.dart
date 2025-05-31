import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme.dart';
import '../utils/constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(bool isDarkModeInitial)
      : _themeData =
            isDarkModeInitial ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (isDarkMode) {
      _themeData = AppTheme.lightTheme;

      await prefs.setBool(kThemePreferenceKey, false);
    } else {
      _themeData = AppTheme.darkTheme;

      await prefs.setBool(kThemePreferenceKey, true);
    }

    notifyListeners();
  }

  static Future<ThemeProvider> create() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool(kThemePreferenceKey) ?? false;
    return ThemeProvider(isDarkMode);
  }
}
