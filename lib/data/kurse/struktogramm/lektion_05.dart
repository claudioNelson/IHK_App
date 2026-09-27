// lib/data/kurse/struktogramm/lektion_05.dart
//
// Struktogramm-Kurs der App, Lektion 5. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 5: Wiederholen: Schleifen
// ═══════════════════════════════════════════════════════════════════════════
// Neu: Schleife, Rumpf, Durchlauf, kopfgesteuert (solange), Endlosschleife,
// fußgesteuert (wiederhole bis), Zählschleife (für), Anzahl Durchläufe,
// Summe von 1 bis n, Wahl der Schleife, ein Durchlauf zu viel.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _bisDrei = <SgBlock>[
  SgAnw('zahl = 1'),
  SgSolange('zahl <= 3', [
    SgAnw('Ausgabe zahl'),
    SgAnw('zahl = zahl + 1'),
  ]),
  SgAnw('Ausgabe "Fertig"'),
];

const _endlos = <SgBlock>[
  SgAnw('zahl = 1'),
  SgSolange('zahl <= 3', [
    SgAnw('Ausgabe zahl'),
  ]),
];

const _wuerfel = <SgBlock>[
  SgWiederhole.bis('wurf >= 1 UND wurf <= 6', [
    SgAnw('Ausgabe "Zahl von 1 bis 6:"'),
    SgAnw('Eingabe wurf'),
  ]),
  SgAnw('Ausgabe "Danke"'),
];

const _fuenfMal = <SgBlock>[
  SgFuer('für i = 1 bis 5', [
    SgAnw('Ausgabe i'),
  ]),
];

const _summe = <SgBlock>[
  SgAnw('Eingabe n'),
  SgAnw('summe = 0'),
  SgFuer('für i = 1 bis n', [
    SgAnw('summe = summe + i'),
  ]),
  SgAnw('Ausgabe summe'),
];

