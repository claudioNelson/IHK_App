// lib/services/lernplan_service.dart
//
// Tagesplan (Pruefungs-Countdown Phase 2, claude/pruefungs-countdown-plan.md).
//
// Rein clientseitig: Die RPC lernplan_status() (Migration 20260917030000)
// liefert in EINEM Aufruf alle Themen mit Fragenzahl, bestem Score und
// heute beantworteten Fragen, dazu faellige/heute erledigte Wiederholungen
// und die letzte Uebungspruefung. Daraus entstehen bis zu drei Posten fuer
// heute:
//   1. "N Fragen <Thema>"        - das schwaechste relevante Thema
//   2. "M Wiederholungen"        - wenn Spaced Repetition etwas faellig hat
//   3. "1 Uebungspruefung"       - alle 7 Tage; in der letzten Woche taeglich
// In den letzten 3 Tagen vor der Pruefung keine neuen Themen mehr, nur
// Wiederholen und Pruefung (Auffrischen des schwaechsten Themas als Ersatz,
// wenn nichts faellig ist).
//
// Tagesziel = clamp(ceil(offene Fragen / verbleibende Tage), 10, 40);
// ohne Termin 15. Relevante Module kommen aus module.ap1/ap2_ae/ap2_si.

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ziel_service.dart';

enum PostenTyp { thema, wiederholen, pruefung }

class LernPosten {
  final PostenTyp typ;
  final String titel;
  final String untertitel;

  /// Zielwert (Fragen, Wiederholungen, Pruefungen).
  final int ziel;

  /// Heute schon geschafft.
  final int erledigt;

  /// Nur bei [PostenTyp.thema]: zum Oeffnen des Themas.
  final int? modulId;
  final String? modulName;
  final int? themaId;
  final String? themaName;
  final int requiredScore;

  const LernPosten({
    required this.typ,
    required this.titel,
    required this.untertitel,
    required this.ziel,
    required this.erledigt,
    this.modulId,
    this.modulName,
    this.themaId,
    this.themaName,
    this.requiredScore = 80,
  });

  bool get fertig => erledigt >= ziel;
  double get anteil => ziel == 0 ? 1 : (erledigt / ziel).clamp(0.0, 1.0);
}

class Tagesplan {
  final List<LernPosten> posten;
  final int tagesziel;
  final int heuteFragen;

  /// Offene Fragen ueber alle relevanten Themen (fuer die Motivation).
  final int offeneFragen;
  final int relevanteThemen;
  final int bestandeneThemen;

  const Tagesplan({
    required this.posten,
    required this.tagesziel,
    required this.heuteFragen,
    required this.offeneFragen,
    required this.relevanteThemen,
    required this.bestandeneThemen,
  });

  bool get allesFertig => posten.isNotEmpty && posten.every((p) => p.fertig);
  int get fertigeposten => posten.where((p) => p.fertig).length;
}

class _ThemaStatus {
  final int themaId;
  final String themaName;
  final int modulId;
  final String modulName;
  final int requiredScore;
  final int fragen;
  final double? bestScore;
  final int heute;
  final DateTime? zuletzt;
  final bool ap1, ap2Ae, ap2Si;

  _ThemaStatus.fromJson(Map<String, dynamic> j)
      : themaId = (j['thema_id'] as num).toInt(),
        themaName = j['thema_name'] as String? ?? '',
        modulId = (j['modul_id'] as num).toInt(),
        modulName = j['modul_name'] as String? ?? '',
        requiredScore = (j['required_score'] as num?)?.toInt() ?? 80,
        fragen = (j['fragen'] as num?)?.toInt() ?? 0,
        bestScore = (j['best_score'] as num?)?.toDouble(),
        heute = (j['heute'] as num?)?.toInt() ?? 0,
        zuletzt = DateTime.tryParse(j['zuletzt'] as String? ?? ''),
        ap1 = j['ap1'] as bool? ?? true,
        ap2Ae = j['ap2_ae'] as bool? ?? true,
        ap2Si = j['ap2_si'] as bool? ?? true;

