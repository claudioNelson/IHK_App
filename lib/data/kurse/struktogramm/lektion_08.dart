// lib/data/kurse/struktogramm/lektion_08.dart
//
// Struktogramm-Kurs der App, Lektion 8. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 8: Tauschen, Sortieren, Unterprogramme
// ═══════════════════════════════════════════════════════════════════════════
// Neu: Tauschen mit Hilfsvariable, Bubblesort (Idee, Struktogramm,
// Schreibtischtest), Unterprogramm, Funktion, Prozedur, Signatur,
// Parameter, Datentyp, Rückgabe, Aufruf, Argument, Lücken ergänzen.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

const _tauschFalsch = <SgBlock>[
  SgAnw('a = b'),
  SgAnw('b = a'),
];

const _tauschRichtig = <SgBlock>[
  SgAnw('hilf = a'),
  SgAnw('a = b'),
  SgAnw('b = hilf'),
];

const _bubblesort = <SgBlock>[
  SgFuer('für durchgang = 1 bis n - 1', [
    SgFuer('für i = 1 bis n - durchgang', [
      SgWenn('zahlen[i] > zahlen[i + 1]', [
        SgAnw('hilf = zahlen[i]'),
        SgAnw('zahlen[i] = zahlen[i + 1]'),
        SgAnw('zahlen[i + 1] = hilf'),
      ]),
    ]),
  ]),
];

const _doppelt = <SgBlock>[
  SgAnw('Rückgabe zahl * 2'),
];

const _summeFunktion = <SgBlock>[
  SgAnw('ergebnis = 0'),
  SgFuer('für i = 1 bis n', [
    SgAnw('ergebnis = ergebnis + zahlen[i]'),
  ]),
  SgAnw('Rückgabe ergebnis'),
];

const _ausgabeFeld = <SgBlock>[
  SgFuer('für i = 1 bis n', [
    SgAnw('Ausgabe zahlen[i]'),
  ]),
];

const _hauptprogramm = <SgBlock>[
  SgAufruf('ausgabeFeld(zahlen, n)'),
  SgAnw('gesamt = summe(zahlen, n)'),
  SgAnw('Ausgabe gesamt'),
];

const _maximumLuecke = <SgBlock>[
  SgAnw('max = zahlen[1]'),
  SgFuer('für i = 2 bis n', [
    SgWenn('zahlen[i] > max', [SgLuecke('1')]),
  ]),
  SgAnw('Rückgabe max'),
];

