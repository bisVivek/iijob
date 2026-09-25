import 'package:flutter/material.dart';

class AppTheme {
  // Vibrant Blue Palette matching user image
  static const Color primaryBlue = Color(0xFF005BFF);
  static const Color darkBlue = Color(0xFF0043C6);
  static const Color lightBlue = Color(0xFF337DFF);
  static const Color softBlueTint = Color(0xFFEAF2FF);
  static const Color iconBg = Color(0xFFEFF5FF);
  
  // Background & surfaces
  static const Color background = Color(0xFFF7FAFF);
  static const Color cardSurface = Colors.white;
  static const Color fieldBackground = Color(0xFFF3F6FB);
  static const Color dividerColor = Color(0xFFE2E8F0);
  
  // Text & subtext
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textPlaceholder = Color(0xFF9CA3AF);
  
  // Accents
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: lightBlue,
        surface: cardSurface,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: 1.0,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }
}
