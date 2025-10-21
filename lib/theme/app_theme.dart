import 'package:flutter/material.dart';

class AppTheme {
  static const Color greenPrimary = Color(0xFF00C853);
  static const Color greenSecondary = Color(0xFF00C853);
  static const Color greenDark = Color(0xFF00A040);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSecondary = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color greenPrimary20 = Color(0x3300C853);
  static const Color greenPrimary30 = Color(0x4D00C853);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color black70 = Color(0xB3000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black20 = Color(0x33000000);

  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [greenPrimary30, greenPrimary20],
  );

  static LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [const Color(0xFF1A1A1A), const Color(0xFF0A0A0A)],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: greenPrimary,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: greenPrimary,
      secondary: greenSecondary,
      surface: darkSecondary,
      background: darkBackground,
    ),
    
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: white),
      bodyMedium: TextStyle(color: white),
      bodySmall: TextStyle(color: white60),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: white),
      hintStyle: const TextStyle(color: white50),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: white50),
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
        foregroundColor: black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: greenPrimary,
      foregroundColor: black,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: greenDark,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: greenDark,
      secondary: greenPrimary,
      surface: lightSecondary,
      background: lightBackground,
    ),
    
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: black),
      bodyMedium: TextStyle(color: black),
      bodySmall: TextStyle(color: black70),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: black),
      hintStyle: const TextStyle(color: black70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: black30),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: greenDark),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenDark,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: greenDark,
      foregroundColor: white,
    ),
  );

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? white : black;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color getSecondaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondary
        : lightSecondary;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? greenPrimary
        : greenDark;
  }

  static Color getTextColor60(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? white60 : black70;
  }

  static Color getTextColor50(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? white50
        : const Color(0x80000000);
  }

  static Color getTextColor30(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? white30 : black30;
  }

  static Color getPrimaryColor20(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? greenPrimary20
        : const Color(0x3300A040);
  }

  static Color getPrimaryColor30(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? greenPrimary30
        : const Color(0x4D00A040);
  }
}

