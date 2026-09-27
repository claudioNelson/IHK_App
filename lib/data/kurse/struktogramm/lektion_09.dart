// lib/data/kurse/struktogramm/lektion_09.dart
//
// Struktogramm-Kurs der App, Lektion 9. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 9: Pseudocode lesen und Fehler finden
// ═══════════════════════════════════════════════════════════════════════════
// Neu: alle Bausteine als Pseudocode im Überblick, andere Schreibweisen
// (:=, ←, englische Wörter), Übersetzen Struktogramm zu Pseudocode,
// Prüfliste zur Fehlersuche, Fehleraufgaben im Prüfungsstil.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _countdown = <SgBlock>[
  SgAnw('Eingabe start'),
  SgSolange('start > 0', [
    SgAnw('Ausgabe start'),
    SgAnw('start = start - 1'),
  ]),
  SgAnw('Ausgabe "Los"'),
];

const struktogrammLektion9 = Lektion(
  nr: 9,
  slug: 'struktogramm-9-pseudocode-fehler',
  titel: 'Pseudocode lesen und Fehler finden',
  kurzbeschreibung:
      'Alle Bausteine als Pseudocode, andere Schreibweisen aus Prüfungen '
      'und eine Prüfliste, mit der du Fehler sicher findest.',
  dauerMinuten: 35,
  bloecke: [
    // ── Seite: Überblick ───────────────────────────────────────────────
    UeberschriftBlock('Alle Bausteine auf einen Blick'),
    TextBlock(
      'Seit Lektion 3 steht neben den Struktogrammen auch Pseudocode. Hier '
      'sind alle Bausteine noch einmal zusammen. Die Wörter in '
      'Großbuchstaben sind die festen **Schlüsselwörter**:',
    ),
    SchreibtischtestBlock(
      spalten: ['Baustein', 'Pseudocode'],
      zeilen: [
        ['Eingabe, Ausgabe', 'EINGABE x\nAUSGABE x'],
        ['Zuweisung', 'x = 5'],
        ['Verzweigung', 'WENN … DANN … SONST … ENDE WENN'],
        ['Mehrfachauswahl', 'FALLS x\nFALL 1: …\nSONST: …\nENDE FALLS'],
        ['kopfgesteuert', 'SOLANGE … ENDE SOLANGE'],
        ['fußgesteuert', 'WIEDERHOLE … BIS …'],
        ['Zählschleife', 'FÜR i = 1 BIS n … ENDE FÜR'],
        ['Funktion', 'FUNKTION … RÜCKGABE … ENDE FUNKTION'],
        ['Prozedur', 'PROZEDUR … ENDE PROZEDUR'],
      ],
      unterschrift: 'Die drei Punkte stehen für den Teil, der je nach '
          'Aufgabe dazwischenkommt.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Zwei Regeln gelten immer:\n'
      '- Was zu einem Baustein gehört, wird **eingerückt**. Die Einrückung '
      'zeigt, was wo drinsteckt, wie die Kästen im Struktogramm.\n'
      '- Jeder Baustein, der etwas umschließt, bekommt ein eigenes **Ende**: '
      'ENDE WENN, ENDE SOLANGE, ENDE FÜR. Nur bei WIEDERHOLE steht die '
      'Bedingung am Ende, mit BIS oder, wie du aus Lektion 5 weißt, '
      'manchmal auch mit SOLANGE.\n'
      '\n'
      'Eine Prozedur schreibst du als Pseudocode wie eine Funktion, nur '
      'ohne Rückgabetyp in der Kopfzeile und ohne RÜCKGABE im Ablauf.',
    ),

    // ── Seite: Andere Schreibweisen ────────────────────────────────────
    UeberschriftBlock('Andere Schreibweisen'),
    TextBlock(
      'Für Pseudocode gibt es keine feste Vorschrift. In Prüfungen und '
      'Büchern begegnen dir deshalb auch andere Schreibweisen. Die '
      'häufigsten:\n'
      '- Zuweisung mit `:=` oder mit einem Pfeil `←`. `x := 5` und `x ← 5` '
      'bedeuten beide: x bekommt 5.\n'
      '- Wer die Zuweisung so schreibt, nimmt für den Vergleich oft ein '
      'einfaches `=`. Dann heißt `WENN x = 5` dasselbe wie `WENN x == 5` '
      'in diesem Kurs.\n'
      '- Englische Wörter: IF, THEN, ELSE statt WENN, DANN, SONST. WHILE '
      'statt SOLANGE, FOR statt FÜR.\n'
      '\n'
      'Zwei Regeln helfen dir:\n'
      '- Gibt die Aufgabe eine Schreibweise vor, übernimm genau diese.\n'
      '- Schreibst du selbst, bleib bei **einer** Schreibweise. Wechsel nicht '
      'mittendrin.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-9-1',
      frage: 'In einer Prüfungsaufgabe steht `summe ← summe + 3`. '
          'Was bedeutet das?',
      optionen: [
        'summe wird mit summe + 3 verglichen',
        'summe bekommt ihren bisherigen Wert plus 3',
        'Der Pfeil zeigt auf die nächste Zeile',
        'summe wird ausgegeben',
      ],
      richtig: 1,
      erklaerung: 'Der Pfeil ist eine andere Schreibweise für die Zuweisung. '
          'Es ist dasselbe wie `summe = summe + 3` in diesem Kurs: summe '
          'wird um 3 erhöht.',
    )),

    // ── Seite: Übersetzen ──────────────────────────────────────────────
    UeberschriftBlock('Vom Struktogramm zum Pseudocode'),
    TextBlock(
      'In der Prüfung sollst du manchmal ein Struktogramm in Pseudocode '
      'übersetzen oder umgekehrt. So gehst du vor: Lies das Struktogramm '
      'von oben nach unten. Jeder Kasten wird eine Zeile. Jeder Baustein, '
      'der etwas umschließt, bekommt eine Anfangs- und eine Endzeile, und '
      'was darin steht, wird eingerückt.',
    ),
    StruktogrammBlock(
      _countdown,
      titel: 'Rückwärts zählen',
    ),
    TextBlock(
      'Als Pseudocode wird daraus:',
    ),
    CodeBlock(
      'EINGABE start\n'
      'SOLANGE start > 0\n'
      '    AUSGABE start\n'
      '    start = start - 1\n'
      'ENDE SOLANGE\n'
      'AUSGABE "Los"',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-9-2',
      frage: 'Ein Programm liest eine Zahl n ein. Dann gibt es mit einer '
          'Zählschleife die Zahlen von 1 bis n aus, jede mit 10 '
          'multipliziert. Zum Schluss gibt es „Ende“ aus. Bring den '
          'Pseudocode in die richtige Reihenfolge.',
      zeilen: [
        'EINGABE n',
        'FÜR i = 1 BIS n',
        'AUSGABE i * 10',
        'ENDE FÜR',
        'AUSGABE "Ende"',
      ],
      einrueckung: [0, 0, 1, 0, 0],
      erklaerung: 'Erst die Eingabe, weil die Schleife n braucht. Die '
          'Ausgabe von i * 10 steht zwischen FÜR und ENDE FÜR, weil sie '
          'wiederholt wird. „Ende“ kommt nach ENDE FÜR, weil es nur einmal '
          'erscheinen soll.',
    )),

    // ── Seite: Prüfliste ───────────────────────────────────────────────
    UeberschriftBlock('Fehler finden: die Prüfliste'),
    TextBlock(
      'Eine beliebte Prüfungsaufgabe: „Finden und korrigieren Sie den '
      'Fehler.“ Fast alle Fehler gehören zu einer dieser fünf Arten. Geh '
      'sie der Reihe nach durch:\n'
      '- **Startwert**: Hat jede Variable einen Wert, bevor sie abgelesen '
      'wird? Stimmt der Startwert, zum Beispiel 0 für eine Summe?\n'
      '- **Bedingung**: Stimmt die Richtung, `>` oder `<`? Stimmt die '
      'Grenze, `>` oder `>=`?\n'
      '- **Schleifenende**: Ändert sich im Rumpf etwas, das in der '
      'Bedingung steht, und zwar so, dass die Bedingung irgendwann falsch '
      'wird? Prüfe auch die Richtung: `+` oder `-`? Sonst droht eine '
      'Endlosschleife.\n'
      '- **Zuweisung**: Steht links, was sich ändern soll? Und steht rechts '
      'noch der Wert, den du brauchst, oder wurde er eine Zeile vorher schon '
      'überschrieben?\n'
      '- **Ort**: Steht die Ausgabe in der Schleife, obwohl sie nur einmal '
      'am Ende kommen soll?\n'
      '\n'
      'Und das beste Werkzeug: ein **Schreibtischtest** mit einer kleinen '
      'Eingabe. Wenn herauskommt, was nicht herauskommen soll, siehst du '
      'in der Tabelle genau, in welcher Zeile es schiefgeht.',
    ),

    // ── Fehleraufgaben ─────────────────────────────────────────────────
    UeberschriftBlock('Fehler 1: die Grenze'),
    AufgabenBlock(FehlerAufgabe(
      id: 'struktogramm-9-3',
      frage: 'Ab 18 Jahren soll „volljährig“ ausgegeben werden. Wer genau '
          '18 ist, bekommt aber „minderjährig“. Tippe die fehlerhafte Zeile '
          'an und korrigiere sie.',
      zeilen: [
        'EINGABE alter',
        'WENN alter > 18 DANN',
        '    AUSGABE "volljährig"',
        'SONST',
        '    AUSGABE "minderjährig"',
        'ENDE WENN',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'WENN alter >= 18 DANN',
        'WENN alter>=18 DANN',
        'WENN alter >=18 DANN',
        'WENN alter>= 18 DANN',
        'WENN alter > 17 DANN',
        'WENN alter>17 DANN',
      ],
      tipp: 'Prüfe die Grenze: Gehört die 18 dazu?',
      erklaerung: '„Ab 18“ schließt die 18 ein. Mit `alter > 18` ist die '
          'Bedingung für 18 falsch. Richtig ist `alter >= 18`.',
    )),

    UeberschriftBlock('Fehler 2: die Schleife hört nicht auf'),
    AufgabenBlock(FehlerAufgabe(
      id: 'struktogramm-9-4',
      frage: 'Das Programm soll 1, 2, 3, 4, 5 ausgeben. Es hört aber nie '
          'auf. Tippe die fehlerhafte Zeile an und korrigiere sie.',
      zeilen: [
        'i = 1',
        'SOLANGE i <= 5',
        '    AUSGABE i',
        '    i = i - 1',
        'ENDE SOLANGE',
      ],
      fehlerZeile: 3,
      korrekturen: [
        'i = i + 1',
        'i=i+1',
        'i = i+1',
        'i=i + 1',
      ],
      tipp: 'Welche Variable steht in der Bedingung, und wie ändert sie '
          'sich im Rumpf?',
      erklaerung: 'Mit `i = i - 1` wird i immer kleiner: 1, 0, -1 … Die '
          'Bedingung `i <= 5` bleibt für immer wahr. i muss hochgezählt '
          'werden: `i = i + 1`.',
    )),

    UeberschriftBlock('Fehler 3: der Tausch'),
    AufgabenBlock(FehlerAufgabe(
      id: 'struktogramm-9-5',
      frage: 'Die Werte von a und b sollen getauscht werden. Danach haben '
          'aber beide denselben Wert. Tippe die fehlerhafte Zeile an und '
          'korrigiere sie.',
      zeilen: [
        'hilf = a',
        'a = b',
        'b = a',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'b = hilf',
        'b=hilf',
      ],
      tipp: 'Wo steht der alte Wert von a nach der zweiten Zeile noch?',
      erklaerung: 'Ein Fehler bei der Zuweisung: Rechts steht a, aber der '
          'alte Wert von a wurde in der Zeile davor schon überschrieben. Er '
          'ist nur noch in hilf. Also muss b ihn von dort holen: '
          '`b = hilf`.',
    )),

    UeberschriftBlock('Fehler 4: der Vergleich'),
    AufgabenBlock(FehlerAufgabe(
      id: 'struktogramm-9-6',
      frage: 'Die Funktion soll den größten Wert des Feldes zurückgeben. '
          'Sie liefert aber den kleinsten. Tippe die fehlerhafte Zeile an '
          'und korrigiere sie.',
      zeilen: [
        'max = zahlen[1]',
        'FÜR i = 2 BIS n',
        '    WENN zahlen[i] < max DANN',
        '        max = zahlen[i]',
        '    ENDE WENN',
        'ENDE FÜR',
        'RÜCKGABE max',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'WENN zahlen[i] > max DANN',
        'WENN zahlen[i]>max DANN',
        'WENN zahlen[i] >max DANN',
        'WENN zahlen[i]> max DANN',
        'WENN max < zahlen[i] DANN',
        'WENN max<zahlen[i] DANN',
      ],
      tipp: 'Wann soll ein Wert das neue Maximum werden?',
      erklaerung: 'Ein Wert soll nur dann das neue Maximum werden, wenn er '
          'größer ist als das bisherige. Mit `<` merkt sich die Funktion '
          'immer den kleineren Wert. Richtig ist `zahlen[i] > max`.',
    )),

    UeberschriftBlock('Fehler 5: der Ort'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-9-9',
      frage: 'Das Programm soll einmal die Summe von 1 bis 4 ausgeben, also '
          '10. Es gibt aber 1, 3, 6 und 10 aus. Der Pseudocode: '
          '`summe = 0`, dann `FÜR i = 1 BIS 4`, darin eingerückt '
          '`summe = summe + i` und `AUSGABE summe`, dann `ENDE FÜR`. '
          'Wo liegt der Fehler?',
      optionen: [
        'summe muss mit 1 starten',
        'Die Schleife muss bis 3 laufen',
        '`AUSGABE summe` gehört hinter ENDE FÜR',
        'Es muss `summe = summe + 1` heißen',
      ],
      richtig: 2,
      erklaerung: 'Ein Fehler beim Ort: Die Ausgabe steht im Rumpf und läuft '
          'deshalb bei jedem Durchlauf. Nach ENDE FÜR läuft sie nur einmal, '
          'wenn die Summe fertig ist.',
    )),

    // ── Seite: Fehlende Zeile ──────────────────────────────────────────
    UeberschriftBlock('Wenn etwas fehlt'),
    TextBlock(
      'Manchmal ist keine Zeile falsch, sondern eine fehlt ganz. Dann hilft '
      'die Prüfliste auch. Schau dir diesen Pseudocode an. Er soll die '
      'Summe aller Werte eines Feldes ausgeben:',
    ),
    CodeBlock(
      'FÜR i = 1 BIS n\n'
      '    summe = summe + zahlen[i]\n'
      'ENDE FÜR\n'
      'AUSGABE summe',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-9-7',
      frage: 'Der Pseudocode soll die Summe aller Werte ausgeben: '
          '`FÜR i = 1 BIS n`, darin `summe = summe + zahlen[i]`, dann '
          '`ENDE FÜR` und `AUSGABE summe`. Welche Zeile fehlt, und wo gehört '
          'sie hin?',
      optionen: [
        '`summe = 0` vor der Schleife',
        '`summe = 0` in der Schleife',
        '`i = i + 1` in der Schleife',
        '`AUSGABE i` nach der Schleife',
      ],
      richtig: 0,
      erklaerung: 'summe wird abgelesen, bevor sie je einen Wert bekommen '
          'hat. Es fehlt die Initialisierung `summe = 0`, und zwar vor der '
          'Schleife. In der Schleife würde sie summe bei jedem Durchlauf '
          'wieder auf 0 setzen. `i = i + 1` braucht die Zählschleife nicht, '
          'sie zählt selbst.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 9'),
    HinweisBlock(
      '- Pseudocode: Schlüsselwörter in Großbuchstaben, Inhalt eingerückt, '
      'jeder umschließende Baustein hat ein Ende.\n'
      '- Andere Schreibweisen: `:=` oder `←` für die Zuweisung, dann oft '
      '`=` für den Vergleich. Vorgaben der Aufgabe übernehmen.\n'
      '- Beim Übersetzen wird jeder Kasten eine Zeile.\n'
      '- Prüfliste für Fehler: Startwert, Bedingung, Schleifenende, '
      'Zuweisung, Ort der Ausgabe.\n'
      '- Im Zweifel: Schreibtischtest mit einer kleinen Eingabe.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-9-8',
      frage: 'Eine Schleife soll 5-mal laufen, läuft aber 6-mal. Wo suchst '
          'du den Fehler zuerst?',
      optionen: [
        'In der Ausgabe',
        'In der Grenze der Bedingung, zum Beispiel `<=` statt `<`',
        'Im Namen der Variablen',
        'In den Anführungszeichen',
      ],
      richtig: 1,
      erklaerung: 'Ein Durchlauf zu viel liegt fast immer an der Grenze. '
          'Prüfe, ob `<` oder `<=` gemeint ist und bei welchem Wert der '
          'Zähler startet. Ein kurzer Schreibtischtest zeigt es sicher.',
    )),
  ],
);
