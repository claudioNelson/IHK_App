// lib/data/kurse/uml/lektion_10.dart
//
// UML-Kurs der App, Lektion 10: Zustandsdiagramm.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _buchungZ = UmlDiagramm(
  breite: 540,
  hoehe: 245,
  beschreibung: 'Zustände einer Buchung: angelegt, bezahlt, aktiv, abgeschlossen, dazu storniert. Übergänge bezahlen, abholen, zurückgeben, stornieren.',
  elemente: [
    UmlStart(x: 22, y: 50),
    UmlAktion(x: 45, y: 30, b: 110, text: 'angelegt', zustand: true),
    UmlAktion(x: 225, y: 30, b: 110, text: 'bezahlt', zustand: true),
    UmlAktion(x: 405, y: 30, b: 110, text: 'aktiv', zustand: true),
    UmlAktion(x: 45, y: 140, b: 110, text: 'storniert', zustand: true),
    UmlAktion(x: 395, y: 140, b: 130, text: 'abgeschlossen', zustand: true),
    UmlEnde(x: 100, y: 222),
    UmlEnde(x: 460, y: 222),
    UmlPfeil(punkte: [Offset(31, 50), Offset(45, 50)]),
    UmlPfeil(punkte: [Offset(155, 50), Offset(225, 50)], text: 'bezahlen'),
    UmlPfeil(punkte: [Offset(335, 50), Offset(405, 50)], text: 'abholen'),
    UmlPfeil(punkte: [Offset(100, 70), Offset(100, 140)], text: 'stornieren'),
    UmlPfeil(punkte: [Offset(460, 70), Offset(460, 140)], text: 'zurückgeben', textAusrichtung: -1),
    UmlPfeil(punkte: [Offset(100, 180), Offset(100, 211)]),
    UmlPfeil(punkte: [Offset(460, 180), Offset(460, 211)]),
  ],
);

const _lampe = UmlDiagramm(
  breite: 470,
  hoehe: 140,
  beschreibung: 'Lampe mit den Zuständen aus und an. Der Zustand an hat entry Lampe einschalten und exit Lampe ausschalten.',
  elemente: [
    UmlStart(x: 18, y: 70),
    UmlAktion(x: 40, y: 45, b: 110, h: 50, text: 'aus', zustand: true),
    UmlAktion(x: 270, y: 30, b: 190, h: 80, text: 'an', zustand: true, zusatz: ['entry / Lampe einschalten', 'exit / Lampe ausschalten']),
    UmlPfeil(punkte: [Offset(27, 70), Offset(40, 70)]),
    UmlPfeil(punkte: [Offset(150, 55), Offset(270, 55)], text: 'drücken'),
    UmlPfeil(punkte: [Offset(270, 85), Offset(150, 85)], text: 'drücken', textVersatz: Offset(0, 24)),
  ],
);

