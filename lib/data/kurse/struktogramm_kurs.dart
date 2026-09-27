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
// Lektion 1: Was ist ein Ablauf?
// ═══════════════════════════════════════════════════════════════════════════
// Startet bei null: kein Vorwissen, keine Variablen, keine Bedingungen.
// Nur Schritte der Reihe nach, Eingabe und Ausgabe. Autor Opus 5.5
// (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _tee = <SgBlock>[
  SgAnw('Teebeutel in die Tasse hängen'),
  SgAnw('Wasser in den Wasserkocher füllen'),
  SgAnw('Wasserkocher einschalten'),
  SgAnw('Warten, bis das Wasser kocht'),
  SgAnw('Wasser in die Tasse gießen'),
  SgAnw('Drei Minuten warten'),
  SgAnw('Teebeutel herausnehmen'),
];

const _begruessung = <SgBlock>[
  SgAnw('Ausgabe "Wie heißt du?"'),
  SgAnw('Eingabe name'),
  SgAnw('Ausgabe "Hallo"'),
  SgAnw('Ausgabe name'),
];

const _begruessungFalsch = <SgBlock>[
  SgAnw('Ausgabe "Wie heißt du?"'),
  SgAnw('Ausgabe "Hallo"'),
  SgAnw('Ausgabe name'),
  SgAnw('Eingabe name'),
];

