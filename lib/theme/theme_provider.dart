// lib/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme-Provider für Dark/Light Toggle mit Persistence
///
/// Verwendung:
///   final themeProvider = context.watch<ThemeProvider>();
///   final isDark = themeProvider.isDark;
///   themeProvider.toggleTheme();
class ThemeProvider extends ChangeNotifier {
  static const String _storageKey = 'lernarena_theme_mode';

  ThemeMode _themeMode = ThemeMode.dark; // Default: Dark (wie Landingpage)
  bool _initialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isLight => _themeMode == ThemeMode.light;
  bool get isInitialized => _initialized;

  /// Beim App-Start aus SharedPreferences laden
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved == 'light') {
        _themeMode = ThemeMode.light;
      } else if (saved == 'dark') {
        _themeMode = ThemeMode.dark;
      }
      // Default bleibt bei Dark wenn nichts gespeichert
    } catch (_) {
      // Fehler ignorieren, Default verwenden
    }
    _initialized = true;
    notifyListeners();
  }

  /// Zwischen Dark und Light umschalten
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _saveTheme();
  }

  /// Explizit setzen
  Future<void> setDark() async {
    if (_themeMode == ThemeMode.dark) return;
    _themeMode = ThemeMode.dark;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> setLight() async {
    if (_themeMode == ThemeMode.light) return;
    _themeMode = ThemeMode.light;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        _themeMode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {
      // Ignorieren, ist nicht kritisch
    }
  }
}
