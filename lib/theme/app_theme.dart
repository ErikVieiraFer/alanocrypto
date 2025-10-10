
import 'package:flutter/material.dart';

class AppTheme {
  static const Color greenPrimary = Color(0xFF00ff01);
  static const Color greenSecondary = Color(0xFF00FF88);
  static const Color darkBlueBackground = Color(0xFF0E1116);
  static const Color darkBlueSecondary = Color(0xFF0E1629);
  static const Color white = Color(0xFFFFFFFF);

  static final ThemeData themeData = ThemeData(
    primaryColor: greenPrimary,
    scaffoldBackgroundColor: darkBlueBackground,
    colorScheme: const ColorScheme.dark(
      primary: greenPrimary,
      secondary: greenSecondary,
      background: darkBlueBackground,
      surface: darkBlueSecondary,
      onPrimary: white,
      onSecondary: white,
      onBackground: white,
      onSurface: white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: white),
      bodyMedium: TextStyle(color: white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: greenPrimary),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenPrimary,
        foregroundColor: darkBlueBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
