// lib/data/kurse/struktogramm/lektion_04.dart
//
// Struktogramm-Kurs der App, Lektion 4. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 4: Mehrere Bedingungen und Rechnen
// ═══════════════════════════════════════════════════════════════════════════
// Neu: UND, ODER, NICHT, Klammern, Text vergleichen, DIV, MOD, gerade und
// ungerade, Teilbarkeit. Verschachtelte Verzweigungen erst in Lektion 6.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

const _versand = <SgBlock>[
  SgAnw('Eingabe bestellwert'),
  SgAnw('Eingabe land'),
  SgWenn(
    'bestellwert >= 50 UND land == "DE"',
    [SgAnw('versand = 0')],
    [SgAnw('versand = 5')],
  ),
  SgAnw('Ausgabe versand'),
];

const _wochenende = <SgBlock>[
  SgAnw('Eingabe tag'),
  SgWenn(
    'tag == 6 ODER tag == 7',
    [SgAnw('Ausgabe "Wochenende"')],
    [SgAnw('Ausgabe "Arbeitstag"')],
  ),
];

const _geradeUngerade = <SgBlock>[
  SgAnw('Eingabe zahl'),
  SgWenn(
    'zahl MOD 2 == 0',
    [SgAnw('Ausgabe "gerade"')],
    [SgAnw('Ausgabe "ungerade"')],
  ),
];