const _pin = UmlDiagramm(
  breite: 580,
  hoehe: 205,
  beschreibung: 'Geldautomat: Beim Start wird zaehler auf 0 gesetzt. Im Zustand PIN-Eingabe führt pinEingeben mit korrekt zur Auswahl, mit falsch zurück in PIN-Eingabe und zählt hoch, bei zaehler gleich 3 nach gesperrt.',
  elemente: [
    UmlStart(x: 18, y: 90),
    UmlAktion(x: 140, y: 70, b: 130, text: 'PIN-Eingabe', zustand: true),
    UmlAktion(x: 440, y: 70, b: 120, text: 'Auswahl', zustand: true),
    UmlAktion(x: 440, y: 150, b: 120, text: 'gesperrt', zustand: true),
    UmlPfeil(punkte: [Offset(27, 90), Offset(140, 90)], text: '/ zaehler = 0'),
    UmlPfeil(punkte: [Offset(270, 90), Offset(440, 90)], text: 'pinEingeben [korrekt]'),
    UmlPfeil(punkte: [Offset(180, 70), Offset(180, 40), Offset(230, 40), Offset(230, 70)], text: 'pinEingeben [falsch] / zaehler++', textSegment: 1, textAusrichtung: 1),
    UmlPfeil(punkte: [Offset(205, 110), Offset(205, 170), Offset(440, 170)], text: '[zaehler = 3]', textSegment: 1),
  ],
);
const umlLektion10 = Lektion(
  nr: 10,
  slug: 'uml-10-zustand',
  titel: 'Das Zustandsdiagramm',
  kurzbeschreibung:
      'In welchen Zuständen kann etwas sein, und was lässt es wechseln? '
      'Zustände, Übergänge mit Ereignis, Wächter und Aktion, entry und exit.',
  dauerMinuten: 20,
  bloecke: [
    // ── Seite: Zustand ─────────────────────────────────────────────────
    UeberschriftBlock('Wie geht es dir gerade?'),
    TextBlock(
      'Eine Ampel ist rot, gelb oder grün. Eine Waschmaschine ist aus, '
      'wäscht oder schleudert. Eine Paketsendung ist unterwegs oder '
      'zugestellt. So ein Moment, in dem sich etwas eine Weile befindet, '
      'heißt **Zustand**.\n'
      '\n'
      'Das **Zustandsdiagramm** zeigt für **ein einziges Ding**, in welchen '
      'Zuständen es sein kann und was es von einem Zustand in den nächsten '
      'bringt. Es beantwortet die Frage: **In welchen Zuständen kann etwas '
      'sein, und wodurch wechselt es?**\n'
      '\n'
      'In Prüfungen heißt es manchmal auch **Zustandsübergangsdiagramm** '
      'oder **Zustandsautomat**. Gemeint ist dasselbe.',
    ),

    // ── Seite: Buchung ─────────────────────────────────────────────────
    UeberschriftBlock('Das Leben einer Buchung'),
    TextBlock('Eine Buchung im Lastenrad-Verleih durchläuft diese Zustände:'),
    UmlBlock(
      _buchungZ,
      unterschrift: 'Jedes abgerundete Rechteck ist ein Zustand, jeder Pfeil '
          'ein Übergang. Es gibt zwei Enden, weil eine Buchung auf zwei Wegen '
          'enden kann: storniert oder abgeschlossen.',
    ),
    TextBlock(
      '- Start und Ende sehen aus wie im Aktivitätsdiagramm: gefüllter Kreis '
      'und Kreis mit Punkt.\n'
      '- Jeder **Zustand** ist ein abgerundetes Rechteck. Der Name ist meist '
      'ein Adjektiv oder beschreibt, was gerade gilt: „angelegt“, „bezahlt“, '
      '„aktiv“.\n'
      '- Ein Pfeil heißt **Übergang**. Daran steht das **Ereignis**, das den '
      'Wechsel auslöst: Wird die Buchung bezahlt, wechselt sie von '
      '„angelegt“ nach „bezahlt“.\n'
      '- Ein Pfeil **ohne** Beschriftung wird sofort genommen, sobald der '
      'Zustand fertig ist. So kommen hier „storniert“ und „abgeschlossen“ '
      'zum Ende.\n'
      '\n'
      'Sieht aus wie ein Aktivitätsdiagramm? Der Unterschied steckt in den '
      'Kästen. Im Aktivitätsdiagramm steht darin ein **Tun** („Rad '
      'auswählen“). Im Zustandsdiagramm steht darin ein **Sein** '
      '(„bezahlt“). Die Buchung **tut** nichts, sie **ist** bezahlt, bis das '
      'nächste Ereignis kommt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-1',
      frage: 'Welcher Name passt zu einem **Zustand**?',
      optionen: [
        'Rechnung drucken',
        'versendet',
        'Kunde',
        'bezahlen()',
      ],
      richtig: 1,
      erklaerung: '„versendet“ beschreibt, was gerade gilt. „Rechnung drucken“ '
          'ist ein Tun, also eine Aktion. „Kunde“ ist eine Klasse oder ein '
          'Akteur, `bezahlen()` eine Methode.',
    )),
    UmlBlock(_buchungZ, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-2',
      frage: 'Die Buchung ist **bezahlt**. Jetzt versucht der Kunde zu '
          'stornieren. Was passiert laut Diagramm?',
      optionen: [
        'Die Buchung wechselt nach „storniert“.',
        'Nichts, aus „bezahlt“ führt kein Übergang „stornieren“.',
        'Die Buchung wechselt nach „angelegt“.',
        'Die Buchung wird gelöscht.',
      ],
      richtig: 1,
      erklaerung: 'Ein Ereignis wirkt nur, wenn aus dem aktuellen Zustand ein '
          'passender Pfeil herausführt. Aus „bezahlt“ gibt es nur „abholen“. '
          'Stornieren geht hier also nur im Zustand „angelegt“.',
    )),

    // ── Seite: Übergang genau ──────────────────────────────────────────
    UeberschriftBlock('Ereignis, Wächter, Aktion'),
    TextBlock(
      'An einem Übergang kann mehr stehen als nur das Ereignis. Schau dir '
      'diesen Geldautomaten an:',
    ),
    UmlBlock(
      _pin,
      unterschrift: 'Der Pfeil oben führt zurück in denselben Zustand. Bei '
          'falscher PIN wird nur hochgezählt.',
    ),
    TextBlock(
      '- Ist die PIN korrekt, geht es zur Auswahl.\n'
      '- Ist sie falsch, führt der Pfeil **zurück in denselben Zustand**, und '
      'als Aktion wird der Zähler um eins erhöht. `zaehler++` heißt '
      '„zaehler plus eins“.\n'
      '- Der Übergang nach „gesperrt“ hat **kein Ereignis**, nur eine '
      'Bedingung. So ein Übergang wird geprüft, sobald der Zustand erreicht '
      'ist. Weil jeder Fehlversuch zurück in „PIN-Eingabe“ führt, wird er '
      'nach jedem Versuch neu geprüft. Steht der Zähler auf 3, wird die '
      'Karte gesperrt. Im Wächter bedeutet `=` „ist gleich“, nicht '
      '„bekommt“.\n'
      '- Schon der Startpfeil hat eine Aktion: `/ zaehler = 0` setzt den '
      'Zähler am Anfang auf 0.\n'
      '\n'
      'Die volle Beschriftung eines Übergangs hat also drei Teile:',
    ),
    CodeBlock(
      'Ereignis [Wächter] / Aktion',
      sprache: 'text',
    ),
    TextBlock(
      '- Das **Ereignis** löst den Übergang aus, zum Beispiel '
      '`pinEingeben`.\n'
      '- Der **Wächter** in eckigen Klammern ist eine Bedingung, wie im '
      'Aktivitätsdiagramm. Der Übergang passiert nur, wenn sie stimmt.\n'
      '- Nach dem Schrägstrich steht eine **Aktion**, die beim Wechsel '
      'ausgeführt wird.\n'
      '\n'
      'Alle drei Teile sind freiwillig.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-10-3',
      frage: 'Ergänze die Beschriftung eines Übergangs: Ereignis `abholen`, '
          'Bedingung `ausweis gültig`, Aktion `Schloss öffnen`.',
      vorlage: 'abholen ___ ausweis gültig ___ ___ Schloss öffnen',
      loesungen: [
        ['['],
        [']'],
        ['/'],
      ],
      bausteine: ['[', ']', '/', '(', ')', ':'],
      erklaerung: 'Der Wächter steht in eckigen Klammern: '
          '`abholen [ausweis gültig] / Schloss öffnen`.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-4',
      frage: 'Was bedeutet `/ zaehler++` an einem Übergang?',
      optionen: [
        'Es ist die Bedingung für den Übergang.',
        'Es ist das Ereignis, das den Übergang auslöst.',
        'Es ist eine Aktion, die beim Übergang ausgeführt wird.',
        'Es ist ein Kommentar.',
      ],
      richtig: 2,
      erklaerung: 'Nach dem Schrägstrich steht die Aktion. Das Ereignis steht '
          'vorne, der Wächter in eckigen Klammern.',
    )),

    // ── Seite: entry exit ──────────────────────────────────────────────
    UeberschriftBlock('Was im Zustand passiert: entry und exit'),
    TextBlock(
      'Eine Lampe hat die Zustände „aus“ und „an“. Jedes Mal, wenn sie in '
      '„an“ wechselt, muss der Strom eingeschaltet werden. Jedes Mal, wenn '
      'sie „an“ verlässt, wieder aus. Das kann man direkt in den Zustand '
      'schreiben:',
    ),
    UmlBlock(
      _lampe,
      unterschrift: 'Unter dem Namen „an“ stehen die inneren Aktionen.',
    ),
    TextBlock(
      '- `entry / …` wird ausgeführt, **wenn der Zustand betreten wird**.\n'
      '- `exit / …` wird ausgeführt, **wenn der Zustand verlassen wird**.\n'
      '- Es gibt noch `do / …`: Das läuft, **solange** der Zustand andauert, '
      'zum Beispiel „do / Trommel drehen“ bei einer Waschmaschine.\n'
      '\n'
      '„entry“ heißt Eintritt, „exit“ heißt Ausgang. Die Wörter werden in '
      'UML immer englisch geschrieben.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-5',
      frage: 'Wann wird `entry / Lampe einschalten` ausgeführt?',
      optionen: [
        'Jedes Mal, wenn der Zustand „an“ betreten wird',
        'Solange die Lampe an ist, immer wieder',
        'Wenn der Zustand „an“ verlassen wird',
        'Nur beim allerersten Start',
      ],
      richtig: 0,
      erklaerung: 'entry gehört zum Betreten des Zustands. Beim Verlassen '
          'läuft exit, während des Zustands do.',
    )),

    // ── Seite: Aus Text ────────────────────────────────────────────────
    UeberschriftBlock('Vom Aufgabentext zum Zustandsdiagramm'),
    TextBlock(
      'Typische Aufgabe: „Eine Bestellung ist zuerst offen. Nach der Zahlung '
      'ist sie bezahlt, nach dem Versand versendet. Solange sie offen ist, '
      'kann sie storniert werden.“\n'
      '\n'
      'So gehst du vor:\n'
      '- Suche Wörter, die beschreiben, **wie** das Ding gerade ist: offen, '
      'bezahlt, versendet, storniert. Das werden die Zustände.\n'
      '- Suche, **wodurch** es wechselt: Zahlung, Versand, Stornierung. An '
      'die Pfeile schreibst du das als Ereignis: „zahlen“, „versenden“, '
      '„stornieren“.\n'
      '- Prüfe genau, **aus welchem** Zustand ein Wechsel möglich ist. Hier '
      'darf nur aus „offen“ storniert werden.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-6',
      frage: 'Welcher Übergang gehört laut Text **nicht** ins Diagramm?',
      optionen: [
        'offen nach bezahlt, Ereignis zahlen',
        'bezahlt nach versendet, Ereignis versenden',
        'offen nach storniert, Ereignis stornieren',
        'versendet nach storniert, Ereignis stornieren',
      ],
      richtig: 3,
      erklaerung: 'Storniert werden darf nur, solange die Bestellung offen '
          'ist. Aus „versendet“ führt deshalb kein Pfeil nach „storniert“.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 10'),
    HinweisBlock(
      '- Das Zustandsdiagramm zeigt die Zustände **eines** Dings und die '
      'Wechsel dazwischen.\n'
      '- **Zustand**: abgerundetes Rechteck, ein Sein wie „bezahlt“.\n'
      '- **Übergang**: Pfeil mit `Ereignis [Wächter] / Aktion`, alle drei '
      'freiwillig.\n'
      '- Ein Ereignis wirkt nur, wenn aus dem aktuellen Zustand ein passender '
      'Pfeil herausführt.\n'
      '- Im Zustand: `entry` beim Betreten, `exit` beim Verlassen, `do` '
      'solange er andauert.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-10-7',
      frage: '„Zeigen Sie, welche Status ein Ticket im Support-System '
          'annehmen kann und wodurch es wechselt.“ Welches Diagramm ist '
          'gemeint?',
      optionen: [
        'Sequenzdiagramm',
        'Klassendiagramm',
        'Zustandsdiagramm',
        'Use-Case-Diagramm',
      ],
      richtig: 2,
      erklaerung: '„Status“ und „wodurch es wechselt“ sind die Signalwörter '
          'für das Zustandsdiagramm.',
    )),
  ],
);