  bool get bestanden => (bestScore ?? 0) >= requiredScore;
  bool get nieGespielt => bestScore == null && zuletzt == null;

  /// Wie viele Fragen hier noch "offen" sind: nie gespielt = alle, sonst
  /// der fehlende Anteil bis zum Ziel, mindestens 5.
  int get offen {
    if (fragen == 0 || bestanden) return 0;
    if (nieGespielt) return fragen;
    final fehlt = (requiredScore - (bestScore ?? 0)) / 100;
    return max(5, (fragen * fehlt).ceil()).clamp(0, fragen);
  }

  bool relevantFuer(PruefungsZiel? ziel) {
    if (ziel == null) return true;
    if (ziel.pruefung == 'AP1') return ap1;
    return ziel.fachrichtung == 'AE' ? ap2Ae : ap2Si;
  }
}

class LernplanService {
  LernplanService._();
  static final LernplanService _instance = LernplanService._();
  factory LernplanService() => _instance;

  Tagesplan? _plan;
  DateTime? _geladenAm;

  Tagesplan? get plan => _plan;

  /// Laedt den Status vom Server und berechnet den Plan. Ein frisches
  /// Ergebnis (juenger als 2 Minuten, gleicher Tag) wird wiederverwendet,
  /// damit der Hub bei jedem Tab-Wechsel nicht neu abfragt; [neu] erzwingt.
  Future<Tagesplan?> laden({bool neu = false}) async {
    final heute = DateTime.now();
    final h = DateTime(heute.year, heute.month, heute.day);
    final frisch = _geladenAm != null &&
        !_geladenAm!.isBefore(h) &&
        heute.difference(_geladenAm!) < const Duration(minutes: 2);
    if (!neu && _plan != null && frisch) return _plan;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    try {
      final res = await Supabase.instance.client.rpc(
        'lernplan_status',
        params: {'p_tagesbeginn': h.toUtc().toIso8601String()},
      );
      final json = res is Map<String, dynamic> ? res : Map<String, dynamic>.from(res as Map);
      _plan = _berechnen(json, ZielService().ziel);
      _geladenAm = DateTime.now();
    } catch (e) {
      debugPrint('LernplanService.laden: $e');
    }
    return _plan;
  }

  void zuruecksetzen() {
    _plan = null;
    _geladenAm = null;
  }

