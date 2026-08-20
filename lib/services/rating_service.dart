// lib/services/rating_service.dart
//
// Bewertungs-Abfrage im Play Store / App Store (In-App Review).
//
// Regeln:
// - Beim 5. App-Start wird zum ersten Mal gefragt.
// - Danach hoechstens alle 30 Tage und nur alle weiteren 15 Starts,
//   falls der Nutzer beim ersten Mal nicht bewertet hat.
// - Es erscheint IMMER das offizielle Store-Fenster (5 Sterne direkt
//   in der App). Ob der Nutzer wirklich bewertet hat, verraten Google
//   und Apple der App absichtlich nicht, deshalb arbeiten wir nur mit
//   Zeit- und Start-Abstaenden. Google drosselt zu haeufige Anfragen
//   zusaetzlich von selbst.

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  static const _keyStarts = 'rating_app_starts';
  static const _keyZuletztGefragtMs = 'rating_zuletzt_gefragt_ms';
  static const _keyStartsBeimFragen = 'rating_starts_beim_fragen';

  static const int _ersteAbfrageAbStart = 5;
  static const int _weitereAbfrageAlleStarts = 15;
  static const int _mindestAbstandTage = 30;

  /// Beim App-Start aufrufen: zaehlt den Start hoch.
  Future<void> appStartRegistrieren() async {
    final prefs = await SharedPreferences.getInstance();
    final starts = (prefs.getInt(_keyStarts) ?? 0) + 1;
    await prefs.setInt(_keyStarts, starts);
  }

  /// Prueft die Regeln und zeigt ggf. das Store-Bewertungsfenster.
  /// Am besten leicht verzoegert aufrufen, wenn der Nutzer schon auf
  /// dem Startbildschirm angekommen ist.
  Future<void> vielleichtFragen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final starts = prefs.getInt(_keyStarts) ?? 0;
      if (starts < _ersteAbfrageAbStart) return;

      final zuletztMs = prefs.getInt(_keyZuletztGefragtMs);
      if (zuletztMs != null) {
        final zuletzt = DateTime.fromMillisecondsSinceEpoch(zuletztMs);
        final tageSeitdem = DateTime.now().difference(zuletzt).inDays;
        if (tageSeitdem < _mindestAbstandTage) return;

        final startsBeimFragen = prefs.getInt(_keyStartsBeimFragen) ?? 0;
        if (starts - startsBeimFragen < _weitereAbfrageAlleStarts) return;
      }

      final review = InAppReview.instance;
      if (!await review.isAvailable()) return;

      await prefs.setInt(
        _keyZuletztGefragtMs,
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setInt(_keyStartsBeimFragen, starts);

      await review.requestReview();
      debugPrint('⭐ Bewertungs-Abfrage angestossen (Start $starts)');
    } catch (e) {
      debugPrint('⭐ Bewertungs-Abfrage fehlgeschlagen: $e');
    }
  }
}
