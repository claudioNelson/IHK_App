// lib/data/kurse/struktogramm/lektion_06.dart
//
// Struktogramm-Kurs der App, Lektion 6. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 6: Mehrfachauswahl und Verschachtelung
// ═══════════════════════════════════════════════════════════════════════════
// Neu: Verzweigung in Verzweigung, Mehrfachauswahl (falls, sonst),
// Wahl zwischen Mehrfachauswahl und Verzweigung, Verzweigung in Schleife,
// Schleife in Schleife, Schreibtischtest bei verschachtelten Abläufen.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _porto = <SgBlock>[
  SgAnw('Eingabe gewicht'),
  SgWenn(
    'gewicht <= 20',
    [SgAnw('porto = 95')],
    [
      SgWenn(
        'gewicht <= 50',
        [SgAnw('porto = 110')],
        [SgAnw('porto = 160')],
      ),
    ],
  ),
  SgAnw('Ausgabe porto'),
];

const _menue = <SgBlock>[
  SgAnw('Eingabe auswahl'),
  SgFalls(
    'auswahl',
    [
      SgFall('1', [SgAnw('Ausgabe "Neu"')]),
      SgFall('2', [SgAnw('Ausgabe "Öffnen"')]),
      SgFall('3', [SgAnw('Ausgabe "Beenden"')]),
    ],
    sonst: [SgAnw('Ausgabe "Ungültig"')],
  ),
];

const _geradeZaehlen = <SgBlock>[
  SgAnw('Eingabe n'),
  SgAnw('anzahl = 0'),
  SgFuer('für i = 1 bis n', [
    SgWenn('i MOD 2 == 0', [SgAnw('anzahl = anzahl + 1')]),
  ]),
  SgAnw('Ausgabe anzahl'),
];

const _einmaleins = <SgBlock>[
  SgFuer('für i = 1 bis 3', [
    SgFuer('für j = 1 bis 3', [
      SgAnw('Ausgabe i * j'),
    ]),
  ]),
];

const _dreieck = <SgBlock>[
  SgAnw('summe = 0'),
  SgFuer('für i = 1 bis 3', [
    SgFuer('für j = 1 bis i', [
      SgAnw('summe = summe + j'),
    ]),
    SgAnw('Ausgabe summe'),
  ]),
];

