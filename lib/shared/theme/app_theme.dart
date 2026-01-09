import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Thème de l'application centralisé
class AppTheme {
  AppTheme._(); // Private constructor

  /// Thème clair de l'application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.ubuntu(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.ubuntu(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.ubuntu(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.ubuntu(fontSize: 20),
        bodyMedium: GoogleFonts.ubuntu(fontSize: 18),
        bodySmall: GoogleFonts.ubuntu(fontSize: 16),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Thème sombre de l'application (optionnel pour le futur)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.ubuntu(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.ubuntu(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.ubuntu(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.ubuntu(fontSize: 20),
        bodyMedium: GoogleFonts.ubuntu(fontSize: 18),
        bodySmall: GoogleFonts.ubuntu(fontSize: 16),
      ),
    );
  }
}

