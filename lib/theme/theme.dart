import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00FFC8),
      scaffoldBackgroundColor: const Color(0xFF0B0B0C),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontWeight: FontWeight.w400,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFC8),
        secondary: Color(0xFF7A00FF),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0B0C),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      splashColor: const Color(0xFF00FFC8).withValues(alpha: 0.2),
      highlightColor: Colors.transparent,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF00FFC8),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00FFC8),
        secondary: Color(0xFF7A00FF),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
      splashColor: const Color(0xFF00FFC8).withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
    );
  }
}
