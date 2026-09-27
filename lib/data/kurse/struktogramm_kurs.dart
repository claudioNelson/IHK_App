// lib/data/kurse/struktogramm_kurs.dart
//
// Inhalt des Struktogramm-Kurses. Reine Daten wie beim SQL- und
// Python-Kurs, gezeichnet vom LektionScreen.
//
// Quelle ist der Web-Kurs unter web/app/struktogramm-kurs/ (8 Lektionen,
// zweimal begutachtet, Schreibtischtests nachgerechnet). Die Struktogramme
// stehen dort als Daten in derselben Form wie in models/struktogramm.dart
// und lassen sich fast Zeile für Zeile übernehmen.
//
// Stand 26.09.2026, Schritt 1 von 5 (Plan in
// claude/naechste-schritte-app-design.md): nur eine Vorschau-Lektion mit
// allen Bausteinen, um die Darstellung auf echten Geräten zu prüfen. Sie
// fliegt raus, sobald die echten Lektionen da sind. Der Kurs ist im
// Lern-Tab nur im Debug-Build sichtbar (kDebugMode in
// learning_hub_screen.dart), bis Release 1.8.0 fertig ist.

import '../../models/kurs_aufgabe.dart';
import '../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Beispiel-Struktogramme (aus dem Web-Kurs)
// ═══════════════════════════════════════════════════════════════════════════

/// Lektion 1: Notenbewertung.
const _bewertung = <SgBlock>[
  SgAnw('Eingabe punkte'),
  SgWenn(
    'punkte >= 50',
    [SgAnw('Ausgabe "bestanden"')],
    [SgAnw('Ausgabe "nicht bestanden"')],
  ),
];

/// Lektion 1: Summe von 1 bis n.
const _summe = <SgBlock>[
  SgAnw('Eingabe n'),
  SgAnw('summe = 0'),
  SgFuer('für i = 1 bis n', [SgAnw('summe = summe + i')]),
  SgAnw('Ausgabe summe'),
];

/// Mehrfachauswahl ohne „sonst“.
const _wochenende = <SgBlock>[
  SgAnw('Eingabe tag'),
  SgFalls('tag', [
    SgFall('6', [SgAnw('Ausgabe "Samstag"')]),
    SgFall('7', [SgAnw('Ausgabe "Sonntag"')]),
  ]),
];

/// Mehrfachauswahl mit „sonst“ in einer fußgesteuerten Schleife,
/// dazu Aufrufe in den Fällen. Breiter als ein Handy.
const _menue = <SgBlock>[
  SgAnw('ende = falsch'),
  SgWiederhole.bis('ende == wahr', [
    SgAnw('Ausgabe Menü'),
    SgAnw('Eingabe wahl'),
    SgFalls(
      'wahl',
      [
        SgFall('1', [SgAufruf('neuesSpiel()')]),
        SgFall('2', [SgAufruf('spielLaden()')]),
        SgFall('3', [SgAnw('ende = wahr')]),
      ],
      sonst: [SgAnw('Ausgabe "Ungültige Wahl"')],
    ),
  ]),
];

/// Unterprogramm mit Lücke und leerem Nein-Zweig.
const _maximum = <SgBlock>[
  SgAnw('max = zahlen[1]'),
  SgFuer('für i = 2 bis n', [
    SgWenn('zahlen[i] > max', [SgLuecke('1')]),
  ]),
  SgAnw('Rückgabe max'),
];

/// Fußgesteuert mit Fortsetzungsbedingung („solange“ unten).
const _eingabePruefen = <SgBlock>[
  SgWiederhole.solange('zahl < 1 ODER zahl > 10', [
    SgAnw('Ausgabe "Zahl von 1 bis 10:"'),
    SgAnw('Eingabe zahl'),
  ]),
  SgAnw('Ausgabe "Danke"'),
];

/// Bubblesort: drei Ebenen tief.
const _bubblesort = <SgBlock>[
  SgFuer('für i = 1 bis n - 1', [
    SgFuer('für j = 1 bis n - i', [
      SgWenn('zahlen[j] > zahlen[j + 1]', [
        SgAnw('tmp = zahlen[j]'),
        SgAnw('zahlen[j] = zahlen[j + 1]'),
        SgAnw('zahlen[j + 1] = tmp'),
      ]),
    ]),
  ]),
];

// ═══════════════════════════════════════════════════════════════════════════
// Vorschau-Lektion (nur zum Prüfen der Darstellung, nicht für den Release)
// ═══════════════════════════════════════════════════════════════════════════

