// lib/data/kurse/struktogramm/lektion_07.dart
//
// Struktogramm-Kurs der App, Lektion 7. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 7: Felder und Grundmuster
// ═══════════════════════════════════════════════════════════════════════════
// Neu: Feld, Index (ab 1, Hinweis auf ab 0), Durchlauf über alle Elemente,
// Summe, Durchschnitt (/ statt DIV), Maximum mit Position, Zählen mit
// Bedingung, Wahrheitswert-Variable als Merker, lineare Suche (mit und ohne
// Abbruch), Muster im Aufgabentext erkennen.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _alleAusgeben = <SgBlock>[
  SgFuer('für i = 1 bis n', [
    SgAnw('Ausgabe zahlen[i]'),
  ]),
];

const _summe = <SgBlock>[
  SgAnw('summe = 0'),
  SgFuer('für i = 1 bis n', [
    SgAnw('summe = summe + zahlen[i]'),
  ]),
  SgAnw('Ausgabe summe'),
];

const _durchschnitt = <SgBlock>[
  SgAnw('summe = 0'),
  SgFuer('für i = 1 bis n', [
    SgAnw('summe = summe + zahlen[i]'),
  ]),
  SgAnw('durchschnitt = summe / n'),
  SgAnw('Ausgabe durchschnitt'),
];

const _maximum = <SgBlock>[
  SgAnw('max = zahlen[1]'),
  SgAnw('pos = 1'),
  SgFuer('für i = 2 bis n', [
    SgWenn('zahlen[i] > max', [
      SgAnw('max = zahlen[i]'),
      SgAnw('pos = i'),
    ]),
  ]),
  SgAnw('Ausgabe max, pos'),
];

const _zaehlen = <SgBlock>[
  SgAnw('anzahl = 0'),
  SgFuer('für i = 1 bis n', [
    SgWenn('zahlen[i] > 5', [SgAnw('anzahl = anzahl + 1')]),
  ]),
  SgAnw('Ausgabe anzahl'),
];

const _suche = <SgBlock>[
  SgAnw('Eingabe gesucht'),
  SgAnw('gefunden = falsch'),
  SgFuer('für i = 1 bis n', [
    SgWenn('zahlen[i] == gesucht', [
      SgAnw('gefunden = wahr'),
      SgAnw('position = i'),
    ]),
  ]),
  SgWenn(
    'gefunden == wahr',
    [SgAnw('Ausgabe position')],
    [SgAnw('Ausgabe "nicht gefunden"')],
  ),
];

const _sucheMitAbbruch = <SgBlock>[
  SgAnw('Eingabe gesucht'),
  SgAnw('gefunden = falsch'),
  SgAnw('i = 1'),
  SgSolange('i <= n UND gefunden == falsch', [
    SgWenn('zahlen[i] == gesucht', [
      SgAnw('gefunden = wahr'),
      SgAnw('position = i'),
    ]),
    SgAnw('i = i + 1'),
  ]),
  SgWenn(
    'gefunden == wahr',
    [SgAnw('Ausgabe position')],
    [SgAnw('Ausgabe "nicht gefunden"')],
  ),
];

