// lib/services/kurs_fortschritt_service.dart
//
// Speichert, welche Kursaufgaben gelöst sind.
//
// Zwei Ebenen:
//   1. Lokal (shared_preferences): sofort, funktioniert offline und für
//      Gäste. Das ist die Wahrheit auf dem Gerät.
//   2. Supabase (Tabelle kurs_fortschritt): wenn ein Nutzer eingeloggt ist,
//      wird zusätzlich hochgeladen. Beim Login werden beide Stände
//      zusammengeführt, es geht also nie etwas verloren.
//
// Die passende Tabelle legt die Migration
// supabase/migrations/20260818090000_kurs_fortschritt.sql an.

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KursFortschrittService {
  KursFortschrittService._();
  static final KursFortschrittService instance = KursFortschrittService._();

  static const _prefsSchluessel = 'kurs_fortschritt_v1';

  /// Aufgaben-IDs, z. B. "sql-1-4". Im Speicher gehalten, damit die
  /// Widgets synchron nachschauen können.
  final Set<String> _geloest = {};
  bool _geladen = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  /// Null, wenn niemand eingeloggt ist ODER Supabase gar nicht
  /// initialisiert wurde (z. B. im Teststart kurs_test.dart).
  User? get _nutzer {
    try {
      return _supabase.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  // ─── Lesen ────────────────────────────────────────────────────────────

  /// Einmal beim App-Start (oder vor dem ersten Kurs-Screen) aufrufen.
  Future<void> laden() async {
    if (_geladen) return;

    final prefs = await SharedPreferences.getInstance();
    final roh = prefs.getString(_prefsSchluessel);
    if (roh != null) {
      final liste = (jsonDecode(roh) as List).cast<String>();
      _geloest.addAll(liste);
    }
    _geladen = true;

    // Cloud-Stand dazuholen, wenn eingeloggt. Fehler sind hier egal,
    // der lokale Stand reicht zum Arbeiten.
    if (_nutzer != null) {
      unawaited(_vonCloudZusammenfuehren());
    }
  }

  bool istGeloest(String aufgabenId) => _geloest.contains(aufgabenId);

  Set<String> alleGeloesten() => Set.unmodifiable(_geloest);

  /// Wie viele der übergebenen IDs sind gelöst? Für Fortschrittsbalken.
  int geloestVon(Iterable<String> ids) =>
      ids.where(_geloest.contains).length;

  // ─── Schreiben ────────────────────────────────────────────────────────

  Future<void> alsGeloestMarkieren(String aufgabenId) async {
    if (_geloest.contains(aufgabenId)) return;
    _geloest.add(aufgabenId);

    await _lokalSpeichern();

    // Cloud asynchron, Fehler nur loggen. Der Nutzer soll beim Lernen
    // nie auf das Netz warten.
    if (_nutzer != null) {
      unawaited(_inCloudSchreiben(aufgabenId));
    }
  }

  Future<void> _lokalSpeichern() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsSchluessel, jsonEncode(_geloest.toList()));
  }

  // ─── Supabase ─────────────────────────────────────────────────────────

  Future<void> _inCloudSchreiben(String aufgabenId) async {
    try {
      await _supabase.from('kurs_fortschritt').upsert(
        {
          'user_id': _nutzer!.id,
          'aufgabe_id': aufgabenId,
        },
        onConflict: 'user_id,aufgabe_id',
        ignoreDuplicates: true,
      );
    } catch (e) {
      // Kein Drama: beim nächsten Login gleicht _vonCloudZusammenfuehren
      // in beide Richtungen ab.
      // ignore: avoid_print
      print('kurs_fortschritt upload: $e');
    }
  }

  /// Cloud und Gerät zusammenführen. Beide Richtungen: was nur lokal ist,
  /// geht hoch, was nur in der Cloud ist, kommt runter.
  Future<void> _vonCloudZusammenfuehren() async {
    try {
      final zeilen = await _supabase
          .from('kurs_fortschritt')
          .select('aufgabe_id')
          .eq('user_id', _nutzer!.id);

      final cloud = (zeilen as List)
          .map((z) => z['aufgabe_id'] as String)
          .toSet();

      final nurLokal = _geloest.difference(cloud);
      final nurCloud = cloud.difference(_geloest);

      if (nurCloud.isNotEmpty) {
        _geloest.addAll(nurCloud);
        await _lokalSpeichern();
      }

      if (nurLokal.isNotEmpty) {
        await _supabase.from('kurs_fortschritt').upsert(
          nurLokal
              .map((id) => {
                    'user_id': _nutzer!.id,
                    'aufgabe_id': id,
                  })
              .toList(),
          onConflict: 'user_id,aufgabe_id',
          ignoreDuplicates: true,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('kurs_fortschritt sync: $e');
    }
  }

  /// Nach einem Login aufrufen (z. B. aus dem Auth-Listener), damit der
  /// Gast-Fortschritt in den Account übernommen wird.
  Future<void> nachLoginAbgleichen() => _vonCloudZusammenfuehren();
}
