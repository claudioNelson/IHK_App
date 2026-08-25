// lib/services/thema_score_service.dart
//
// Bestes Themen-Ergebnis im Uebungsbereich speichern: lokal fuer die
// sofortige Anzeige, zusaetzlich in der Cloud (Tabelle thema_scores),
// damit der Stand Logout, Neuinstallation und Geraetewechsel ueberlebt.
// Gleiches Muster wie kurs_fortschritt_service.
//
// Hintergrund: Der Logout loescht absichtlich alle nutzerspezifischen
// lokalen Daten (auth_service.signOut). Ohne Cloud-Kopie war der
// Uebungs-Fortschritt danach weg.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ThemaScoreService {
  final _client = Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  static String schluessel(int modulId, int themaId) =>
      'score_mod_${modulId}_thema_$themaId';

  /// Bestes Ergebnis speichern. Es zaehlt immer das Maximum, ein
  /// schlechterer neuer Lauf ueberschreibt nichts.
  Future<void> speichern({
    required int modulId,
    required int themaId,
    required double prozent,
  }) async {
    // 1. Lokal, damit die Themenliste sofort aktuell ist.
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = schluessel(modulId, themaId);
      if (prozent > (prefs.getDouble(key) ?? 0)) {
        await prefs.setDouble(key, prozent);
      }
    } catch (e) {
      debugPrint('Thema-Score lokal speichern fehlgeschlagen: $e');
    }

    // 2. Cloud, nur eingeloggt (Gaeste sind anonyme User und haben
    //    auch eine userId, die zaehlt hier mit).
    final userId = _userId;
    if (userId == null) return;
    try {
      final vorhanden = await _client
          .from('thema_scores')
          .select('best_score')
          .eq('user_id', userId)
          .eq('modul_id', modulId)
          .eq('thema_id', themaId)
          .maybeSingle();
      final bisher = (vorhanden?['best_score'] as num?)?.toDouble() ?? 0;
      if (prozent <= bisher) return;

      await _client.from('thema_scores').upsert({
        'user_id': userId,
        'modul_id': modulId,
        'thema_id': themaId,
        'best_score': prozent,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,modul_id,thema_id');
    } catch (e) {
      debugPrint('Thema-Score Cloud-Sync fehlgeschlagen: $e');
    }
  }

  /// Alle Scores eines Moduls laden: lokal sofort, dann Cloud mergen
  /// (jeweils das Maximum) und den Stand wieder lokal ablegen.
  Future<Map<int, double>> ladeFuerModul(
    int modulId,
    List<int> themaIds,
  ) async {
    final scores = <int, double>{};
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      for (final id in themaIds) {
        scores[id] = prefs.getDouble(schluessel(modulId, id)) ?? 0.0;
      }
    } catch (_) {}

    final userId = _userId;
    if (userId != null) {
      try {
        final result = await _client
            .from('thema_scores')
            .select('thema_id, best_score')
            .eq('user_id', userId)
            .eq('modul_id', modulId);
        for (final zeile in result) {
          final id = zeile['thema_id'] as int;
          final cloud = (zeile['best_score'] as num).toDouble();
          if (cloud > (scores[id] ?? 0)) {
            scores[id] = cloud;
            await prefs?.setDouble(schluessel(modulId, id), cloud);
          }
        }
      } catch (e) {
        debugPrint('Thema-Scores aus der Cloud laden fehlgeschlagen: $e');
      }
    }
    return scores;
  }
}
