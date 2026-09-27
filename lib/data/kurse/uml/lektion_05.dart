// lib/data/kurse/uml/lektion_05.dart
//
// UML-Kurs der App, Lektion 5: Beziehungen und Multiplizitäten
// (Klassendiagramm II).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _kb0 = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Kunde und Buchung, verbunden durch eine Linie.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Kunde'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Buchung'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)]),
  ],
);

const _kb1 = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Kunde 1 legt an beliebig viele Buchungen.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Kunde'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Buchung'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], von: '1', nach: '*', name: 'legt an'),
  ],
);

const _station = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Station 1 zu Lastenrad 1..*.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Station'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Lastenrad'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], von: '1', nach: '1..*'),
  ],
);

const _radB = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Buchung zeigt mit offener Pfeilspitze auf Lastenrad, Multiplizität * an Buchung, 1 und Rolle rad an Lastenrad.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Buchung'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Lastenrad'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], art: UmlKantenArt.gerichtet, von: '*', nach: '1', rolleNach: 'rad'),
  ],
);

const _dienstwagen = UmlDiagramm(
  breite: 460,
  hoehe: 80,
  beschreibung: 'Mitarbeiter 0..1 zu Dienstwagen 0..1.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Mitarbeiter'),
    UmlKlasse(x: 320, y: 25, b: 120, name: 'Dienstwagen'),
    UmlKante(punkte: [Offset(140, 40), Offset(320, 40)], von: '0..1', nach: '0..1'),
  ],
);

