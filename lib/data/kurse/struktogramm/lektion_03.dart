// lib/data/kurse/struktogramm/lektion_03.dart
//
// Struktogramm-Kurs der App, Lektion 3. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 3: Entscheidungen: die Verzweigung
// ═══════════════════════════════════════════════════════════════════════════
// Neu: Bedingung, wahr/falsch, Vergleiche, zweiseitige und einseitige
// Verzweigung, ∅, Grenzen („ab“, „über“), Pseudocode als Text-Zwilling,
// Startwert vor einseitiger Verzweigung. Noch kein UND/ODER (Lektion 4).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

const _bewertung = <SgBlock>[
  SgAnw('Eingabe punkte'),
  SgWenn(
    'punkte >= 50',
    [SgAnw('Ausgabe "bestanden"')],
    [SgAnw('Ausgabe "nicht bestanden"')],
  ),
];

const _tasche = <SgBlock>[
  SgAnw('Eingabe einkauf'),
  SgWenn('einkauf > 100', [SgAnw('Ausgabe "Gratis Tasche"')]),
  SgAnw('Ausgabe "Danke"'),
];

const _rabattFalsch = <SgBlock>[
  SgAnw('Eingabe betrag'),
  SgWenn('betrag >= 100', [SgAnw('rabatt = 10')]),
  SgAnw('Ausgabe rabatt'),
];

const _rabattRichtig = <SgBlock>[
  SgAnw('Eingabe betrag'),
  SgAnw('rabatt = 0'),
  SgWenn('betrag >= 100', [SgAnw('rabatt = 10')]),
  SgAnw('Ausgabe rabatt'),
];

