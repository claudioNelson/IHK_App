// lib/theme/kurs_theme.dart
//
// Material-Theme für die Kurs-Screens, gebaut aus den AppColors.
//
// Hintergrund: die Kurs-Widgets (Aufgabenkarten, Editor, Ergebnistabelle)
// nutzen durchgehend Theme.of(context).colorScheme. Statt jedes Widget
// einzeln auf AppColors umzuschreiben, bekommen die Kurs-Screens dieses
// Theme übergestülpt. Damit sehen sie automatisch aus wie der Rest der
// App, in beiden Themes.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData kursTheme(bool isDark) {
  final basis = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: isDark ? Brightness.dark : Brightness.light,
  );

  final schema = isDark
      ? basis.copyWith(
          primary: AppColors.accent,
          surface: AppColors.darkBg,
          surfaceContainerHighest: AppColors.darkSurfaceElev,
          onSurface: AppColors.darkText,
          onSurfaceVariant: AppColors.darkTextMid,
          outlineVariant: AppColors.darkBorderStrong,
        )
      : basis.copyWith(
          primary: AppColors.accent,
          surface: AppColors.lightBg,
          surfaceContainerHighest: AppColors.lightBgMuted,
          onSurface: AppColors.lightText,
          onSurfaceVariant: AppColors.lightTextMid,
          outlineVariant: AppColors.lightBorderStrong,
        );

  final textFarbe = isDark ? AppColors.darkText : AppColors.lightText;

  return ThemeData(
    useMaterial3: true,
    colorScheme: schema,
    scaffoldBackgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
    textTheme: GoogleFonts.interTightTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    ).apply(bodyColor: textFarbe, displayColor: textFarbe),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      foregroundColor: textFarbe,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textFarbe,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(
          color: isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
    ),
  );
}