const _ausleihe = UmlDiagramm(
  breite: 580,
  hoehe: 100,
  beschreibung: 'Leser 1 zu * Ausleihe, Ausleihe * zu 1 Medium. Ausleihe hat die Attribute ausleihDatum und rueckgabeDatum.',
  elemente: [
    UmlKlasse(x: 10, y: 33, b: 90, name: 'Leser'),
    UmlKlasse(x: 190, y: 10, b: 200, name: 'Ausleihe', attribute: ['- ausleihDatum: Date', '- rueckgabeDatum: Date']),
    UmlKlasse(x: 480, y: 33, b: 90, name: 'Medium'),
    UmlKante(punkte: [Offset(100, 48), Offset(190, 48)], von: '1', nach: '*'),
    UmlKante(punkte: [Offset(390, 48), Offset(480, 48)], von: '*', nach: '1'),
  ],
);
const umlLektion5 = Lektion(
  nr: 5,
  slug: 'uml-5-beziehungen',
  titel: 'Beziehungen und Multiplizitäten',
  kurzbeschreibung:
      'Wie Klassen zusammenhängen und wie viele Objekte beteiligt sind: '
      'Assoziation, die Zahlen an den Linienenden, Rollen und Pfeilspitzen.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Klassen kennen sich ─────────────────────────────────────
    UeberschriftBlock('Klassen kennen sich'),
    TextBlock(
      'In Lektion 4 stand jede Klasse für sich allein. In einem echten '
      'Programm hängen sie aber zusammen. Ein Kunde legt Buchungen an. Eine '
      'Buchung gehört zu einem Kunden.\n'
      '\n'
      'Im Klassendiagramm zeichnest du dafür eine durchgezogene Linie '
      'zwischen den Klassen:',
    ),
    UmlBlock(
      _kb0,
      unterschrift: 'Um die Beziehung zu zeigen, reicht hier der Name der '
          'Klassen. Attribute und Methoden lassen wir weg.',
    ),
    TextBlock(
      'Diese Linie heißt wie im Use-Case-Diagramm **Assoziation**. Hier '
      'bedeutet sie: Objekte dieser beiden Klassen **kennen sich**. Ein '
      'Kunde weiß, welche Buchungen er hat. Eine Buchung weiß, zu welchem '
      'Kunden sie gehört.\n'
      '\n'
      'Man darf Klassen im Diagramm so verkürzt zeichnen, wenn es gerade nur '
      'um die Beziehungen geht.',
    ),

    // ── Seite: Wie viele ───────────────────────────────────────────────
    UeberschriftBlock('Wie viele? Die Multiplizität'),
    TextBlock(
      'Die Linie allein sagt noch nicht, wie viele Buchungen ein Kunde haben '
      'kann. Dafür schreibt man an jedes Ende eine Zahl oder ein Zeichen. Das '
      'heißt **Multiplizität**:',
    ),
    UmlBlock(
      _kb1,
      unterschrift: 'Die 1 steht am Kunden, der Stern an der Buchung.',
    ),
    TextBlock(
      'Der Stern `*` heißt **beliebig viele**, auch keine. So liest du die '
      'Linie, einmal in jede Richtung:\n'
      '- „Ein Kunde legt **beliebig viele** Buchungen an.“ Der Stern steht '
      'deshalb an der **Buchung**.\n'
      '- „Eine Buchung gehört zu **genau einem** Kunden.“ Die 1 steht deshalb '
      'am **Kunden**.\n'
      '\n'
      'Das Wort „legt an“ in der Mitte ist der **Name** der Beziehung. Er ist '
      'freiwillig, macht das Diagramm aber leichter lesbar.',
    ),
    HinweisBlock(
      'Die wichtigste Regel: Die Multiplizität steht an der Klasse, **deren '
      'Anzahl sie beschreibt**. Du fängst also auf der anderen Seite an zu '
      'lesen: „Ein Kunde hat … Buchungen“. Die Zahl dafür steht bei den '
      'Buchungen.',
    ),
    UmlBlock(_kb1, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-1',
      frage: 'Im Diagramm: Was bedeutet die 1 am Kunden?',
      optionen: [
        'Ein Kunde hat genau eine Buchung.',
        'Eine Buchung gehört zu genau einem Kunden.',
        'Es gibt nur einen Kunden.',
        'Der Kunde ist die erste Klasse.',
      ],
      richtig: 1,
      erklaerung: 'Die 1 steht am Kunden, sie beschreibt also, wie viele '
          'Kunden beteiligt sind. Von der Buchung aus gelesen: Eine Buchung '
          'gehört zu genau einem Kunden.',
    )),

    // ── Seite: Die Zeichen ─────────────────────────────────────────────
    UeberschriftBlock('Die üblichen Multiplizitäten'),
    TextBlock(
      'Zwei Punkte `..` bedeuten „bis“. `0..1` heißt also „null bis eins“. '
      'Diese Schreibweisen kommen in der Prüfung vor:',
    ),
    SchreibtischtestBlock(
      spalten: ['Zeichen', 'Bedeutung', 'Beispiel'],
      zeilen: [
        ['1', 'genau eins', 'jede Buchung hat genau einen Kunden'],
        ['0..1', 'keins oder eins', 'ein Mitarbeiter hat höchstens einen '
            'Dienstwagen'],
        ['*', 'beliebig viele, auch keins', 'ein Kunde hat beliebig viele '
            'Buchungen'],
        ['0..*', 'dasselbe wie *', 'wie oben'],
        ['1..*', 'mindestens eins', 'eine Station hat mindestens ein Rad'],
        ['2..4', 'fester Bereich', 'ein Team hat zwei bis vier Mitglieder'],
      ],
      aenderungenMarkieren: false,
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-2',
      frage: 'Welche Multiplizität bedeutet „mindestens eins“?',
      optionen: ['0..1', '*', '1..*', '1'],
      richtig: 2,
      erklaerung: '`1..*` heißt „eins bis beliebig viele“, also mindestens '
          'eins. `*` erlaubt auch null.',
    )),
    UmlBlock(_station, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-3',
      frage: 'Was sagt dieses Diagramm über Station und Lastenrad?',
      optionen: [
        'Eine Station hat genau ein Lastenrad.',
        'Ein Lastenrad kann zu mehreren Stationen gehören.',
        'Eine Station hat mindestens ein Lastenrad, jedes Rad gehört zu '
            'genau einer Station.',
        'Eine Station kann auch ganz ohne Lastenrad sein.',
      ],
      richtig: 2,
      erklaerung: '`1..*` steht am Lastenrad: Eine Station hat mindestens ein '
          'Rad. Die 1 steht an der Station: Jedes Rad gehört zu genau einer '
          'Station.',
    )),

    // ── Seite: Satzprobe ───────────────────────────────────────────────
    UeberschriftBlock('Die Satzprobe'),
    TextBlock(
      'Der häufigste Fehler: Die Zahl landet am falschen Ende. Dagegen hilft '
      'eine einfache Probe. Lies jede Linie zweimal laut, einmal von jeder '
      'Seite, nach dem Muster:\n'
      '\n'
      '„**Ein** [Klasse A] hat [Zahl bei B] [Klasse B].“\n'
      '\n'
      'Klingt ein Satz falsch, ist die Zahl am falschen Ende.\n'
      '\n'
      'Beispiel: „Ein Mitarbeiter hat höchstens einen '
      'Dienstwagen. Ein Dienstwagen ist höchstens einem Mitarbeiter '
      'zugeteilt.“',
    ),
    UmlBlock(
      _dienstwagen,
      unterschrift: '„Ein Mitarbeiter hat 0..1 Dienstwagen.“ „Ein Dienstwagen '
          'gehört 0..1 Mitarbeitern.“ Beide Sätze stimmen.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-5-4',
      frage: 'Text: „Ein Kurs hat mindestens einen Teilnehmer. Ein Teilnehmer '
          'besucht beliebig viele Kurse.“ Welche Multiplizität steht an '
          'welcher Klasse?',
      vorlage: 'Am Teilnehmer steht ___ und am Kurs steht ___.',
      loesungen: [
        ['1..*'],
        ['*'],
      ],
      bausteine: ['1..*', '*', '1', '0..1'],
      erklaerung: '„Ein Kurs hat mindestens einen Teilnehmer“: Die Zahl dafür '
          'steht am Teilnehmer, also `1..*`. „Ein Teilnehmer besucht beliebig '
          'viele Kurse“: Am Kurs steht `*`.',
    )),

    // ── Seite: Rollen und Pfeile ───────────────────────────────────────
    UeberschriftBlock('Rollen und Pfeilspitzen'),
    TextBlock(
      'Eine Buchung gilt für genau ein Lastenrad. So kann das aussehen:',
    ),
    UmlBlock(
      _radB,
      unterschrift: 'Die Pfeilspitze zeigt zum Lastenrad, darunter steht der '
          'Rollenname „rad“.',
    ),
    TextBlock(
      'Hier sind zwei neue Dinge zu sehen:\n'
      '- Das Wort `rad` am Ende der Linie ist ein **Rollenname**. Er sagt, '
      'welche Rolle das Lastenrad für die Buchung spielt: Es ist „das Rad“ '
      'der Buchung. Der Rollenname steht am **Ende** der Linie, der Name der '
      'Beziehung wie „legt an“ dagegen in der **Mitte**. In Lektion 7 wird '
      'aus dem Rollennamen im Programmcode ein Attribut.\n'
      '- Die offene **Pfeilspitze** zeigt, in welche Richtung man die '
      'Beziehung benutzen kann. Das heißt **Navigierbarkeit**. Hier kennt die '
      'Buchung ihr Rad. Das Rad muss aber nicht wissen, in welchen Buchungen '
      'es vorkommt.\n'
      '\n'
      'Ohne Pfeilspitze ist die Richtung offen. In der Prüfung liest man eine '
      'Linie ohne Spitze meist so: Beide kennen sich. Zeichne Spitzen nur, '
      'wenn die Aufgabe eine Richtung verlangt.',
    ),
    UmlBlock(_radB, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-5',
      frage: 'Was bedeutet die Pfeilspitze am Lastenrad?',
      optionen: [
        'Das Lastenrad erbt von der Buchung.',
        'Die Buchung kennt ihr Lastenrad.',
        'Das Lastenrad kennt alle seine Buchungen.',
        'Es gibt mehr Lastenräder als Buchungen.',
      ],
      richtig: 1,
      erklaerung: 'Die Pfeilspitze zeigt die Navigierbarkeit: Von der Buchung '
          'aus kommt man zum Lastenrad. Umgekehrt ist das nicht festgelegt.',
    )),

    // ── Seite: Klasse dazwischen ───────────────────────────────────────
    UeberschriftBlock('Eine Klasse in der Mitte'),
    TextBlock(
      'In einer Bibliothek leiht ein Leser viele Medien aus, und ein Medium '
      'wird im Lauf der Zeit von vielen Lesern ausgeliehen. Zu jeder Ausleihe '
      'gehören aber eigene Daten: das Ausleihdatum und das Rückgabedatum.\n'
      '\n'
      'Wohin mit diesen Daten? Zum Leser passen sie nicht, zum Medium auch '
      'nicht. Sie gehören zur **Ausleihe** selbst. Also bekommt die Ausleihe '
      'eine eigene Klasse in der Mitte:',
    ),
    UmlBlock(
      _ausleihe,
      unterschrift: 'Ein Leser hat beliebig viele Ausleihen, jede Ausleihe '
          'gehört zu genau einem Leser und genau einem Medium.',
    ),
    TextBlock(
      'Merke: Hat eine Beziehung **eigene Daten**, wird sie oft zu einer '
      'eigenen Klasse. Typische Beispiele sind Ausleihe, Buchung, Bestellung '
      'und Termin.',
    ),
    UmlBlock(_ausleihe, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-6',
      frage: 'Im Diagramm: Wie viele Medien gehören zu **einer** Ausleihe?',
      optionen: ['Keins oder eins', 'Genau eins', 'Beliebig viele',
          'Zwei oder mehr'],
      richtig: 1,
      erklaerung: 'An der Klasse Medium steht eine 1. Von der Ausleihe aus '
          'gelesen: Eine Ausleihe gilt für genau ein Medium.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-7',
      frage: 'Ein Arzt hat viele Patienten, ein Patient war bei vielen Ärzten. '
          'Zu jedem Besuch sollen Datum und Befund gespeichert werden. Was '
          'ist die beste Lösung?',
      optionen: [
        'Datum und Befund als Attribute in die Klasse Patient',
        'Eine eigene Klasse Behandlung zwischen Arzt und Patient',
        'Datum und Befund als Rollennamen an die Linie',
        'Eine Multiplizität 2..4',
      ],
      richtig: 1,
      erklaerung: 'Datum und Befund gehören zu jedem einzelnen Besuch. Also '
          'bekommt der Besuch eine eigene Klasse, zum Beispiel Behandlung, mit '
          'einer Linie zum Arzt und einer zum Patienten.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 5'),
    HinweisBlock(
      '- **Assoziation**: durchgezogene Linie, die Klassen kennen sich.\n'
      '- **Multiplizität** an jedem Ende: 1, 0..1, *, 1..*, 2..4.\n'
      '- Die Zahl steht an der Klasse, deren Anzahl sie beschreibt. Satzprobe: '
      '„Ein A hat [Zahl bei B] B.“\n'
      '- **Rollenname** am Linienende, **Name** der Beziehung in der Mitte.\n'
      '- Offene **Pfeilspitze**: nur in diese Richtung navigierbar.\n'
      '- Beziehung mit eigenen Daten: eigene Klasse in der Mitte.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-5-8',
      frage: 'Text: „Jede Bestellung gehört zu genau einem Kunden. Ein Kunde '
          'kann beliebig viele Bestellungen aufgeben.“ Was ist richtig?',
      optionen: [
        '1 an Bestellung, * an Kunde',
        '* an Bestellung, 1 an Kunde',
        '1 an beiden Enden',
        '* an beiden Enden',
      ],
      richtig: 1,
      erklaerung: '„Ein Kunde hat beliebig viele Bestellungen“: Der Stern steht '
          'an der Bestellung. „Eine Bestellung gehört zu genau einem Kunden“: '
          'Die 1 steht am Kunden.',
    )),
  ],
);
