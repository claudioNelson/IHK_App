// lib/widgets/kurs/ada_kontext.dart
//
// Baut den Text, den Ada im Kurs über die aktuelle Seite bekommt.
//
// Vorher bekam Ada nur `aufgabe.frage`. Bei Aufgaben wie „Welche Zeile
// ist falsch?", „Fülle die Lücken" oder „Was gibt das Struktogramm oben
// aus?" fehlte ihr damit alles Wesentliche: Code, Lücken, Optionen,
// Tabellen, Diagramme. Folge: Ada wusste nicht, worum es geht, obwohl
// im Sheet „Sie kennt deine aktuelle Aufgabe" stand (Play-Bewertung
// 27.09.2026, 2 Sterne).
//
// Jetzt bekommt Ada:
// - die Aufgabe mit allem, was der Azubi sieht (Code, Lücken, Optionen,
//   Tabellen, Diagramme auf der Seite),
// - die Erklärseite direkt davor (dort stehen meist das Struktogramm oder
//   der Code, auf die sich die Frage bezieht),
// - die Lösung, markiert als „nur für dich". Ada verrät sie laut Prompt
//   nicht ungefragt, kann sie aber auf ausdrückliche Nachfrage korrekt
//   nennen, statt zu raten.
//
// Reine Textaufbereitung ohne Zustand, damit sie leicht testbar bleibt.

import 'dart:math' as math;
import 'dart:ui' show Offset, Rect;

import '../../data/kurse/sql_datensaetze.dart';
import '../../models/kurs_aufgabe.dart';
import '../../models/struktogramm.dart';
import '../../models/uml.dart';

/// Obergrenzen je Abschnitt in Zeichen. Die Edge Function lehnt Gespräche
/// über 20.000 Zeichen ab (Kontext + Prompt + Verlauf). Zusammen höchstens
/// 11.000, damit genug Platz für den Verlauf bleibt; das Sheet kürzt den
/// Verlauf zusätzlich (ada_kurs_sheet.dart).
const int _maxDavor = 3000;
const int _maxMaterial = 3000;
const int _maxAufgabe = 3000;
const int _maxLoesung = 2000;
const int _maxSeite = 5000;

/// Kontext für Ada zu Schritt [index] der Lektion.
///
/// `aufgabe` ist gesetzt, wenn der Schritt eine Aufgabe ist, `seite`, wenn
/// es eine reine Erklärseite ist. Beide null auf der Abschlussseite.
({String? aufgabe, String? seite}) adaKontextFuerSchritt(
  List<List<LektionsBlock>> schritte,
  int index,
) {
  if (index < 0 || index >= schritte.length) {
    return (aufgabe: null, seite: null);
  }
  final schritt = schritte[index];
  final letzter = schritt.isEmpty ? null : schritt.last;

  if (letzter is! AufgabenBlock) {
    return (
      aufgabe: null,
      seite: _kuerzen(_bloeckeAlsText(schritt), _maxSeite),
    );
  }

  final teile = <String>[];

  // Erklärseite direkt davor, falls es keine Aufgabe ist.
  if (index > 0) {
    final davor = schritte[index - 1];
    if (davor.isNotEmpty && davor.last is! AufgabenBlock) {
      final text = _bloeckeAlsText(davor);
      if (text.isNotEmpty) {
        teile.add('ERKLÄRSEITE DIREKT DAVOR (darauf bezieht sich die '
            'Aufgabe oft, z. B. „das Programm oben"):\n'
            '${_kuerzen(text, _maxDavor)}');
      }
    }
  }

  // Material auf der Aufgabenseite selbst (Überschrift, UML-Diagramm).
  final material =
      _bloeckeAlsText(schritt.sublist(0, schritt.length - 1));
  if (material.isNotEmpty) {
    teile.add(
        'AUF DER AUFGABENSEITE:\n${_kuerzen(material, _maxMaterial)}');
  }

  final a = letzter.aufgabe;
  teile.add('AUFGABE (das sieht der Azubi gerade):\n'
      '${_kuerzen(_aufgabeAlsText(a), _maxAufgabe)}');
  teile.add('LÖSUNG (nur für dich, nicht ungefragt verraten):\n'
      '${_kuerzen(_loesungAlsText(a), _maxLoesung)}');

  return (aufgabe: teile.join('\n\n'), seite: null);
}

