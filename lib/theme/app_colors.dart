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
  // 25.09.2026: von 606070 (3,0:1 auf darkSurface) auf 8A8A9C (5,5:1),
  // damit die 10-px-Mono-Metazeilen AA erreichen.
  static const Color darkTextDim = Color(0xFF8A8A9C);
  static const Color darkAccentSoft = Color(0x247C6DFF);   // 14% accent

  // ─── LIGHT THEME "Warmes Papier" (25.09.2026) ───────────────
  // Warmer Off-White-Grund wie Papier, weisse Karten mit weichem warmem
  // Schatten, Rahmen und gedaempfte Texte in warmem Grau. Indigo bleibt der
  // einzige kuehle Ton und wirkt dadurch staerker. Vorher (04.09.) war der
  // Grund blaustichig (#F3F4F9) und wirkte kalt und flach.
  static const Color lightBg = Color(0xFFF6F5F1);
  static const Color lightBgMuted = Color(0xFFECEAE4);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElev = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x1F2A2419);       // 12% warmes Braunschwarz
  static const Color lightBorderStrong = Color(0x332A2419); // 20%
  static const Color lightText = Color(0xFF1C1A17);         // warmes Fast-Schwarz
  static const Color lightTextMid = Color(0xFF55524B);
  static const Color lightTextDim = Color(0xFF6E6A62);      // 4,6:1 auf dem Grund
  static const Color lightAccentSoft = Color(0x2E7C6DFF);   // 18% accent

  // Tiefe im Hellmodus: weiche, warm getoente Schatten statt Glows
  static const Color lightShadow = Color(0x162A2419);       // Karten
  static const Color lightShadowStrong = Color(0x262A2419); // Sheets, Nav-Pille
  // Akzent im Light: tieferes Indigo statt Pastell-Violett (Entscheidung 25.09.).
  // Als Text Indigo-700 (7,9:1 auf Weiss), als Flaeche Indigo-600 (6,3:1 mit Weiss).
  static const Color lightAccentInk = Color(0xFF4338CA);
  static const Color lightAccentFill = Color(0xFF4F46E5);

  // Aktueller Modus, vom ThemeProvider bei jedem Wechsel gesetzt. Erlaubt
  // themefaehige Getter ohne BuildContext (Kicker, Chips, Buttons).
  static bool istHell = false;
  /// Akzent als TEXT: im Light die dunklere Tinte (5,95:1 auf Weiss),
  /// im Dark der normale Akzent.
  static Color get accentText => istHell ? lightAccentInk : accent;
  /// Akzent als FLAECHE unter weissem Text (Buttons, Badges, aktiver Tab).
  static Color get accentFill => istHell ? lightAccentFill : accent;

  /// Schatten unter Karten: im Light weich und warm, im Dark keiner
  /// (dort tragen Flaechenebenen und Rahmen die Tiefe).
  static List<BoxShadow> get kartenSchatten => istHell
      ? const [BoxShadow(color: lightShadow, blurRadius: 14, offset: Offset(0, 3))]
      : const [];

  /// Kraeftige Signalfarbe als TEXT: im Light die dunklere "Tinte" mit
  /// AA-Kontrast auf Weiss, im Dark unveraendert. Flaechen (Toenungen,
  /// Icons, Rahmen) weiter mit der Originalfarbe fuellen.
  static Color ink(Color c) {
    if (!istHell) return c;
    return _tinte[c.value] ?? c;
  }

  static const Map<int, Color> _tinte = {
    0xFF7C6DFF: lightAccentInk,         // accent
    0xFF22D3EE: Color(0xFF0E7490),      // accentCyan, Diamant (5,4:1)
    0xFFF59E0B: Color(0xFFA16207),      // warning, Gold, Bernstein (4,9:1)
    0xFF94A3B8: Color(0xFF64748B),      // Silber (4,8:1)
    0xFFEF4444: Color(0xFFDC2626),      // error, Meister (4,8:1)
    0xFF10B981: Color(0xFF047857),      // success (4,9:1)
    0xFF34D399: Color(0xFF047857),      // Saison Gruen
    0xFF3B82F6: Color(0xFF1D4ED8),      // info (6,0:1)
    0xFF60A5FA: Color(0xFF1D4ED8),      // Saison Blau
    0xFFFF9900: Color(0xFFA16207),      // awsOrange
    0xFF0078D4: Color(0xFF005A9E),      // azureBlue
    0xFF4285F4: Color(0xFF1D4ED8),      // gcpBlue
    0xFF0070F2: Color(0xFF0052B4),      // sapBlue
  };
  // Indigo-Verlauf hinter Kopfbereichen (nur Light)
  static const Color lightHeaderWash = Color(0x1A7C6DFF);   // 10% accent, dezenter auf warmem Grund
}
