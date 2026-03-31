import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Spacing Constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Common Border Radius Constants
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 16.0;
  static const double borderRadiusLg = 24.0;

  // Base Typography Helper
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.outfitTextTheme(base); // Very clean, distinctly unique minimalist font
  }

  // -------------------------------------------------------------
  // DARK THEME (MINIMALIST WIREFRAME)
  // -------------------------------------------------------------
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white, 
        brightness: Brightness.dark,
        surface: const Color(0xFF000000), // Pure OLED black
        primaryContainer: const Color(0xFF000000), // Pure black inner containers
        secondaryContainer: const Color(0xFF050505), // Ultra slight variance
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF000000), // Transparent/black vibe
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), 
          side: const BorderSide(color: Colors.white12, width: 1), // Crisp 1px thin wireframe border
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false, // Absolutely no background fill for inputs
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white12, width: 1), // Thin border
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white12, width: 1), // Explicit fallback border geometry
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1.5), // Pure white when focused
        ),
        hintStyle: const TextStyle(color: Color(0xFF666666)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white, 
          foregroundColor: Colors.black, 
          minimumSize: const Size(88, 56), // Use a fixed safe minimum width to prevent infinite constraint explosions in Intrinsic passes!
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
