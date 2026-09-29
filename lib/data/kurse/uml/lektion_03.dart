// lib/data/kurse/uml/lektion_03.dart
//
// UML-Kurs der App, Lektion 3: include, extend und Generalisierung im
// Use-Case-Diagramm.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _include = UmlDiagramm(
  breite: 610,
  hoehe: 260,
  beschreibung: 'Rad buchen und Buchung verlängern binden beide mit include den Fall Bezahlen ein. Die Pfeile zeigen zu Bezahlen.',
  elemente: [
    UmlRahmen(x: 120, y: 10, b: 360, h: 240, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 220, cy: 80, rx: 62, text: 'Rad buchen'),
    UmlUseCase(cx: 220, cy: 190, rx: 84, text: 'Buchung verlängern'),
    UmlUseCase(cx: 400, cy: 135, rx: 56, text: 'Bezahlen'),
    UmlAkteur(x: 50, y: 105, name: 'Kunde'),
    UmlAkteur(x: 545, y: 105, name: 'Zahlungsanbieter'),
    UmlKante(punkte: [Offset(66, 131), Offset(172.9, 95.6)]),
    UmlKante(punkte: [Offset(66, 131), Offset(169.8, 170.8)]),
    UmlKante(punkte: [Offset(529, 131), Offset(455.9, 133.3)]),
    UmlKante(punkte: [Offset(268.7, 94.9), Offset(354.4, 121.1)], art: UmlKantenArt.abhaengigkeit),
    UmlKante(punkte: [Offset(277.4, 172.5), Offset(354.4, 148.9)], art: UmlKantenArt.abhaengigkeit),
    UmlText(x: 322, y: 86, text: '«include»', ausrichtung: 0),
    UmlText(x: 348, y: 172, text: '«include»', ausrichtung: 0),
  ],
);

const _extend = UmlDiagramm(
  breite: 520,
  hoehe: 250,
  beschreibung: 'Zubehör hinzubuchen erweitert Rad buchen mit extend. Der Pfeil zeigt zu Rad buchen, eine Notiz nennt die Bedingung.',
  elemente: [
    UmlRahmen(x: 120, y: 10, b: 380, h: 230, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 220, cy: 80, rx: 62, text: 'Rad buchen'),
    UmlUseCase(cx: 220, cy: 200, rx: 90, text: 'Zubehör hinzubuchen'),
    UmlAkteur(x: 50, y: 55, name: 'Kunde'),
    UmlKante(punkte: [Offset(66, 81), Offset(158, 80.4)]),
    UmlKante(punkte: [Offset(220, 176), Offset(220, 104)], art: UmlKantenArt.abhaengigkeit, name: '«extend»'),
    UmlNotiz(x: 345, y: 125, b: 140, text: 'Bedingung:\nKunde wünscht\nZubehör', anker: Offset(220, 160), ankerVon: Offset(345, 160)),
  ],
);

const _gesamt = UmlDiagramm(
  breite: 660,
  hoehe: 330,
  beschreibung: 'Vollständiges Use-Case-Diagramm Lastenrad-Verleih mit include zu Bezahlen und extend von Zubehör hinzubuchen.',
  elemente: [
    UmlRahmen(x: 120, y: 10, b: 400, h: 310, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 230, cy: 80, rx: 62, text: 'Rad buchen'),
    UmlUseCase(cx: 445, cy: 80, rx: 56, text: 'Bezahlen'),
    UmlUseCase(cx: 230, cy: 170, rx: 90, text: 'Zubehör hinzubuchen'),
    UmlUseCase(cx: 230, cy: 250, rx: 92, text: 'Buchung stornieren'),
    UmlUseCase(cx: 420, cy: 285, rx: 66, text: 'Rad warten'),
    UmlAkteur(x: 50, y: 110, name: 'Kunde'),
    UmlAkteur(x: 590, y: 45, name: 'Zahlungsanbieter'),
    UmlAkteur(x: 590, y: 245, name: 'Mitarbeiter'),
    UmlKante(punkte: [Offset(66, 136), Offset(183.5, 95.9)]),
    UmlKante(punkte: [Offset(66, 136), Offset(197.7, 227.5)]),
    UmlKante(punkte: [Offset(574, 71), Offset(500.3, 76.1)]),
    UmlKante(punkte: [Offset(574, 271), Offset(484, 279.2)]),
    UmlKante(punkte: [Offset(292, 80), Offset(389, 80)], art: UmlKantenArt.abhaengigkeit, name: '«include»'),
    UmlKante(punkte: [Offset(230, 146), Offset(230, 104)], art: UmlKantenArt.abhaengigkeit),
    UmlText(x: 223, y: 116, text: '«extend»', ausrichtung: 1),
    UmlNotiz(x: 345, y: 112, b: 140, text: 'Bedingung:\nKunde wünscht\nZubehör', anker: Offset(230, 130), ankerVon: Offset(345, 130)),
  ],
);

