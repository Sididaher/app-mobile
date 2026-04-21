import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0D1B6D);
  static const Color accentGold = Color(0xFFC5A059);
  static const Color lightGrey = Color(0xFFF8F9FA);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF6C757D);
  static const Color surfaceWhite = Colors.white;

  // Spacing & Radius
  static const double borderRadius = 16.0;
  static const double defaultPadding = 20.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: surfaceWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: accentGold,
      surface: surfaceWhite,
      background: lightGrey,
    ),
    
    // Typography
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkGrey,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkGrey,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        color: darkGrey,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        color: textGrey,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceWhite,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: darkGrey, size: 24),
      titleTextStyle: GoogleFonts.outfit(
        color: primaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 3.0,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textGrey, fontSize: 14),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: surfaceWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentGold,
        textStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      color: surfaceWhite,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      secondary: accentGold,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
    ),
    
    // Typography
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      titleTextStyle: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 3.0,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentGold,
        textStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      color: const Color(0xFF1E1E1E),
    ),
  );
}