const struktogrammLektion8 = Lektion(
  nr: 8,
  slug: 'struktogramm-8-sortieren-unterprogramme',
  titel: 'Tauschen, Sortieren, Unterprogramme',
  kurzbeschreibung:
      'Zwei Werte richtig tauschen, ein Feld mit Bubblesort sortieren und '
      'Abläufe in eigene Teile mit Namen auslagern.',
  dauerMinuten: 45,
  bloecke: [
    // ── Seite: Tauschen ────────────────────────────────────────────────
    UeberschriftBlock('Zwei Werte tauschen'),
    TextBlock(
      'Du hast ein Glas mit Saft und ein Glas mit Wasser. Jetzt sollen die '
      'Inhalte getauscht werden. Kippst du den Saft einfach ins Wasserglas, '
      'vermischt sich beides, und das Wasser ist verloren. Du brauchst ein **drittes, leeres Glas** zum '
      'Zwischenlagern.\n'
      '\n'
      'Bei Variablen ist es genauso. Auf `a` steht 5, auf `b` steht 8. Der '
      'erste Versuch geht schief:',
    ),
    StruktogrammBlock(
      _tauschFalsch,
      titel: 'Tauschversuch (falsch)',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'a', 'b'],
      zeilen: [
        ['Start', '5', '8'],
        ['a = b', '8', '8'],
        ['b = a', '8', '8'],
      ],
      unterschrift: 'Nach a = b ist die 5 überschrieben. Sie ist weg, und '
          'b = a kopiert nur noch die 8.',
    ),
    TextBlock(
      'Richtig geht es mit einer **Hilfsvariable**, dem dritten Glas:',
    ),
    StruktogrammBlock(
      _tauschRichtig,
      titel: 'Tauschen (richtig)',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'a', 'b', 'hilf'],
      zeilen: [
        ['Start', '5', '8', ''],
        ['hilf = a', '5', '8', '5'],
        ['a = b', '8', '8', '5'],
        ['b = hilf', '8', '5', '5'],
      ],
      unterschrift: 'Die 5 wird zuerst in hilf gerettet und am Ende von dort '
          'nach b geholt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-1',
      frage: 'Auf `a` steht 3, auf `b` steht 9. Es läuft `a = b` und danach '
          '`b = a`. Was steht danach auf a und b?',
      optionen: [
        'a ist 9, b ist 3',
        'a ist 3, b ist 9',
        'a ist 9, b ist 9',
        'a ist 3, b ist 3',
      ],
      richtig: 2,
      erklaerung: 'Nach `a = b` steht auf a die 9, die 3 ist überschrieben. '
          '`b = a` schreibt dann 9 auf b. Beide sind 9. Zum Tauschen fehlt '
          'die Hilfsvariable.',
    )),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-8-2',
      frage: 'Bring die drei Schritte in die richtige Reihenfolge, damit die '
          'Werte von a und b getauscht werden.',
      zeilen: [
        'hilf = a',
        'a = b',
        'b = hilf',
      ],
      erklaerung: 'Zuerst den Wert von a retten, bevor er überschrieben '
          'wird. Dann bekommt a den Wert von b. Zum Schluss bekommt b den '
          'geretteten Wert aus hilf.',
    )),

    // ── Seite: Sortieren, Idee ─────────────────────────────────────────
    UeberschriftBlock('Sortieren: die Idee'),
    TextBlock(
      'Ein Feld soll der Größe nach sortiert werden, die kleinste Zahl '
      'vorne. Das bekannteste Verfahren für Prüfungen heißt **Bubblesort**. '
      'Die Idee ist einfach:\n'
      '- Vergleiche die ersten beiden Zahlen. Steht die größere links, '
      'tausche sie.\n'
      '- Dann vergleiche die zweite mit der dritten, und so weiter bis '
      'zum Ende.\n'
      '\n'
      'Nach so einem Durchgang ist die größte Zahl ganz hinten angekommen. '
      'Sie ist ans Ende gewandert, so wie eine Luftblase im Wasser nach '
      'oben steigt. „Bubble“ '
      'ist das englische Wort für Blase, daher der Name.\n'
      '\n'
      'Der erste Durchgang für das Feld 5, 2, 4, 1:',
    ),
    SchreibtischtestBlock(
      spalten: ['Vergleich', 'Tauschen?', 'Feld danach'],
      zeilen: [
        ['5 > 2', 'ja', '2, 5, 4, 1'],
        ['5 > 4', 'ja', '2, 4, 5, 1'],
        ['5 > 1', 'ja', '2, 4, 1, 5'],
      ],
      unterschrift: 'Die 5 wandert Schritt für Schritt nach hinten. Vorne ist '
          'das Feld noch nicht sortiert.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Dann beginnt der nächste Durchgang von vorn. Er muss nur noch bis '
      'vor die 5 gehen, denn die steht schon richtig. So geht es weiter, '
      'bis alles sortiert ist.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-3',
      frage: 'Das Feld 7, 3, 9, 1 wird mit Bubblesort sortiert. Wie sieht '
          'es nach dem **ersten** Durchgang aus?',
      optionen: [
        '1, 3, 7, 9',
        '3, 7, 1, 9',
        '3, 7, 9, 1',
        '3, 1, 7, 9',
      ],
      richtig: 1,
      erklaerung: '7 > 3: tauschen, 3, 7, 9, 1. 7 > 9: nein. 9 > 1: '
          'tauschen, 3, 7, 1, 9. Die größte Zahl, die 9, ist hinten. Ganz '
          'sortiert ist das Feld erst nach weiteren Durchgängen.',
    )),

    // ── Seite: Bubblesort als Struktogramm ─────────────────────────────
    UeberschriftBlock('Bubblesort als Struktogramm'),
    StruktogrammBlock(
      _bubblesort,
      titel: 'Bubblesort',
    ),
    TextBlock(
      'Hier steckt alles drin, was du bisher gelernt hast. Von außen nach '
      'innen:\n'
      '- Die **äußere Schleife** zählt die Durchgänge. Bei n Zahlen reichen '
      'n - 1 Durchgänge. Dann ist jede Zahl außer der ersten hinten '
      'einsortiert, und die erste steht von selbst richtig.\n'
      '- Die **innere Schleife** geht die Nachbarpaare durch. Sie läuft nur '
      'bis n - durchgang, weil hinten schon sortiert ist.\n'
      '- Die **Verzweigung** vergleicht ein Fach mit seinem rechten '
      'Nachbarn `zahlen[i + 1]`.\n'
      '- Im Ja-Zweig steht der **Tausch** mit Hilfsvariable.',
    ),

    // ── Seite: Bubblesort als Pseudocode ───────────────────────────────
    UeberschriftBlock('Bubblesort als Pseudocode'),
    TextBlock(
      'Derselbe Ablauf noch einmal als Text. Jede Ebene ist ein Stück weiter '
      'eingerückt:',
    ),
    CodeBlock(
      'FÜR durchgang = 1 BIS n - 1\n'
      '    FÜR i = 1 BIS n - durchgang\n'
      '        WENN zahlen[i] > zahlen[i + 1] DANN\n'
      '            hilf = zahlen[i]\n'
      '            zahlen[i] = zahlen[i + 1]\n'
      '            zahlen[i + 1] = hilf\n'
      '        ENDE WENN\n'
      '    ENDE FÜR\n'
      'ENDE FÜR',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),

    // ── Seite: Bubblesort Schreibtischtest ─────────────────────────────
    UeberschriftBlock('Bubblesort Schritt für Schritt'),
    TextBlock(
      'Der vollständige Schreibtischtest für 5, 2, 4, 1 mit n = 4:',
    ),
    SchreibtischtestBlock(
      spalten: ['durchgang', 'i', 'Vergleich', 'Tauschen?', 'Feld danach'],
      zeilen: [
        ['1', '1', '5 > 2', 'ja', '2, 5, 4, 1'],
        ['1', '2', '5 > 4', 'ja', '2, 4, 5, 1'],
        ['1', '3', '5 > 1', 'ja', '2, 4, 1, 5'],
        ['2', '1', '2 > 4', 'nein', '2, 4, 1, 5'],
        ['2', '2', '4 > 1', 'ja', '2, 1, 4, 5'],
        ['3', '1', '2 > 1', 'ja', '1, 2, 4, 5'],
      ],
      unterschrift: 'Im ersten Durchgang vergleicht die innere Schleife 3 '
          'Paare, dann 2, dann 1. Nach dem dritten Durchgang ist das Feld '
          'sortiert.',
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'In Prüfungen wird oft gefragt, wie das Feld nach dem ersten oder '
      'zweiten Durchgang aussieht. Übe deshalb vor allem, einen Durchgang '
      'Paar für Paar sauber durchzuspielen.\n'
      '\n'
      'Soll absteigend sortiert werden, also die größte Zahl vorne, drehst '
      'du nur den Vergleich um: `<` statt `>`.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-4',
      frage: 'Warum läuft die innere Schleife nur bis `n - durchgang` und '
          'nicht bis n?',
      optionen: [
        'Weil ein Zähler nie n erreichen darf',
        'Weil der Vergleich auch das Fach rechts daneben braucht und hinten '
            'schon sortiert ist',
        'Damit die kleinste Zahl vorne bleibt',
        'Weil die äußere Schleife sonst nicht endet',
      ],
      richtig: 1,
      erklaerung: 'Bei i = n gäbe es kein Fach `zahlen[n + 1]` mehr. Die '
          'Grenze muss also mindestens eins unter n liegen. Und nach jedem '
          'Durchgang ist hinten ein weiteres Fach fertig, deshalb wird die '
          'Grenze jedes Mal um eins kleiner.',
    )),

    // ── Seite: Unterprogramme, Idee ────────────────────────────────────
    UeberschriftBlock('Unterprogramme: Teile mit Namen'),
    TextBlock(
      'In einem Kochbuch steht oft: „Teig nach dem Grundrezept auf Seite 12 '
      'zubereiten.“ Das Grundrezept steht nur einmal im Buch. Jedes Rezept, '
      'das den Teig braucht, verweist einfach darauf.\n'
      '\n'
      'Bei Programmen macht man das auch. Ein Ablauf, den man öfter '
      'braucht, bekommt einen eigenen Namen und ein eigenes Struktogramm. '
      'Das nennt man **Unterprogramm**. Wer es benutzen will, **ruft** es '
      'mit seinem Namen **auf**.\n'
      '\n'
      'Es gibt zwei Arten:\n'
      '- Eine **Funktion** rechnet etwas aus und gibt das Ergebnis zurück. '
      'Das heißt **Rückgabe**.\n'
      '- Eine **Prozedur** tut etwas, zum Beispiel etwas ausgeben. Ein '
      'Ergebnis gibt sie nicht zurück.',
    ),

    // ── Seite: Funktion ────────────────────────────────────────────────
    UeberschriftBlock('Eine Funktion'),
    TextBlock(
      'Diese Funktion verdoppelt eine Zahl:',
    ),
    StruktogrammBlock(
      _doppelt,
      titel: 'doppelt(zahl: Ganzzahl): Ganzzahl',
    ),
    TextBlock(
      'Neu ist, was in der Überschrift steht. Diese Form heißt **Signatur** '
      'und hat drei Teile:\n'
      '- den **Namen**: `doppelt`\n'
      '- in Klammern die **Parameter**: `zahl: Ganzzahl`. Ein Parameter ist '
      'ein Zettel, den der Aufrufer beschreibt, bevor die Funktion '
      'losläuft.\n'
      '- nach dem Doppelpunkt den **Rückgabetyp**: Die Funktion gibt eine '
      'Ganzzahl zurück.\n'
      '\n'
      '„Ganzzahl“ ist ein **Datentyp**. Er sagt, welche Art von Wert auf '
      'einem Zettel stehen darf. Die vier wichtigsten: **Ganzzahl** (wie 7), '
      '**Kommazahl** (wie 5,5), **Text** (wie `"Hallo"`) und '
      '**Wahrheitswert** (wahr oder falsch).',
    ),
    HinweisBlock(
      'In Prüfungen heißt ein Unterprogramm oft **Methode**. Die Datentypen '
      'stehen oft auf Englisch: integer (Ganzzahl), double (Kommazahl), '
      'string (Text), boolean (Wahrheitswert). Manchmal steht der Typ vor '
      'dem Namen: `int zahl`. Gemeint ist immer dasselbe.',
    ),

    // ── Seite: Funktion aufrufen ───────────────────────────────────────
    UeberschriftBlock('Eine Funktion aufrufen'),
    TextBlock(
      'So wird die Funktion `doppelt` aufgerufen:',
    ),
    StruktogrammBlock(
      [SgAnw('ergebnis = doppelt(7)')],
    ),
    TextBlock(
      'Die 7 in der Klammer heißt **Argument**. Sie landet auf dem Zettel '
      '`zahl`. Die Funktion rechnet 7 * 2 und gibt 14 zurück. Die 14 kommt '
      'an die Stelle des Aufrufs, und `ergebnis` bekommt 14.\n'
      '\n'
      'Als Pseudocode schreibt man eine Funktion so: eine Kopfzeile mit '
      'FUNKTION und der Signatur, darunter eingerückt der Ablauf mit '
      'RÜCKGABE, am Ende ENDE FUNKTION.',
    ),
    CodeBlock(
      'FUNKTION doppelt(zahl: Ganzzahl): Ganzzahl\n'
      '    RÜCKGABE zahl * 2\n'
      'ENDE FUNKTION',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-5',
      frage: 'Die Funktion `doppelt` verdoppelt eine Zahl. Welchen Wert '
          'bekommt x bei `x = doppelt(5) + 1`?',
      optionen: [
        '11',
        '12',
        '6',
        '10',
      ],
      richtig: 0,
      erklaerung: 'Erst wird die Funktion aufgerufen: doppelt(5) gibt 10 '
          'zurück. Dann rechnet der Computer 10 + 1 = 11. x bekommt 11.',
    )),

    // ── Seite: Prozedur und Aufruf ─────────────────────────────────────
    UeberschriftBlock('Prozedur und Hauptprogramm'),
    TextBlock(
      'Zwei Unterprogramme für Felder. Auch `Feld` ist ein Datentyp: eine '
      'Reihe von Fächern wie in Lektion 7. Die Summe aus Lektion 7, jetzt '
      'als Funktion:',
    ),
    StruktogrammBlock(
      _summeFunktion,
      titel: 'summe(zahlen: Feld, n: Ganzzahl): Ganzzahl',
    ),
    TextBlock(
      'Die Variable in der Funktion heißt jetzt `ergebnis` statt `summe`, '
      'weil `summe` schon der Name der Funktion ist.\n'
      '\n'
      'Und eine Prozedur, die alle Werte ausgibt. Sie hat keinen '
      'Rückgabetyp, weil sie nichts zurückgibt:',
    ),
    StruktogrammBlock(
      _ausgabeFeld,
      titel: 'ausgabeFeld(zahlen: Feld, n: Ganzzahl)',
    ),
    TextBlock(
      'Das **Hauptprogramm** ist der Ablauf, der die Unterprogramme '
      'benutzt:',
    ),
    StruktogrammBlock(
      _hauptprogramm,
      titel: 'Hauptprogramm',
    ),
    TextBlock(
      'Zwei Arten, aufzurufen:\n'
      '- Eine **Prozedur** steht als eigener Schritt da. Dafür gibt es einen '
      'Kasten mit **doppelten Seitenlinien**.\n'
      '- Das Ergebnis einer **Funktion** wird gebraucht, deshalb steht ihr '
      'Aufruf in einer Zuweisung: `gesamt = summe(zahlen, n)`.\n'
      '\n'
      'Die Argumente stehen in derselben Reihenfolge wie die Parameter in '
      'der Signatur. Für das Feld 4, 9, 2, 7 gibt das Hauptprogramm erst '
      '4, 9, 2 und 7 aus, danach 22.\n'
      '\n'
      'Als Pseudocode sehen die Prozedur und das Hauptprogramm so aus:',
    ),
    CodeBlock(
      'PROZEDUR ausgabeFeld(zahlen: Feld, n: Ganzzahl)\n'
      '    FÜR i = 1 BIS n\n'
      '        AUSGABE zahlen[i]\n'
      '    ENDE FÜR\n'
      'ENDE PROZEDUR\n'
      '\n'
      'ausgabeFeld(zahlen, n)\n'
      'gesamt = summe(zahlen, n)\n'
      'AUSGABE gesamt',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-6',
      frage: 'Worin unterscheidet sich eine Funktion von einer Prozedur?',
      optionen: [
        'Eine Funktion hat Parameter, eine Prozedur nie',
        'Eine Prozedur darf keine Schleifen enthalten',
        'Eine Funktion gibt ein Ergebnis zurück, eine Prozedur nicht',
        'Eine Funktion darf nur einmal aufgerufen werden',
      ],
      richtig: 2,
      erklaerung: 'Beide können Parameter und alle Bausteine enthalten. Der '
          'Unterschied ist die Rückgabe. Deshalb hat eine Funktion in der '
          'Signatur einen Rückgabetyp und im Struktogramm eine Zeile '
          '„Rückgabe“.',
    )),

    // ── Seite: Lücken ergänzen ─────────────────────────────────────────
    UeberschriftBlock('Prüfungsaufgabe: Lücken ergänzen'),
    TextBlock(
      'Eine typische Aufgabe in der AP1 lautet: „Ergänzen Sie das '
      'Struktogramm.“ Dann fehlen Stellen, die schraffiert und nummeriert '
      'sind. So sieht das aus:',
    ),
    StruktogrammBlock(
      _maximumLuecke,
      titel: 'maximum(zahlen: Feld, n: Ganzzahl): Ganzzahl',
      unterschrift: 'Die Funktion soll den größten Wert des Feldes '
          'zurückgeben. An der Stelle (1) fehlt ein Schritt.',
    ),
    TextBlock(
      'So gehst du vor: Erkenne zuerst das Muster. Hier ist es das Maximum '
      'aus Lektion 7. Dann überlege, was an dieser Stelle im Muster steht. '
      'Die Aufgabe auf der nächsten Seite zeigt denselben Ablauf als '
      'Pseudocode.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-8-7',
      frage: 'Ergänze die Lücke, damit die Funktion den größten Wert '
          'zurückgibt.',
      vorlage: 'FUNKTION maximum(zahlen: Feld, n: Ganzzahl): Ganzzahl\n'
          '    max = zahlen[1]\n'
          '    FÜR i = 2 BIS n\n'
          '        WENN zahlen[i] > max DANN\n'
          '            ___\n'
          '        ENDE WENN\n'
          '    ENDE FÜR\n'
          '    RÜCKGABE max\n'
          'ENDE FUNKTION',
      loesungen: [
        [
          'max = zahlen[i]',
          'max=zahlen[i]',
          'max = zahlen [i]',
          'max=zahlen [i]',
          'max = zahlen[ i ]',
          'max=zahlen[ i ]',
          'max = zahlen[i];',
          'max=zahlen[i];',
        ],
      ],
      erklaerung: 'Ist der aktuelle Wert größer als das bisherige Maximum, '
          'wird er das neue Maximum: `max = zahlen[i]`. Schreibst du '
          'dagegen `zahlen[i] = max`, würde das Feld verändert und max '
          'bliebe gleich.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 8'),
    HinweisBlock(
      '- Tauschen geht nur mit **Hilfsvariable**: `hilf = a`, `a = b`, '
      '`b = hilf`.\n'
      '- **Bubblesort** vergleicht Nachbarn und tauscht, wenn links der '
      'größere Wert steht. Nach jedem Durchgang steht eine weitere große '
      'Zahl hinten.\n'
      '- Äußere Schleife bis n - 1, innere bis n - durchgang.\n'
      '- Ein **Unterprogramm** ist ein Ablauf mit Namen, der aufgerufen '
      'wird.\n'
      '- **Funktion**: gibt mit „Rückgabe“ ein Ergebnis zurück. '
      '**Prozedur**: tut etwas, gibt nichts zurück.\n'
      '- Die **Signatur** nennt Namen, Parameter mit Datentyp und bei '
      'Funktionen den Rückgabetyp.\n'
      '- Argumente beim Aufruf in derselben Reihenfolge wie die Parameter.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-8-8',
      frage: 'Was gilt nach dem ersten Durchgang von Bubblesort (kleinste '
          'Zahl vorne) sicher?',
      optionen: [
        'Die größte Zahl steht ganz hinten',
        'Die kleinste Zahl steht ganz vorne',
        'Das Feld ist vollständig sortiert',
        'Es wurde genau einmal getauscht',
      ],
      richtig: 0,
      erklaerung: 'Jeder Vergleich schiebt die größere Zahl nach rechts. So '
          'wandert die größte im ersten Durchgang ganz nach hinten. Über den '
          'Anfang sagt das nichts: Bei 5, 2, 4, 1 steht danach vorne die 2, '
          'nicht die 1.',
    )),
  ],
);