// ───────────────────────────────────────────────────────────────────────────
// Blöcke
// ───────────────────────────────────────────────────────────────────────────

String _bloeckeAlsText(List<LektionsBlock> bloecke) {
  final out = <String>[];
  for (final b in bloecke) {
    switch (b) {
      case UeberschriftBlock():
        out.add('## ${b.text}');
      case TextBlock():
        out.add(b.text);
      case HinweisBlock():
        out.add('Hinweis: ${b.text}');
      case CodeBlock():
        final titel = b.titel != null ? ' (${b.titel})' : '';
        out.add('Code ${b.sprache}$titel:\n```\n${b.code}\n```');
      case StruktogrammBlock():
        final titel = b.titel != null ? ' „${b.titel}"' : '';
        final unter = b.unterschrift != null ? '\n(${b.unterschrift})' : '';
        out.add('Struktogramm$titel, als Pseudocode von oben nach unten:\n'
            '${_struktogrammAlsText(b.bloecke, 1)}$unter');
      case SchreibtischtestBlock():
        final unter = b.unterschrift != null ? '\n(${b.unterschrift})' : '';
        out.add('Schreibtischtest (Wertetabelle):\n'
            '${b.spalten.join(' | ')}\n'
            '${b.zeilen.map((z) => z.join(' | ')).join('\n')}$unter');
      case UmlBlock():
        final unter = b.unterschrift != null ? '\n(${b.unterschrift})' : '';
        out.add('${_umlAlsText(b.diagramm)}$unter');
      case AufgabenBlock():
        // Frühere Aufgaben auf derselben Seite gibt es durch die
        // Aufteilung nicht; zur Sicherheit nur die Frage nennen.
        out.add('Aufgabe: ${b.aufgabe.frage}');
    }
  }
  return out.join('\n\n').trim();
}

// ───────────────────────────────────────────────────────────────────────────
// Aufgaben
// ───────────────────────────────────────────────────────────────────────────

String _aufgabeAlsText(KursAufgabe a) {
  final out = StringBuffer(a.frage);
  switch (a) {
    case LueckenAufgabe():
      out.write('\n\nLückentext (jede ___ ist eine Lücke, '
          '${a.anzahlLuecken} Stück):\n```\n${a.vorlage}\n```');
      if (a.bausteine.isNotEmpty) {
        out.write('\nAntippbare Bausteine: ${a.bausteine.join(', ')}');
      }
    case ReihenfolgeAufgabe():
      // Der Azubi sieht die Zeilen gemischt. Hier alphabetisch, damit die
      // Reihenfolge nicht schon die Lösung verrät.
      final gemischt = [...a.zeilen]..sort();
      out.write('\n\nDer Azubi soll diese Zeilen in die richtige '
          'Reihenfolge ziehen:\n${gemischt.map((z) => '- $z').join('\n')}');
    case FehlerAufgabe():
      out.write('\n\nCode mit einem Fehler (Zeilennummern zur '
          'Orientierung):\n```\n');
      for (var i = 0; i < a.zeilen.length; i++) {
        out.write('${i + 1}: ${a.zeilen[i]}\n');
      }
      out.write('```\nDer Azubi tippt die fehlerhafte Zeile an und '
          'schreibt sie richtig.');
      if (a.tipp != null) out.write('\nTipp in der App: ${a.tipp}');
    case AuswahlAufgabe():
      out.write('\n\nAntwortmöglichkeiten:');
      for (var i = 0; i < a.optionen.length; i++) {
        out.write('\n${_buchstabe(i)}) ${a.optionen[i]}');
      }
    case SqlAufgabe():
      final ds = sqlDatensaetze[a.datensatz];
      if (ds != null) {
        out.write('\n\nDatenbank „${ds.titel}": ${ds.beschreibung}\n'
            'Tabellen und Spalten:');
        for (final e in ds.tabellen.entries) {
          out.write('\n- ${e.key}(${e.value.join(', ')})');
        }
      }
      out.write('\nDer Azubi schreibt eine SQL-Abfrage, geprüft wird das '
          'Ergebnis, nicht der Wortlaut.');
      if (a.bausteinModus) {
        out.write('\nAntippbare Bausteine: ${a.bausteine.join('  ')}');
      } else if (a.startCode.trim().isNotEmpty) {
        out.write('\nStartinhalt im Editor: ${a.startCode}');
      }
      if (a.reihenfolgeZaehlt) {
        out.write('\nDie Reihenfolge der Zeilen zählt.');
      }
      if (a.tipp != null) out.write('\nTipp in der App: ${a.tipp}');
  }
  return out.toString();
}

