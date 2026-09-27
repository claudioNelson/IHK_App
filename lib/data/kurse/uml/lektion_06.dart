// lib/data/kurse/uml/lektion_06.dart
//
// UML-Kurs der App, Lektion 6: Vererbung, Aggregation, Komposition,
// abstrakte Klasse und Interface (Klassendiagramm III).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _vererbung = UmlDiagramm(
  breite: 520,
  hoehe: 258,
  beschreibung: 'Buch und DVD erben von Medium: Linien mit hohlem Dreieck an Medium.',
  elemente: [
    UmlKlasse(x: 150, y: 10, b: 220, name: 'Medium', attribute: ['- titel: String', '- signatur: String'], methoden: ['+ ausleihen(): void']),
    UmlKlasse(x: 10, y: 170, b: 200, name: 'Buch', attribute: ['- isbn: String', '- seiten: int']),
    UmlKlasse(x: 310, y: 170, b: 200, name: 'DVD', attribute: ['- laufzeit: int']),
    UmlKante(punkte: [Offset(110, 170), Offset(110, 142), Offset(230, 142), Offset(230, 114)], art: UmlKantenArt.vererbung),
    UmlKante(punkte: [Offset(410, 170), Offset(410, 142), Offset(290, 142), Offset(290, 114)], art: UmlKantenArt.vererbung),
  ],
);

const _abstrakt = UmlDiagramm(
  breite: 520,
  hoehe: 258,
  beschreibung: 'Medium ist abstrakt (Name kursiv mit {abstract}), Buch und DVD erben davon.',
  elemente: [
    UmlKlasse(x: 150, y: 10, b: 220, name: 'Medium', attribute: ['- titel: String', '- signatur: String'], methoden: ['+ ausleihen(): void'], abstrakt: true),
    UmlKlasse(x: 10, y: 170, b: 200, name: 'Buch', attribute: ['- isbn: String', '- seiten: int']),
    UmlKlasse(x: 310, y: 170, b: 200, name: 'DVD', attribute: ['- laufzeit: int']),
    UmlKante(punkte: [Offset(110, 170), Offset(110, 149), Offset(230, 149), Offset(230, 128)], art: UmlKantenArt.vererbung),
    UmlKante(punkte: [Offset(410, 170), Offset(410, 149), Offset(290, 149), Offset(290, 128)], art: UmlKantenArt.vererbung),
  ],
);

const _interface = UmlDiagramm(
  breite: 520,
  hoehe: 248,
  beschreibung: 'Rechnung und Ticket realisieren das Interface Druckbar: gestrichelte Linien mit hohlem Dreieck.',
  elemente: [
    UmlKlasse(x: 150, y: 10, b: 220, name: 'Druckbar', methoden: ['+ drucken(): void'], stereotyp: '«interface»'),
    UmlKlasse(x: 10, y: 150, b: 200, name: 'Rechnung', attribute: ['- betrag: double'], methoden: ['+ drucken(): void']),
    UmlKlasse(x: 310, y: 150, b: 200, name: 'Ticket', attribute: ['- platz: String'], methoden: ['+ drucken(): void']),
    UmlKante(punkte: [Offset(110, 150), Offset(110, 116), Offset(230, 116), Offset(230, 82)], art: UmlKantenArt.realisierung),
    UmlKante(punkte: [Offset(410, 150), Offset(410, 116), Offset(290, 116), Offset(290, 82)], art: UmlKantenArt.realisierung),
  ],
);

const _aggregation = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Team mit leerer Raute zu Mitarbeiter, 0..1 am Team, 1..* am Mitarbeiter.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Team'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Mitarbeiter'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], art: UmlKantenArt.aggregation, von: '0..1', nach: '1..*'),
  ],
);

