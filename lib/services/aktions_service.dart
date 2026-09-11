// lib/services/aktions_service.dart
//
// Zeitlich begrenzte Angebote ("Pruefungs-Endspurt"). Quelle ist die
// Tabelle aktionen (Migration 20260910020000); die RLS-Policy liefert nur
// aktive Zeilen im Gueltigkeitszeitraum, der Client filtert nicht selbst.
//
// Der Rabatt selbst steckt in den Stores (Apple Einfuehrungsangebot,
// Google Angebot auf dem Base Plan); die Tabelle steuert nur, OB und mit
// welchem Text die App auf die Aktion hinweist. So laesst sich eine Aktion
// ohne Release beenden oder zur naechsten Pruefung wieder einschalten.
//
// Einmal pro Sitzung geladen; nach Ablauf der Aktion greift beim naechsten
// App-Start die Policy.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Aktion {
  final String schluessel;
  final String titel;
  final String text;
  final String? hinweis;

  /// 'monthly' | 'half-year' | 'annual' | null (planunabhaengig)
  final String? plan;
  final DateTime gueltigBis;

  const Aktion({
    required this.schluessel,
    required this.titel,
    required this.text,
    required this.gueltigBis,
    this.hinweis,
    this.plan,
  });

  /// Kalendertage bis zum letzten Aktionstag (heute = 0).
  int get tageBis {
    final heute = DateTime.now();
    final h = DateTime(heute.year, heute.month, heute.day);
    return DateTime(gueltigBis.year, gueltigBis.month, gueltigBis.day)
        .difference(h)
        .inDays;
  }

  /// Kurzform fuer Chips: "NOCH 3 TAGE" / "LETZTER TAG" / "BIS 30.09."
  String get fristLabel {
    final t = tageBis;
    if (t <= 0) return 'LETZTER TAG';
    if (t <= 7) return 'NOCH $t ${t == 1 ? 'TAG' : 'TAGE'}';
    return 'BIS ${gueltigBis.day.toString().padLeft(2, '0')}.${gueltigBis.month.toString().padLeft(2, '0')}.';
  }
}

class AktionsService {
  AktionsService._();
  static final AktionsService _instance = AktionsService._();
  factory AktionsService() => _instance;

  Aktion? _aktion;
  bool _geladen = false;

  /// Aktuell laufende Aktion (nach [laden]), sonst null.
  Aktion? get aktion => _aktion;

  /// Aktion fuer einen bestimmten Plan (oder planunabhaengig).
  Aktion? fuerPlan(String plan) {
    final a = _aktion;
    if (a == null) return null;
    if (a.plan == null || a.plan == plan) return a;
    return null;
  }

  Future<Aktion?> laden({bool neu = false}) async {
    if (_geladen && !neu) return _aktion;
    try {
      final rows = await Supabase.instance.client
          .from('aktionen')
          .select('schluessel, titel, text, hinweis, plan, gueltig_bis')
          .order('gueltig_bis')
          .limit(1);
      final list = rows as List;
      if (list.isEmpty) {
        _aktion = null;
      } else {
        final r = list.first as Map<String, dynamic>;
        final bis = DateTime.tryParse(r['gueltig_bis'] as String? ?? '');
        _aktion = bis == null
            ? null
            : Aktion(
                schluessel: r['schluessel'] as String,
                titel: r['titel'] as String,
                text: r['text'] as String,
                hinweis: r['hinweis'] as String?,
                plan: r['plan'] as String?,
                gueltigBis: bis,
              );
      }
      _geladen = true;
    } catch (e) {
      // Kein Netz o. ae.: keine Aktion anzeigen, beim naechsten Aufruf neu
      // versuchen.
      debugPrint('AktionsService.laden: $e');
      _aktion = null;
    }
    return _aktion;
  }
}