const struktogrammLektion5 = Lektion(
  nr: 5,
  slug: 'struktogramm-5-schleifen',
  titel: 'Wiederholen: Schleifen',
  kurzbeschreibung:
      'Wie ein Programm etwas mehrmals macht, ohne dass man es mehrmals '
      'hinschreibt. Die drei Schleifenarten und wann du welche nimmst.',
  dauerMinuten: 35,
  bloecke: [
    // ── Seite: Idee ────────────────────────────────────────────────────
    UeberschriftBlock('Immer wieder dasselbe'),
    TextBlock(
      'Stell dir vor, du spülst ab. Du denkst nicht: „Teller 1 spülen, '
      'Teller 2 spülen, Teller 3 spülen …“. Du denkst: „**Solange** noch '
      'Geschirr im Becken ist, spüle ich ein Teil.“\n'
      '\n'
      'Das ist eine **Schleife**: Ein paar Schritte werden wiederholt, '
      'solange eine Bedingung gilt. Drei Begriffe brauchst du dafür:\n'
      '- Der **Rumpf** ist der Teil, der wiederholt wird. Hier: ein Teil '
      'spülen.\n'
      '- Ein **Durchlauf** ist ein einziges Mal durch den Rumpf.\n'
      '- Die **Bedingung** entscheidet, ob noch ein Durchlauf kommt. Hier: '
      'Ist noch Geschirr im Becken?\n'
      '\n'
      'Ohne Schleife müsstest du jeden Schritt so oft hinschreiben, wie er '
      'passieren soll. Bei 100 Tellern wären das 100 Kästen.',
    ),

    // ── Seite: solange ─────────────────────────────────────────────────
    UeberschriftBlock('Die Schleife mit „solange“'),
    TextBlock(
      'Dieses Programm gibt die Zahlen 1, 2 und 3 aus:',
    ),
    StruktogrammBlock(
      _bisDrei,
      titel: 'Zählen bis 3',
    ),
    TextBlock(
      'So liest du die Schleife:\n'
      '- In der Kopfzeile steht die Bedingung: `solange zahl <= 3`.\n'
      '- Der **Balken** links umklammert den Rumpf. Alles rechts vom Balken '
      'wird wiederholt.\n'
      '- Ablauf: Bedingung prüfen. Ist sie wahr, läuft der Rumpf einmal. '
      'Dann geht es **zurück nach oben** zur Bedingung. Ist sie falsch, '
      'geht es unter der Schleife weiter.\n'
      '\n'
      'Weil die Bedingung oben im Kopf steht, heißt diese Schleife '
      '**kopfgesteuert**.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'zahl', 'Ausgabe'],
      zeilen: [
        ['zahl = 1', '1', ''],
        ['Durchlauf 1', '2', '1'],
        ['Durchlauf 2', '3', '2'],
        ['Durchlauf 3', '4', '3'],
        ['4 <= 3 ist falsch, Ende', '4', 'Fertig'],
      ],
      unterschrift: 'In jedem Durchlauf wird erst zahl ausgegeben, dann um '
          '1 erhöht. In der Tabelle steht der Wert am Ende des Durchlaufs.',
    ),
    CodeBlock(
      'zahl = 1\n'
      'SOLANGE zahl <= 3\n'
      '    AUSGABE zahl\n'
      '    zahl = zahl + 1\n'
      'ENDE SOLANGE\n'
      'AUSGABE "Fertig"',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-1',
      frage: 'Im Programm „Zählen bis 3“ wird der Startwert geändert: '
          '`zahl = 5` statt `zahl = 1`. Wie oft läuft der Rumpf?',
      optionen: [
        'Einmal',
        'Dreimal',
        'Keinmal',
        'Immer wieder, ohne Ende',
      ],
      richtig: 2,
      erklaerung: 'Die Bedingung wird geprüft, bevor der Rumpf das erste Mal '
          'läuft. `5 <= 3` ist von Anfang an falsch. Der Rumpf läuft '
          'also kein einziges Mal, und es erscheint nur „Fertig“. Bei der '
          'kopfgesteuerten Schleife sind null Durchläufe möglich.',
    )),

    // ── Seite: Endlosschleife ──────────────────────────────────────────
    UeberschriftBlock('Vorsicht: die Endlosschleife'),
    TextBlock(
      'Was passiert, wenn man das Hochzählen vergisst?',
    ),
    StruktogrammBlock(
      _endlos,
      titel: 'Zählen, mit Fehler',
    ),
    TextBlock(
      '`zahl` bleibt für immer 1. Die Bedingung `1 <= 3` ist deshalb immer '
      'wahr, und die Schleife hört nie auf. Das nennt man eine '
      '**Endlosschleife**.\n'
      '\n'
      'Merke dir: Im Rumpf muss sich etwas ändern, das in der Bedingung '
      'vorkommt. Nur dann kann die Bedingung irgendwann falsch werden.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-2',
      frage: 'Eine Schleife lautet `solange geld > 0` mit dem Rumpf '
          '`Ausgabe geld`. Vorher steht `geld = 20`. Was stimmt?',
      optionen: [
        'Der Rumpf läuft 20-mal',
        'Der Rumpf läuft keinmal',
        'Es ist eine Endlosschleife, weil geld sich nie ändert',
        'Der Rumpf läuft einmal',
      ],
      richtig: 2,
      erklaerung: 'Im Rumpf wird geld nur ausgegeben, aber nie verändert. '
          '`20 > 0` bleibt also immer wahr. Es fehlt eine Zeile wie '
          '`geld = geld - 5`, die geld kleiner macht.',
    )),

    // ── Seite: wiederhole bis ──────────────────────────────────────────
    UeberschriftBlock('Erst tun, dann prüfen: „wiederhole bis“'),
    TextBlock(
      'Manchmal kann man erst prüfen, **nachdem** der Rumpf gelaufen ist. '
      'Beispiel: Jemand soll eine Würfelzahl eintippen. Ob sie gültig ist, '
      'weiß man erst, wenn sie eingetippt wurde. Ist sie ungültig, wird '
      'noch einmal gefragt.',
    ),
    StruktogrammBlock(
      _wuerfel,
      titel: 'Würfelzahl einlesen',
    ),
    TextBlock(
      'Hier steht die Bedingung **unten**, im Fuß. Deshalb heißt diese '
      'Schleife **fußgesteuert**. Der Ablauf:\n'
      '- Erst läuft der Rumpf: Frage anzeigen, Zahl einlesen.\n'
      '- Dann wird unten geprüft: Liegt die Zahl zwischen 1 und 6?\n'
      '- Wenn nicht, geht es zurück nach oben in den Rumpf.\n'
      '\n'
      'Weil erst getan und dann geprüft wird, läuft der Rumpf '
      '**mindestens einmal**.\n'
      '\n'
      'Achte auf das Wort **bis**: Die Schleife läuft, **bis** die '
      'Bedingung wahr ist. Bei „solange“ ist es umgekehrt: Sie läuft, '
      '**solange** die Bedingung wahr ist.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'wurf', 'Ausgabe'],
      zeilen: [
        ['Durchlauf 1', '9', 'Zahl von 1 bis 6:'],
        ['9 gültig? nein, wiederholen', '9', ''],
        ['Durchlauf 2', '4', 'Zahl von 1 bis 6:'],
        ['4 gültig? ja, Ende', '4', 'Danke'],
      ],
      unterschrift: 'Schreibtischtest, wenn jemand erst 9 und dann 4 '
          'eintippt.',
    ),
    CodeBlock(
      'WIEDERHOLE\n'
      '    AUSGABE "Zahl von 1 bis 6:"\n'
      '    EINGABE wurf\n'
      'BIS wurf >= 1 UND wurf <= 6\n'
      'AUSGABE "Danke"',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'Gut zu wissen: Manche Aufgaben schreiben unten „solange“ statt '
      '„bis“. Dann steht dort das Gegenteil, also wann es **weitergehen** '
      'soll. Lies bei fußgesteuerten Schleifen immer genau, welches Wort '
      'dasteht.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-3',
      frage: 'Welche Schleife läuft auf jeden Fall mindestens einmal?',
      optionen: [
        'Die kopfgesteuerte Schleife mit „solange“ oben',
        'Die fußgesteuerte Schleife mit „bis“ unten',
        'Beide',
        'Keine von beiden',
      ],
      richtig: 1,
      erklaerung: 'Bei der fußgesteuerten Schleife läuft erst der Rumpf, '
          'geprüft wird danach. Bei der kopfgesteuerten wird zuerst geprüft. '
          'Ist die Bedingung gleich falsch, läuft sie keinmal.',
    )),

    // ── Seite: Zählschleife ────────────────────────────────────────────
    UeberschriftBlock('Die Zählschleife'),
    TextBlock(
      'Oft weiß man vorher genau, wie oft etwas passieren soll. Zum '
      'Beispiel: „Gib die Zahlen von 1 bis 5 aus.“ Dafür gibt es eine '
      'Abkürzung, die **Zählschleife**:',
    ),
    StruktogrammBlock(
      _fuenfMal,
      titel: 'Von 1 bis 5',
    ),
    TextBlock(
      'Die Kopfzeile `für i = 1 bis 5` sagt drei Dinge auf einmal:\n'
      '- Die Variable `i` ist der **Zähler**. Er startet bei 1.\n'
      '- Nach jedem Durchlauf wird `i` automatisch um 1 erhöht.\n'
      '- Nach dem Durchlauf mit `i = 5` ist Schluss.\n'
      '\n'
      'Ausgegeben wird also 1, 2, 3, 4, 5. Die Zählschleife prüft, genau wie '
      'die kopfgesteuerte Schleife, vor jedem Durchlauf. Trotzdem gilt sie '
      'als eigene, dritte Schleifenart, weil Startwert, Prüfung und '
      'Hochzählen schon eingebaut sind. Man kann sie nicht vergessen.',
    ),
    CodeBlock(
      'FÜR i = 1 BIS 5\n'
      '    AUSGABE i\n'
      'ENDE FÜR',
      titel: 'Pseudocode',
      sprache: 'pseudocode',
    ),
    TextBlock(
      'Wie viele Durchläufe hat eine Zählschleife? Rechne: **Endwert minus '
      'Startwert plus 1**. Bei „für i = 1 bis 5“ sind das 5 - 1 + 1 = 5. '
      'Das „plus 1“ vergisst man leicht, weil Start und Ende beide '
      'mitzählen.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-5-4',
      frage: 'Wie oft läuft der Rumpf dieser Zählschleife?',
      vorlage: 'für i = 3 bis 7\n'
          '\n'
          'Anzahl der Durchläufe: ___',
      loesungen: [
        ['5', 'fünf'],
      ],
      erklaerung: 'Endwert minus Startwert plus 1: 7 - 3 + 1 = 5. Zur '
          'Kontrolle: i ist nacheinander 3, 4, 5, 6 und 7, das sind fünf '
          'Werte.',
    )),

    // ── Seite: Summe ───────────────────────────────────────────────────
    UeberschriftBlock('Ein Klassiker: die Summe von 1 bis n'),
    TextBlock(
      'Dieses Beispiel kommt in fast jedem Kurs und in vielen Prüfungen '
      'vor. Das Programm liest eine Zahl n ein und zählt alle Zahlen von 1 '
      'bis n zusammen.',
    ),
    StruktogrammBlock(
      _summe,
      titel: 'Summe von 1 bis n',
    ),
    TextBlock(
      'Hier kommt alles zusammen, was du schon kennst: die Eingabe, der '
      'Startwert `summe = 0`, das Hochzählen mit `summe = summe + i` und '
      'die Zählschleife. Bei jedem Durchlauf kommt das aktuelle i zur '
      'Summe dazu.',
    ),
    SchreibtischtestBlock(
      spalten: ['Schritt', 'n', 'i', 'summe', 'Ausgabe'],
      zeilen: [
        ['Eingabe n', '4', '', '', ''],
        ['summe = 0', '4', '', '0', ''],
        ['Durchlauf 1', '4', '1', '1', ''],
        ['Durchlauf 2', '4', '2', '3', ''],
        ['Durchlauf 3', '4', '3', '6', ''],
        ['Durchlauf 4', '4', '4', '10', ''],
        ['Ausgabe summe', '4', '4', '10', '10'],
      ],
      unterschrift: 'Schreibtischtest für n = 4: 1 + 2 + 3 + 4 = 10.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-5-5',
      frage: 'Führe den Schreibtischtest für n = 5 durch. Was wird '
          'ausgegeben?',
      vorlage: 'Eingabe: n = 5\n'
          '\n'
          'Ausgabe: ___',
      loesungen: [
        ['15'],
      ],
      erklaerung: 'Die Summe wächst mit jedem Durchlauf: 1, 3, 6, 10, 15. '
          'Fünf Durchläufe, weil i die Werte 1 bis 5 annimmt. Ausgegeben '
          'wird 15.',
    )),

    // ── Seite: Welche Schleife ─────────────────────────────────────────
    UeberschriftBlock('Welche Schleife nehme ich?'),
    TextBlock(
      'In der Prüfung steht die Aufgabe als Text. An bestimmten Wörtern '
      'erkennst du, welche Schleife passt:',
    ),
    SchreibtischtestBlock(
      spalten: ['Schleife', 'Wann?', 'Typische Wörter'],
      zeilen: [
        [
          'Zählschleife',
          'Anzahl steht vorher fest',
          '„für jede“, „von 1 bis n“, „zehnmal“',
        ],
        [
          'kopfgesteuert',
          'Anzahl unbekannt, auch keinmal möglich',
          '„solange noch“',
        ],
        [
          'fußgesteuert',
          'Rumpf muss mindestens einmal laufen',
          '„wiederhole, bis“, „erneut eingeben“',
        ],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Typisch fußgesteuert sind Eingaben, die geprüft werden, und Menüs. '
      'Man muss erst etwas anzeigen oder einlesen, bevor man prüfen kann.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-6',
      frage: 'Ein Menü soll angezeigt und eine Auswahl eingelesen werden. '
          'Das wiederholt sich, bis jemand „Beenden“ wählt. Welche Schleife '
          'passt am besten?',
      optionen: [
        'Zählschleife, weil das Menü drei Einträge hat',
        'Kopfgesteuert, weil man vorher prüfen muss',
        'Fußgesteuert, weil das Menü mindestens einmal erscheinen muss',
        'Gar keine, eine Verzweigung reicht',
      ],
      richtig: 2,
      erklaerung: 'Bevor jemand „Beenden“ wählen kann, muss das Menü einmal '
          'angezeigt und eine Auswahl gelesen worden sein. Der Rumpf läuft '
          'also mindestens einmal. Unten steht dann `bis auswahl == '
          '"Beenden"`.',
    )),

    // ── Seite: Einer zu viel ───────────────────────────────────────────
    UeberschriftBlock('Ein Durchlauf zu viel?'),
    TextBlock(
      'Der häufigste Fehler bei Schleifen: ein Durchlauf zu viel oder zu '
      'wenig. Oft liegt es an einem einzigen Zeichen.\n'
      '\n'
      'Beide Schleifen starten mit `i = 0` und haben den Rumpf '
      '`Ausgabe i` und `i = i + 1`:\n'
      '- Mit `solange i < 5` wird 0, 1, 2, 3, 4 ausgegeben. Das sind '
      '**fünf** Durchläufe.\n'
      '- Mit `solange i <= 5` kommt die 5 dazu. Das sind **sechs** '
      'Durchläufe.\n'
      '\n'
      'Der Unterschied ist nur das Gleichheitszeichen in der Bedingung. '
      'Rate deshalb nie, sondern mach einen Schreibtischtest. Das dauert '
      'eine Minute und rettet in der Prüfung Punkte.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-7',
      frage: 'Zuerst `i = 0`. Dann `solange i < 4` mit dem Rumpf '
          '`Ausgabe i` und `i = i + 1`. Welche Zahl wird **zuletzt** '
          'ausgegeben?',
      optionen: [
        '4',
        '3',
        '5',
        '0',
      ],
      richtig: 1,
      erklaerung: 'Ausgegeben wird 0, 1, 2, 3. Danach wird i zu 4, und '
          '`4 < 4` ist falsch. Die Schleife endet, bevor die 4 ausgegeben '
          'wird. Am Ende steht i zwar auf 4, ausgegeben wurde zuletzt aber '
          'die 3.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 5'),
    HinweisBlock(
      '- Eine **Schleife** wiederholt ihren **Rumpf**. Ein **Durchlauf** '
      'ist einmal durch den Rumpf.\n'
      '- **Kopfgesteuert** (solange oben): erst prüfen, dann laufen. '
      'Keinmal ist möglich.\n'
      '- **Fußgesteuert** (bis unten): erst laufen, dann prüfen. '
      'Mindestens einmal.\n'
      '- „bis“ heißt: aufhören, wenn wahr. „solange“ heißt: weitermachen, '
      'solange wahr.\n'
      '- **Zählschleife** (für i = a bis b): läuft b - a + 1 mal, der '
      'Zähler steigt von selbst.\n'
      '- Im Rumpf muss sich ändern, was in der Bedingung steht. Sonst '
      'entsteht eine **Endlosschleife**.\n'
      '- Zahl der Durchläufe nie raten, sondern mit einem Schreibtischtest '
      'prüfen.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-5-8',
      frage: 'Woran erkennst du im Struktogramm eine fußgesteuerte '
          'Schleife?',
      optionen: [
        'Die Bedingung steht unter dem Rumpf',
        'Die Bedingung steht über dem Rumpf',
        'Sie hat keinen Balken links',
        'Sie hat zwei Bedingungen statt einer',
      ],
      richtig: 0,
      erklaerung: 'Fußgesteuert heißt: Die Bedingung steht unten, im Fuß. '
          'Bei der kopfgesteuerten Schleife und der Zählschleife steht sie '
          'oben im Kopf. Den Balken links haben alle Schleifen.',
    )),
  ],
);