const _vorschau = Lektion(
  nr: 1,
  slug: 'struktogramm-vorschau',
  titel: 'Vorschau: alle Bausteine',
  kurzbeschreibung:
      'Testseite für die Darstellung. Kommt so nicht in den Release.',
  dauerMinuten: 5,
  bloecke: [
    UeberschriftBlock('Sequenz und Verzweigung'),
    TextBlock(
      'Das Beispiel „Bewertung“ aus Lektion 1: eine Eingabe, dann eine '
      'Verzweigung.',
    ),
    StruktogrammBlock(
      _bewertung,
      titel: 'Bewertung',
      unterschrift:
          'Lies es von oben nach unten: erst die Eingabe, dann die Frage, '
          'dann je nach Antwort die linke oder die rechte Spalte.',
    ),
    UeberschriftBlock('Zählschleife'),
    StruktogrammBlock(
      _summe,
      titel: 'Summe von 1 bis n',
      unterschrift:
          'Die Zählschleife läuft für i = 1, 2, 3 bis n. Bei jedem Durchlauf '
          'kommt das aktuelle i zur Summe dazu.',
    ),
    UeberschriftBlock('Schreibtischtest'),
    TextBlock(
      'Dasselbe Struktogramm für n = 3, Zeile für Zeile. Hervorgehoben ist, '
      'was sich im jeweiligen Schritt geändert hat.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'n', 'i', 'summe', 'Ausgabe'],
      zeilen: [
        ['Eingabe', '3', '', '', ''],
        ['summe = 0', '3', '', '0', ''],
        ['Durchlauf 1', '3', '1', '1', ''],
        ['Durchlauf 2', '3', '2', '3', ''],
        ['Durchlauf 3', '3', '3', '6', ''],
        ['Ende', '3', '4', '6', '6'],
      ],
      unterschrift:
          'Am Ende steht i auf 4. Weil 4 größer als n ist, endet die '
          'Schleife, und die Summe 6 wird ausgegeben.',
    ),
    UeberschriftBlock('Die Grundformen, kompakt'),
    StruktogrammBlock(
      [SgAnw('x = 5'), SgAnw('Ausgabe x')],
      klein: true,
      unterschrift: 'Sequenz',
    ),
    StruktogrammBlock(
      [
        SgWenn(
          'x > 0',
          [SgAnw('Ausgabe "positiv"')],
          [SgAnw('Ausgabe "nicht positiv"')],
        ),
      ],
      klein: true,
      unterschrift: 'Verzweigung',
    ),
    StruktogrammBlock(
      [
        SgSolange('x < 10', [SgAnw('x = x + 1')]),
      ],
      klein: true,
      unterschrift: 'Kopfgesteuerte Schleife',
    ),
    StruktogrammBlock(
      [
        SgWiederhole.bis('x >= 10', [SgAnw('x = x + 1')]),
      ],
      klein: true,
      unterschrift: 'Fußgesteuerte Schleife',
    ),
    StruktogrammBlock(
      [
        SgFuer('für i = 1 bis 5', [SgAnw('Ausgabe i')]),
      ],
      klein: true,
      unterschrift: 'Zählschleife',
    ),
    UeberschriftBlock('Mehrfachauswahl'),
    StruktogrammBlock(
      _wochenende,
      unterschrift:
          'Ohne „sonst“: die Diagonale läuft bis in die rechte untere Ecke.',
    ),
    StruktogrammBlock(
      _menue,
      titel: 'Menü',
      unterschrift:
          'Mit „sonst“, in einer fußgesteuerten Schleife. Wird es breiter '
          'als der Bildschirm, lässt es sich seitlich schieben.',
    ),
    UeberschriftBlock('Unterprogramm, Aufruf, Lücke'),
    StruktogrammBlock(
      _maximum,
      titel: 'maximum(zahlen: Feld, n: Ganzzahl): Ganzzahl',
      unterschrift:
          'Die Lücke (1) ist die Stelle für Aufgaben der Art „Ergänzen Sie“. '
          'Der leere Nein-Zweig steht als ∅ da.',
    ),
    StruktogrammBlock(
      [
        SgAnw('Eingabe zahlen'),
        SgAufruf('sortiere(zahlen)'),
        SgAnw('Ausgabe zahlen'),
      ],
      unterschrift:
          'Aufruf eines Unterprogramms: Rechteck mit doppelten Seitenlinien.',
    ),
    UeberschriftBlock('Fußgesteuert mit „solange“'),
    StruktogrammBlock(
      _eingabePruefen,
      unterschrift:
          'Die Bedingung unten ist hier eine Fortsetzungsbedingung: '
          'wiederholen, solange die Zahl ungültig ist.',
    ),
    UeberschriftBlock('Tiefe Verschachtelung'),
    StruktogrammBlock(
      _bubblesort,
      titel: 'Bubblesort',
      unterschrift:
          'Drei Ebenen: zwei Zählschleifen und eine Verzweigung. So sieht '
          'Lektion 6 später aus.',
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Der Kurs
// ═══════════════════════════════════════════════════════════════════════════
// Geplante Lektionen (wie im Web): 1 Struktogramm und Pseudocode in der
// Prüfung · 2 Sequenz, Verzweigung, Operatoren · 3 Schleifen ·
// 4 Mehrfachauswahl, Verschachtelung, Schreibtischtest · 5 Felder und
// Grundmuster · 6 Tauschen, Sortieren, Unterprogramme · 7 Pseudocode und
// Python · 8 Prüfungstraining

const struktogrammKurs = Kurs(
  slug: 'struktogramm',
  titel: 'Struktogramm und Pseudocode',
  beschreibung:
      'Abläufe lesen, ergänzen und selbst entwerfen, wie in der AP1. '
      'Mit Schreibtischtest, Pseudocode und Prüfungstraining.',
  lektionenGeplant: 8,
  lektionen: [_vorschau],
);
