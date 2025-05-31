import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      elevation: 1.0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
      labelSmall: TextStyle(color: Colors.grey[600], fontSize: 12),
      headlineSmall:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.teal,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.amber,
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[850],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 1.0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.grey[400],
      backgroundColor: Colors.grey[900],
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
      labelSmall: TextStyle(color: Colors.grey[400], fontSize: 12),
      headlineSmall:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[800],
    ),
    iconTheme: IconThemeData(
      color: Colors.tealAccent,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
      surface: Colors.grey[800]!,
      background: Colors.grey[850]!,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    ),
  );
}
