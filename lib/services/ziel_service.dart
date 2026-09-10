// lib/services/ziel_service.dart
//
// Pruefungsziel des Nutzers: Pruefung (AP1/AP2), Fachrichtung (AE/SI) und
// Termin. Liegt in profiles (pruefung, fachrichtung, pruefungsdatum,
// Migration 20260910010000) und als Kopie in SharedPreferences, damit der
// Countdown im Lernhub sofort steht, bevor das Netz antwortet.
//
// Phase 1 des Plans "Pruefungs-Countdown mit Tagesplan"
// (claude/pruefungs-countdown-plan.md). Phase 2 (Tagesplan) setzt hier auf.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PruefungsZiel {
  /// 'AP1' oder 'AP2'
  final String pruefung;

  /// 'AE' oder 'SI'
  final String fachrichtung;

  /// null = Termin noch unbekannt (dann kein Countdown, nur Tagesziel)
  final DateTime? datum;

  const PruefungsZiel({
    required this.pruefung,
    required this.fachrichtung,
    this.datum,
  });

  /// Tage bis zur Pruefung (Kalendertage, heute = 0). null ohne Termin.
  int? get tageBis {
    final d = datum;
    if (d == null) return null;
    final heute = DateTime.now();
    final h = DateTime(heute.year, heute.month, heute.day);
    return DateTime(d.year, d.month, d.day).difference(h).inDays;
  }

  bool get vorbei => (tageBis ?? 1) < 0;

  String get pruefungLabel => pruefung == 'AP1' ? 'AP1' : 'AP2';
  String get fachrichtungLabel =>
      fachrichtung == 'AE' ? 'Anwendungsentwicklung' : 'Systemintegration';

  PruefungsZiel copyWith({
    String? pruefung,
    String? fachrichtung,
    DateTime? datum,
    bool datumLoeschen = false,
  }) =>
      PruefungsZiel(
        pruefung: pruefung ?? this.pruefung,
        fachrichtung: fachrichtung ?? this.fachrichtung,
        datum: datumLoeschen ? null : (datum ?? this.datum),
      );
}

class PruefungsTermin {
  final String pruefung;
  final String bezeichnung;
  final DateTime datum;
  final String? hinweis;

  const PruefungsTermin({
    required this.pruefung,
    required this.bezeichnung,
    required this.datum,
    this.hinweis,
  });
}

class ZielService {
  ZielService._();
  static final ZielService _instance = ZielService._();
  factory ZielService() => _instance;

  static const _kPruefung = 'ziel_pruefung';
  static const _kFachrichtung = 'ziel_fachrichtung';
  static const _kDatum = 'ziel_datum';

  PruefungsZiel? _ziel;
  bool _geladen = false;
  List<PruefungsTermin>? _termine;

  PruefungsZiel? get ziel => _ziel;
  bool get geladen => _geladen;

  /// Erst lokale Kopie (sofort), dann Profil aus der DB (ueberschreibt).
  Future<PruefungsZiel?> laden() async {
    if (!_geladen) {
      _ziel = await _ausPrefs();
      _geladen = true;
    }
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final row = await Supabase.instance.client
            .from('profiles')
            .select('pruefung, fachrichtung, pruefungsdatum')
            .eq('id', user.id)
            .maybeSingle();
        final p = row?['pruefung'] as String?;
        final f = row?['fachrichtung'] as String?;
        if (p != null && f != null) {
          final d = row?['pruefungsdatum'] as String?;
          _ziel = PruefungsZiel(
            pruefung: p,
            fachrichtung: f,
            datum: d == null ? null : DateTime.tryParse(d),
          );
          await _inPrefs(_ziel);
        } else if (row != null && _ziel != null) {
          // Lokal gesetzt (z. B. als Gast vor dem Login), in der DB noch
          // leer -> nachtragen.
          await speichern(_ziel!);
        }
      } catch (e) {
        debugPrint('ZielService.laden: $e');
      }
    }
    return _ziel;
  }

  Future<void> speichern(PruefungsZiel ziel) async {
    _ziel = ziel;
    _geladen = true;
    await _inPrefs(ziel);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      await Supabase.instance.client.from('profiles').update({
        'pruefung': ziel.pruefung,
        'fachrichtung': ziel.fachrichtung,
        'pruefungsdatum': ziel.datum == null
            ? null
            : ziel.datum!.toIso8601String().substring(0, 10),
      }).eq('id', user.id);
    } catch (e) {
      debugPrint('ZielService.speichern: $e');
    }
  }

  Future<void> loeschen() async {
    _ziel = null;
    await _inPrefs(null);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      await Supabase.instance.client.from('profiles').update({
        'pruefung': null,
        'fachrichtung': null,
        'pruefungsdatum': null,
      }).eq('id', user.id);
    } catch (e) {
      debugPrint('ZielService.loeschen: $e');
    }
  }

  /// Beim Logout: nur den Speicher leeren, das Profil bleibt.
  void zuruecksetzen() {
    _ziel = null;
    _geladen = false;
    _inPrefs(null);
  }

  /// Vorschlagstermine aus pruefungstermine (nur aktive, ab heute).
  Future<List<PruefungsTermin>> termine() async {
    if (_termine != null) return _termine!;
    try {
      final rows = await Supabase.instance.client
          .from('pruefungstermine')
          .select('pruefung, bezeichnung, datum, hinweis')
          .order('datum');
      final heute = DateTime.now();
      final h = DateTime(heute.year, heute.month, heute.day);
      _termine = [
        for (final r in (rows as List))
          if (DateTime.tryParse(r['datum'] as String? ?? '') != null &&
              !DateTime.parse(r['datum'] as String).isBefore(h))
            PruefungsTermin(
              pruefung: r['pruefung'] as String,
              bezeichnung: r['bezeichnung'] as String,
              datum: DateTime.parse(r['datum'] as String),
              hinweis: r['hinweis'] as String?,
            ),
      ];
    } catch (e) {
      debugPrint('ZielService.termine: $e');
      _termine = const [];
    }
    return _termine!;
  }

  Future<PruefungsZiel?> _ausPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final p = prefs.getString(_kPruefung);
      final f = prefs.getString(_kFachrichtung);
      if (p == null || f == null) return null;
      final d = prefs.getString(_kDatum);
      return PruefungsZiel(
        pruefung: p,
        fachrichtung: f,
        datum: d == null ? null : DateTime.tryParse(d),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _inPrefs(PruefungsZiel? ziel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (ziel == null) {
        await prefs.remove(_kPruefung);
        await prefs.remove(_kFachrichtung);
        await prefs.remove(_kDatum);
        return;
      }
      await prefs.setString(_kPruefung, ziel.pruefung);
      await prefs.setString(_kFachrichtung, ziel.fachrichtung);
      if (ziel.datum == null) {
        await prefs.remove(_kDatum);
      } else {
        await prefs.setString(
          _kDatum,
          ziel.datum!.toIso8601String().substring(0, 10),
        );
      }
    } catch (e) {
      debugPrint('ZielService prefs: $e');
    }
  }
}
