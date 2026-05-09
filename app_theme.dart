import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF7F7F8);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF10A37F); // ChatGPT-like green
  static const Color lightUserBubble = Color(0xFF007AFF); // iOS Blue
  static const Color lightAIBubble = Colors.white;
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF6E6E80);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF343541);
  static const Color darkSurface = Color(0xFF444654);
  static const Color darkPrimary = Color(0xFF10A37F);
  static const Color darkUserBubble = Color(0xFF10A37F);
  static const Color darkAIBubble = Color(0xFF444654);
  static const Color darkTextPrimary = Color(0xFFECECF1);
  static const Color darkTextSecondary = Color(0xFFC5C5D2);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        secondary: lightUserBubble,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        secondary: darkUserBubble,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true,
    );
  }
}
