import 'package:flutter/material.dart';

class AppTheme {
  // Theme Mode Notifier for reactive app-wide theme switching (Default: Light/White Theme)
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDark => themeModeNotifier.value == ThemeMode.dark;

  static void toggleTheme() {
    themeModeNotifier.value =
        isDark ? ThemeMode.light : ThemeMode.dark;
  }

  static void setTheme(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  // 11Jobs Signature Palette
  static const Color primaryBlue = Color(0xFF005BFF);
  static const Color darkBlue = Color(0xFF003CB8);
  static const Color lightBlue = Color(0xFF38BDF8);
  static const Color accentYellow = Color(0xFFFACC15);
  static const Color accentGold = Color(0xFFEAB308);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightInputBg = Color(0xFFF1F5F9);

  // Dark Mode Colors (11Jobs Midnight Navy Theme from 11jobs.in)
  static const Color darkBackground = Color(0xFF050814);
  static const Color darkCard = Color(0xFF0D1527);
  static const Color darkCardElevated = Color(0xFF131F37);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkInputBg = Color(0xFF0F1A30);

  // Shared Constants
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // Backward-compatible static accessors (defaulting to light tokens)
  static const Color background = lightBackground;
  static const Color cardSurface = lightCard;
  static const Color cardBackground = lightCard;
  static const Color fieldBackground = lightInputBg;
  static const Color dividerColor = lightBorder;
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textPlaceholder = Color(0xFF9CA3AF);
  static const Color softBlueTint = Color(0xFFEAF2FF);
  static const Color iconBg = Color(0xFFEFF5FF);

  // Dynamic Theme-Aware Helpers
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBackground : lightBackground;

  static Color cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color cardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;

  static Color txtPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color txtSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  static Color inputBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkInputBg : lightInputBg;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: lightBlue,
        surface: lightCard,
        onSurface: lightTextPrimary,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: lightTextPrimary,
        elevation: 0,
      ),
    );
  }

  // Dark Theme (11Jobs Midnight Navy Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: lightBlue,
        surface: darkCard,
        onSurface: darkTextPrimary,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        elevation: 0,
      ),
    );
  }
}