String _loesungAlsText(KursAufgabe a) {
  final out = StringBuffer();
  switch (a) {
    case LueckenAufgabe():
      for (var i = 0; i < a.loesungen.length; i++) {
        final l = a.loesungen[i];
        out.write('Lücke ${i + 1}: ${l.isEmpty ? '?' : l.first}');
        if (l.length > 1) out.write(' (auch ok: ${l.skip(1).join(', ')})');
        out.write('\n');
      }
    case ReihenfolgeAufgabe():
      out.write('Richtige Reihenfolge:\n');
      for (var i = 0; i < a.zeilen.length; i++) {
        out.write('${'  ' * a.tiefe(i)}${a.zeilen[i]}\n');
      }
    case FehlerAufgabe():
      final korrektur = a.korrekturen.isEmpty ? '?' : a.korrekturen.first;
      out.write('Fehler in Zeile ${a.fehlerZeile + 1}. '
          'Richtig: $korrektur\n');
    case AuswahlAufgabe():
      final ok = a.richtig >= 0 && a.richtig < a.optionen.length;
      out.write(ok
          ? 'Richtig ist ${_buchstabe(a.richtig)}) ${a.optionen[a.richtig]}\n'
          : 'Richtige Option unbekannt.\n');
    case SqlAufgabe():
      out.write('Musterlösung:\n```sql\n${a.musterloesung}\n```\n');
  }
  if (a.erklaerung != null && a.erklaerung!.trim().isNotEmpty) {
    out.write('Erklärung: ${a.erklaerung}');
  }
  return out.toString().trim();
}

String _buchstabe(int i) => String.fromCharCode(65 + i);

/// Kürzt auf [max] Zeichen, möglichst an einem Zeilenende.
String _kuerzen(String text, int max) {
  if (text.length <= max) return text;
  final ende = text.lastIndexOf('\n', max);
  final schnitt = ende > max ~/ 2 ? ende : max;
  return '${text.substring(0, schnitt)}\n[gekürzt]';
}

// ───────────────────────────────────────────────────────────────────────────
// Struktogramm als eingerückter Pseudocode
// ───────────────────────────────────────────────────────────────────────────

String _struktogrammAlsText(List<SgBlock> bloecke, int tiefe) {
  final rand = '  ' * tiefe;
  final out = <String>[];
  if (bloecke.isEmpty) {
    out.add('$rand(leer)');
  }
  for (final b in bloecke) {
    switch (b) {
      case SgAnw():
        out.add('$rand${b.text}');
      case SgAufruf():
        out.add('${rand}AUFRUF ${b.text}');
      case SgLuecke():
        out.add('$rand[LÜCKE ${b.marke}]');
      case SgWenn():
        out.add('${rand}WENN ${b.bedingung}');
        out.add('$rand  ${b.jaText}:');
        out.add(_struktogrammAlsText(b.ja, tiefe + 2));
        out.add('$rand  ${b.neinText}:');
        out.add(_struktogrammAlsText(b.nein, tiefe + 2));
      case SgFalls():
        out.add('${rand}FALLS ${b.ausdruck}');
        for (final f in b.faelle) {
          out.add('$rand  = ${f.wert}:');
          out.add(_struktogrammAlsText(f.bloecke, tiefe + 2));
        }
        if (b.sonst != null) {
          out.add('$rand  sonst:');
          out.add(_struktogrammAlsText(b.sonst!, tiefe + 2));
        }
      case SgSolange():
        out.add('${rand}SOLANGE ${b.bedingung} (kopfgesteuert)');
        out.add(_struktogrammAlsText(b.rumpf, tiefe + 1));
      case SgWiederhole():
        out.add('${rand}WIEDERHOLE (fußgesteuert)');
        out.add(_struktogrammAlsText(b.rumpf, tiefe + 1));
        out.add('$rand${b.bis ? 'BIS' : 'SOLANGE'} ${b.bedingung}');
      case SgFuer():
        out.add('$rand${b.kopf} (Zählschleife)');
        out.add(_struktogrammAlsText(b.rumpf, tiefe + 1));
    }
  }
  return out.join('\n');
}