const struktogrammLektion7 = Lektion(
  nr: 7,
  slug: 'struktogramm-7-felder',
  titel: 'Felder und Grundmuster',
  kurzbeschreibung:
      'Viele Werte unter einem Namen. Dazu die fünf Muster, die in '
      'Prüfungen ständig vorkommen: Summe, Durchschnitt, Maximum, Zählen, '
      'Suchen.',
  dauerMinuten: 45,
  bloecke: [
    // ── Seite: Feld ────────────────────────────────────────────────────
    UeberschriftBlock('Viele Werte unter einem Namen'),
    TextBlock(
      'Ein Programm soll die Temperaturen einer ganzen Woche speichern. '
      'Sieben Variablen `tag1`, `tag2` bis `tag7`? Das wird schnell '
      'unübersichtlich. Bei 365 Tagen geht es gar nicht mehr.\n'
      '\n'
      'Dafür gibt es das **Feld**. Stell dir eine Reihe von Schließfächern '
      'vor. Alle Fächer gehören zusammen und haben einen gemeinsamen Namen. '
      'Jedes Fach hat eine **Nummer** und darin liegt ein Wert. Die Nummer '
      'heißt **Index**.\n'
      '\n'
      'Das Feld `zahlen` mit vier Fächern:',
    ),
    SchreibtischtestBlock(
      spalten: ['Index', '1', '2', '3', '4'],
      zeilen: [
        ['Wert', '4', '9', '2', '7'],
      ],
      unterschrift: 'Ein Feld mit dem Namen zahlen. Im Fach mit dem Index 2 '
          'liegt die 9.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Auf ein einzelnes Fach greifst du mit dem Index in **eckigen '
      'Klammern** zu:\n'
      '- `zahlen[1]` ist 4.\n'
      '- `zahlen[2]` ist 9.\n'
      '- `zahlen[4]` ist 7.\n'
      '\n'
      'In manchen Prüfungsaufgaben steht statt Feld das englische Wort '
      '**Array**. Gemeint ist dasselbe. Die Anzahl der Fächer heißt in '
      'diesem Kurs `n`. Unser Feld hat also n = 4.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-7-1',
      frage: 'Das Feld `zahlen` enthält der Reihe nach 4, 9, 2 und 7. Das '
          'erste Fach hat den Index 1. Welchen Wert hat `zahlen[3]`?',
      optionen: [
        '3',
        '9',
        '7',
        '2',
      ],
      richtig: 3,
      erklaerung: 'Der Index 3 meint das dritte Fach. Darin liegt die 2. '
          'Der Index ist die Nummer des Fachs, nicht der Wert darin.',
    )),

    // ── Seite: Index 1 oder 0 ──────────────────────────────────────────
    UeberschriftBlock('Fängt der Index bei 1 oder bei 0 an?'),
    TextBlock(
      'In diesem Kurs hat das erste Fach den Index **1** und das letzte den '
      'Index **n**.\n'
      '\n'
      'Viele Prüfungsaufgaben fangen aber bei **0** an, weil die meisten '
      'Programmiersprachen das so machen. Dann ist das erste Fach '
      '`zahlen[0]` und das letzte `zahlen[n - 1]`.\n'
      '\n'
      'Welche Zählweise gilt, steht in der Aufgabe. Lies das immer nach, '
      'bevor du anfängst, und bleib dann dabei. Der häufigste Fehler bei '
      'Feldern ist ein Fach zu viel oder zu wenig.',
    ),

    // ── Seite: Alle durchgehen ─────────────────────────────────────────
    UeberschriftBlock('Alle Fächer durchgehen'),
    TextBlock(
      'Der Index darf auch eine Variable sein. `zahlen[i]` meint je nach '
      'Wert von i ein anderes Fach. Zusammen mit der Zählschleife aus '
      'Lektion 5 kannst du so alle Fächer der Reihe nach ansehen:',
    ),
    StruktogrammBlock(
      _alleAusgeben,
      titel: 'Alle Werte ausgeben',
    ),
    TextBlock(
      'Der Zähler `i` ist hier gleichzeitig der Index. Im ersten Durchlauf '
      'ist i = 1, also wird `zahlen[1]` ausgegeben. Im zweiten `zahlen[2]` '
      'und so weiter. Für unser Feld erscheint 4, 9, 2, 7.\n'
      '\n'
      'Alle Muster auf den nächsten Seiten sind genau dieser Durchlauf, '
      'mit etwas davor, etwas im Rumpf und etwas danach.',
    ),
    CodeBlock(
      'FÜR i = 1 BIS n\n'
      '    AUSGABE zahlen[i]\n'
      'ENDE FÜR',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-7-2',
      frage: 'Das Feld `zahlen` enthält 4, 9, 2 und 7. Gerade ist i = 4. '
          'Welchen Wert hat `zahlen[i]`?',
      optionen: [
        '4',
        '7',
        '9',
        'i',
      ],
      richtig: 1,
      erklaerung: 'Erst wird i abgelesen, das ist 4. `zahlen[i]` meint also '
          '`zahlen[4]`, das vierte Fach. Darin liegt die 7.',
    )),

    // ── Seite: Summe ───────────────────────────────────────────────────
    UeberschriftBlock('Muster 1: die Summe'),
    TextBlock(
      'Alle Werte zusammenzählen. Du brauchst eine Variable, die vor der '
      'Schleife bei 0 anfängt und in jedem Durchlauf den aktuellen Wert '
      'dazubekommt. Sie sammelt also, deshalb nennt man sie auch '
      '**Sammelvariable**.',
    ),
    StruktogrammBlock(
      _summe,
      titel: 'Summe',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'i', 'zahlen[i]', 'summe', 'Ausgabe'],
      zeilen: [
        ['summe = 0', '', '', '0', ''],
        ['Durchlauf 1', '1', '4', '4', ''],
        ['Durchlauf 2', '2', '9', '13', ''],
        ['Durchlauf 3', '3', '2', '15', ''],
        ['Durchlauf 4', '4', '7', '22', ''],
        ['Ausgabe summe', '', '', '22', '22'],
      ],
      unterschrift: 'Schreibtischtest für das Feld 4, 9, 2, 7. Die Ausgabe '
          'steht nach der Schleife. Im Rumpf würden alle Zwischensummen '
          'ausgegeben.',
    ),

    // ── Seite: Durchschnitt ────────────────────────────────────────────
    UeberschriftBlock('Muster 2: der Durchschnitt'),
    TextBlock(
      'Der Durchschnitt ist die Summe geteilt durch die Anzahl. Er kommt '
      'als eine Zeile **nach** der Schleife dazu:',
    ),
    StruktogrammBlock(
      _durchschnitt,
      titel: 'Durchschnitt',
    ),
    TextBlock(
      'Für unser Feld: 22 geteilt durch 4 ergibt 5,5.\n'
      '\n'
      'Achtung: Hier gehört die normale Division `/` hin, nicht `DIV` aus '
      'Lektion 4. `22 DIV 4` wäre 5, die Nachkommastelle ginge verloren. '
      'Das kostet in Prüfungen Punkte.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-7-3',
      frage: 'Das Feld enthält die Werte 3, 5 und 10. Was ergeben Summe und '
          'Durchschnitt?',
      vorlage: 'summe        = ___\n'
          'durchschnitt = ___',
      loesungen: [
        ['18'],
        ['6', '6,0', '6.0'],
      ],
      erklaerung: '3 + 5 + 10 = 18. Das Feld hat 3 Werte, also n = 3. '
          '18 / 3 = 6.',
    )),

    // ── Seite: Maximum ─────────────────────────────────────────────────
    UeberschriftBlock('Muster 3: der größte Wert'),
    TextBlock(
      'Wie findest du den größten Wert? So, wie du es auch ohne Computer '
      'machen würdest: Du merkst dir den ersten Wert als bisher größten. '
      'Dann schaust du dir die übrigen der Reihe nach an. Ist einer größer, '
      'merkst du dir den stattdessen.\n'
      '\n'
      'Oft will die Aufgabe auch wissen, **wo** der größte Wert steht. Dann '
      'merkst du dir die Position gleich mit.',
    ),
    StruktogrammBlock(
      _maximum,
      titel: 'Maximum mit Position',
    ),
    HinweisBlock(
      'Warum nicht einfach `max = 0` als Startwert? Stehen im Feld nur '
      'Minuszahlen, zum Beispiel -5 und -3, ist keine davon größer als 0. '
      'Dann käme 0 heraus, obwohl die 0 gar nicht im Feld steht. Mit dem '
      'ersten Fach als Startwert passiert das nie.',
    ),

    // ── Seite: Maximum Schreibtischtest ────────────────────────────────
    UeberschriftBlock('Maximum Schritt für Schritt'),
    SchreibtischtestBlock(
      spalten: ['Prüfung', 'i', 'zahlen[i]', 'max', 'pos'],
      zeilen: [
        ['Start', '', '', '4', '1'],
        ['9 > 4? ja', '2', '9', '9', '2'],
        ['2 > 9? nein', '3', '2', '9', '2'],
        ['7 > 9? nein', '4', '7', '9', '2'],
      ],
      unterschrift: 'Für 4, 9, 2, 7 wird 9 an Position 2 ausgegeben. Die '
          'Schleife beginnt bei 2, weil das erste Fach schon der Startwert '
          'ist.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-7-4',
      frage: 'Führe „Maximum mit Position“ für das Feld 3, 8, 5, 8, 1 '
          'durch. Welche Werte werden ausgegeben?',
      vorlage: 'max = ___\n'
          'pos = ___',
      loesungen: [
        ['8'],
        ['2'],
      ],
      erklaerung: 'max startet mit 3. Die 8 an Position 2 ist größer, also '
          'max = 8 und pos = 2. Die zweite 8 an Position 4 ändert nichts, '
          'weil `8 > 8` falsch ist. Gemerkt bleibt die erste Stelle: 8 und 2.',
    )),

    // ── Seite: Zählen ──────────────────────────────────────────────────
    UeberschriftBlock('Muster 4: zählen'),
    TextBlock(
      '„Wie viele Werte sind größer als 5?“ Das kennst du schon aus '
      'Lektion 6: ein Zähler, der vor der Schleife bei 0 anfängt, und eine '
      'Verzweigung im Rumpf. Neu ist nur, dass die Bedingung ein Fach des '
      'Feldes prüft.',
    ),
    StruktogrammBlock(
      _zaehlen,
      titel: 'Werte über 5 zählen',
    ),
    TextBlock(
      'Für 4, 9, 2, 7 sind die 9 und die 7 größer als 5. Ausgegeben wird 2.\n'
      '\n'
      'Vergleiche mit der Summe: Beim Zählen kommt bei jedem Treffer `+ 1` '
      'dazu. Bei der Summe kommt der Wert selbst dazu, `+ zahlen[i]`.',
    ),

    // ── Seite: Suchen ──────────────────────────────────────────────────
    UeberschriftBlock('Muster 5: suchen'),
    TextBlock(
      '„Kommt die Zahl im Feld vor, und wenn ja, wo?“ Dafür brauchst du '
      'etwas Neues: eine Variable, die sich nur **wahr** oder **falsch** '
      'merkt. Man nennt sie einen **Merker**. Stell dir ein Fähnchen vor: '
      'unten heißt falsch, oben heißt wahr.\n'
      '\n'
      'Am Anfang ist das Fähnchen unten: `gefunden = falsch`. Findet die '
      'Schleife den gesuchten Wert, geht es hoch: `gefunden = wahr`.',
    ),
    StruktogrammBlock(
      _suche,
      titel: 'Suchen',
    ),
    TextBlock(
      'Erst **nach** der Schleife wird entschieden, was ausgegeben wird. '
      'Dazu schaut die letzte Verzweigung auf das Fähnchen. Ist es oben, '
      'wird die Position ausgegeben, sonst „nicht gefunden“.\n'
      '\n'
      'Oft steht statt `gefunden == wahr` nur `gefunden`. Das bedeutet '
      'dasselbe, denn der Merker ist ja schon wahr oder falsch.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-7-5',
      frage: 'Im Feld stehen 4, 9, 2 und 7. Mit „Suchen“ wird nach der 5 '
          'gesucht. Was wird ausgegeben?',
      optionen: [
        'nicht gefunden',
        '0',
        '4',
        'Nichts',
      ],
      richtig: 0,
      erklaerung: 'Keines der vier Fächer enthält die 5. Die Bedingung im '
          'Rumpf ist nie wahr, gefunden bleibt falsch. Nach der Schleife '
          'läuft deshalb die rechte Spalte: „nicht gefunden“.',
    )),

    // ── Seite: Suchen mit Abbruch ──────────────────────────────────────
    UeberschriftBlock('Früher aufhören'),
    TextBlock(
      'Die Suche oben schaut sich immer alle Fächer an, auch wenn der Wert '
      'schon im ersten gefunden wurde. Bei großen Feldern ist das '
      'Verschwendung. Deshalb verlangen Aufgaben oft: „Die Suche soll nach '
      'dem ersten Treffer beendet werden.“\n'
      '\n'
      'Dann nimmst du eine Schleife mit „solange“ und zwei Bedingungen:',
    ),
    StruktogrammBlock(
      _sucheMitAbbruch,
      titel: 'Suchen mit Abbruch',
    ),
    TextBlock(
      'Die Schleife läuft, solange noch Fächer übrig sind **und** noch '
      'nichts gefunden wurde. Sobald eins von beiden nicht mehr stimmt, '
      'hört sie auf.\n'
      '\n'
      'Weil das keine Zählschleife ist, musst du den Zähler selbst '
      'verwalten: `i = 1` vor der Schleife und `i = i + 1` im Rumpf.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'i', 'zahlen[i]', 'gefunden', 'position'],
      zeilen: [
        ['Start', '1', '', 'falsch', ''],
        ['Durchlauf 1: 4 == 2? nein', '1', '4', 'falsch', ''],
        ['Durchlauf 2: 9 == 2? nein', '2', '9', 'falsch', ''],
        ['Durchlauf 3: 2 == 2? ja', '3', '2', 'wahr', '3'],
        ['gefunden ist wahr: Ende', '4', '', 'wahr', '3'],
      ],
      unterschrift: 'Suche nach 2 im Feld 4, 9, 2, 7. In jeder Zeile steht i '
          'so, wie es beim Vergleich war. Am Ende jedes Durchlaufs wird i um 1 '
          'erhöht. Nach dem Treffer im dritten Fach endet die Schleife, die 7 '
          'wird nicht mehr angeschaut. Ausgegeben wird 3.',
    ),
    TextBlock(
      'Kommt der gesuchte Wert **mehrmals** im Feld vor, gibt es noch einen '
      'zweiten Unterschied. Ohne Abbruch läuft die Schleife weiter und '
      'überschreibt `position` bei jedem Treffer. Am Ende steht dort die '
      '**letzte** Fundstelle. Mit Abbruch hört die Schleife beim ersten '
      'Treffer auf. Dann wird die **erste** Fundstelle ausgegeben.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-7-8',
      frage: 'Im Feld stehen 6, 3, 8, 3. Gesucht wird die 3. Welche Position '
          'geben die beiden Suchen aus?',
      vorlage: '„Suchen“ ohne Abbruch:     ___\n'
          '„Suchen mit Abbruch“:      ___',
      loesungen: [
        ['4'],
        ['2'],
      ],
      erklaerung: 'Die 3 steht in Fach 2 und in Fach 4. Ohne Abbruch läuft '
          'die Schleife bis zum Ende, position wird erst 2, dann 4. Mit '
          'Abbruch endet die Schleife nach dem ersten Treffer, position '
          'bleibt 2.',
    )),

    // ── Seite: Muster erkennen ─────────────────────────────────────────
    UeberschriftBlock('Muster im Aufgabentext erkennen'),
    TextBlock(
      'Prüfungsaufgaben sagen nicht „Zeichne das Muster Zählen“. Sie '
      'beschreiben, was herauskommen soll. An diesen Wörtern erkennst du '
      'das Muster:',
    ),
    SchreibtischtestBlock(
      spalten: ['In der Aufgabe steht', 'Muster'],
      zeilen: [
        ['„insgesamt“, „Gesamtbetrag“', 'Summe'],
        ['„im Mittel“, „durchschnittlich“', 'Durchschnitt'],
        ['„der größte“, „der teuerste“', 'Maximum'],
        ['„wie viele“, „die Anzahl“', 'Zählen'],
        ['„ob … vorkommt“, „an welcher Stelle“', 'Suchen'],
      ],
      aenderungenMarkieren: false,
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-7-6',
      frage: 'In einer Aufgabe steht: „Geben Sie aus, wie viele '
          'Bestellungen einen Wert über 100 Euro haben.“ Welches Muster ist '
          'gemeint?',
      optionen: [
        'Summe, weil es um Euro geht',
        'Zählen, mit einer Verzweigung im Rumpf',
        'Maximum, weil nach großen Werten gefragt ist',
        'Suchen, weil ein Wert gesucht wird',
      ],
      richtig: 1,
      erklaerung: '„Wie viele“ fragt nach einer Anzahl, nicht nach einem '
          'Betrag. Also Zählen: Zähler vorher auf 0, im Rumpf eine '
          'Verzweigung mit „über 100“, im Ja-Zweig um 1 erhöhen.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 7'),
    HinweisBlock(
      '- Ein **Feld** speichert viele Werte unter einem Namen. Die Nummer '
      'eines Fachs ist der **Index**: `zahlen[2]`.\n'
      '- Ob der Index bei 1 oder 0 beginnt, steht in der Aufgabe.\n'
      '- Alle Fächer durchgehen: Zählschleife, der Zähler ist der Index.\n'
      '- Startwerte: Summe und Zähler 0, Maximum das erste Fach, Merker '
      'falsch.\n'
      '- Durchschnitt mit `/`, nicht mit DIV.\n'
      '- Ein **Merker** speichert nur wahr oder falsch.\n'
      '- Die Ausgabe steht nach der Schleife, nicht im Rumpf.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-7-7',
      frage: 'Welcher Startwert ist für die Suche nach dem größten Wert '
          'sicher?',
      optionen: [
        '0',
        'Die Anzahl n',
        'Der Wert im ersten Fach',
        'Der Durchschnitt',
      ],
      richtig: 2,
      erklaerung: 'Das erste Fach ist immer ein echter Wert aus dem Feld. '
          'Mit 0 als Start ginge es bei lauter Minuszahlen schief. Die '
          'Schleife beginnt dann beim zweiten Fach.',
    )),
  ],
);