const struktogrammLektion6 = Lektion(
  nr: 6,
  slug: 'struktogramm-6-verschachtelung',
  titel: 'Mehrfachauswahl und Verschachtelung',
  kurzbeschreibung:
      'Fragen in Fragen, Schleifen in Schleifen und die Mehrfachauswahl. '
      'Dazu der Schreibtischtest für Abläufe mit mehreren Ebenen.',
  dauerMinuten: 45,
  bloecke: [
    // ── Seite: Verzweigung in Verzweigung ──────────────────────────────
    UeberschriftBlock('Eine Frage in der Frage'),
    TextBlock(
      'Bisher hatte eine Verzweigung zwei Wege. Was, wenn es drei gibt? '
      'Beim Briefporto zum Beispiel:\n'
      '- bis 20 Gramm: 95 Cent\n'
      '- bis 50 Gramm: 110 Cent\n'
      '- darüber: 160 Cent\n'
      '\n'
      'Die Lösung: In einen Zweig kommt eine **zweite Verzweigung**. Das '
      'nennt man **Verschachtelung**, weil ein Kasten im anderen steckt, '
      'wie bei Schachteln.',
    ),
    StruktogrammBlock(
      _porto,
      titel: 'Porto',
    ),
    TextBlock(
      'So liest du es:\n'
      '- Erste Frage: Wiegt der Brief höchstens 20 Gramm? „Höchstens“ '
      'heißt wie „bis“: Die 20 zählt noch dazu. Wenn ja, 95 Cent. '
      'Fertig.\n'
      '- Wenn nein, kommt im rechten Zweig die zweite Frage: höchstens '
      '50 Gramm? Wenn ja, 110 Cent, sonst 160 Cent.\n'
      '\n'
      'Die zweite Bedingung muss nicht `gewicht > 20 UND gewicht <= 50` '
      'heißen. Wer im rechten Zweig ankommt, wiegt ja schon mehr als '
      '20 Gramm.',
    ),
    CodeBlock(
      'EINGABE gewicht\n'
      'WENN gewicht <= 20 DANN\n'
      '    porto = 95\n'
      'SONST\n'
      '    WENN gewicht <= 50 DANN\n'
      '        porto = 110\n'
      '    SONST\n'
      '        porto = 160\n'
      '    ENDE WENN\n'
      'ENDE WENN\n'
      'AUSGABE porto',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'Im Pseudocode zeigt die **Einrückung**, was wo drinsteckt. Die '
      'innere Verzweigung ist weiter eingerückt und hat ihr eigenes '
      'ENDE WENN.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-6-1',
      frage: 'Im Struktogramm „Porto“ wiegt ein Brief genau 50 Gramm. '
          'Welcher Wert wird ausgegeben?',
      optionen: [
        '95',
        '160',
        '110',
        '110 und 160',
      ],
      richtig: 2,
      erklaerung: '`50 <= 20` ist falsch, also geht es nach rechts. Dort ist '
          '`50 <= 50` wahr, denn „höchstens“ schließt die 50 ein. Also '
          'porto = 110.',
    )),

    // ── Seite: Mehrfachauswahl ─────────────────────────────────────────
    UeberschriftBlock('Viele feste Werte: die Mehrfachauswahl'),
    TextBlock(
      'Ein Programm zeigt ein Menü: 1 für „Neu“, 2 für „Öffnen“, 3 für '
      '„Beenden“. Mit Verzweigungen bräuchtest du drei ineinander. Dafür '
      'gibt es einen eigenen Baustein, die **Mehrfachauswahl**:',
    ),
    StruktogrammBlock(
      _menue,
      titel: 'Menü',
    ),
    TextBlock(
      'So liest du den Kasten:\n'
      '- Oben links steht, was geprüft wird: hier `auswahl`.\n'
      '- Darunter stehen die möglichen **Fälle**: 1, 2 und 3. Unter jedem '
      'Fall steht eine eigene Spalte.\n'
      '- Ganz rechts steht **sonst**. Diese Spalte läuft, wenn kein Fall '
      'passt, zum Beispiel bei einer 9.\n'
      '\n'
      'Wie bei der Verzweigung läuft immer **genau eine** Spalte. Danach '
      'geht es unter dem Kasten weiter.',
    ),
    CodeBlock(
      'EINGABE auswahl\n'
      'FALLS auswahl\n'
      '    FALL 1: AUSGABE "Neu"\n'
      '    FALL 2: AUSGABE "Öffnen"\n'
      '    FALL 3: AUSGABE "Beenden"\n'
      '    SONST: AUSGABE "Ungültig"\n'
      'ENDE FALLS',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-6-2',
      frage: 'Im Struktogramm „Menü“ tippt jemand 9 ein. '
          'Was wird ausgegeben?',
      optionen: [
        'Beenden',
        'Ungültig',
        'Nichts',
        'Neu',
      ],
      richtig: 1,
      erklaerung: 'Für 9 gibt es keinen Fall. Deshalb läuft die Spalte '
          '„sonst“, und es erscheint „Ungültig“.',
    )),

    // ── Seite: Ohne sonst / Wahl ───────────────────────────────────────
    UeberschriftBlock('Mehrfachauswahl oder Verzweigung?'),
    TextBlock(
      'Das „sonst“ ist freiwillig. Fehlt es und kein Fall passt, passiert '
      'in der Mehrfachauswahl einfach nichts. Das ist wie der leere Zweig '
      'mit ∅ bei der Verzweigung. Bei Eingaben ist ein „sonst“ aber fast '
      'immer sinnvoll, weil es falsche Eingaben abfängt.\n'
      '\n'
      'Wann nimmst du was? Eine Faustregel:\n'
      '- **Mehrfachauswahl**, wenn **ein** Wert mit mehreren **festen** '
      'Werten verglichen wird: Menünummer, Wochentag, Kürzel.\n'
      '- **Verzweigungen**, wenn es um **Bereiche** geht („bis 20 Gramm“) '
      'oder die Fälle ganz verschiedene Bedingungen haben.\n'
      '\n'
      'In der Prüfung ist beides erlaubt. Die Mehrfachauswahl ist bei '
      'vielen Fällen nur übersichtlicher.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-6-3',
      frage: 'Eine Zahl von 1 bis 7 soll in den Namen des Wochentags '
          'umgewandelt werden. Welcher Baustein passt am besten?',
      optionen: [
        'Eine Zählschleife von 1 bis 7',
        'Eine einzige Verzweigung',
        'Eine fußgesteuerte Schleife',
        'Eine Mehrfachauswahl mit sieben Fällen und „sonst“',
      ],
      richtig: 3,
      erklaerung: 'Ein Wert wird mit sieben festen Werten verglichen. Genau '
          'dafür ist die Mehrfachauswahl da. Das „sonst“ fängt Zahlen wie 0 '
          'oder 8 ab.',
    )),

    // ── Seite: Verzweigung in Schleife ─────────────────────────────────
    UeberschriftBlock('Eine Verzweigung in der Schleife'),
    TextBlock(
      'Verschachteln kann man alle Bausteine. Sehr häufig steht eine '
      'Verzweigung **im Rumpf** einer Schleife. Die Schleife geht Zahlen '
      'durch, und bei jeder Zahl wird etwas geprüft.\n'
      '\n'
      'Beispiel: Wie viele gerade Zahlen gibt es von 1 bis n?',
    ),
    StruktogrammBlock(
      _geradeZaehlen,
      titel: 'Gerade Zahlen zählen',
    ),
    TextBlock(
      'Die Verzweigung wird bei **jedem** Durchlauf neu geprüft, einmal für '
      'jedes i. Wichtig ist, wo `anzahl = 0` steht: **vor** der Schleife. '
      'Stünde es im Rumpf, würde der Zähler bei jedem Durchlauf wieder auf 0 '
      'gesetzt.',
    ),
    SchreibtischtestBlock(
      spalten: ['Prüfung', 'i', 'anzahl'],
      zeilen: [
        ['Start', '', '0'],
        ['1 MOD 2 == 0? nein', '1', '0'],
        ['2 MOD 2 == 0? ja', '2', '1'],
        ['3 MOD 2 == 0? nein', '3', '1'],
        ['4 MOD 2 == 0? ja', '4', '2'],
        ['5 MOD 2 == 0? nein', '5', '2'],
      ],
      unterschrift: 'Schreibtischtest für n = 5. Die Spalte „Prüfung“ zeigt '
          'bei jedem Durchlauf, ob die Bedingung wahr war. Ausgegeben wird 2.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-6-4',
      frage: 'Was gibt „Gerade Zahlen zählen“ für n = 7 aus?',
      vorlage: 'Eingabe: n = 7\n'
          '\n'
          'Ausgabe: ___',
      loesungen: [
        ['3'],
      ],
      erklaerung: 'Von 1 bis 7 sind 2, 4 und 6 gerade. Bei diesen drei '
          'Durchläufen ist die Bedingung wahr, anzahl wird dreimal erhöht. '
          'Ausgegeben wird 3.',
    )),

    // ── Seite: Schleife in Schleife ────────────────────────────────────
    UeberschriftBlock('Eine Schleife in der Schleife'),
    TextBlock(
      'Denk an eine Uhr: Für jede Stunde läuft der Minutenzeiger eine ganze '
      'Runde. Genauso ist es, wenn eine Schleife in einer anderen steckt. '
      'Die **innere** Schleife läuft bei **jedem** Durchlauf der äußeren '
      'komplett durch.',
    ),
    StruktogrammBlock(
      _einmaleins,
      titel: 'Einmaleins bis 3',
    ),
    TextBlock(
      'Die äußere Schleife zählt i von 1 bis 3. Für jedes i zählt die '
      'innere Schleife j von 1 bis 3. Ausgegeben wird:\n'
      '- bei i = 1: 1, 2, 3\n'
      '- bei i = 2: 2, 4, 6\n'
      '- bei i = 3: 3, 6, 9\n'
      '\n'
      'Das sind 3 mal 3 = **9** Ausgaben. Die Zahl der Durchläufe wird '
      '**multipliziert**, nicht addiert.\n'
      '\n'
      'Die innere Schleife braucht einen anderen Zähler als die äußere, '
      'hier j statt i. Sonst kämen sich beide in die Quere.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-6-5',
      frage: 'Eine äußere Schleife `für i = 1 bis 4` enthält eine innere '
          'Schleife `für j = 1 bis 3`. Im inneren Rumpf steht eine Ausgabe. '
          'Wie oft wird ausgegeben?',
      optionen: [
        '7-mal',
        '4-mal',
        '12-mal',
        '3-mal',
      ],
      richtig: 2,
      erklaerung: 'Bei jedem der 4 äußeren Durchläufe läuft die innere '
          'Schleife 3-mal. 4 mal 3 ergibt 12. Wer 7 sagt, hat addiert statt '
          'multipliziert.',
    )),

    // ── Seite: Schreibtischtest mit Ebenen ─────────────────────────────
    UeberschriftBlock('Schreibtischtest mit mehreren Ebenen'),
    TextBlock(
      'Bei verschachtelten Abläufen verliert man im Kopf sehr schnell einen '
      'Durchlauf. Dann hilft nur die Tabelle. Diese Regeln machen sie '
      'sicher:\n'
      '- Eine **Spalte je Variable**, auch für die Zähler i und j. Dazu eine '
      'Spalte „Ausgabe“.\n'
      '- **Eine Zeile je Durchlauf** der innersten Schleife. Dazu eine '
      'eigene Zeile für jeden weiteren Schritt im Rumpf der äußeren '
      'Schleife, zum Beispiel eine Ausgabe.\n'
      '- Bei jeder Bedingung aufschreiben, ob sie wahr oder falsch war.\n'
      '- In „Ausgabe“ nur dann etwas eintragen, wenn der Ausgabe-Kasten '
      'wirklich erreicht wird.\n'
      '\n'
      'Probier es an diesem Struktogramm. Achte darauf, **wo** die Ausgabe '
      'steht: im Rumpf der äußeren Schleife, aber unter der inneren.',
    ),
    StruktogrammBlock(
      _dreieck,
      titel: 'Summe in Stufen',
    ),
    TextBlock(
      'Die innere Schleife läuft `bis i`. Beim ersten äußeren Durchlauf '
      'läuft sie also einmal, beim zweiten zweimal, beim dritten dreimal. '
      'Nimm dir Papier und schreib die Tabelle, bevor du weiterblätterst.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-6-6',
      frage: 'Welche drei Zahlen gibt „Summe in Stufen“ nacheinander aus?',
      vorlage: 'erste Ausgabe:  ___\n'
          'zweite Ausgabe: ___\n'
          'dritte Ausgabe: ___',
      loesungen: [
        ['1'],
        ['4'],
        ['10'],
      ],
      erklaerung: 'summe wächst so: bei i = 1 kommt 1 dazu, Ausgabe 1. Bei '
          'i = 2 kommen 1 und 2 dazu, summe ist 4, Ausgabe 4. Bei i = 3 '
          'kommen 1, 2 und 3 dazu, summe ist 10, Ausgabe 10. Die Ausgabe '
          'steht unter der inneren Schleife, deshalb kommt sie dreimal, '
          'nicht sechsmal.',
    )),

    // ── Seite: Lösung als Tabelle ──────────────────────────────────────
    UeberschriftBlock('Die Lösung als Schreibtischtest'),
    TextBlock(
      'So sieht die vollständige Tabelle zu „Summe in Stufen“ aus. Jede '
      'Zeile ist ein Durchlauf der inneren Schleife oder eine Ausgabe:',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'i', 'j', 'summe', 'Ausgabe'],
      zeilen: [
        ['summe = 0', '', '', '0', ''],
        ['i = 1, j = 1', '1', '1', '1', ''],
        ['innere Schleife fertig', '1', '', '1', '1'],
        ['i = 2, j = 1', '2', '1', '2', ''],
        ['i = 2, j = 2', '2', '2', '4', ''],
        ['innere Schleife fertig', '2', '', '4', '4'],
        ['i = 3, j = 1', '3', '1', '5', ''],
        ['i = 3, j = 2', '3', '2', '7', ''],
        ['i = 3, j = 3', '3', '3', '10', ''],
        ['innere Schleife fertig', '3', '', '10', '10'],
      ],
      unterschrift: 'In der Prüfung gibt es oft für jede richtige Zeile '
          'Punkte, nicht nur für das Endergebnis. Die ganze Tabelle lohnt '
          'sich also.',
    ),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 6'),
    HinweisBlock(
      '- **Verschachtelung**: Ein Baustein steckt in einem anderen, zum '
      'Beispiel eine Verzweigung im Zweig einer Verzweigung.\n'
      '- Im Pseudocode zeigt die Einrückung, was wo drinsteckt.\n'
      '- **Mehrfachauswahl**: ein Wert, mehrere feste Fälle, dazu „sonst“ '
      'für alles andere. Genau eine Spalte läuft.\n'
      '- Für Bereiche („bis 20 Gramm“) nimmst du Verzweigungen.\n'
      '- Eine Verzweigung im Rumpf wird bei jedem Durchlauf neu geprüft. '
      'Zähler vor der Schleife auf 0 setzen.\n'
      '- Schleife in Schleife: Die innere läuft für jeden äußeren Durchlauf '
      'komplett. Anzahl der Durchläufe multiplizieren.\n'
      '- Schreibtischtest: eine Zeile je innerstem Durchlauf, Bedingungen '
      'mit Ergebnis notieren.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-6-7',
      frage: 'Eine Mehrfachauswahl hat die Fälle 1, 2 und 3, aber kein '
          '„sonst“. Der geprüfte Wert ist 5. Was passiert?',
      optionen: [
        'Der Fall 3 läuft, weil er am nächsten liegt',
        'Das Programm bricht ab',
        'Der Fall 1 läuft',
        'Keine Spalte läuft, es geht unter dem Kasten weiter',
      ],
      richtig: 3,
      erklaerung: 'Ohne „sonst“ passiert bei einem Wert ohne passenden Fall '
          'einfach nichts. Danach geht es ganz normal unter der '
          'Mehrfachauswahl weiter.',
    )),
  ],
);