const struktogrammLektion3 = Lektion(
  nr: 3,
  slug: 'struktogramm-3-verzweigung',
  titel: 'Entscheidungen: die Verzweigung',
  kurzbeschreibung:
      'Wie ein Programm eine Frage stellt und je nach Antwort etwas anderes '
      'tut. Mit Vergleichen, Grenzen und dem ersten Pseudocode.',
  dauerMinuten: 30,
  bloecke: [
    // ── Seite: Frage ───────────────────────────────────────────────────
    UeberschriftBlock('Eine Frage teilt den Weg'),
    TextBlock(
      'Bisher liefen alle Schritte immer gleich ab, von oben nach unten. '
      'Im Alltag entscheidest du aber ständig:\n'
      '\n'
      '„Regnet es? Wenn ja, nehme ich den Schirm mit. Wenn nein, lasse ich '
      'ihn zu Hause.“\n'
      '\n'
      'Genau das kann ein Programm auch. Es stellt eine Frage, die nur mit '
      '**ja** oder **nein** beantwortet werden kann. So eine Frage heißt '
      '**Bedingung**.\n'
      '\n'
      'Statt ja und nein sagt man beim Programmieren oft **wahr** und '
      '**falsch**. Das bedeutet dasselbe: Die Bedingung stimmt, oder sie '
      'stimmt nicht.',
    ),

    // ── Seite: Vergleiche ──────────────────────────────────────────────
    UeberschriftBlock('Vergleiche'),
    TextBlock(
      'Die meisten Bedingungen vergleichen zwei Werte. Angenommen, auf dem '
      'Zettel `punkte` steht 7. Dann gilt:',
    ),
    SchreibtischtestBlock(
      spalten: ['Zeichen', 'Bedeutung', 'Beispiel', 'Ergebnis'],
      zeilen: [
        ['>', 'größer als', 'punkte > 5', 'wahr'],
        ['<', 'kleiner als', 'punkte < 7', 'falsch'],
        ['>=', 'größer oder gleich', 'punkte >= 7', 'wahr'],
        ['<=', 'kleiner oder gleich', 'punkte <= 6', 'falsch'],
        ['==', 'ist gleich', 'punkte == 7', 'wahr'],
        ['!=', 'ist ungleich', 'punkte != 7', 'falsch'],
      ],
      unterschrift: 'Übersicht der Vergleichszeichen, wenn punkte den Wert 7 '
          'hat. Das ist kein Schreibtischtest, nur eine Liste.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Zwei Dinge zum Merken:\n'
      '- Bei `>` und `<` zeigt die Spitze immer auf die kleinere Seite. '
      'Die offene Seite zeigt zur größeren.\n'
      '- „Ist gleich“ schreibt man mit **zwei** Gleichheitszeichen: `==`. '
      'Ein einzelnes `=` ist ja schon vergeben. Es heißt „bekommt“, wie du '
      'aus Lektion 2 weißt.\n'
      '\n'
      'Ein Vergleich ändert nichts. Er schaut nur nach und antwortet mit '
      'wahr oder falsch.\n'
      '\n'
      'In Prüfungsaufgaben steht für „ungleich“ manchmal auch `<>` oder '
      '`≠`. Das bedeutet dasselbe wie `!=`.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-1',
      frage: 'Auf dem Zettel `x` steht 10. Welche Bedingung ist falsch?',
      optionen: [
        'x >= 10',
        'x != 5',
        'x < 10',
        'x == 10',
      ],
      richtig: 2,
      erklaerung: '10 ist nicht kleiner als 10, also ist `x < 10` falsch. '
          '`x >= 10` ist wahr, weil „oder gleich“ die 10 mit einschließt. '
          '`x != 5` ist wahr, denn 10 ist ungleich 5. `x == 10` ist wahr.',
    )),

    // ── Seite: Zweiseitige Verzweigung ─────────────────────────────────
    UeberschriftBlock('Die Verzweigung im Struktogramm'),
    TextBlock(
      'So sieht eine Entscheidung im Struktogramm aus:',
    ),
    StruktogrammBlock(
      _bewertung,
      titel: 'Bewertung',
    ),
    TextBlock(
      'Lies den Kasten mit dem Dreieck so:\n'
      '- Oben im Dreieck steht die **Bedingung**: `punkte >= 50`.\n'
      '- Darunter teilt sich der Weg in zwei Spalten. **Links** steht, was '
      'passiert, wenn die Bedingung wahr ist. Darüber steht „ja“.\n'
      '- **Rechts** steht, was passiert, wenn sie falsch ist. Darüber steht '
      '„nein“.\n'
      '\n'
      'Das Ganze heißt **Verzweigung**, weil sich der Weg verzweigt wie ein '
      'Ast. Es läuft immer **genau eine** der beiden Spalten, nie beide und '
      'nie keine.\n'
      '\n'
      'Tippt jemand 72 ein, ist `72 >= 50` wahr. Es erscheint „bestanden“. '
      'Bei 30 ist die Bedingung falsch, also erscheint „nicht bestanden“.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-2',
      frage: 'Beim Struktogramm „Bewertung“ tippt jemand genau 50 ein. '
          'Was wird ausgegeben?',
      optionen: [
        'bestanden',
        'nicht bestanden',
        'Beides nacheinander',
        'Gar nichts',
      ],
      richtig: 0,
      erklaerung: 'Die Bedingung lautet `punkte >= 50`, also „größer oder '
          'gleich 50“. 50 ist gleich 50, die Bedingung ist wahr. Deshalb '
          'läuft die linke Spalte: „bestanden“. Es läuft immer genau eine '
          'Spalte.',
    )),

    // ── Seite: Grenzen ─────────────────────────────────────────────────
    UeberschriftBlock('Auf die Grenze kommt es an'),
    TextBlock(
      'In Aufgaben steht die Bedingung meist als Satz. Dann musst du genau '
      'lesen, ob der **Grenzwert** selbst dazugehört, also die Zahl, an der '
      'sich die Entscheidung dreht:\n'
      '- „**ab** 50“ oder „mindestens 50“ heißt: 50 gehört dazu. '
      'Also `>= 50`.\n'
      '- „**über** 50“ oder „mehr als 50“ heißt: 50 gehört nicht dazu. '
      'Also `> 50`.\n'
      '- „**bis** 50“ oder „höchstens 50“ heißt: 50 gehört dazu. '
      'Also `<= 50`.\n'
      '- „**unter** 50“ oder „weniger als 50“ heißt: 50 gehört nicht dazu. '
      'Also `< 50`.\n'
      '\n'
      'Ein guter Test: Setz den Grenzwert selbst ein und prüf, ob das '
      'Ergebnis zur Aufgabe passt. Genau an der Grenze passieren in '
      'Prüfungen die meisten Fehler.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-3',
      frage: 'In der Aufgabe steht: „Ab 18 Jahren gilt der normale Preis.“ '
          'Welche Bedingung passt dazu?',
      optionen: [
        'alter > 18',
        'alter <= 18',
        'alter == 18',
        'alter >= 18',
      ],
      richtig: 3,
      erklaerung: '„Ab 18“ schließt die 18 mit ein. Wer genau 18 ist, zahlt '
          'schon den normalen Preis. Deshalb `alter >= 18`. Mit `alter > 18` '
          'wäre jemand mit genau 18 Jahren falsch eingeordnet.',
    )),

    // ── Seite: Einseitige Verzweigung ──────────────────────────────────
    UeberschriftBlock('Wenn im Nein-Fall nichts passiert'),
    TextBlock(
      'Manchmal soll nur im Ja-Fall etwas passieren. Beispiel: Wer für mehr '
      'als 100 Euro einkauft, bekommt eine Tasche geschenkt. Alle anderen '
      'bekommen nichts extra.',
    ),
    StruktogrammBlock(
      _tasche,
      titel: 'Gratis Tasche',
    ),
    TextBlock(
      'Die rechte Spalte ist leer. Damit niemand denkt, dort wurde etwas '
      'vergessen, steht darin das Zeichen **∅**. Es bedeutet: „Hier passiert '
      'nichts.“ So eine Verzweigung heißt **einseitig**. Die mit zwei '
      'gefüllten Spalten heißt **zweiseitig**.\n'
      '\n'
      'Achte auf den letzten Kasten „Danke“. Er steht **unter** der '
      'Verzweigung, nicht in einer der Spalten. Deshalb läuft er in jedem '
      'Fall, egal ob die Bedingung wahr oder falsch war.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-4',
      frage: 'Beim Struktogramm „Gratis Tasche“ tippt jemand 80 ein. '
          'Was wird ausgegeben?',
      optionen: [
        'Gratis Tasche, dann Danke',
        'Nur Gratis Tasche',
        'Nur Danke',
        'Gar nichts',
      ],
      richtig: 2,
      erklaerung: '`80 > 100` ist falsch. Also läuft die rechte Spalte, und '
          'dort steht ∅: Es passiert nichts. Danach geht es unter der '
          'Verzweigung weiter, und „Danke“ wird ausgegeben.',
    )),

    // ── Seite: Pseudocode ──────────────────────────────────────────────
    UeberschriftBlock('Dasselbe als Text: Pseudocode'),
    TextBlock(
      'Ein Struktogramm zu zeichnen, dauert. Deshalb schreibt man denselben '
      'Ablauf oft einfach als Text auf. Das heißt **Pseudocode**. „Pseudo“ '
      'bedeutet „unecht“: Es sieht aus wie ein Programm, ist aber keins. '
      'Es ist für Menschen gedacht und nicht für einen Computer.\n'
      '\n'
      'Die Bewertung als Pseudocode:',
    ),
    CodeBlock(
      'EINGABE punkte\n'
      'WENN punkte >= 50 DANN\n'
      '    AUSGABE "bestanden"\n'
      'SONST\n'
      '    AUSGABE "nicht bestanden"\n'
      'ENDE WENN',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'So liest du ihn:\n'
      '- Die Wörter in Großbuchstaben sind feste Wörter, auch '
      '**Schlüsselwörter** genannt: EINGABE, AUSGABE, WENN, DANN, SONST, '
      'ENDE WENN.\n'
      '- Im Struktogramm haben wir Eingabe und Ausgabe normal geschrieben. '
      'Im Pseudocode schreibt man diese festen Wörter groß, damit man sie '
      'sofort von Variablennamen unterscheidet. Gemeint ist dasselbe.\n'
      '- Die Zeilen unter WENN sind ein Stück nach rechts geschoben. Man '
      'sagt: Sie sind **eingerückt**. So sieht man sofort, was zur '
      'Verzweigung gehört.\n'
      '- Was unter WENN eingerückt ist, ist die linke Spalte (ja). '
      'Was unter SONST eingerückt ist, ist die rechte Spalte (nein).\n'
      '- ENDE WENN schließt die Verzweigung ab. Danach geht es für alle '
      'weiter.\n'
      '\n'
      'Bei einer einseitigen Verzweigung fällt SONST einfach weg:',
    ),
    CodeBlock(
      'EINGABE einkauf\n'
      'WENN einkauf > 100 DANN\n'
      '    AUSGABE "Gratis Tasche"\n'
      'ENDE WENN\n'
      'AUSGABE "Danke"',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'In der Prüfung darfst du meist wählen, ob du ein Struktogramm oder '
      'Pseudocode schreibst. Ab jetzt siehst du im Kurs beides.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-3-5',
      frage: 'Bring den Pseudocode in die richtige Reihenfolge. Das Programm '
          'liest eine Temperatur ein. Ist sie höher als 30, warnt es vor '
          'Hitze. Zum Schluss gibt es in jedem Fall „Fertig“ aus.',
      zeilen: [
        'EINGABE temperatur',
        'WENN temperatur > 30 DANN',
        'AUSGABE "Hitzewarnung"',
        'ENDE WENN',
        'AUSGABE "Fertig"',
      ],
      einrueckung: [0, 0, 1, 0, 0],
      erklaerung: 'Erst die Eingabe, dann die Frage. Die Warnung gehört in '
          'die Verzweigung, deshalb steht sie zwischen WENN und ENDE WENN. '
          '„Fertig“ kommt nach ENDE WENN, weil es in jedem Fall erscheinen '
          'soll.',
    )),

    // ── Seite: Startwert ───────────────────────────────────────────────
    UeberschriftBlock('Der vergessene Startwert'),
    TextBlock(
      'Bei einseitigen Verzweigungen passiert ein Fehler besonders oft. '
      'Schau dir dieses Struktogramm an: Ab 100 Euro soll es 10 Euro Rabatt '
      'geben.',
    ),
    StruktogrammBlock(
      _rabattFalsch,
      titel: 'Rabatt (falsch)',
    ),
    TextBlock(
      'Tippt jemand 80 ein, ist die Bedingung falsch. Die rechte Spalte ist '
      'leer, `rabatt` bekommt also nie einen Wert. Trotzdem soll danach '
      '`rabatt` ausgegeben werden. Der Zettel ist leer, das geht schief.\n'
      '\n'
      'Die Lösung kennst du aus Lektion 2: ein Startwert vorher. Die '
      'Verzweigung überschreibt ihn nur, wenn es Rabatt gibt.',
    ),
    StruktogrammBlock(
      _rabattRichtig,
      titel: 'Rabatt (richtig)',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'betrag', 'rabatt', 'Ausgabe'],
      zeilen: [
        ['Eingabe betrag', '80', '', ''],
        ['rabatt = 0', '80', '0', ''],
        ['betrag >= 100 ist falsch', '80', '0', ''],
        ['Ausgabe rabatt', '80', '0', '0'],
      ],
      unterschrift: 'Schreibtischtest für die Eingabe 80. Der Startwert 0 '
          'bleibt stehen und wird ausgegeben.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-6',
      frage: 'Im Struktogramm „Rabatt (richtig)“ tippt jemand 150 ein. '
          'Was wird ausgegeben?',
      optionen: [
        '0',
        '10',
        '150',
        'Erst 0, dann 10',
      ],
      richtig: 1,
      erklaerung: 'Zuerst bekommt rabatt den Startwert 0. Dann ist '
          '`150 >= 100` wahr, also läuft die linke Spalte, und rabatt '
          'bekommt 10. Die 0 wird dabei überschrieben. Ausgegeben wird nur '
          'einmal, am Ende: 10.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 3'),
    HinweisBlock(
      '- Eine **Bedingung** ist eine Frage, die wahr oder falsch ist.\n'
      '- Vergleiche: `>` `<` `>=` `<=` `==` `!=`. „Ist gleich“ hat zwei '
      'Gleichheitszeichen.\n'
      '- In der **Verzweigung** steht die Bedingung im Dreieck. Links läuft '
      'der Ja-Fall, rechts der Nein-Fall. Immer genau eine Seite.\n'
      '- Einseitig: Eine Seite ist leer und bekommt das Zeichen ∅.\n'
      '- Was unter der Verzweigung steht, läuft in jedem Fall.\n'
      '- Grenzen: „ab“ und „bis“ schließen den Wert ein, „über“ und '
      '„unter“ nicht.\n'
      '- **Pseudocode** ist derselbe Ablauf als Text, mit festen Wörtern '
      'wie EINGABE, AUSGABE, WENN, DANN, SONST, ENDE WENN.\n'
      '- Bekommt eine Variable nur im Ja-Fall einen Wert und wird sie '
      'danach gelesen, braucht sie vorher einen Startwert.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-3-7',
      frage: 'Was ist der Unterschied zwischen `x = 5` und `x == 5`?',
      optionen: [
        'Es gibt keinen, beides bedeutet dasselbe',
        '`x = 5` vergleicht, `x == 5` gibt x den Wert 5',
        '`x = 5` gibt x den Wert 5, `x == 5` vergleicht',
        '`x == 5` gibt x den Wert 5 zweimal',
      ],
      richtig: 2,
      erklaerung: 'Ein Gleichheitszeichen heißt „bekommt“: x bekommt 5. '
          'Zwei Gleichheitszeichen fragen „ist x gleich 5?“ und antworten '
          'mit wahr oder falsch, ohne etwas zu ändern.',
    )),
  ],
);
