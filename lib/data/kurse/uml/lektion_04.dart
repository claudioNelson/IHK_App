// lib/data/kurse/uml/lektion_04.dart
//
// UML-Kurs der App, Lektion 4: Klassen und Objekte (Klassendiagramm I).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _objekte = UmlDiagramm(
  breite: 470,
  hoehe: 110,
  beschreibung: 'Zwei Objekte der Klasse Lastenrad: rad7 und rad12 mit eigenen Werten.',
  elemente: [
    UmlKlasse(x: 10, y: 8, b: 210, name: 'rad7 : Lastenrad', attribute: ['radNr = 7', 'modell = "Cargo L"', 'preisProStunde = 4.5'], objekt: true),
    UmlKlasse(x: 250, y: 8, b: 210, name: 'rad12 : Lastenrad', attribute: ['radNr = 12', 'modell = "Cargo S"', 'preisProStunde = 3.0'], objekt: true),
  ],
);

const _einfach = UmlDiagramm(
  breite: 450,
  hoehe: 145,
  beschreibung: 'Klasse Lastenrad mit drei Fächern: Name, Attribute radNr, modell, preisProStunde und Methode istVerfuegbar().',
  elemente: [
    UmlKlasse(x: 10, y: 8, b: 180, name: 'Lastenrad', attribute: ['radNr', 'modell', 'preisProStunde'], methoden: ['istVerfuegbar()']),
    UmlText(x: 205, y: 16, text: '1. Name der Klasse'),
    UmlText(x: 205, y: 62, text: '2. Attribute: was es speichert'),
    UmlText(x: 205, y: 108, text: '3. Methoden: was es kann'),
  ],
);

const _voll = UmlDiagramm(
  breite: 300,
  hoehe: 170,
  beschreibung: 'Klasse Lastenrad mit Sichtbarkeit und Datentypen.',
  elemente: [
    UmlKlasse(x: 10, y: 6, b: 280, name: 'Lastenrad', attribute: ['- radNr: int', '- modell: String', '- preisProStunde: double', '- verfuegbar: boolean'], methoden: ['+ istVerfuegbar(): boolean', '+ berechnePreis(stunden: int): double']),
  ],
);

