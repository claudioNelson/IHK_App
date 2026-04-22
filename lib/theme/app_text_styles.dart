// lib/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography-System für Lernarena
///
/// Fonts:
/// - Inter Tight: Body & UI (default)
/// - Instrument Serif: Display-Akzente (italic)
/// - JetBrains Mono: Technische Details, Labels, Meta
class AppTextStyles {
  AppTextStyles._();

  // ─── HELPERS ────────────────────────────────────────────────
  static TextStyle interTight({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.interTight(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle instrumentSerif({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
    bool italic = true,
  }) {
    return GoogleFonts.instrumentSerif(
      fontSize: size,
      fontWeight: weight,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle mono({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing ?? 1.0,
    );
  }

  // ─── DISPLAY (große Headlines) ──────────────────────────────
  static TextStyle displayLarge(Color color) => interTight(
        size: 48,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -1.5,
        height: 1.05,
      );

  static TextStyle displayMedium(Color color) => interTight(
        size: 36,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -1.0,
        height: 1.1,
      );

  static TextStyle displaySmall(Color color) => interTight(
        size: 28,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -0.5,
        height: 1.15,
      );

  // Serif-Akzent-Variante (italic, für "emphasized" Wörter)
  static TextStyle displayAccent(double size, Color color) =>
      instrumentSerif(size: size, color: color, letterSpacing: -0.5);

  // ─── HEADINGS ────────────────────────────────────────────────
  static TextStyle h1(Color color) => interTight(
        size: 24,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -0.5,
        height: 1.25,
      );

  static TextStyle h2(Color color) => interTight(
        size: 20,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle h3(Color color) => interTight(
        size: 17,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -0.2,
        height: 1.35,
      );

  // ─── BODY ────────────────────────────────────────────────────
  static TextStyle bodyLarge(Color color) => interTight(
        size: 17,
        weight: FontWeight.w400,
        color: color,
        height: 1.6,
      );

  static TextStyle bodyMedium(Color color) => interTight(
        size: 15,
        weight: FontWeight.w400,
        color: color,
        height: 1.55,
      );

  static TextStyle bodySmall(Color color) => interTight(
        size: 13,
        weight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  // ─── LABELS (für Buttons, Tags, etc.) ────────────────────────
  static TextStyle labelLarge(Color color) => interTight(
        size: 15,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle labelMedium(Color color) => interTight(
        size: 13,
        weight: FontWeight.w500,
        color: color,
      );

  static TextStyle labelSmall(Color color) => interTight(
        size: 12,
        weight: FontWeight.w500,
        color: color,
      );

  // ─── MONO (für technische Details) ───────────────────────────
  // Für Labels wie "FRAGE 14/21", Meta-Infos, Versionsnummern
  static TextStyle monoLabel(Color color) => mono(
        size: 11,
        weight: FontWeight.w500,
        color: color,
        letterSpacing: 1.5,
      );

  static TextStyle monoSmall(Color color) => mono(
        size: 10,
        weight: FontWeight.w500,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle monoData(Color color) => mono(
        size: 13,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: 0,
      );
}