const struktogrammLektion4 = Lektion(
  nr: 4,
  slug: 'struktogramm-4-bedingungen-rechnen',
  titel: 'Mehrere Bedingungen und Rechnen',
  kurzbeschreibung:
      'Bedingungen mit UND, ODER und NICHT verknüpfen. Dazu DIV und MOD, '
      'mit denen du zum Beispiel prüfst, ob eine Zahl gerade ist.',
  dauerMinuten: 30,
  bloecke: [
    // ── Seite: UND ─────────────────────────────────────────────────────
    UeberschriftBlock('Zwei Bedingungen auf einmal: UND'),
    TextBlock(
      'Manchmal reicht eine Bedingung nicht. Denk an einen Kinobesuch: '
      'Du gehst nur, wenn du Zeit hast **und** genug Geld dabei hast. '
      'Fehlt eines von beiden, bleibst du zu Hause.\n'
      '\n'
      'Genau so funktioniert **UND** im Programm. Es verbindet zwei '
      'Bedingungen. Das Ganze ist nur wahr, wenn **beide** Teile wahr sind.',
    ),
    SchreibtischtestBlock(
      spalten: ['Zeit?', 'Geld?', 'Zeit UND Geld'],
      zeilen: [
        ['wahr', 'wahr', 'wahr'],
        ['wahr', 'falsch', 'falsch'],
        ['falsch', 'wahr', 'falsch'],
        ['falsch', 'falsch', 'falsch'],
      ],
      unterschrift: 'Nur in der ersten Zeile sind beide Teile wahr. '
          'Nur dort ist auch das Ganze wahr.',
      aenderungenMarkieren: false,
    ),

    // ── Seite: UND im Struktogramm ─────────────────────────────────────
    UeberschriftBlock('UND im Struktogramm'),
    TextBlock(
      'Ein Beispiel aus dem Versandhandel: Versandkostenfrei ist eine '
      'Bestellung ab 50 Euro, aber nur nach Deutschland.',
    ),
    StruktogrammBlock(
      _versand,
      titel: 'Versandkosten',
    ),
    CodeBlock(
      'EINGABE bestellwert\n'
      'EINGABE land\n'
      'WENN bestellwert >= 50 UND land == "DE" DANN\n'
      '    versand = 0\n'
      'SONST\n'
      '    versand = 5\n'
      'ENDE WENN\n'
      'AUSGABE versand',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'Neu ist hier `land == "DE"`: Man kann auch **Text** vergleichen. '
      'Der Text steht in Anführungszeichen. `==` prüft, ob er Buchstabe für '
      'Buchstabe genau gleich ist. Auch Groß- und Kleinschreibung zählt: '
      '`"de"` ist nicht gleich `"DE"`.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-1',
      frage: 'Im Struktogramm „Versandkosten“ ist bestellwert 60 und land '
          '`"AT"` (Österreich). Welcher Wert wird ausgegeben?',
      optionen: [
        '0',
        '5',
        '60',
        '55',
      ],
      richtig: 1,
      erklaerung: '`60 >= 50` ist wahr, aber `"AT" == "DE"` ist falsch. '
          'Bei UND müssen beide Teile wahr sein, also ist die ganze '
          'Bedingung falsch. Es läuft die rechte Spalte: versand = 5.',
    )),

    // ── Seite: ODER ────────────────────────────────────────────────────
    UeberschriftBlock('Eine von beiden reicht: ODER'),
    TextBlock(
      'Im Zoo gilt: Freien Eintritt haben Kinder **oder** Mitglieder des '
      'Zoovereins. Ein Kind kommt umsonst rein. Ein Mitglied auch. Und ein '
      'Kind, das zugleich Mitglied ist? Natürlich auch.\n'
      '\n'
      'Das ist **ODER**: Das Ganze ist wahr, wenn **mindestens eine** Seite '
      'wahr ist. Sind beide wahr, ist es auch wahr.\n'
      '\n'
      'Vorsicht: Im Alltag meint man mit „oder“ oft „entweder oder“, also '
      'genau eins von beiden. Im Programm nicht. Hier ist ODER auch dann '
      'wahr, wenn beide Seiten stimmen.',
    ),
    TextBlock(
      'In der Tabelle stehen A und B für zwei beliebige Bedingungen, zum '
      'Beispiel „ist ein Kind“ und „ist Mitglied“.',
    ),
    SchreibtischtestBlock(
      spalten: ['A', 'B', 'A ODER B'],
      zeilen: [
        ['wahr', 'wahr', 'wahr'],
        ['wahr', 'falsch', 'wahr'],
        ['falsch', 'wahr', 'wahr'],
        ['falsch', 'falsch', 'falsch'],
      ],
      unterschrift: 'Nur wenn beide Seiten falsch sind, ist auch das Ganze '
          'falsch.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Ein Beispiel: Die Tage sind durchnummeriert, Montag ist 1 und '
      'Sonntag ist 7. Samstag (6) oder Sonntag (7) ist Wochenende.',
    ),
    StruktogrammBlock(
      _wochenende,
      titel: 'Wochenende',
    ),
    TextBlock(
      'Wichtig: Man muss den Namen auf beiden Seiten hinschreiben. '
      '`tag == 6 ODER 7` wäre falsch, denn „7“ allein ist keine Frage.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-2',
      frage: 'Im Struktogramm „Wochenende“ tippt jemand 7 ein. '
          'Was wird ausgegeben?',
      optionen: [
        'Arbeitstag',
        'Wochenende',
        'Nichts, weil nur eine Seite wahr ist',
        'Wochenende und Arbeitstag',
      ],
      richtig: 1,
      erklaerung: '`7 == 6` ist falsch, `7 == 7` ist wahr. Bei ODER reicht '
          'eine wahre Seite. Die Bedingung ist also wahr, und es erscheint '
          '„Wochenende“.',
    )),

    // ── Seite: NICHT ───────────────────────────────────────────────────
    UeberschriftBlock('Umdrehen: NICHT'),
    TextBlock(
      '„Wenn es **nicht** regnet, gehen wir raus.“ Hier wird eine Bedingung '
      'umgedreht: Wir gehen raus, wenn „es regnet“ falsch ist.\n'
      '\n'
      'Im Programm macht das **NICHT**. Es steht vor einer Bedingung und '
      'dreht sie um. Aus wahr wird falsch, aus falsch wird wahr.\n'
      '\n'
      'Angenommen, auf `x` steht 3:\n'
      '- `x > 5` ist falsch.\n'
      '- `NICHT (x > 5)` ist deshalb wahr.\n'
      '\n'
      'Die Klammer zeigt, was umgedreht wird. `NICHT (x > 5)` bedeutet '
      'dasselbe wie `x <= 5`. Meist ist die zweite Schreibweise leichter '
      'zu lesen. In Prüfungen begegnet dir NICHT trotzdem, deshalb solltest '
      'du es kennen.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-3',
      frage: 'Auf `a` steht 3. Ist `NICHT (a < 5)` wahr oder falsch?',
      optionen: [
        'wahr, weil 3 kleiner als 5 ist',
        'falsch, weil 3 kleiner als 5 ist',
        'wahr, weil NICHT immer wahr ist',
        'Das lässt sich nicht sagen',
      ],
      richtig: 1,
      erklaerung: '`3 < 5` ist wahr. NICHT dreht das um, also ist '
          '`NICHT (a < 5)` falsch.',
    )),

    // ── Seite: Klammern ────────────────────────────────────────────────
    UeberschriftBlock('Klammern zuerst'),
    TextBlock(
      'Ein Ausflug soll stattfinden, wenn Wochenende ist und die Sonne '
      'scheint. Wochenende ist Samstag oder Sonntag. Hier stecken also UND '
      'und ODER in einer Bedingung:',
    ),
    StruktogrammBlock(
      [
        SgAnw('Eingabe tag'),
        SgAnw('Eingabe wetter'),
        SgWenn(
          '(tag == 6 ODER tag == 7) UND wetter == "Sonne"',
          [SgAnw('Ausgabe "Ausflug"')],
          [SgAnw('Ausgabe "Zu Hause bleiben"')],
        ),
      ],
      titel: 'Ausflug',
    ),
    TextBlock(
      'Wie in Mathe gilt: Was in **Klammern** steht, wird zuerst '
      'ausgewertet. Für tag 7 und wetter `"Regen"` rechnest du so:\n'
      '- Zuerst die Klammer: `7 == 6` ist falsch, `7 == 7` ist wahr. '
      'Falsch ODER wahr ergibt **wahr**.\n'
      '- Dann der Rest: `"Regen" == "Sonne"` ist **falsch**.\n'
      '- Zum Schluss: wahr UND falsch ergibt **falsch**. Es heißt „Zu Hause '
      'bleiben“.\n'
      '\n'
      'Setz bei gemischten Bedingungen immer Klammern. Dann muss niemand '
      'raten, was zuerst gilt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-4',
      frage: 'Im Struktogramm „Ausflug“ ist tag 6 und wetter `"Sonne"`. '
          'Was wird ausgegeben?',
      optionen: [
        'Zu Hause bleiben',
        'Nichts',
        'Ausflug',
        'Ausflug und Zu Hause bleiben',
      ],
      richtig: 2,
      erklaerung: 'Klammer: `6 == 6` ist wahr, also ist die ganze Klammer '
          'wahr. `"Sonne" == "Sonne"` ist auch wahr. Wahr UND wahr ergibt '
          'wahr, also „Ausflug“.',
    )),

    // ── Seite: DIV ─────────────────────────────────────────────────────
    UeberschriftBlock('Ganzzahlig teilen: DIV'),
    TextBlock(
      'Jetzt zwei Rechenarten, die in Prüfungen oft vorkommen.\n'
      '\n'
      'Stell dir vor, du verteilst 17 Kekse an 5 Kinder. Jedes Kind bekommt '
      'gleich viele ganze Kekse. Jedes bekommt 3, denn 5 mal 3 ist 15. '
      '2 Kekse bleiben übrig.\n'
      '\n'
      '**DIV** beantwortet die Frage: Wie oft passt die zweite Zahl ganz in '
      'die erste? Bei `17 DIV 5` also: Wie oft passt 5 in 17? '
      'Der Rest wird einfach weggelassen.\n'
      '- `17 DIV 5` ergibt **3**.\n'
      '- `20 DIV 5` ergibt **4**.\n'
      '- `3 DIV 5` ergibt **0**, denn 5 passt kein einziges Mal in 3.\n'
      '\n'
      'Zum Vergleich: Die normale Division `17 / 5` ergibt 3,4, also mit '
      'Nachkommastellen. DIV liefert immer eine ganze Zahl.',
    ),

    // ── Seite: MOD ─────────────────────────────────────────────────────
    UeberschriftBlock('Der Rest: MOD'),
    TextBlock(
      'Bei den Keksen blieben 2 übrig. Genau diesen Rest liefert **MOD**.',
    ),
    SchreibtischtestBlock(
      spalten: ['Rechnung', 'DIV', 'MOD', 'Warum'],
      zeilen: [
        ['17 und 5', '3', '2', '5 * 3 = 15, Rest 2'],
        ['20 und 5', '4', '0', '5 * 4 = 20, kein Rest'],
        ['7 und 2', '3', '1', '2 * 3 = 6, Rest 1'],
        ['3 und 5', '0', '3', '5 passt nicht, Rest 3'],
      ],
      unterschrift: 'So liest du die erste Zeile: 17 DIV 5 ergibt 3, '
          '17 MOD 5 ergibt 2.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Die letzte Zeile ist eine beliebte Falle: Ist die erste Zahl kleiner, '
      'passt die zweite kein Mal hinein. Dann bleibt die erste Zahl ganz '
      'als Rest übrig.\n'
      '\n'
      'In manchen Aufgaben steht statt MOD das Zeichen `%`. Es bedeutet '
      'dasselbe.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-4-5',
      frage: 'Rechne beide Ergebnisse aus.',
      vorlage: '23 DIV 4 ergibt ___\n'
          '23 MOD 4 ergibt ___',
      loesungen: [
        ['5', 'fünf'],
        ['3', 'drei'],
      ],
      erklaerung: '4 passt fünfmal in 23, denn 4 * 5 = 20. Also ergibt '
          '23 DIV 4 die 5. Übrig bleiben 23 - 20 = 3. Also ergibt 23 MOD 4 '
          'die 3.',
    )),

    // ── Seite: gerade/ungerade ─────────────────────────────────────────
    UeberschriftBlock('Gerade oder ungerade?'),
    TextBlock(
      'Wofür braucht man den Rest? Vor allem, um zu prüfen, ob eine Zahl '
      'durch eine andere **teilbar** ist. Teilbar heißt: Es bleibt kein '
      'Rest, MOD ergibt also 0.\n'
      '\n'
      'Eine Zahl ist **gerade**, wenn sie durch 2 teilbar ist:',
    ),
    StruktogrammBlock(
      _geradeUngerade,
      titel: 'Gerade oder ungerade',
    ),
    TextBlock(
      'Für 8 ist `8 MOD 2` gleich 0, die Bedingung ist wahr: „gerade“. '
      'Für 7 ist `7 MOD 2` gleich 1, die Bedingung ist falsch: „ungerade“.\n'
      '\n'
      'Genauso prüfst du jede andere Teilbarkeit:\n'
      '- durch 3 teilbar: `zahl MOD 3 == 0`\n'
      '- durch 10 teilbar: `zahl MOD 10 == 0`',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-6',
      frage: 'Welche Bedingung ist genau dann wahr, wenn zahl durch 5 '
          'teilbar ist?',
      optionen: [
        'zahl DIV 5 == 0',
        'zahl MOD 5 == 0',
        'zahl MOD 5 == 5',
        'zahl / 5 == 0',
      ],
      richtig: 1,
      erklaerung: 'Teilbar heißt: kein Rest. Den Rest liefert MOD, also '
          '`zahl MOD 5 == 0`. `zahl DIV 5 == 0` stimmt nur für Zahlen, die '
          'kleiner als 5 sind. Einen Rest von 5 gibt es beim Teilen durch 5 '
          'nie.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 4'),
    HinweisBlock(
      '- **UND**: nur wahr, wenn beide Seiten wahr sind.\n'
      '- **ODER**: wahr, wenn mindestens eine Seite wahr ist, auch wenn '
      'beide stimmen.\n'
      '- **NICHT**: dreht wahr und falsch um.\n'
      '- Klammern werden zuerst ausgewertet. Bei gemischten Bedingungen '
      'immer Klammern setzen.\n'
      '- Text vergleichst du mit `==`, der Text steht in Anführungszeichen.\n'
      '- **DIV**: Wie oft passt die zweite Zahl ganz in die erste? '
      '`17 DIV 5` ist 3.\n'
      '- **MOD**: Was bleibt übrig? `17 MOD 5` ist 2.\n'
      '- Teilbar heißt `MOD ... == 0`. Gerade: `zahl MOD 2 == 0`.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-4-7',
      frage: 'Auf `zahl` steht 12. Ist '
          '`zahl MOD 2 == 0 UND zahl MOD 5 == 0` wahr oder falsch?',
      optionen: [
        'wahr, weil 12 gerade ist',
        'falsch, weil 12 nicht durch 5 teilbar ist',
        'wahr, weil eine Seite reicht',
        'falsch, weil 12 ungerade ist',
      ],
      richtig: 1,
      erklaerung: '`12 MOD 2` ist 0, der erste Teil ist wahr. `12 MOD 5` '
          'ist 2, der zweite Teil ist falsch. Bei UND müssen beide wahr '
          'sein, also ist das Ganze falsch. „Eine Seite reicht“ gilt nur '
          'bei ODER.',
    )),
  ],
);