const _kunde = UmlDiagramm(
  breite: 290,
  hoehe: 140,
  beschreibung: 'Klasse Kunde mit drei privaten Attributen und einer öffentlichen Methode.',
  elemente: [
    UmlKlasse(x: 10, y: 6, b: 270, name: 'Kunde', attribute: ['- kundenNr: int', '- name: String', '- email: String'], methoden: ['+ aendereEmail(neu: String): void']),
  ],
);
const umlLektion4 = Lektion(
  nr: 4,
  slug: 'uml-4-klassen',
  titel: 'Klassen und Objekte',
  kurzbeschreibung:
      'Was eine Klasse ist, was ein Objekt ist, und wie du eine Klasse mit '
      'Attributen, Methoden, Datentypen und Sichtbarkeit aufschreibst.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Ausstecher ──────────────────────────────────────────────
    UeberschriftBlock('Ausstecher und Plätzchen'),
    TextBlock(
      'Zu Weihnachten backst du Plätzchen. Mit **einem** Ausstecher in '
      'Sternform stichst du **viele** Sterne aus. Alle haben dieselbe Form. '
      'Trotzdem ist jeder Stern ein eigenes Plätzchen: Einer hat rote '
      'Streusel, einer grüne, einer ist etwas dunkler geworden.\n'
      '\n'
      'In der Programmierung heißt der Ausstecher **Klasse** und jedes '
      'Plätzchen **Objekt**.\n'
      '- Die **Klasse** ist der Bauplan. Sie legt fest, welche Eigenschaften '
      'jedes Objekt hat.\n'
      '- Ein **Objekt** ist ein einzelnes Ding nach diesem Bauplan, mit '
      'eigenen Werten.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-1',
      frage: 'Ein Autohaus hat drei Autos auf dem Hof: einen roten Kombi, '
          'einen blauen Kleinwagen und einen schwarzen Transporter. Was ist '
          'hier die Klasse?',
      optionen: [
        'Der rote Kombi',
        'Auto',
        'Die drei Autos zusammen',
        'Rot, blau und schwarz',
      ],
      richtig: 1,
      erklaerung: '„Auto“ ist der Bauplan: Jedes Auto hat eine Farbe, eine '
          'Bauart und so weiter. Die drei einzelnen Autos auf dem Hof sind '
          'Objekte dieser Klasse. Rot, blau und schwarz sind Werte.',
    )),

    // ── Seite: Objekte im Verleih ──────────────────────────────────────
    UeberschriftBlock('Objekte im Lastenrad-Verleih'),
    TextBlock(
      'Der Verleih hat viele Lastenräder. Jedes hat eine Nummer, ein Modell '
      'und einen Preis pro Stunde. Zwei davon sehen in UML so aus:',
    ),
    UmlBlock(
      _objekte,
      unterschrift: 'Zwei Objekte. Oben steht unterstrichen: Name des Objekts, '
          'Doppelpunkt, Name der Klasse.',
    ),
    TextBlock(
      'Beide sind Lastenräder, also Objekte derselben Klasse `Lastenrad`. '
      'Beide haben eine Nummer, ein Modell und einen Preis. Aber jedes hat '
      '**eigene Werte**: `rad7` kostet 4,50 Euro pro Stunde, `rad12` nur 3 '
      'Euro.\n'
      '\n'
      'Im Code schreibt man Kommazahlen mit Punkt, deshalb steht dort `4.5`. '
      'Texte stehen in geraden Anführungszeichen, zum Beispiel `"Cargo L"`.\n'
      '\n'
      'Solche Objekte zeichnet man selten. In der Prüfung geht es fast immer '
      'um die **Klasse**, also den Bauplan.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-2',
      frage: 'Woran erkennst du im Diagramm, dass `rad7 : Lastenrad` ein '
          'Objekt ist und keine Klasse?',
      optionen: [
        'Der Kopf ist unterstrichen und nennt Objekt und Klasse.',
        'Das Kästchen ist kleiner.',
        'Es hat keine Werte.',
        'Der Name ist fett gedruckt.',
      ],
      richtig: 0,
      erklaerung: 'Bei einem Objekt ist der Kopf unterstrichen, und es steht '
          '`objektname : Klassenname` darin. Darunter stehen die konkreten '
          'Werte.',
    )),

    // ── Seite: Drei Fächer ─────────────────────────────────────────────
    UeberschriftBlock('Eine Klasse hat drei Fächer'),
    TextBlock(
      'Eine Klasse wird als Rechteck mit drei Fächern gezeichnet, von oben '
      'nach unten:',
    ),
    UmlBlock(
      _einfach,
      unterschrift: 'Name, Attribute, Methoden: immer in dieser Reihenfolge.',
    ),
    TextBlock(
      '- Oben steht der **Name** der Klasse. Er beginnt mit einem '
      'Großbuchstaben und steht in der Einzahl: `Lastenrad`, nicht '
      '`Lastenräder`. Denn die Klasse beschreibt, wie **ein** Rad aussieht.\n'
      '- In der Mitte stehen die **Attribute**. Das sind die Eigenschaften, '
      'die jedes Objekt speichert, hier Nummer, Modell und Preis.\n'
      '- Unten stehen die **Methoden**. Das ist das, was ein Objekt **kann**. '
      'Hier kann jedes Rad sagen, ob es gerade frei ist. Methoden erkennst du '
      'an den runden Klammern.\n'
      '\n'
      'Attribute und Methoden schreibt man klein. Besteht ein Name aus '
      'mehreren Wörtern, schreibt man sie ohne Leerzeichen zusammen und jedes '
      'weitere Wort groß: `preisProStunde`. Weil die Großbuchstaben wie '
      'Höcker aussehen, heißt das **camelCase** (Kamelschreibweise).',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-3',
      frage: 'Eine Klasse `Konto` soll speichern, wie viel Geld darauf ist, '
          'und man soll Geld einzahlen können. Wohin gehört `einzahlen()`?',
      optionen: [
        'In den Namen der Klasse',
        'Ins Attributfach, weil es mit Geld zu tun hat',
        'Ins Methodenfach, weil das Konto es kann',
        'Gar nicht in die Klasse',
      ],
      richtig: 2,
      erklaerung: 'Einzahlen ist etwas, das das Konto kann, also eine '
          'Methode. Der Kontostand dagegen wird gespeichert und ist ein '
          'Attribut.',
    )),

    // ── Seite: Datentypen ──────────────────────────────────────────────
    UeberschriftBlock('Datentypen: welche Art Wert?'),
    TextBlock(
      'In der Prüfung schreibst du hinter jedes Attribut, **welche Art Wert** '
      'es speichert. Das heißt **Datentyp**. Er steht nach einem '
      'Doppelpunkt: `radNr: int`.\n'
      '\n'
      'Denk an ein Formular: Beim Feld „Alter“ darfst du nur eine Zahl '
      'eintragen, beim Feld „Name“ Buchstaben. Der Datentyp legt genau das '
      'fest. Diese fünf reichen für fast jede Prüfung:',
    ),
    SchreibtischtestBlock(
      spalten: ['Datentyp', 'Speichert', 'Beispiel'],
      zeilen: [
        ['int', 'ganze Zahl', 'radNr, anzahl'],
        ['double', 'Kommazahl', 'preis, gewicht'],
        ['boolean', 'wahr oder falsch', 'verfuegbar, bezahlt'],
        ['String', 'Text', 'name, email'],
        ['Date', 'Datum', 'geburtsdatum, beginn'],
      ],
      aenderungenMarkieren: false,
    ),
    HinweisBlock(
      'Eine Postleitzahl oder Telefonnummer ist ein **String**, keine Zahl. '
      'Man rechnet nicht mit ihr, und führende Nullen wie in 01067 würden '
      'sonst verloren gehen.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-4-4',
      frage: 'Welcher Datentyp passt jeweils?',
      vorlage: 'preisProStunde: ___ und verfuegbar: ___',
      loesungen: [
        ['double'],
        ['boolean'],
      ],
      bausteine: ['double', 'boolean', 'int', 'String'],
      erklaerung: 'Ein Preis hat Nachkommastellen, also double. „Verfügbar“ '
          'ist entweder wahr oder falsch, also boolean.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-5',
      frage: 'Welcher Datentyp passt für die Postleitzahl `plz`?',
      optionen: ['int', 'double', 'boolean', 'String'],
      richtig: 3,
      erklaerung: 'Mit einer Postleitzahl rechnet man nicht, und die führende '
          'Null in 01067 muss erhalten bleiben. Deshalb String.',
    )),

    // ── Seite: Methoden ────────────────────────────────────────────────
    UeberschriftBlock('Methoden genau aufschreiben'),
    TextBlock(
      'Eine Methode kann etwas **mitbekommen** und etwas **zurückgeben**. '
      'Denk an einen Getränkeautomaten: Du gibst Geld hinein, heraus kommt '
      'eine Flasche.\n'
      '\n'
      'Die Methode `berechnePreis` bekommt die Anzahl der Stunden und gibt '
      'den Preis zurück. In UML sieht das so aus:',
    ),
    CodeBlock(
      'berechnePreis(stunden: int): double',
      sprache: 'text',
    ),
    TextBlock(
      '- In den Klammern steht, was die Methode mitbekommt. Das heißt '
      '**Parameter**: Name, Doppelpunkt, Datentyp. Mehrere Parameter trennst '
      'du mit Komma.\n'
      '- Nach den Klammern kommt ein Doppelpunkt und der Datentyp dessen, was '
      'zurückkommt. Das heißt **Rückgabetyp**.\n'
      '- Gibt eine Methode nichts zurück, ist der Rückgabetyp `void` '
      '(englisch für „leer“).\n'
      '- Bekommt sie nichts mit, bleiben die Klammern leer, fehlen aber '
      'nie: `stornieren(): void`.',
    ),
    AufgabenBlock(FehlerAufgabe(
      id: 'uml-4-6',
      frage: 'Ein Azubi hat die Klasse `Lastenrad` als Text aufgeschrieben. '
          'Eine Zeile ist falsch. Tipp sie an und korrigiere sie.',
      zeilen: [
        'Lastenrad',
        '- radNr: int',
        '- modell: String',
        '+ istVerfuegbar: boolean',
      ],
      fehlerZeile: 3,
      korrekturen: [
        '+ istVerfuegbar(): boolean',
        '+istVerfuegbar(): boolean',
      ],
      tipp: 'Woran erkennt man eine Methode?',
      erklaerung: 'Eine Methode hat immer runde Klammern, auch wenn sie nichts '
          'mitbekommt: `+ istVerfuegbar(): boolean`.',
    )),

    // ── Seite: Sichtbarkeit ────────────────────────────────────────────
    UeberschriftBlock('Sichtbarkeit: wer darf ran?'),
    TextBlock(
      'Dein Kontostand ist in der Bank gespeichert. Du kannst ihn nicht '
      'einfach selbst von 50 auf 5000 Euro ändern. Du kannst aber einzahlen, '
      'abheben oder überweisen, und die Bank prüft dabei, ob alles '
      'stimmt.\n'
      '\n'
      'Genauso ist es in einer Klasse. Vor jedem Attribut und jeder Methode '
      'steht ein Zeichen. Es sagt, wer darauf zugreifen darf. Das nennt man '
      '**Sichtbarkeit**:',
    ),
    SchreibtischtestBlock(
      spalten: ['Zeichen', 'Name', 'Wer darf zugreifen?'],
      zeilen: [
        ['+', 'public (öffentlich)', 'alle'],
        ['-', 'private (privat)', 'nur die eigene Klasse'],
        ['#', 'protected (geschützt)',
            'die Klasse und ihre Unterklassen (Lektion 6)'],
        ['~', 'package (Paket)',
            'Klassen im selben Paket, also derselben Gruppe von Klassen; '
                'selten'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Eine **Unterklasse** ist eine Klasse, die alles von einer anderen '
      'Klasse übernimmt und noch etwas dazu hat. Genauer lernst du sie in '
      'Lektion 6 kennen. Für die Prüfung reicht '
      'meist eine Faustregel: **Attribute privat, Methoden öffentlich.** '
      'Die Daten sind geschützt, und nur über die Methoden kommt man heran. '
      'Das nennt man **Datenkapselung**.',
    ),
    UmlBlock(
      _voll,
      unterschrift: 'Die vollständige Klasse: Attribute privat mit Datentyp, '
          'Methoden öffentlich mit Parametern und Rückgabetyp.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-7',
      frage: 'Welches Zeichen steht vor einem Attribut, auf das nur die '
          'eigene Klasse zugreifen darf?',
      optionen: ['+', '#', '-', '~'],
      richtig: 2,
      erklaerung: 'Das Minus steht für private: nur die eigene Klasse. Das '
          'Plus heißt public, die Raute protected, die Tilde package.',
    )),

    // ── Seite: Klasse lesen ────────────────────────────────────────────
    UeberschriftBlock('Eine Klasse lesen'),
    UmlBlock(_kunde, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-8',
      frage: 'Was sagt dir die Zeile `+ aendereEmail(neu: String): void`?',
      optionen: [
        'Ein privates Attribut für die neue E-Mail-Adresse',
        'Eine öffentliche Methode, die einen Text bekommt und nichts '
            'zurückgibt',
        'Eine öffentliche Methode, die einen Text zurückgibt',
        'Eine private Methode ohne Parameter',
      ],
      richtig: 1,
      erklaerung: 'Das Plus heißt öffentlich, die Klammern zeigen eine '
          'Methode. Sie bekommt den Parameter `neu` vom Typ String und gibt '
          'nichts zurück, denn der Rückgabetyp ist void.',
    )),

    // ── Seite: Aus dem Text ────────────────────────────────────────────
    UeberschriftBlock('Klassen im Aufgabentext finden'),
    TextBlock(
      'In der Prüfung steht ein Text, zum Beispiel: „Die Stadtbibliothek '
      'verwaltet **Leser** mit Name und Ausweisnummer. Jedes **Medium** hat '
      'einen Titel und eine Signatur. Man soll prüfen können, ob ein Medium '
      'ausgeliehen ist.“\n'
      '\n'
      'So gehst du vor:\n'
      '- **Klassen** sind die Nomen, die eigene Daten haben und mehrfach '
      'vorkommen: Leser, Medium.\n'
      '- **Attribute** sind Nomen, die nur eine Eigenschaft beschreiben: '
      'Name, Ausweisnummer, Titel, Signatur.\n'
      '- **Methoden** kommen aus Verben, die eine Fähigkeit beschreiben: '
      '„prüfen, ob ausgeliehen“ wird `istAusgeliehen(): boolean` im Medium.\n'
      '- Das Programm selbst („Stadtbibliothek“) wird meistens **keine** '
      'Klasse. Nur wenn die Aufgabe ausdrücklich Beziehungen zu ihm verlangt, '
      'bekommt es eine eigene Klasse.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-9',
      frage: 'Text: „Ein Hotel verwaltet Zimmer mit Zimmernummer und Preis pro '
          'Nacht.“ Was wird eine Klasse?',
      optionen: ['Zimmernummer', 'Hotel', 'Zimmer', 'Preis pro Nacht'],
      richtig: 2,
      erklaerung: 'Zimmer gibt es viele, und jedes hat eigene Daten. '
          'Zimmernummer und Preis pro Nacht sind nur Eigenschaften, also '
          'Attribute. Das Hotel ist hier das Programm selbst.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-4-10',
      frage: 'Schreib das Attribut für die Zimmernummer vollständig auf: '
          'privat, Name `zimmerNr`, ganze Zahl.',
      vorlage: '___ zimmerNr: ___',
      loesungen: [
        ['-'],
        ['int'],
      ],
      bausteine: ['-', '+', 'int', 'String'],
      erklaerung: 'Attribute sind privat, also Minus. Eine Zimmernummer wie '
          '12 ist eine ganze Zahl: `- zimmerNr: int`.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 4'),
    HinweisBlock(
      '- **Klasse** = Bauplan, **Objekt** = einzelnes Ding mit eigenen '
      'Werten.\n'
      '- Drei Fächer: Name (groß, Einzahl), Attribute, Methoden.\n'
      '- Attribut: `- name: Typ`. Methode: `+ name(parameter: Typ): '
      'Rückgabetyp`.\n'
      '- Datentypen: int, double, boolean, String, Date. Nichts zurück: '
      'void.\n'
      '- Sichtbarkeit: + public, - private, # protected, ~ package. '
      'Faustregel: Attribute privat, Methoden öffentlich.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-4-11',
      frage: 'Welche Zeile ist korrekt aufgeschrieben?',
      optionen: [
        '+ Preis: double',
        '- preis: double',
        '- preis double',
        'preis(): -double',
      ],
      richtig: 1,
      erklaerung: 'Ein Attribut: Sichtbarkeit, Name klein, Doppelpunkt, '
          'Datentyp. Also `- preis: double`.',
    )),
  ],
);