const _komposition = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Gebäude mit gefüllter Raute zu Raum, 1 am Gebäude, 1..* am Raum.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Gebäude'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Raum'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], art: UmlKantenArt.komposition, von: '1', nach: '1..*'),
  ],
);
const umlLektion6 = Lektion(
  nr: 6,
  slug: 'uml-6-vererbung-komposition',
  titel: 'Vererbung, Aggregation, Komposition',
  kurzbeschreibung:
      'Die besonderen Linien im Klassendiagramm: Dreieck, leere und gefüllte '
      'Raute. Dazu abstrakte Klassen und Interfaces.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Ist ein ─────────────────────────────────────────────────
    UeberschriftBlock('Ein Buch ist ein Medium'),
    TextBlock(
      'Eine Bibliothek verleiht Bücher und DVDs. Beide haben einen Titel und '
      'eine Signatur, also die Nummer auf dem Rücken. Beide kann man '
      'ausleihen. Ein Buch hat zusätzlich eine ISBN und eine Seitenzahl, eine '
      'DVD eine Laufzeit.\n'
      '\n'
      'Man könnte Titel und Signatur in beide Klassen schreiben. Das wäre '
      'doppelt. Besser: Man sammelt das Gemeinsame in einer Klasse `Medium`. '
      'Buch und DVD übernehmen alles davon und ergänzen nur ihre Besonderheiten:',
    ),
    UmlBlock(
      _vererbung,
      unterschrift: 'Das hohle Dreieck zeigt auf Medium, die allgemeinere '
          'Klasse.',
    ),
    TextBlock(
      'Das heißt **Vererbung**. `Medium` ist die **Oberklasse**, `Buch` und '
      '`DVD` sind **Unterklassen**. Eine Unterklasse **erbt** alle Attribute '
      'und Methoden der Oberklasse. Ein Buch hat also Titel, Signatur, ISBN '
      'und Seitenzahl, und man kann es ausleihen.\n'
      '\n'
      'Gezeichnet wird eine durchgezogene Linie mit **hohlem Dreieck an der '
      'Oberklasse**. Das kennst du schon aus Lektion 3, dort hieß es '
      'Generalisierung. Beides meint dasselbe.',
    ),
    HinweisBlock(
      'Die Probe für Vererbung: Stimmt der Satz „Ein [Unterklasse] **ist '
      'ein** [Oberklasse]“? „Ein Buch ist ein Medium“ stimmt. „Ein Rad ist '
      'eine Station“ stimmt nicht, also keine Vererbung.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-1',
      frage: 'Bei welchem Paar ist Vererbung richtig?',
      optionen: [
        'Motor erbt von Auto',
        'Kunde erbt von Bestellung',
        'Pkw erbt von Fahrzeug',
        'Fahrzeug erbt von Pkw',
      ],
      richtig: 2,
      erklaerung: '„Ein Pkw ist ein Fahrzeug“ stimmt. Ein Motor ist kein '
          'Auto, sondern ein Teil davon. Ein Kunde ist keine Bestellung. Und '
          'nicht jedes Fahrzeug ist ein Pkw, die Richtung wäre falsch herum.',
    )),
    UmlBlock(_vererbung, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-2',
      frage: 'Welche Attribute hat ein Objekt der Klasse `DVD`?',
      optionen: [
        'Nur laufzeit',
        'titel, signatur und laufzeit',
        'titel, signatur, isbn, seiten und laufzeit',
        'Nur titel und signatur',
      ],
      richtig: 1,
      erklaerung: 'Die DVD erbt titel und signatur von Medium und hat selbst '
          'noch laufzeit. isbn und seiten gehören nur zum Buch.',
    )),

    // ── Seite: protected ───────────────────────────────────────────────
    UeberschriftBlock('Noch einmal: protected'),
    TextBlock(
      'In Lektion 4 stand in der Tabelle das Zeichen `#` für **protected**, '
      'also geschützt. Jetzt verstehst du, wozu es da ist.\n'
      '\n'
      'Ein privates Attribut `- titel` darf nur die Klasse `Medium` selbst '
      'benutzen. Nicht einmal das Buch darf direkt darauf zugreifen, obwohl '
      'es den Titel geerbt hat. Mit `# titel` dürfen es auch die '
      'Unterklassen.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-3',
      frage: 'Die Klasse `Buch` soll direkt auf das Attribut `titel` ihrer '
          'Oberklasse zugreifen dürfen, fremde Klassen aber nicht. Welche '
          'Sichtbarkeit passt?',
      optionen: ['+ public', '- private', '# protected', 'Das geht nicht'],
      richtig: 2,
      erklaerung: 'protected erlaubt den Zugriff für die Klasse selbst und '
          'ihre Unterklassen, aber nicht für fremde Klassen.',
    )),

    // ── Seite: Abstrakt ────────────────────────────────────────────────
    UeberschriftBlock('Abstrakte Klassen'),
    TextBlock(
      'Geh in eine Bibliothek und frag nach „einem Medium“. Die Antwort '
      'wird sein: „Was denn, ein Buch oder eine DVD?“ Ein Medium an sich gibt '
      'es nicht im Regal. Es gibt nur Bücher und DVDs.\n'
      '\n'
      'So eine Klasse nennt man **abstrakt**. Von ihr werden **keine '
      'Objekte** erzeugt. Sie ist nur dazu da, das Gemeinsame für ihre '
      'Unterklassen zu sammeln.\n'
      '\n'
      'Im Diagramm steht der Name **kursiv**. Weil man Kursivschrift von Hand '
      'schlecht erkennt, schreibt man zusätzlich `{abstract}` dazu:',
    ),
    UmlBlock(
      _abstrakt,
      unterschrift: 'Medium ist abstrakt. Objekte gibt es nur von Buch und '
          'DVD.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-4',
      frage: 'Was gilt für eine abstrakte Klasse?',
      optionen: [
        'Sie hat keine Attribute.',
        'Von ihr werden keine Objekte erzeugt, nur von ihren Unterklassen.',
        'Sie darf keine Unterklassen haben.',
        'Ihre Attribute sind alle öffentlich.',
      ],
      richtig: 1,
      erklaerung: 'Eine abstrakte Klasse sammelt das Gemeinsame. Objekte '
          'erzeugt man nur von den Unterklassen. Attribute und Methoden darf '
          'sie ganz normal haben.',
    )),

    // ── Seite: Interface ───────────────────────────────────────────────
    UeberschriftBlock('Interfaces: ein Versprechen'),
    TextBlock(
      'Eine Rechnung und ein Kinoticket haben wenig gemeinsam. Aber beide '
      'kann man drucken. Das Programm will einfach sagen können: „Druck das '
      'aus“, egal was es ist.\n'
      '\n'
      'Dafür gibt es ein **Interface**, auf Deutsch **Schnittstelle**. Ein '
      'Interface ist wie ein Versprechen: Jede Klasse, die es umsetzt, '
      'verspricht, bestimmte Methoden zu haben. Wie sie das macht, entscheidet '
      'jede Klasse selbst.',
    ),
    UmlBlock(
      _interface,
      unterschrift: 'Rechnung und Ticket setzen das Interface Druckbar um. '
          'Beide haben deshalb die Methode drucken().',
    ),
    TextBlock(
      'So erkennst du es:\n'
      '- Über dem Namen steht der Stereotyp «interface».\n'
      '- Ein Interface hat meist nur Methoden, keine Attribute.\n'
      '- Die Linie ist **gestrichelt** mit **hohlem Dreieck** am Interface. '
      'Sie heißt **Realisierung**, weil die Klasse das Versprechen '
      'verwirklicht.\n'
      '\n'
      'Vergleich mit der Vererbung: Dasselbe Dreieck, aber gestrichelt statt '
      'durchgezogen.',
    ),
    HinweisBlock(
      'Abstrakte Klasse oder Interface? Haben die Unterklassen gemeinsame '
      '**Attribute**, nimm eine abstrakte Klasse. Geht es nur um ein '
      'Versprechen, dass bestimmte **Methoden** da sind, nimm ein Interface.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-5',
      frage: 'Woran erkennst du, dass eine Klasse ein Interface umsetzt?',
      optionen: [
        'Durchgezogene Linie mit hohlem Dreieck',
        'Gestrichelte Linie mit hohlem Dreieck am Interface',
        'Gefüllte Raute am Interface',
        'Gestrichelter Pfeil mit «include»',
      ],
      richtig: 1,
      erklaerung: 'Die Realisierung ist gestrichelt mit hohlem Dreieck am '
          'Interface. Durchgezogen mit Dreieck wäre Vererbung.',
    )),

    // ── Seite: Teil und Ganzes ─────────────────────────────────────────
    UeberschriftBlock('Teil und Ganzes'),
    TextBlock(
      'Manche Beziehungen bedeuten „besteht aus“: Ein Team besteht aus '
      'Mitarbeitern. Ein Gebäude besteht aus Räumen. Dafür gibt es zwei '
      'besondere Linien mit einer **Raute**. Die Raute sitzt immer am '
      '**Ganzen**, also am Team oder am Gebäude.\n'
      '\n'
      'Der Unterschied liegt in einer Frage: **Was passiert mit den Teilen, '
      'wenn das Ganze verschwindet?**',
    ),
    UmlBlock(
      _aggregation,
      unterschrift: 'Aggregation: leere Raute am Team.',
    ),
    TextBlock(
      'Löst sich ein Team auf, gibt es die Mitarbeiter weiterhin. Sie gehen '
      'in ein anderes Team oder arbeiten allein. Die Teile können also ohne '
      'das Ganze existieren. Das ist eine **Aggregation**, gezeichnet mit '
      '**leerer Raute**.',
    ),
    UmlBlock(
      _komposition,
      unterschrift: 'Komposition: gefüllte Raute am Gebäude.',
    ),
    TextBlock(
      'Wird ein Gebäude abgerissen, sind auch seine Räume weg. Ein Raum kann '
      'nicht ohne sein Gebäude existieren und gehört zu genau einem Gebäude. '
      'Das ist eine **Komposition**, gezeichnet mit **gefüllter Raute**. Am '
      'Ganzen steht deshalb meist die Multiplizität 1.',
    ),
    HinweisBlock(
      'Merkhilfe: Die gefüllte Raute ist „fest verbunden“. Die Teile leben '
      'und sterben mit dem Ganzen. Die leere Raute ist „locker verbunden“.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-6-6',
      frage: 'Ergänze.',
      vorlage: 'Die Raute sitzt immer am ___. Bei einer Komposition ist sie '
          '___.',
      loesungen: [
        ['Ganzen'],
        ['gefüllt'],
      ],
      bausteine: ['Ganzen', 'Teil', 'gefüllt', 'leer'],
      erklaerung: 'Die Raute sitzt am Ganzen. Gefüllt heißt Komposition, leer '
          'heißt Aggregation.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-7',
      frage: 'Eine Rechnung besteht aus Rechnungspositionen. Wird die Rechnung '
          'gelöscht, sind auch ihre Positionen weg. Welche Beziehung passt?',
      optionen: [
        'Aggregation, leere Raute an der Rechnung',
        'Komposition, gefüllte Raute an der Rechnung',
        'Komposition, gefüllte Raute an der Rechnungsposition',
        'Vererbung, Dreieck an der Rechnung',
      ],
      richtig: 1,
      erklaerung: 'Die Positionen existieren nicht ohne ihre Rechnung: '
          'Komposition. Die gefüllte Raute sitzt am Ganzen, also an der '
          'Rechnung.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-8',
      frage: 'Ein Warenkorb enthält Artikel. Wird der Warenkorb geleert, gibt '
          'es die Artikel im Shop natürlich weiterhin. Welche Beziehung passt?',
      optionen: [
        'Komposition, gefüllte Raute am Warenkorb',
        'Aggregation, leere Raute am Artikel',
        'Aggregation, leere Raute am Warenkorb',
        'Vererbung, Dreieck am Warenkorb',
      ],
      richtig: 2,
      erklaerung: 'Die Artikel überleben den Warenkorb, also Aggregation. Die '
          'leere Raute sitzt am Ganzen, dem Warenkorb.',
    )),

    // ── Seite: Alle Linien ─────────────────────────────────────────────
    UeberschriftBlock('Alle Linien auf einen Blick'),
    SchreibtischtestBlock(
      spalten: ['Linie', 'Name', 'Bedeutung'],
      zeilen: [
        ['durchgezogen', 'Assoziation', 'kennen sich'],
        ['durchgezogen, offene Spitze', 'gerichtete Assoziation',
            'nur in Pfeilrichtung bekannt (Lektion 5)'],
        ['leere Raute am Ganzen', 'Aggregation', 'besteht aus, Teile '
            'überleben'],
        ['gefüllte Raute am Ganzen', 'Komposition', 'besteht aus, Teile '
            'sterben mit'],
        ['durchgezogen, hohles Dreieck', 'Vererbung', 'ist ein'],
        ['gestrichelt, hohles Dreieck', 'Realisierung', 'setzt Interface '
            'um'],
        ['gestrichelt, offene Spitze', 'Abhängigkeit', 'benutzt kurz'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Die Linie mit Pfeilspitze aus Lektion 5 heißt offiziell **gerichtete '
      'Assoziation**. Neu ist nur die letzte Zeile: Die **Abhängigkeit** '
      'bedeutet, dass eine Klasse eine andere nur kurz benutzt, zum Beispiel '
      'als Parameter einer Methode. In Prüfungen kommt sie selten vor.',
    ),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 6'),
    HinweisBlock(
      '- **Vererbung**: „ist ein“, hohles Dreieck an der Oberklasse. Die '
      'Unterklasse erbt alles.\n'
      '- `#` protected: auch Unterklassen dürfen zugreifen.\n'
      '- **Abstrakte Klasse**: Name kursiv mit {abstract}, keine eigenen '
      'Objekte.\n'
      '- **Interface**: «interface», Methoden ohne Attribute. Realisierung '
      'gestrichelt mit hohlem Dreieck.\n'
      '- **Aggregation**: leere Raute am Ganzen, Teile überleben.\n'
      '- **Komposition**: gefüllte Raute am Ganzen, Teile sterben mit.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-6-9',
      frage: 'Ein Hotel besteht aus Zimmern. Wird das Hotel abgerissen, gibt '
          'es die Zimmer nicht mehr. Außerdem gibt es Einzelzimmer und '
          'Doppelzimmer, beide sind Zimmer. Welche Kombination ist richtig?',
      optionen: [
        'Komposition mit gefüllter Raute am Hotel, Einzelzimmer und '
            'Doppelzimmer erben von Zimmer',
        'Aggregation mit leerer Raute am Hotel, Zimmer erbt von Einzelzimmer',
        'Zimmer erbt von Hotel, Einzelzimmer und Doppelzimmer erben von Zimmer',
        'Komposition mit gefüllter Raute am Zimmer, Einzelzimmer und '
            'Doppelzimmer erben von Zimmer',
      ],
      richtig: 0,
      erklaerung: 'Die Zimmer sterben mit dem Hotel: Komposition mit gefüllter '
          'Raute am Hotel. „Ein Einzelzimmer ist ein Zimmer“: Vererbung mit '
          'Dreieck an Zimmer.',
    )),
  ],
);
