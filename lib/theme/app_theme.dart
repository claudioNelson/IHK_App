// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Zentrale Theme-Definitionen für Flutter Material 3
///
/// Verwendung in MaterialApp:
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: themeProvider.themeMode,
class AppTheme {
  AppTheme._();

  // ─── DARK THEME (Default) ──────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        canvasColor: AppColors.darkBg,

        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: AppColors.accent,
          onPrimary: Colors.white,
          secondary: AppColors.accentCyan,
          onSecondary: Colors.black,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkText,
          surfaceContainerHighest: AppColors.darkSurfaceElev,
          error: AppColors.error,
          onError: Colors.white,
          outline: AppColors.darkBorderStrong,
          outlineVariant: AppColors.darkBorder,
        ),

        textTheme: GoogleFonts.interTightTextTheme(
          ThemeData.dark().textTheme.apply(
                bodyColor: AppColors.darkText,
                displayColor: AppColors.darkText,
              ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),

        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.darkBorder),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkText,
            foregroundColor: AppColors.darkBg,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkText,
            side: const BorderSide(color: AppColors.darkBorderStrong),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            textStyle: GoogleFonts.interTight(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          hintStyle: GoogleFonts.interTight(
            color: AppColors.darkTextDim,
            fontSize: 14,
          ),
        ),

        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
          space: 1,
        ),

        iconTheme: const IconThemeData(color: AppColors.darkTextMid),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.accent,
        ),
      );

  // ─── LIGHT THEME ───────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        canvasColor: AppColors.lightBg,

        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          primary: AppColors.accent,
          onPrimary: Colors.white,
          secondary: AppColors.accentCyan,
          onSecondary: Colors.black,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightText,
          surfaceContainerHighest: AppColors.lightBgMuted,
          error: AppColors.error,
          onError: Colors.white,
          outline: AppColors.lightBorderStrong,
          outlineVariant: AppColors.lightBorder,
        ),

        textTheme: GoogleFonts.interTightTextTheme(
          ThemeData.light().textTheme.apply(
                bodyColor: AppColors.lightText,
                displayColor: AppColors.lightText,
              ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBg,
          foregroundColor: AppColors.lightText,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),

        cardTheme: CardThemeData(
          color: AppColors.lightSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightText,
            foregroundColor: AppColors.lightBg,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lightText,
            side: const BorderSide(color: AppColors.lightBorderStrong),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            textStyle: GoogleFonts.interTight(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          hintStyle: GoogleFonts.interTight(
            color: AppColors.lightTextDim,
            fontSize: 14,
          ),
        ),

        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorder,
          thickness: 1,
          space: 1,
        ),

        iconTheme: const IconThemeData(color: AppColors.lightTextMid),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.accent,
        ),
      );
}