const _lektion1 = Lektion(
  nr: 1,
  slug: 'struktogramm-1-ablauf',
  titel: 'Was ist ein Ablauf?',
  kurzbeschreibung:
      'Warum ein Computer jeden Schritt einzeln braucht und wie dein erstes '
      'Struktogramm aussieht. Ganz ohne Vorwissen.',
  dauerMinuten: 10,
  bloecke: [
    // ── Seite: Einstieg ────────────────────────────────────────────────
    UeberschriftBlock('Worum es in diesem Kurs geht'),
    TextBlock(
      'Ein **Programm** ist eine Anleitung für einen Computer. '
      'Es sagt ihm, was er tun soll, Schritt für Schritt.\n'
      '\n'
      'Bevor jemand ein Programm schreibt, plant er den **Ablauf**: '
      'Was soll passieren, und in welcher Reihenfolge? '
      'Diesen Plan kann man zeichnen. Die Zeichnung heißt **Struktogramm**.\n'
      '\n'
      'In der Abschlussprüfung Teil 1, kurz **AP1**, kommt oft eine Aufgabe '
      'mit einem Struktogramm. Du sollst es lesen oder selbst zeichnen.\n'
      '\n'
      'Dieser Kurs fängt ganz vorne an. Du brauchst kein Vorwissen.',
    ),

    // ── Seite: Alltag ──────────────────────────────────────────────────
    UeberschriftBlock('Ein Ablauf aus dem Alltag'),
    TextBlock(
      'Du kennst Abläufe schon, auch wenn du sie nicht so nennst. '
      'Denk an eine Tasse Tee:\n'
      '- Teebeutel in die Tasse hängen\n'
      '- Wasser in den Wasserkocher füllen\n'
      '- Wasserkocher einschalten\n'
      '- Warten, bis das Wasser kocht\n'
      '- Wasser in die Tasse gießen\n'
      '- Drei Minuten warten\n'
      '- Teebeutel herausnehmen\n'
      '\n'
      'Das ist ein **Ablauf**: mehrere Schritte, die nacheinander passieren.\n'
      '\n'
      'Bei manchen Schritten ist die Reihenfolge egal. Den Teebeutel kannst '
      'du auch erst später in die Tasse hängen. Bei anderen ist sie '
      'wichtig: Gießt du das Wasser ein, bevor es kocht, wird der Tee nichts.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-1-1',
      frage: 'Bring die Schritte in die richtige Reihenfolge. '
          'Der Teebeutel hängt schon in der Tasse.',
      zeilen: [
        'Wasser in den Wasserkocher füllen',
        'Wasserkocher einschalten',
        'Warten, bis das Wasser kocht',
        'Wasser in die Tasse gießen',
        'Teebeutel herausnehmen',
      ],
      erklaerung: 'Erst Wasser einfüllen, dann einschalten, dann warten. '
          'Erst wenn das Wasser kocht, kommt es in die Tasse. '
          'Der Teebeutel kommt ganz zum Schluss heraus.',
    )),

    // ── Seite: Computer ────────────────────────────────────────────────
    UeberschriftBlock('Ein Computer rät nicht'),
    TextBlock(
      'Sagst du zu einem Freund „Mach mir bitte einen Tee“, weiß er, '
      'was zu tun ist. Er denkt mit.\n'
      '\n'
      'Ein Computer denkt nicht mit. Er macht **genau** das, was in der '
      'Anleitung steht. Nicht mehr und nicht weniger. Fehlt ein Schritt, '
      'fehlt er eben. Ist ein Schritt ungenau, weiß der Computer nicht '
      'weiter.\n'
      '\n'
      'Eine Anleitung, die so genau ist, dass man sie ohne Nachdenken '
      'Schritt für Schritt ausführen kann, heißt **Algorithmus**. '
      'Das Wort klingt schwierig, meint aber nur das: eine sehr genaue '
      'Anleitung.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-2',
      frage: 'Welcher Schritt ist für einen Computer zu ungenau?',
      optionen: [
        'Wasserkocher einschalten',
        'Drei Minuten warten',
        'Wasser heiß genug machen',
        'Teebeutel herausnehmen',
      ],
      richtig: 2,
      erklaerung: 'Was heißt „heiß genug“? Ein Mensch schätzt das ab, ein '
          'Computer kann das nicht. Genauer wäre: „Warten, bis das Wasser '
          'kocht“. Die anderen Schritte sind eindeutig.',
    )),

    // ── Seite: Erstes Struktogramm ─────────────────────────────────────
    UeberschriftBlock('Dein erstes Struktogramm'),
    TextBlock(
      'So sieht der Tee als **Struktogramm** aus. Jeder Schritt steht in '
      'einem eigenen Kasten. Die Kästen liegen übereinander wie ein Stapel.',
    ),
    StruktogrammBlock(
      _tee,
      titel: 'Tee kochen',
      unterschrift: 'Du liest von oben nach unten. Oben ist der erste '
          'Schritt, unten der letzte.',
    ),
    TextBlock(
      'Schritte, die einfach nacheinander ablaufen, nennt man **Sequenz**. '
      'Das Wort bedeutet „Folge“.\n'
      '\n'
      'Mehr gibt es hier noch nicht zu wissen. Später kommen Kästen dazu, '
      'die etwas entscheiden oder wiederholen. Aber jedes Struktogramm '
      'liest du so: von oben nach unten, Kasten für Kasten.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-3',
      frage: 'In welcher Richtung liest du ein Struktogramm?',
      optionen: [
        'Von unten nach oben',
        'Von oben nach unten',
        'Von rechts nach links',
        'In beliebiger Reihenfolge',
      ],
      richtig: 1,
      erklaerung: 'Der oberste Kasten ist der erste Schritt. Dann geht es '
          'Kasten für Kasten nach unten, bis zum letzten.',
    )),

    // ── Seite: Eingabe und Ausgabe ─────────────────────────────────────
    UeberschriftBlock('Eingabe und Ausgabe'),
    TextBlock(
      'Tee kochen kann ein Computer nicht. Aber er kann mit dir reden. '
      'Dafür gibt es zwei Arten von Schritten:\n'
      '- **Ausgabe**: Der Computer zeigt etwas auf dem Bildschirm an.\n'
      '- **Eingabe**: Der Computer wartet, bis du etwas eintippst.\n'
      '\n'
      'Ein kleines Programm, das dich begrüßt:',
    ),
    StruktogrammBlock(
      _begruessung,
      titel: 'Begrüßung',
    ),
    TextBlock(
      'Achte auf die Anführungszeichen:\n'
      '- `Ausgabe "Hallo"` zeigt genau den Text **Hallo** an. '
      'Was in Anführungszeichen steht, erscheint Wort für Wort.\n'
      '- `Eingabe name` merkt sich, was du eintippst, unter dem Namen '
      '**name**. Stell dir einen Zettel vor, auf dem „name“ steht. '
      'Darauf schreibt der Computer deine Antwort.\n'
      '- `Ausgabe name` hat **keine** Anführungszeichen. Deshalb erscheint '
      'nicht das Wort „name“, sondern das, was auf dem Zettel steht.\n'
      '\n'
      'Tippst du „Lena“ ein, steht auf dem Bildschirm erst **Hallo** und '
      'dann **Lena**. Wie solche Zettel genau funktionieren, lernst du in '
      'Lektion 2.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-4',
      frage: 'Beim Programm „Begrüßung“ tippt jemand „Tom“ ein. '
          'Was steht danach auf dem Bildschirm?',
      optionen: [
        'Erst name, dann Hallo',
        'Erst Hallo, dann name',
        'Erst Tom, dann Hallo',
        'Erst Hallo, dann Tom',
      ],
      richtig: 3,
      erklaerung: 'Zuerst kommt `Ausgabe "Hallo"`, also das Wort Hallo. '
          'Danach `Ausgabe name` ohne Anführungszeichen. Das zeigt den '
          'Inhalt des Zettels an, also Tom.',
    )),

    // ── Seite: Reihenfolge ─────────────────────────────────────────────
    UeberschriftBlock('Die Reihenfolge zählt'),
    TextBlock(
      'Hier sind die letzten beiden Schritte vertauscht:',
    ),
    StruktogrammBlock(
      _begruessungFalsch,
      titel: 'Begrüßung mit Fehler',
    ),
    TextBlock(
      'Der Computer will den Namen anzeigen, bevor jemand ihn eingetippt '
      'hat. Der Zettel „name“ ist noch leer. Also erscheint nach Hallo '
      'nichts Sinnvolles.\n'
      '\n'
      'Merke dir: Etwas kann erst **ausgegeben** werden, wenn es vorher '
      '**eingegeben** oder berechnet wurde.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-1-5',
      frage: 'Das Programm soll erst nach der Lieblingsfarbe fragen, dann '
          'die Antwort einlesen und danach „Du magst:“ und die Farbe '
          'anzeigen. Bring die Kästen in die richtige Reihenfolge.',
      zeilen: [
        'Ausgabe "Welche Farbe magst du?"',
        'Eingabe farbe',
        'Ausgabe "Du magst:"',
        'Ausgabe farbe',
      ],
      erklaerung: 'Zuerst die Frage, damit man weiß, was man eintippen '
          'soll. Dann die Eingabe. Erst danach kann die Farbe angezeigt '
          'werden, weil sie vorher noch gar nicht bekannt ist.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 1'),
    HinweisBlock(
      '- Ein **Ablauf** ist eine Folge von Schritten.\n'
      '- Ein **Algorithmus** ist eine so genaue Anleitung, dass auch ein '
      'Computer sie ausführen kann.\n'
      '- Im **Struktogramm** steht jeder Schritt in einem Kasten. '
      'Du liest von oben nach unten.\n'
      '- Schritte nacheinander heißen **Sequenz**.\n'
      '- **Ausgabe** zeigt etwas an, **Eingabe** liest etwas ein.\n'
      '- Text in Anführungszeichen erscheint genau so. Ein Name ohne '
      'Anführungszeichen steht für seinen Inhalt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-6',
      frage: 'Was ist eine Sequenz?',
      optionen: [
        'Schritte, die nacheinander ablaufen',
        'Ein Schritt, der etwas entscheidet',
        'Ein Schritt, der sich wiederholt',
        'Ein Fehler im Struktogramm',
      ],
      richtig: 0,
      erklaerung: 'Sequenz heißt Folge. Die Schritte laufen einfach '
          'nacheinander ab, von oben nach unten. Entscheiden und '
          'Wiederholen lernst du in den nächsten Lektionen.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Vorschau-Lektion (nur zum Prüfen der Darstellung, nicht für den Release)
// ═══════════════════════════════════════════════════════════════════════════

const _vorschau = Lektion(
  nr: 99,
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
  lektionenGeplant: 10,
  lektionen: [_lektion1, _vorschau],
);
