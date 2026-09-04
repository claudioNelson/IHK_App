// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Zentrale Farbdefinitionen für Lernarena
/// Basierend auf dem Landing-Page-Design (Dark-first, Indigo-Akzent)
class AppColors {
  AppColors._(); // private constructor

  // ─── MARKEN-FARBEN (theme-unabhängig) ────────────────────────
  static const Color accent = Color(0xFF7C6DFF);      // Indigo-Violet
  static const Color accentHover = Color(0xFF6B5DF0);
  static const Color accentCyan = Color(0xFF22D3EE);  // Cyan-Secondary

  // Vendor-Farben für Zertifikate
  static const Color awsOrange = Color(0xFFFF9900);
  static const Color azureBlue = Color(0xFF0078D4);
  static const Color gcpBlue = Color(0xFF4285F4);
  static const Color sapBlue = Color(0xFF0070F2);

  // Status-Farben
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ─── DARK THEME ────────────────────────────────────────────────
  static const Color darkBg = Color(0xFF08080C);
  static const Color darkBgMuted = Color(0xFF0E0E14);
  static const Color darkSurface = Color(0xFF12121C);
  static const Color darkSurfaceElev = Color(0xFF1A1A28);
  static const Color darkBorder = Color(0x14FFFFFF);       // 8% white
  static const Color darkBorderStrong = Color(0x24FFFFFF); // 14% white
  static const Color darkText = Color(0xFFF5F5F7);
  static const Color darkTextMid = Color(0xFFA0A0B0);
  static const Color darkTextDim = Color(0xFF606070);
  static const Color darkAccentSoft = Color(0x247C6DFF);   // 14% accent

  // ─── LIGHT THEME (Variante D "Indigo-Wash", 04.09.2026) ───────
  // Kuehler, leicht indigo-verwandter Grund; Karten bleiben weiss und heben
  // sich dadurch ab. Rahmen kraeftiger, gedimmter Text AA-tauglich.
  static const Color lightBg = Color(0xFFF3F4F9);
  static const Color lightBgMuted = Color(0xFFE7E9F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElev = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x24141A2E);       // 14% blauschwarz
  static const Color lightBorderStrong = Color(0x33141A2E); // 20% blauschwarz
  static const Color lightText = Color(0xFF0D0F1A);
  static const Color lightTextMid = Color(0xFF4B4F60);
  static const Color lightTextDim = Color(0xFF6B7080);      // 4,9:1 auf Weiss
  static const Color lightAccentSoft = Color(0x2E7C6DFF);   // 18% accent

  // Tiefe im Hellmodus: neutrale, leicht blauschwarze Schatten statt Glows
  static const Color lightShadow = Color(0x140B1033);       // Karten
  static const Color lightShadowStrong = Color(0x240B1033); // Sheets, Nav-Pille
  // Akzent als Text auf Weiss (6,2:1 statt 3,8:1)
  static const Color lightAccentInk = Color(0xFF5B4BE0);
  // Indigo-Verlauf hinter Kopfbereichen (nur Light)
  static const Color lightHeaderWash = Color(0x297C6DFF);   // 16% accent
}