  Tagesplan _berechnen(Map<String, dynamic> json, PruefungsZiel? ziel) {
    final themen = [
      for (final t in (json['themen'] as List? ?? const []))
        _ThemaStatus.fromJson(Map<String, dynamic>.from(t as Map)),
    ].where((t) => t.fragen > 0 && t.relevantFuer(ziel)).toList();

    final heuteFragen = (json['heute_fragen'] as num?)?.toInt() ?? 0;
    final faellig = (json['faellig'] as num?)?.toInt() ?? 0;
    final heuteWiederholt = (json['heute_wiederholt'] as num?)?.toInt() ?? 0;
    final heutePruefung = json['heute_pruefung'] == true;
    final letztePruefung = DateTime.tryParse(json['letzte_pruefung'] as String? ?? '');

    final offen = themen.fold<int>(0, (s, t) => s + t.offen);
    final bestanden = themen.where((t) => t.bestanden).length;
    final tage = ziel?.tageBis;
    final vorbei = tage != null && tage < 0;

    // Tagesziel
    int tagesziel;
    if (tage == null || vorbei) {
      tagesziel = 15;
    } else {
      tagesziel = (offen / max(tage, 1)).ceil().clamp(10, 40);
    }

    final endspurt = tage != null && !vorbei && tage <= 3;
    final letzteWoche = tage != null && !vorbei && tage <= 7;
    final posten = <LernPosten>[];

    // 1. Wiederholungen (immer zuerst, wenn faellig)
    final wiederholZiel = faellig > 0 ? min(faellig, 20) : 0;
    if (wiederholZiel > 0 || heuteWiederholt > 0) {
      final z = max(wiederholZiel, min(heuteWiederholt, 20));
      posten.add(LernPosten(
        typ: PostenTyp.wiederholen,
        titel: '$z Wiederholungen',
        untertitel: faellig > 0
            ? '$faellig fällig'
            : 'Alles wiederholt',
        ziel: z,
        erledigt: min(heuteWiederholt, z),
      ));
    }

    // 2. Thema (nicht im Endspurt, ausser es ist nichts faellig)
    final kandidat = _schwaechstesThema(themen);
    if (kandidat != null && (!endspurt || wiederholZiel == 0)) {
      final restZiel = max(8, tagesziel - wiederholZiel);
      final n = min(restZiel, kandidat.fragen).clamp(5, 25);
      posten.add(LernPosten(
        typ: PostenTyp.thema,
        titel: endspurt ? 'Auffrischen: ${kandidat.themaName}' : '$n Fragen ${kandidat.themaName}',
        untertitel: kandidat.bestScore == null
            ? '${kandidat.modulName} · ${kandidat.nieGespielt ? 'noch nicht gespielt' : 'angefangen'}'
            : '${kandidat.modulName} · bisher ${kandidat.bestScore!.round()} % von ${kandidat.requiredScore} %',
        ziel: n,
        erledigt: min(kandidat.heute, n),
        modulId: kandidat.modulId,
        modulName: kandidat.modulName,
        themaId: kandidat.themaId,
        themaName: kandidat.themaName,
        requiredScore: kandidat.requiredScore,
      ));
    }

    // 3. Uebungspruefung: alle 7 Tage, in der letzten Woche taeglich
    final tageSeitPruefung = letztePruefung == null
        ? 99
        : DateTime.now().difference(letztePruefung).inDays;
    final pruefungDran = !vorbei && (letzteWoche || tageSeitPruefung >= 7 || heutePruefung);
    if (pruefungDran) {
      posten.add(LernPosten(
        typ: PostenTyp.pruefung,
        titel: '1 Übungsprüfung',
        untertitel: letzteWoche
            ? 'Letzte Woche: jeden Tag eine Simulation'
            : letztePruefung == null
                ? 'Noch keine Simulation gemacht'
                : 'Letzte vor $tageSeitPruefung Tagen',
        ziel: 1,
        erledigt: heutePruefung ? 1 : 0,
      ));
    }

    return Tagesplan(
      posten: posten,
      tagesziel: tagesziel,
      // Wiederholungen sind fuer den Nutzer auch "beantwortete Fragen":
      // in den Tagesbalken zaehlen beide.
      heuteFragen: heuteFragen + heuteWiederholt,
      offeneFragen: offen,
      relevanteThemen: themen.length,
      bestandeneThemen: bestanden,
    );
  }

  /// Reihenfolge: angefangene, nicht bestandene Themen (schlechteste Quote
  /// zuerst) vor nie gespielten; unter den nie gespielten bevorzugt Module,
  /// in denen der Nutzer schon gespielt hat (sort_index-Reihenfolge kommt
  /// von der RPC), damit der Plan nicht quer durch alle Module springt.
  _ThemaStatus? _schwaechstesThema(List<_ThemaStatus> themen) {
    final offen = themen.where((t) => !t.bestanden).toList();
    if (offen.isEmpty) return null;
    final angefangen = offen.where((t) => !t.nieGespielt).toList()
      ..sort((a, b) => (a.bestScore ?? 0).compareTo(b.bestScore ?? 0));
    if (angefangen.isNotEmpty) return angefangen.first;
    final gespielteModule = themen.where((t) => !t.nieGespielt).map((t) => t.modulId).toSet();
    for (final t in offen) {
      if (gespielteModule.contains(t.modulId)) return t;
    }
    return offen.first;
  }
}