// ───────────────────────────────────────────────────────────────────────────
// UML als Text
// ───────────────────────────────────────────────────────────────────────────

class _Knoten {
  final String name;
  final Rect flaeche;
  const _Knoten(this.name, this.flaeche);
}

/// Beschreibt ein UML-Diagramm in Worten. Die Diagramme haben nur
/// Koordinaten, keine Verweise; Kanten und Pfeile werden deshalb dem
/// Element zugeordnet, an dem ihr Start- bzw. Endpunkt liegt.
String _umlAlsText(UmlDiagramm d) {
  final knoten = <_Knoten>[];
  final elemente = <String>[];
  final verbindungen = <String>[];

  for (final e in d.elemente) {
    switch (e) {
      case UmlKlasse():
        final art = e.objekt
            ? 'Objekt'
            : e.stereotyp != null
                ? 'Klasse ${e.stereotyp}'
                : e.abstrakt
                    ? 'Abstrakte Klasse'
                    : 'Klasse';
        final z = StringBuffer('- $art ${e.name}');
        if (e.attribute != null && e.attribute!.isNotEmpty) {
          z.write('\n    Attribute: ${e.attribute!.join('; ')}');
        }
        if (e.methoden != null && e.methoden!.isNotEmpty) {
          z.write('\n    Methoden: ${e.methoden!.join('; ')}');
        }
        elemente.add(z.toString());
        knoten.add(
            _Knoten(e.name, Rect.fromLTWH(e.x, e.y, e.b, e.hoehe)));
      case UmlAkteur():
        elemente.add('- Akteur ${e.name}');
        knoten.add(_Knoten(
            'Akteur ${e.name}', Rect.fromLTWH(e.x - 25, e.y, 50, 72)));
      case UmlUseCase():
        final t = _einzeilig(e.text);
        elemente.add('- Anwendungsfall „$t"');
        knoten.add(_Knoten(
            '„$t"',
            Rect.fromCenter(
                center: Offset(e.cx, e.cy),
                width: e.rx * 2,
                height: e.ry * 2)));
      case UmlRahmen():
        if (e.titel.trim().isNotEmpty) {
          elemente.add(e.fragment
              ? '- Fragment ${e.titel}'
              : '- Rahmen/Systemgrenze „${e.titel}"');
        }
      case UmlStart():
        knoten.add(_Knoten('Start', Rect.fromCircle(
            center: Offset(e.x, e.y), radius: 9)));
      case UmlEnde():
        knoten.add(_Knoten('Ende', Rect.fromCircle(
            center: Offset(e.x, e.y), radius: 11)));
      case UmlAblaufende():
        knoten.add(_Knoten('Ablaufende', Rect.fromCircle(
            center: Offset(e.x, e.y), radius: 10)));
      case UmlAktion():
        final t = _einzeilig(e.text);
        final zusatz =
            e.zusatz.isEmpty ? '' : ' (${e.zusatz.join('; ')})';
        elemente.add(e.zustand
            ? '- Zustand „$t"$zusatz'
            : '- Aktion „$t"');
        knoten.add(_Knoten('„$t"', Rect.fromLTWH(e.x, e.y, e.b, e.h)));
      case UmlRaute():
        knoten.add(_Knoten('Raute (Entscheidung/Zusammenführung)',
            Rect.fromCircle(center: Offset(e.x, e.y), radius: 16)));
      case UmlBalken():
        knoten.add(_Knoten('Balken (Gabelung/Vereinigung)',
            Rect.fromLTRB(math.min(e.x1, e.x2), e.y - 4,
                math.max(e.x1, e.x2), e.y + 4)));
      case UmlLebenslinie():
        elemente.add('- Lebenslinie ${e.name}');
        knoten.add(_Knoten(e.name,
            Rect.fromLTRB(e.x - e.b / 2, e.y, e.x + e.b / 2, e.bis)));
      case UmlText():
        elemente.add('- Text: ${_einzeilig(e.text)}');
      case UmlNotiz():
        elemente.add('- Notiz: ${_einzeilig(e.text)}');
      case UmlAktivierung():
        break;
      case UmlKante():
      case UmlPfeil():
        break; // zweiter Durchlauf, wenn alle Knoten bekannt sind
    }
  }

  for (final e in d.elemente) {
    if (e is UmlKante && e.punkte.length >= 2) {
      final von = _knotenAn(knoten, e.punkte.first);
      final nach = _knotenAn(knoten, e.punkte.last);
      final z = StringBuffer('- ${_kantenName(e.art)}: $von → $nach');
      if (e.von != null || e.nach != null) {
        z.write(' (Multiplizität ${e.von ?? '-'} zu ${e.nach ?? '-'})');
      }
      if (e.rolleVon != null || e.rolleNach != null) {
        z.write(' (Rollen ${e.rolleVon ?? '-'} / ${e.rolleNach ?? '-'})');
      }
      if (e.name != null) z.write(' „${e.name}"');
      verbindungen.add(z.toString());
    } else if (e is UmlPfeil && e.punkte.length >= 2) {
      final von = _knotenAn(knoten, e.punkte.first);
      final nach = _knotenAn(knoten, e.punkte.last);
      final art = e.gestrichelt ? 'gestrichelter Pfeil' : 'Pfeil';
      final text = e.text != null ? ' „${_einzeilig(e.text!)}"' : '';
      verbindungen.add('- $art: $von → $nach$text');
    }
  }

  final out = StringBuffer('UML-Diagramm: ${d.beschreibung}');
  if (elemente.isNotEmpty) {
    out.write('\nElemente:\n${elemente.join('\n')}');
  }
  if (verbindungen.isNotEmpty) {
    out.write('\nVerbindungen (in Zeichenreihenfolge):\n'
        '${verbindungen.join('\n')}');
  }
  return out.toString();
}

