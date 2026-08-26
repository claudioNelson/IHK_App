// lib/services/bereitschafts_service.dart
//
// Pruefungsbereitschaft: EIN verstaendlicher Wert fuers Profil.
//
// Statt einzelner Zahlen ohne Kontext wird der Lernstand je BEREICH
// gemessen und als Prozent angezeigt:
//   Lernmodule  = gemeisterte Themen / alle Themen (thema_scores,
//                 gemeistert ab required_score, Standard 80)
//   Levels      = geschaffte Levels / alle Levels (level_progress,
//                 geschafft ab Schwelle des Levels)
//   SQL-Kurs    = geloeste Aufgaben / alle Aufgaben (kurs_fortschritt)
//   Python-Kurs = geloeste Aufgaben / alle Aufgaben (kurs_fortschritt)
//
// Die Gesamt-Bereitschaft ist der Durchschnitt der Bereichs-Prozente
// (jeder Bereich zaehlt gleich viel). So passt die grosse Zahl immer
// zu den vier kleinen, die man in der Aufschluesselung sieht.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/kurse/python_kurs.dart';
import '../data/kurse/sql_kurs.dart';
import '../models/kurs_aufgabe.dart';
import 'kurs_fortschritt_service.dart';

class BereitschaftsBereich {
  final String schluessel; // 'module' | 'levels' | 'sql' | 'python'
  final String name;
  final int gesamt;
  final int geschafft;

  const BereitschaftsBereich({
    required this.schluessel,
    required this.name,
    required this.gesamt,
    required this.geschafft,
  });

  double get anteil => gesamt == 0 ? 0 : geschafft / gesamt;
  int get prozent => (anteil * 100).round();
}

class Bereitschaft {
  final List<BereitschaftsBereich> bereiche;

  const Bereitschaft(this.bereiche);

  /// Durchschnitt der Bereichs-Prozente, jeder Bereich gleich gewichtet.
  double get anteil {
    if (bereiche.isEmpty) return 0;
    final summe = bereiche.fold<double>(0, (s, b) => s + b.anteil);
    return summe / bereiche.length;
  }

  int get prozent => (anteil * 100).round();
}

class BereitschaftsService {
  final _client = Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  Future<Bereitschaft?> laden() async {
    final userId = _userId;
    if (userId == null) return null;

    try {
      final ergebnisse = await Future.wait<dynamic>([
        // Nur Module, die auch auf der Lernmodule-Seite stehen
        // (gleiche Filterung wie modul_liste_screen)
        _client.from('module').select('id').neq('kategorie', 'kernthema'),
        // Themen + beste Scores fuer den Modul-Bereich
        _client.from('themen').select('id, module_id, required_score'),
        _client
            .from('thema_scores')
            .select('modul_id, thema_id, best_score')
            .eq('user_id', userId),
        // Levels + Fortschritt
        _client.from('levels').select('id, schwelle'),
        _client
            .from('level_progress')
            .select('level_id, best_score')
            .eq('user_id', userId),
        // Kurs-Fortschritt kommt aus dem lokalen Service (der ist mit
        // der Cloud-Tabelle kurs_fortschritt synchronisiert)
        KursFortschrittService.instance.laden(),
      ]);

      final moduleIds = (ergebnisse[0] as List<dynamic>)
          .map((m) => m['id'] as int)
          .toSet();
      final themen = ergebnisse[1] as List<dynamic>;
      final scores = ergebnisse[2] as List<dynamic>;
      final levels = ergebnisse[3] as List<dynamic>;
      final levelProgress = ergebnisse[4] as List<dynamic>;

      return Bereitschaft([
        _bereichModule(moduleIds, themen, scores),
        _bereichLevels(levels, levelProgress),
        _bereichKurs('sql', 'SQL-Kurs', sqlKurs),
        _bereichKurs('python', 'Python-Kurs', pythonKurs),
      ]);
    } catch (e) {
      debugPrint('Bereitschaft laden fehlgeschlagen: $e');
      return null;
    }
  }

  BereitschaftsBereich _bereichModule(
    Set<int> moduleIds,
    List<dynamic> themen,
    List<dynamic> scoresRoh,
  ) {
    // Bester Score je (Modul, Thema). Achtung Spaltennamen: themen
    // verweist per module_id aufs Modul, thema_scores per modul_id.
    final scores = <String, double>{};
    for (final zeile in scoresRoh) {
      final key = '${zeile['modul_id']}_${zeile['thema_id']}';
      scores[key] = (zeile['best_score'] as num).toDouble();
    }

    var gesamt = 0;
    var gemeistert = 0;
    for (final thema in themen) {
      final modulId = thema['module_id'] as int?;
      final themaId = thema['id'] as int?;
      if (modulId == null || themaId == null) continue;
      if (!moduleIds.contains(modulId)) continue;
      gesamt++;
      final noetig = ((thema['required_score'] ?? 80) as num).toDouble();
      if ((scores['${modulId}_$themaId'] ?? 0) >= noetig) gemeistert++;
    }

    return BereitschaftsBereich(
      schluessel: 'module',
      name: 'Lernmodule',
      gesamt: gesamt,
      geschafft: gemeistert,
    );
  }

  BereitschaftsBereich _bereichLevels(
    List<dynamic> levels,
    List<dynamic> progressRoh,
  ) {
    final bestScores = <int, int>{};
    for (final zeile in progressRoh) {
      bestScores[zeile['level_id'] as int] =
          (zeile['best_score'] as num?)?.toInt() ?? 0;
    }

    var geschafft = 0;
    for (final level in levels) {
      final schwelle = ((level['schwelle'] ?? 80) as num).toInt();
      if ((bestScores[level['id'] as int] ?? 0) >= schwelle) geschafft++;
    }

    return BereitschaftsBereich(
      schluessel: 'levels',
      name: 'Levels',
      gesamt: levels.length,
      geschafft: geschafft,
    );
  }

  BereitschaftsBereich _bereichKurs(String schluessel, String name, Kurs kurs) {
    final ids = kurs.lektionen
        .expand((l) => l.aufgaben)
        .map((a) => a.id)
        .toList(growable: false);

    return BereitschaftsBereich(
      schluessel: schluessel,
      name: name,
      gesamt: ids.length,
      geschafft: KursFortschrittService.instance.geloestVon(ids),
    );
  }
}
