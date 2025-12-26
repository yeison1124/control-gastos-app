import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark mode colors with neumorphism
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkCardLight = Color(0xFF2D2D2D);
  static const Color darkCardDark = Color(0xFF1C1C1C);

  // Accent colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentRed = Color(0xFFE53935);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF707070);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFFE53935),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
    Color(0xFF795548),
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: primaryBlue,
        surface: darkCard,
        error: accentRed,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textTertiary,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // Neumorphic shadow for cards
  static List<BoxShadow> get neumorphicShadow {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(4, 4),
        blurRadius: 8,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: darkCardLight.withOpacity(0.1),
        offset: const Offset(-4, -4),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  // Neumorphic shadow for pressed state
  static List<BoxShadow> get neumorphicShadowPressed {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(2, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];
  }
}
