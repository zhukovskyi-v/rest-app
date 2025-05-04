import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF11998E),
      scaffoldBackgroundColor: const Color(0xFF0B0B0C),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
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
        primary: Color(0xFF11998E),
        secondary: Color(0xFF7A00FF),
        surface: Colors.white,
        inverseSurface: Colors.black,
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
      splashColor: const Color(0xFF11998E).withValues(alpha: 0.2),
      highlightColor: Colors.transparent,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF11998E),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
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
        primary: Color(0xFF11998E),
        secondary: Color(0xFF7A00FF),
        surface: Colors.black,
        inverseSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardTheme(
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
      splashColor: const Color(0xFF11998E).withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
    );
  }
}

extension DatePickerTheme on ThemeData {
  ThemeData datePickerTheme() {
    final bool isDarkMode = brightness == Brightness.dark;

    return copyWith(
      colorScheme:
          isDarkMode
              ? ColorScheme.dark(
                primary: colorScheme.primary,
                onPrimary: Colors.white,
                surface: const Color(0xFF303030),
                onSurface: Colors.white,
              )
              : ColorScheme.light(
                primary: colorScheme.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDarkMode ? const Color(0xFF303030) : Colors.white,
      ),
    );
  }
}