const _general = UmlDiagramm(
  breite: 430,
  hoehe: 250,
  beschreibung: 'Die Stationsleitung ist eine besondere Art Mitarbeiter: Linie mit hohlem Dreieck am Mitarbeiter.',
  elemente: [
    UmlRahmen(x: 160, y: 10, b: 250, h: 230, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 290, cy: 70, rx: 66, text: 'Rad warten'),
    UmlUseCase(cx: 290, cy: 196, rx: 76, text: 'Rad ausmustern'),
    UmlAkteur(x: 60, y: 30, name: 'Mitarbeiter'),
    UmlAkteur(x: 60, y: 170, name: 'Stationsleitung'),
    UmlKante(punkte: [Offset(76, 56), Offset(225, 65.8)]),
    UmlKante(punkte: [Offset(76, 196), Offset(214, 196)]),
    UmlKante(punkte: [Offset(60, 168), Offset(60, 104)], art: UmlKantenArt.vererbung),
  ],
);

const _ucGeneral = UmlDiagramm(
  breite: 460,
  hoehe: 185,
  beschreibung: 'Mit Karte bezahlen und Per Rechnung bezahlen sind besondere Arten von Bezahlen: Linien mit hohlem Dreieck an Bezahlen.',
  elemente: [
    UmlUseCase(cx: 230, cy: 40, rx: 56, text: 'Bezahlen'),
    UmlUseCase(cx: 110, cy: 150, rx: 90, text: 'Mit Karte bezahlen'),
    UmlUseCase(cx: 350, cy: 150, rx: 96, text: 'Per Rechnung bezahlen'),
    UmlKante(punkte: [Offset(135.1, 127), Offset(206.3, 61.7)], art: UmlKantenArt.vererbung),
    UmlKante(punkte: [Offset(324.7, 126.8), Offset(253.7, 61.7)], art: UmlKantenArt.vererbung),
  ],
);
const umlLektion3 = Lektion(
  nr: 3,
  slug: 'uml-3-include-extend',
  titel: 'include, extend und Generalisierung',
  kurzbeschreibung:
      'Wie Anwendungsfälle zusammenhängen: was immer dabei ist, was nur '
      'manchmal dazukommt, in welche Richtung der Pfeil zeigt und was eine '
      '„besondere Art von“ ist.',
  dauerMinuten: 20,
  bloecke: [
    // ── Seite: Einstieg ────────────────────────────────────────────────
    UeberschriftBlock('Wenn Fälle zusammenhängen'),
    TextBlock(
      'Im Lastenrad-Verleih kann ein Kunde ein Rad buchen und eine Buchung '
      'verlängern. Bei beidem muss er bezahlen. Soll man das Bezahlen jetzt '
      'zweimal beschreiben?\n'
      '\n'
      'Nein. Man macht aus „Bezahlen“ einen eigenen Anwendungsfall und '
      'verbindet ihn mit den anderen beiden. Für solche Verbindungen zwischen '
      'Anwendungsfällen hat UML vor allem zwei feste Beziehungen:\n'
      '- **include**: Der andere Fall ist **immer** dabei.\n'
      '- **extend**: Der andere Fall kommt **nur manchmal** dazu.\n'
      '\n'
      'Den Unterschied machen die Bedeutung und vor allem die '
      '**Pfeilrichtung**. Genau hier passieren in der Prüfung die meisten '
      'Fehler.',
    ),

    // ── Seite: include ─────────────────────────────────────────────────
    UeberschriftBlock('include: immer dabei'),
    TextBlock(
      '„include“ ist Englisch und heißt **einbinden**. Gezeichnet wird es als '
      '**gestrichelter Pfeil** mit offener Spitze. Am Pfeil steht das Wort in '
      'doppelten spitzen Klammern: «include». Diese Klammern heißen '
      'französische Anführungszeichen. Ein Wort darin nennt man '
      '**Stereotyp**. Hier sagt es, welche Art Beziehung gemeint ist. Später '
      'siehst du Stereotypen auch an anderen Stellen, zum Beispiel an '
      'Klassen.\n'
      '\n'
      'So sieht es aus:',
    ),
    UmlBlock(
      _include,
      unterschrift: 'Beide Pfeile zeigen zu „Bezahlen“. Das Bezahlen gehört '
          'jedes Mal dazu.',
    ),
    TextBlock(
      'Den Anwendungsfall, um den es dem Akteur eigentlich geht und der den '
      'anderen Fall braucht, nennt man **Basisfall**. Hier gibt es zwei: '
      '„Rad buchen“ und „Buchung verlängern“. „Bezahlen“ ist der '
      '**eingebundene Fall**.\n'
      '\n'
      'Der Pfeil zeigt **vom Basisfall zum eingebundenen Fall**. Stell dir '
      'ein Kochrezept vor, in dem steht: „Teig nach Grundrezept S. 12 '
      'zubereiten.“ Das Rezept verweist auf das Grundrezept, nicht '
      'umgekehrt. Genauso verweist „Rad buchen“ auf „Bezahlen“.\n'
      '\n'
      'Der Zahlungsanbieter hängt nur an „Bezahlen“, denn nur dort macht er '
      'mit.\n'
      '\n'
      'Der Kunde braucht keine eigene Linie zu „Bezahlen“ mehr. Er kommt '
      'über „Rad buchen“ dorthin, denn das Bezahlen gehört ja jedes Mal '
      'dazu. In Lektion 2 hatten wir die Linie noch gezeichnet, weil wir '
      'include noch nicht kannten.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-1',
      frage: 'Was bedeutet «include» von „Rad buchen“ zu „Bezahlen“?',
      optionen: [
        'Beim Buchen wird manchmal bezahlt, wenn der Kunde es möchte.',
        'Beim Buchen wird jedes Mal bezahlt.',
        'Bezahlen ist eine besondere Art von Buchen.',
        'Erst wird bezahlt, danach gebucht.',
      ],
      richtig: 1,
      erklaerung: 'include heißt: immer dabei. Jede Buchung schließt das '
          'Bezahlen ein. Eine Reihenfolge zeigt das Use-Case-Diagramm nicht.',
    )),

    // ── Seite: extend ──────────────────────────────────────────────────
    UeberschriftBlock('extend: nur manchmal'),
    TextBlock(
      'Beim Buchen kann der Kunde auf Wunsch Zubehör dazubuchen, etwa einen '
      'Kindersitz. Das passiert nicht immer, nur wenn er es möchte. Dafür '
      'gibt es «extend», auf Deutsch **erweitern**. Auch das ist ein '
      'gestrichelter Pfeil mit offener Spitze:',
    ),
    UmlBlock(
      _extend,
      unterschrift: 'Der Pfeil zeigt zu „Rad buchen“. Die Notiz rechts nennt '
          'die Bedingung.',
    ),
    TextBlock(
      'Achtung, jetzt dreht sich die Richtung um: Der Pfeil zeigt **von der '
      'Erweiterung zum Basisfall**.\n'
      '\n'
      'Warum? „Rad buchen“ funktioniert auch ohne Zubehör und weiß gar '
      'nichts davon. Die Erweiterung dagegen weiß, wo sie sich einklinkt. '
      'Denk an eine Pizza: Die Pizza Margherita schmeckt auch ohne Extra-Käse. '
      'Den Extra-Käse aber gibt es nur auf einer Pizza.\n'
      '\n'
      'Die **Bedingung**, wann die Erweiterung dazukommt, schreibst du in '
      'eine **Notiz**. Eine Notiz ist ein Zettel mit umgeknickter Ecke, der '
      'mit einer gestrichelten Linie an den Pfeil gehängt wird.\n'
      '\n'
      'Manche Musterlösungen schreiben die Bedingung stattdessen in eckigen '
      'Klammern an den Pfeil: «extend» [Kunde wünscht Zubehör]. Beides ist '
      'richtig.',
    ),
    HinweisBlock(
      'Merksatz: **include zeigt weg, extend zeigt hin.** Gemeint ist der '
      'Basisfall. Bei include zeigt der Pfeil vom Basisfall weg, bei extend '
      'zum Basisfall hin.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-3-2',
      frage: 'Ergänze die Pfeilrichtung.',
      vorlage: 'include: Der Pfeil zeigt ___ Basisfall weg. '
          'extend: Der Pfeil zeigt ___ Basisfall hin.',
      loesungen: [
        ['vom'],
        ['zum'],
      ],
      bausteine: ['vom', 'zum', 'neben dem', 'über dem'],
      erklaerung: 'include zeigt weg, extend zeigt hin: bei include vom '
          'Basisfall zum eingebundenen Fall, bei extend von der Erweiterung '
          'zum Basisfall.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-3',
      frage: 'In einem Onlineshop kann der Kunde bei der Bestellung auf Wunsch '
          'eine Geschenkverpackung wählen. Wie zeichnest du das?',
      optionen: [
        '«include»-Pfeil von „Bestellung aufgeben“ zu „Geschenkverpackung '
            'wählen“',
        '«extend»-Pfeil von „Bestellung aufgeben“ zu „Geschenkverpackung '
            'wählen“',
        '«include»-Pfeil von „Geschenkverpackung wählen“ zu „Bestellung '
            'aufgeben“',
        '«extend»-Pfeil von „Geschenkverpackung wählen“ zu „Bestellung '
            'aufgeben“',
      ],
      richtig: 3,
      erklaerung: '„Auf Wunsch“ heißt nur manchmal, also extend. Bei extend '
          'zeigt der Pfeil von der Erweiterung zum Basisfall, hier von '
          '„Geschenkverpackung wählen“ zu „Bestellung aufgeben“.',
    )),

    // ── Seite: Signalwörter ────────────────────────────────────────────
    UeberschriftBlock('Signalwörter im Aufgabentext'),
    TextBlock(
      'Im Aufgabentext verraten dir oft einzelne Wörter, was gemeint ist:',
    ),
    SchreibtischtestBlock(
      spalten: ['Steht im Text', 'Beziehung'],
      zeilen: [
        ['„immer“, „jedes Mal“, „vor jeder …“, „gehört zu jeder …“',
            'include'],
        ['„auf Wunsch“, „optional“, „falls“, „wenn … dann zusätzlich“',
            'extend'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Aber Vorsicht: Nicht alles, was mit einem Fall zu tun hat, ist eine '
      'Erweiterung. Ein Kunde storniert seine Buchung Tage später, in einem '
      'eigenen Vorgang mit eigenem Ziel. „Buchung stornieren“ ist deshalb '
      'ein **eigener Anwendungsfall** mit eigener Linie zum Kunden, kein '
      'extend.\n'
      '\n'
      'Die Frage dazu: Passiert es **während** des anderen Falls? Dann kann '
      'es include oder extend sein. Passiert es **für sich allein**? Dann ist '
      'es ein eigener Anwendungsfall.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-4',
      frage: 'Text: „Vor jeder Ausleihe und jeder Verlängerung prüft das '
          'System das Leserkonto.“ Wie zeichnest du „Leserkonto prüfen“?',
      optionen: [
        'Je ein «include»-Pfeil von „Medium ausleihen“ und von „Ausleihe '
            'verlängern“ zu „Leserkonto prüfen“',
        'Je ein «extend»-Pfeil von „Leserkonto prüfen“ zu den beiden Fällen',
        'Als eigenen Akteur „Leserkonto“',
        'Als eigenen Anwendungsfall mit Linie zum Leser',
      ],
      richtig: 0,
      erklaerung: '„Vor jeder“ heißt immer, also include. Der Pfeil zeigt vom '
          'Basisfall weg zum eingebundenen Fall. Weil beide Fälle die Prüfung '
          'brauchen, gibt es zwei Pfeile, die Prüfung wird aber nur einmal '
          'gezeichnet.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-5',
      frage: 'Text: „Der Bibliothekar nimmt Rückgaben an. Ist die Leihfrist '
          'überschritten, erhebt er zusätzlich eine Mahngebühr.“ Was ist '
          'richtig?',
      optionen: [
        '«include» von „Rückgabe annehmen“ zu „Mahngebühr erheben“',
        '«extend» von „Mahngebühr erheben“ zu „Rückgabe annehmen“',
        '«extend» von „Rückgabe annehmen“ zu „Mahngebühr erheben“',
        '„Mahngebühr erheben“ ist ein eigener Akteur',
      ],
      richtig: 1,
      erklaerung: 'Die Mahngebühr kommt nur dazu, wenn die Frist '
          'überschritten ist: extend. Der Pfeil zeigt zum Basisfall „Rückgabe '
          'annehmen“. Die Bedingung kommt in eine Notiz.',
    )),

    // ── Seite: Anmelden ────────────────────────────────────────────────
    UeberschriftBlock('Sonderfall Anmelden'),
    TextBlock(
      'Ist „Anmelden“ ein Anwendungsfall? Allein nicht: Niemand meldet sich '
      'an, um danach zufrieden aufzuhören. Das Anmelden ist eine '
      'Voraussetzung, kein Ziel.\n'
      '\n'
      'Als eingebundener Fall darf es trotzdem als Oval stehen. Ein '
      'eingebundener Fall braucht kein eigenes Ziel, er hilft nur beim Ziel '
      'des Basisfalls. So steht es in vielen Musterlösungen: „Rad warten“ '
      'bindet mit «include» den Fall „Anmelden“ ein, weil sich der '
      'Mitarbeiter dafür jedes Mal anmelden muss.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-6',
      frage: 'Ein Mitarbeiter muss sich vor jeder Wartung anmelden. Welche '
          'Lösung ist üblich?',
      optionen: [
        '„Anmelden“ als einziger Anwendungsfall des Mitarbeiters',
        '«extend» von „Rad warten“ zu „Anmelden“',
        '«include» von „Rad warten“ zu „Anmelden“',
        '„Anmelden“ als Akteur',
      ],
      richtig: 2,
      erklaerung: '„Vor jeder“ heißt immer, also include vom Basisfall „Rad '
          'warten“ zu „Anmelden“. Allein wäre „Anmelden“ kein gutes Ziel.',
    )),

    // ── Seite: Generalisierung ─────────────────────────────────────────
    UeberschriftBlock('Generalisierung: eine besondere Art von'),
    TextBlock(
      'Im Lastenrad-Verleih gibt es eine **Stationsleitung**. Sie ist auch '
      'Mitarbeiterin und darf alles, was ein Mitarbeiter darf. Zusätzlich '
      'darf sie alte Räder ausmustern.\n'
      '\n'
      'Man könnte von ihr jede Linie des Mitarbeiters noch einmal ziehen. '
      'Einfacher ist ein eigenes Zeichen: eine **durchgezogene Linie mit '
      'hohlem Dreieck**. Das Dreieck zeigt auf den **allgemeineren** '
      'Akteur:',
    ),
    UmlBlock(
      _general,
      unterschrift: 'Das Dreieck sitzt am Mitarbeiter. Die Stationsleitung '
          'erbt „Rad warten“ und darf zusätzlich ausmustern.',
    ),
    TextBlock(
      'Diese Beziehung heißt **Generalisierung**. Lies sie als „ist eine '
      'besondere Art von“: Die Stationsleitung ist eine besondere Art von '
      'Mitarbeiter. Alles, was der Mitarbeiter darf, darf sie auch. Man sagt: '
      'Sie **erbt** seine Anwendungsfälle.\n'
      '\n'
      'Dasselbe Dreieck begegnet dir wieder im Klassendiagramm, dort heißt '
      'es Vererbung (Lektion 6).\n'
      '\n'
      'Auch zwischen **Anwendungsfällen** ist eine Generalisierung erlaubt. '
      '„Mit Karte bezahlen“ und „Per Rechnung bezahlen“ sind besondere Arten '
      'von „Bezahlen“:',
    ),
    UmlBlock(
      _ucGeneral,
      unterschrift: 'Auch hier sitzt das Dreieck am allgemeineren Fall.',
    ),
    TextBlock(
      'In Prüfungen kommt die Generalisierung aber fast nur bei Akteuren '
      'vor.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-7',
      frage: 'In einer Tierarztpraxis darf die Tierärztin alles, was ein '
          'Praxismitarbeiter darf, und zusätzlich Behandlungen dokumentieren. '
          'Wo sitzt das hohle Dreieck?',
      optionen: [
        'Am Praxismitarbeiter',
        'An der Tierärztin',
        'Am Anwendungsfall „Behandlung dokumentieren“',
        'Es gibt kein Dreieck, nur eine gestrichelte Linie',
      ],
      richtig: 0,
      erklaerung: 'Das Dreieck zeigt auf den allgemeineren Akteur. Die '
          'Tierärztin ist eine besondere Art von Praxismitarbeiter, also '
          'sitzt das Dreieck am Praxismitarbeiter.',
    )),

    // ── Seite: Alles zusammen ──────────────────────────────────────────
    UeberschriftBlock('Alles zusammen'),
    TextBlock(
      'Aus diesem Aufgabentext entsteht das Diagramm unten:\n'
      '\n'
      '„Kunden buchen ein Lastenrad. Zu jeder Buchung gehört die Bezahlung '
      'über einen externen Zahlungsanbieter. Auf Wunsch kann der Kunde bei '
      'der Buchung Zubehör hinzubuchen. Bis 24 Stunden vorher kann er die '
      'Buchung stornieren. Mitarbeiter warten die Räder.“',
    ),
    UmlBlock(
      _gesamt,
      unterschrift: 'include für das Bezahlen, extend für das Zubehör, '
          'Stornieren als eigener Fall.',
      zurAufgabe: true,
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-8',
      frage: 'Warum ist „Buchung stornieren“ im Diagramm kein extend von „Rad '
          'buchen“?',
      optionen: [
        'Weil Stornieren immer passiert',
        'Weil der Kunde später in einem eigenen Vorgang storniert, mit eigenem '
            'Ziel',
        'Weil extend nur zwischen Akteuren erlaubt ist',
        'Weil der Zahlungsanbieter beteiligt ist',
      ],
      richtig: 1,
      erklaerung: 'Eine Erweiterung klinkt sich während des Basisfalls ein. '
          'Storniert wird aber später und für sich allein. Deshalb ist es ein '
          'eigener Anwendungsfall.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 3'),
    HinweisBlock(
      '- **include**: immer dabei. Gestrichelter Pfeil vom Basisfall zum '
      'eingebundenen Fall.\n'
      '- **extend**: nur manchmal. Gestrichelter Pfeil von der Erweiterung '
      'zum Basisfall, Bedingung in einer Notiz.\n'
      '- Merksatz: include zeigt weg, extend zeigt hin.\n'
      '- Was später für sich allein passiert, ist ein eigener '
      'Anwendungsfall.\n'
      '- **Generalisierung**: durchgezogene Linie, hohles Dreieck am '
      'allgemeineren Akteur.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-3-9',
      frage: 'Welche Aussage ist richtig?',
      optionen: [
        'Bei «extend» zeigt der Pfeil vom Basisfall zur Erweiterung.',
        '«include» wird mit durchgezogener Linie gezeichnet.',
        'Bei «include» zeigt der Pfeil vom Basisfall zum eingebundenen Fall.',
        'Das Dreieck der Generalisierung sitzt am spezielleren Akteur.',
      ],
      richtig: 2,
      erklaerung: 'include zeigt vom Basisfall weg. extend zeigt zum Basisfall '
          'hin. Beide sind gestrichelt. Das Dreieck sitzt am allgemeineren '
          'Akteur.',
    )),
  ],
);