/// Element, an dem [p] liegt: das kleinste, dessen Fläche (mit etwas
/// Spielraum) den Punkt enthält, sonst das mit dem nächsten Mittelpunkt.
String _knotenAn(List<_Knoten> knoten, Offset p) {
  if (knoten.isEmpty) return '?';
  _Knoten? treffer;
  for (final k in knoten) {
    if (k.flaeche.inflate(14).contains(p)) {
      if (treffer == null ||
          _inhalt(k.flaeche) < _inhalt(treffer.flaeche)) {
        treffer = k;
      }
    }
  }
  if (treffer != null) return treffer.name;
  var best = knoten.first;
  var bestAbstand = double.infinity;
  for (final k in knoten) {
    final d = (k.flaeche.center - p).distance;
    if (d < bestAbstand) {
      bestAbstand = d;
      best = k;
    }
  }
  return best.name;
}

double _inhalt(Rect r) => r.width * r.height;

String _einzeilig(String s) => s.replaceAll(RegExp(r'\s*\n\s*'), ' ').trim();

String _kantenName(UmlKantenArt art) => switch (art) {
      UmlKantenArt.assoziation => 'Assoziation',
      UmlKantenArt.gerichtet => 'Gerichtete Assoziation',
      UmlKantenArt.abhaengigkeit => 'Abhängigkeit',
      UmlKantenArt.aggregation => 'Aggregation (Ganzes → Teil)',
      UmlKantenArt.komposition => 'Komposition (Ganzes → Teil)',
      UmlKantenArt.vererbung => 'Vererbung (Unterklasse → Oberklasse)',
      UmlKantenArt.realisierung => 'Realisierung (Klasse → Interface)',
    };
