// lib/data/kurse/struktogramm/lektion_02.dart
//
// Struktogramm-Kurs der App, Lektion 2. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 2: Variablen und Werte
// ═══════════════════════════════════════════════════════════════════════════
// Baut auf dem Zettel-Bild aus Lektion 1 auf. Neu: Variable, Zuweisung,
// Überschreiben, Rechnen (+, -, *), x = x + 1, Initialisierung, erster
// Schreibtischtest. Noch keine Bedingungen, keine Schleifen.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

const _guthaben = <SgBlock>[
  SgAnw('guthaben = 10'),
  SgAnw('guthaben = guthaben - 4'),
  SgAnw('guthaben = guthaben + 7'),
  SgAnw('Ausgabe guthaben'),
];

const _verdoppeln = <SgBlock>[
  SgAnw('Eingabe zahl'),
  SgAnw('doppelt = zahl * 2'),
  SgAnw('Ausgabe doppelt'),
];

const struktogrammLektion2 = Lektion(
  nr: 2,
  slug: 'struktogramm-2-variablen',
  titel: 'Variablen und Werte',
  kurzbeschreibung:
      'Wie sich ein Programm etwas merkt, was das Gleichheitszeichen '
      'bedeutet und wie du einen Ablauf Schritt für Schritt mitschreibst.',
  dauerMinuten: 30,
  bloecke: [
    // ── Seite: Variable ────────────────────────────────────────────────
    UeberschriftBlock('Der Computer merkt sich etwas'),
    TextBlock(
      'In Lektion 1 hast du den Zettel „name“ kennengelernt. Auf ihm hat '
      'sich der Computer gemerkt, was du eingetippt hast.\n'
      '\n'
      'So ein Zettel heißt richtig **Variable**. Eine Variable hat zwei '
      'Teile:\n'
      '- einen **Namen**, zum Beispiel `punkte`\n'
      '- einen **Wert**, also das, was gerade darauf steht, zum Beispiel 5\n'
      '\n'
      'Der Name bleibt immer gleich. Der Wert kann sich ändern. Daher kommt '
      'das Wort: „variabel“ heißt „veränderlich“.\n'
      '\n'
      'Auf einem Zettel kann Text stehen, wie der Name aus Lektion 1, oder '
      'eine Zahl. In dieser Lektion geht es um Zahlen, weil wir damit '
      'rechnen wollen.',
    ),

    // ── Seite: Zuweisung ───────────────────────────────────────────────
    UeberschriftBlock('Einen Wert hineinschreiben'),
    TextBlock(
      'So schreibst du einen Wert auf den Zettel:',
    ),
    StruktogrammBlock([SgAnw('punkte = 5')]),
    TextBlock(
      'Lies das als: „**punkte bekommt den Wert 5**“. Dieser Schritt heißt '
      '**Zuweisung**, weil der Variablen ein Wert zugewiesen wird.\n'
      '\n'
      'Wichtig: Das Gleichheitszeichen bedeutet hier **nicht** „ist gleich“ '
      'wie in Mathe. Es bedeutet „bekommt“. Links steht immer der Name, '
      'rechts der neue Wert.\n'
      '\n'
      'Auf einem Zettel steht immer nur **ein** Wert. Schreibst du etwas '
      'Neues darauf, wird das Alte vorher ausradiert:',
    ),
    StruktogrammBlock(
      [SgAnw('punkte = 5'), SgAnw('punkte = 8')],
      unterschrift: 'Erst steht 5 auf dem Zettel. Dann wird die 5 '
          'ausradiert und 8 hingeschrieben. Am Ende ist punkte 8.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-1',
      frage: 'Zuerst läuft `x = 3`, danach `x = 7`. '
          'Welcher Wert steht am Ende in x?',
      optionen: [
        '3',
        '7',
        '10',
        'Beide, also 3 und 7',
      ],
      richtig: 1,
      erklaerung: 'Eine Variable hat immer nur einen Wert. Bei `x = 7` '
          'wird die 3 überschrieben. Zusammengerechnet wird hier nichts.',
    )),

    // ── Seite: Rechnen ─────────────────────────────────────────────────
    UeberschriftBlock('Mit Variablen rechnen'),
    TextBlock(
      'Rechts vom Gleichheitszeichen darf auch eine Rechnung stehen:',
    ),
    StruktogrammBlock([SgAnw('summe = 4 + 3')]),
    TextBlock(
      'Rechts steht 4 + 3, das ist 7. Also bekommt `summe` den Wert 7.\n'
      '\n'
      'Die Regel dahinter: Der Computer rechnet **zuerst** die rechte Seite '
      'aus. Erst danach schreibt er das Ergebnis auf den Zettel links.\n'
      '\n'
      'Zum Rechnen gibt es diese Zeichen:\n'
      '- `+` plus\n'
      '- `-` minus\n'
      '- `*` mal. Auf der Tastatur gibt es kein Malkreuz, deshalb nimmt '
      'man den Stern.\n'
      '\n'
      'Teilen gibt es natürlich auch. Das hat beim Programmieren aber eine '
      'Besonderheit, deshalb kommt es erst in Lektion 4.\n'
      '\n'
      'Rechts dürfen auch Namen von Variablen stehen. Dann nimmt der '
      'Computer den Wert, der gerade auf diesem Zettel steht:',
    ),
    StruktogrammBlock(
      [
        SgAnw('preis = 3'),
        SgAnw('menge = 4'),
        SgAnw('gesamt = preis * menge'),
      ],
      unterschrift: 'Rechts steht preis * menge, also 3 * 4. '
          'gesamt bekommt den Wert 12.',
    ),
    TextBlock(
      'Beim Rechnen wird ein Wert nur **abgelesen**. Der Zettel `preis` '
      'behält seine 3.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-2',
      frage: 'Zuerst läuft `a = 4`, danach `b = a + 2`. '
          'Welche Werte haben a und b danach?',
      optionen: [
        'a ist 6 und b ist 6',
        'a ist 4 und b ist 2',
        'a ist 4 und b ist 6',
        'a ist 6 und b ist 4',
      ],
      richtig: 2,
      erklaerung: 'Rechts steht a + 2. Der Computer liest a ab, das ist 4, '
          'und rechnet 4 + 2 = 6. Das Ergebnis kommt auf den Zettel b. '
          'Auf a steht weiterhin 4, denn a wurde nur abgelesen.',
    )),

    // ── Seite: x = x + 1 ───────────────────────────────────────────────
    UeberschriftBlock('Der Trick mit punkte = punkte + 1'),
    TextBlock(
      'Diese Zeile sieht in Mathe unmöglich aus:',
    ),
    StruktogrammBlock([SgAnw('punkte = punkte + 1')]),
    TextBlock(
      'Mit der Regel „erst rechts ausrechnen, dann links hinschreiben“ '
      'ergibt sie Sinn. Angenommen, auf `punkte` steht gerade 5:\n'
      '- Rechts ausrechnen: Wert von punkte ablesen, das ist 5. '
      'Dann 5 + 1 = 6.\n'
      '- Links hinschreiben: Die 5 auf dem Zettel ausradieren, '
      '6 hinschreiben.\n'
      '\n'
      'Die Zeile heißt also: „Erhöhe punkte um 1.“ Das nennt man auch '
      '**hochzählen**. Du wirst es in fast jedem Programm wiedersehen.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-3',
      frage: 'Zuerst läuft `zaehler = 2`, danach '
          '`zaehler = zaehler + 3`. Welcher Wert steht am Ende in zaehler?',
      optionen: [
        '5',
        '3',
        '2',
        'Das geht nicht, 2 ist nicht gleich 5',
      ],
      richtig: 0,
      erklaerung: 'Rechts wird zuerst gerechnet: Wert von zaehler ist 2, '
          'dazu 3, ergibt 5. Dann bekommt zaehler den neuen Wert 5. '
          'Das Gleichheitszeichen heißt „bekommt“, nicht „ist gleich“.',
    )),

    // ── Seite: Schreibtischtest ────────────────────────────────────────
    UeberschriftBlock('Mitschreiben: der Schreibtischtest'),
    TextBlock(
      'Bei mehreren Schritten verliert man leicht den Überblick. '
      'Deshalb schreibt man mit, welcher Wert nach jedem Schritt auf '
      'welchem Zettel steht. Hier ein kleines Beispiel:',
    ),
    StruktogrammBlock(
      _guthaben,
      titel: 'Guthaben',
    ),
    TextBlock(
      'Das Mitschreiben machst du in einer Tabelle. Jede **Zeile** ist ein '
      'Schritt. Die erste Spalte nennt den Schritt. Dann kommt für jede '
      'Variable eine eigene **Spalte**. Ganz rechts steht, was der Computer '
      'in diesem Schritt ausgibt. Farbig markiert ist, was sich im '
      'jeweiligen Schritt geändert hat.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'guthaben', 'Ausgabe'],
      zeilen: [
        ['guthaben = 10', '10', ''],
        ['guthaben = guthaben - 4', '6', ''],
        ['guthaben = guthaben + 7', '13', ''],
        ['Ausgabe guthaben', '13', '13'],
      ],
      unterschrift: 'Am Ende wird 13 ausgegeben.',
    ),
    TextBlock(
      'So eine Tabelle heißt **Schreibtischtest**. Der Name kommt daher, '
      'dass man den Ablauf am Schreibtisch mit Stift und Papier prüft, '
      'ganz ohne Computer. In der AP1 lautet eine häufige Aufgabe: '
      '„Führen Sie einen Schreibtischtest durch.“',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-2-4',
      frage: 'Führe den Schreibtischtest im Kopf oder auf Papier durch. '
          'Welche Werte haben y und x nach dem letzten Schritt?',
      vorlage: 'x = 2\n'
          'y = x * 3\n'
          'x = x + y\n'
          '\n'
          'y ist am Ende ___\n'
          'x ist am Ende ___',
      loesungen: [
        ['6'],
        ['8'],
      ],
      erklaerung: 'Erst bekommt x den Wert 2. Dann rechnet der Computer '
          'x * 3, also 2 * 3 = 6, und y bekommt 6. Zum Schluss rechnet er '
          'x + y, also 2 + 6 = 8, und x bekommt 8. Auf y steht weiterhin 6.',
    )),

    // ── Seite: Eingabe ─────────────────────────────────────────────────
    UeberschriftBlock('Eingabe in eine Variable'),
    TextBlock(
      'Jetzt verstehst du auch `Eingabe name` aus Lektion 1 genauer: '
      'Das, was jemand eintippt, wird der Variablen zugewiesen. '
      'Damit kann das Programm danach weiterrechnen:',
    ),
    StruktogrammBlock(
      _verdoppeln,
      titel: 'Verdoppeln',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'zahl', 'doppelt', 'Ausgabe'],
      zeilen: [
        ['Eingabe zahl', '7', '', ''],
        ['doppelt = zahl * 2', '7', '14', ''],
        ['Ausgabe doppelt', '7', '14', '14'],
      ],
      unterschrift: 'Schreibtischtest, wenn jemand 7 eintippt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-5',
      frage: 'Ein Programm hat diese drei Schritte: `Eingabe zahl`, dann '
          '`ergebnis = zahl + 10`, dann `Ausgabe ergebnis`. '
          'Jemand tippt 5 ein. Was wird ausgegeben?',
      optionen: [
        '10',
        'ergebnis',
        '5',
        '15',
      ],
      richtig: 3,
      erklaerung: 'zahl bekommt 5. Dann rechnet der Computer 5 + 10 = 15, '
          'und ergebnis bekommt 15. `Ausgabe ergebnis` ohne '
          'Anführungszeichen zeigt den Wert an, also 15.',
    )),

    // ── Seite: Initialisierung ─────────────────────────────────────────
    UeberschriftBlock('Erst ein Startwert, dann rechnen'),
    TextBlock(
      'Was passiert hier?',
    ),
    StruktogrammBlock(
      [SgAnw('summe = summe + 5'), SgAnw('Ausgabe summe')],
    ),
    TextBlock(
      'Der Computer soll den Wert von `summe` ablesen. Aber auf diesem '
      'Zettel steht noch gar nichts, es gibt nichts abzulesen. Deshalb '
      'bricht das Programm meist mit einem Fehler ab.\n'
      '\n'
      'Die Lösung: Vorher einen Startwert hineinschreiben.',
    ),
    StruktogrammBlock(
      [
        SgAnw('summe = 0'),
        SgAnw('summe = summe + 5'),
        SgAnw('Ausgabe summe'),
      ],
      unterschrift: 'Jetzt ist klar: 0 + 5 = 5, ausgegeben wird 5.',
    ),
    TextBlock(
      'Den ersten Wert in eine Variable zu schreiben, nennt man '
      '**Initialisierung**. Merke dir: Eine Variable muss einen Wert haben, '
      'bevor man ihn abliest. In Prüfungen gibt es für eine fehlende '
      'Initialisierung meist Punktabzug.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-6',
      frage: 'Ein Programm soll mit `anzahl = anzahl + 1` hochzählen. '
          'Was muss vorher passieren?',
      optionen: [
        'Nichts, anzahl beginnt immer bei 1',
        'anzahl muss einen Startwert bekommen, zum Beispiel 0',
        'anzahl muss ausgegeben werden',
        'Die Zeile muss anzahl + 1 = anzahl heißen',
      ],
      richtig: 1,
      erklaerung: 'Bevor der Computer den Wert von anzahl ablesen kann, '
          'muss einer draufstehen. Deshalb kommt vorher eine '
          'Initialisierung wie `anzahl = 0`. Links vom Gleichheitszeichen '
          'steht immer der Name, nie eine Rechnung.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 2'),
    HinweisBlock(
      '- Eine **Variable** hat einen Namen und einen Wert. '
      'Der Wert kann sich ändern.\n'
      '- `x = 5` heißt „x bekommt 5“. Das ist eine **Zuweisung**.\n'
      '- Ein neuer Wert ersetzt den alten.\n'
      '- Links vom Gleichheitszeichen steht immer nur der Name der '
      'Variablen, nie eine Rechnung.\n'
      '- Erst wird rechts gerechnet, dann links hingeschrieben. '
      'Deshalb funktioniert `x = x + 1`.\n'
      '- Rechnen: `+` plus, `-` minus, `*` mal.\n'
      '- Vor dem ersten Ablesen braucht eine Variable einen Startwert. '
      'Das heißt **Initialisierung**.\n'
      '- Im **Schreibtischtest** schreibst du nach jedem Schritt die Werte '
      'aller Variablen in eine Tabelle.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-2-7',
      frage: 'Was bedeutet das Gleichheitszeichen in `preis = 20`?',
      optionen: [
        'preis ist gleich 20, das wird geprüft',
        'preis bekommt den Wert 20',
        '20 bekommt den Wert von preis',
        'preis und 20 werden addiert',
      ],
      richtig: 1,
      erklaerung: 'Das Gleichheitszeichen ist hier eine Zuweisung: Die '
          'Variable links bekommt den Wert von rechts. Etwas prüfen, also '
          'vergleichen, lernst du in Lektion 3. Dort schreibt man dafür '
          'zwei Gleichheitszeichen: `==`.',
    )),
  ],
);
