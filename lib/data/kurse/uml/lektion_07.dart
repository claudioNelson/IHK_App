// lib/data/kurse/uml/lektion_07.dart
//
// UML-Kurs der App, Lektion 7: Vom Klassendiagramm zum Code (Java).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _rad = UmlDiagramm(
  breite: 330,
  hoehe: 120,
  beschreibung: 'Klasse Lastenrad mit radNr, preisProStunde und berechnePreis.',
  elemente: [
    UmlKlasse(x: 10, y: 6, b: 310, name: 'Lastenrad', attribute: ['- radNr: int', '- preisProStunde: double'], methoden: ['+ berechnePreis(stunden: int): double']),
  ],
);

const _buchungRad = UmlDiagramm(
  breite: 480,
  hoehe: 80,
  beschreibung: 'Buchung zeigt auf Lastenrad, Rolle rad, Multiplizität 1.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Buchung'),
    UmlKlasse(x: 340, y: 25, b: 120, name: 'Lastenrad'),
    UmlKante(punkte: [Offset(140, 40), Offset(340, 40)], art: UmlKantenArt.gerichtet, von: '*', nach: '1', rolleNach: 'rad'),
  ],
);

const _kundeBuchungen = UmlDiagramm(
  breite: 480,
  hoehe: 80,
  beschreibung: 'Kunde zeigt auf Buchung, Rolle buchungen, Multiplizität *.',
  elemente: [
    UmlKlasse(x: 20, y: 25, b: 120, name: 'Kunde'),
    UmlKlasse(x: 340, y: 25, b: 120, name: 'Buchung'),
    UmlKante(punkte: [Offset(140, 40), Offset(340, 40)], art: UmlKantenArt.gerichtet, von: '1', nach: '*', rolleNach: 'buchungen'),
  ],
);

const _erbe = UmlDiagramm(
  breite: 490,
  hoehe: 260,
  beschreibung: 'Buch erbt von der abstrakten Klasse Medium und realisiert das Interface Verlaengerbar.',
  elemente: [
    UmlKlasse(x: 10, y: 10, b: 190, name: 'Medium', attribute: ['# titel: String'], abstrakt: true),
    UmlKlasse(x: 290, y: 10, b: 190, name: 'Verlaengerbar', methoden: ['+ verlaengern(): void'], stereotyp: '«interface»'),
    UmlKlasse(x: 150, y: 150, b: 190, name: 'Buch', attribute: ['- isbn: String'], methoden: ['+ verlaengern(): void']),
    UmlKante(punkte: [Offset(215, 150), Offset(215, 115), Offset(105, 115), Offset(105, 82)], art: UmlKantenArt.vererbung),
    UmlKante(punkte: [Offset(275, 150), Offset(275, 115), Offset(385, 115), Offset(385, 82)], art: UmlKantenArt.realisierung),
  ],
);
const umlLektion7 = Lektion(
  nr: 7,
  slug: 'uml-7-code',
  titel: 'Vom Klassendiagramm zum Code',
  kurzbeschreibung:
      'Wie aus Kästen und Linien Programmcode wird und umgekehrt: Attribute, '
      'Methoden, Beziehungen und Vererbung in Java.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Warum ───────────────────────────────────────────────────
    UeberschriftBlock('Der Plan wird zum Programm'),
    TextBlock(
      'Das Klassendiagramm ist der Bauplan. Irgendwann wird daraus echter '
      'Programmcode. In der Prüfung kommt das in zwei Richtungen vor:\n'
      '- „Setzen Sie die Klasse … in Code um.“\n'
      '- „Erstellen Sie aus dem folgenden Code das Klassendiagramm.“\n'
      '\n'
      'Meist wird dafür **Java** verwendet oder ein Pseudocode, der so '
      'ähnlich aussieht. Du musst dafür nicht programmieren können. Es reicht, '
      'die Übersetzung Zeile für Zeile zu kennen. Genau die lernst du hier.',
    ),

    // ── Seite: Eine Klasse ─────────────────────────────────────────────
    UeberschriftBlock('Eine Klasse in Java'),
    TextBlock('Aus dieser Klasse …'),
    UmlBlock(_rad),
    TextBlock('… wird dieser Code:'),
    CodeBlock(
      'public class Lastenrad {\n'
      '    private int radNr;\n'
      '    private double preisProStunde;\n'
      '\n'
      '    public double berechnePreis(int stunden) {\n'
      '        return preisProStunde * stunden;\n'
      '    }\n'
      '}',
      titel: 'Lastenrad.java',
      sprache: 'java',
    ),
    TextBlock(
      'Das fällt auf:\n'
      '- `class Lastenrad { … }`: Alles, was zur Klasse gehört, steht '
      'zwischen den geschweiften Klammern.\n'
      '- Aus `-` wird das Wort `private`, aus `+` wird `public`, aus `#` '
      'wird `protected`.\n'
      '- **Der Datentyp steht vorne.** In UML heißt es `radNr: int`, in Java '
      '`int radNr`. Das ist der häufigste Stolperstein.\n'
      '- Jede Attributzeile endet mit einem Semikolon `;`.\n'
      '- Bei der Methode steht der Rückgabetyp, also der Datentyp des '
      'Ergebnisses, ebenfalls vorne: '
      '`double berechnePreis(int stunden)`. Was die Methode tut, steht in '
      'ihren eigenen geschweiften Klammern. Das zeigt das Diagramm nicht.',
    ),
    UmlBlock(_rad, zurAufgabe: true),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-7-1',
      frage: 'Übersetze `- preisProStunde: double` nach Java.',
      vorlage: '___ ___ preisProStunde;',
      loesungen: [
        ['private'],
        ['double'],
      ],
      bausteine: ['private', 'public', 'double', 'int'],
      erklaerung: 'Minus wird private, und der Datentyp steht in Java vor dem '
          'Namen: `private double preisProStunde;`.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-2',
      frage: 'Welche Java-Zeile passt zu `+ istVerfuegbar(): boolean`?',
      optionen: [
        'public istVerfuegbar(): boolean',
        'private boolean istVerfuegbar()',
        'public boolean istVerfuegbar()',
        'public void istVerfuegbar(boolean)',
      ],
      richtig: 2,
      erklaerung: 'Plus wird public, der Rückgabetyp boolean steht vor dem '
          'Namen, die leeren Klammern bleiben: `public boolean '
          'istVerfuegbar()`.',
    )),
    AufgabenBlock(FehlerAufgabe(
      id: 'uml-7-3',
      frage: 'Laut Diagramm gilt `- radNr: int`. Eine Zeile im Code passt '
          'nicht dazu. Tipp sie an und korrigiere sie.',
      zeilen: [
        'public class Lastenrad {',
        '    public int radNr;',
        '    private double preisProStunde;',
        '}',
      ],
      fehlerZeile: 1,
      korrekturen: ['private int radNr;'],
      tipp: 'Achte auf das Zeichen vor radNr im Diagramm.',
      erklaerung: 'Das Minus steht für private. Richtig ist '
          '`private int radNr;`.',
    )),

    // ── Seite: void und Parameter ──────────────────────────────────────
    UeberschriftBlock('Parameter und void'),
    TextBlock(
      'Mehrere Parameter werden auch in Java mit Komma getrennt, und auch '
      'hier steht bei jedem der Typ vorne:',
    ),
    CodeBlock(
      'UML:  + verschieben(tage: int, grund: String): void\n'
      'Java: public void verschieben(int tage, String grund)',
      sprache: 'java',
    ),
    TextBlock(
      '`void` bleibt `void`: Die Methode gibt nichts zurück.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-4',
      frage: 'Zu welcher UML-Zeile gehört '
          '`public void aendereEmail(String neu)`?',
      optionen: [
        '- aendereEmail(neu: String): void',
        '+ aendereEmail(neu: String): void',
        '+ aendereEmail(): String',
        '+ neu: String',
      ],
      richtig: 1,
      erklaerung: 'public wird Plus. Der Parameter heißt neu und hat den Typ '
          'String. Der Rückgabetyp void kommt in UML ans Ende.',
    )),

    // ── Seite: Beziehungen ─────────────────────────────────────────────
    UeberschriftBlock('Aus Linien werden Attribute'),
    TextBlock(
      'Eine Linie im Diagramm heißt: Die eine Klasse kennt die andere. Im '
      'Code merkt sie sich die andere Klasse in einem **Attribut**.',
    ),
    UmlBlock(
      _buchungRad,
      unterschrift: 'Die Buchung kennt genau ein Lastenrad, Rolle „rad“.',
    ),
    CodeBlock(
      'public class Buchung {\n'
      '    private Lastenrad rad;\n'
      '}',
      sprache: 'java',
    ),
    TextBlock(
      'Der **Rollenname** `rad` wird zum Namen des Attributs. Der Datentyp '
      'ist die andere Klasse, `Lastenrad`. Das Attribut steht in der Klasse, '
      'bei der der Pfeil beginnt, nicht bei der Spitze.\n'
      '\n'
      'Und wenn es **viele** sind? Ein Kunde hat beliebig viele Buchungen:',
    ),
    UmlBlock(
      _kundeBuchungen,
      unterschrift: 'Ein Kunde kennt beliebig viele Buchungen, Rolle '
          '„buchungen“.',
    ),
    CodeBlock(
      'public class Kunde {\n'
      '    private List<Buchung> buchungen;\n'
      '}',
      sprache: 'java',
    ),
    TextBlock(
      'Bei `*` oder `1..*` braucht man eine **Liste**. `List<Buchung>` liest '
      'du als „Liste von Buchungen“. In spitzen Klammern steht, was in der '
      'Liste liegt. Bei `1` oder `0..1` reicht ein einfaches Attribut.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-5',
      frage: 'Eine Station kennt ihre Lastenräder, Multiplizität `1..*`, '
          'Rolle `raeder`. Welche Zeile gehört in die Klasse `Station`?',
      optionen: [
        'private Lastenrad raeder;',
        'private List<Lastenrad> raeder;',
        'private List<Station> raeder;',
        'private int raeder;',
      ],
      richtig: 1,
      erklaerung: 'Mindestens eins, also mehrere: Dafür braucht es eine Liste '
          'von Lastenrädern. Der Rollenname wird der Attributname.',
    )),

    // ── Seite: Vererbung ───────────────────────────────────────────────
    UeberschriftBlock('Vererbung und Interfaces im Code'),
    UmlBlock(
      _erbe,
      unterschrift: 'Buch erbt von Medium und setzt das Interface '
          'Verlaengerbar um.',
    ),
    CodeBlock(
      'public abstract class Medium {\n'
      '    protected String titel;\n'
      '}\n'
      '\n'
      'public interface Verlaengerbar {\n'
      '    void verlaengern();\n'
      '}\n'
      '\n'
      'public class Buch extends Medium implements Verlaengerbar {\n'
      '    private String isbn;\n'
      '\n'
      '    public void verlaengern() {\n'
      '        // um zwei Wochen verlängern\n'
      '    }\n'
      '}',
      sprache: 'java',
    ),
    TextBlock(
      'Drei Wörter musst du dir merken:\n'
      '- `extends` („erweitert“): Vererbung, durchgezogene Linie mit '
      'Dreieck. In Java erbt eine Klasse von höchstens **einer** Oberklasse.\n'
      '- `implements` („setzt um“): Realisierung, gestrichelte Linie mit '
      'Dreieck. Interfaces darf eine Klasse beliebig viele umsetzen.\n'
      '- `abstract`: abstrakte Klasse, im Diagramm kursiv mit {abstract}.\n'
      '\n'
      'Die Zeile mit `//` ist ein **Kommentar**, also eine Notiz für '
      'Menschen. Das Programm beachtet sie nicht.\n'
      '\n'
      'Und Aggregation und Komposition? Die siehst du im Code nicht. Beide '
      'werden wie eine normale Linie zu einem Attribut mit dem Typ der '
      'anderen Klasse. Der Unterschied liegt nur in der Bedeutung.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-6',
      frage: 'Im Diagramm führt eine gestrichelte Linie mit hohlem Dreieck '
          'von `Drucker` zum «interface» `Druckbar`. Welche Zeile passt?',
      optionen: [
        'public class Drucker extends Druckbar',
        'public class Drucker implements Druckbar',
        'public class Druckbar implements Drucker',
        'public abstract class Drucker',
      ],
      richtig: 1,
      erklaerung: 'Gestrichelt mit Dreieck ist eine Realisierung. Die Klasse '
          'Drucker setzt das Interface um: `implements Druckbar`.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-7-7',
      frage: '`Pkw` erbt von `Fahrzeug`. Ergänze die erste Zeile der Klasse.',
      vorlage: 'public class Pkw ___ Fahrzeug {',
      loesungen: [
        ['extends'],
      ],
      bausteine: ['extends', 'implements', 'abstract'],
      erklaerung: 'Vererbung heißt in Java extends.',
    )),

    // ── Seite: Rückwärts ───────────────────────────────────────────────
    UeberschriftBlock('Rückwärts: vom Code zum Diagramm'),
    TextBlock(
      'Genauso gut kann die Prüfung Code zeigen, und du zeichnest das '
      'Diagramm. Dann gehst du den Weg einfach rückwärts:\n'
      '- `class Name` wird der Klassenname.\n'
      '- Jede Zeile `private Typ name;` wird `- name: Typ`.\n'
      '- Steht als Typ eine andere Klasse **aus dem Diagramm**, zeichnest du '
      'eine Linie statt eines Attributs. Bei `List<…>` kommt `*` an das '
      'Ende.\n'
      '- Eingebaute Typen wie `String`, `int`, `double`, `boolean` und `Date` '
      'bleiben normale Attribute, auch wenn `Date` wie eine Klasse '
      'aussieht.\n'
      '- `extends` wird Dreieck, `implements` gestricheltes Dreieck.',
    ),
    CodeBlock(
      'public class Termin {\n'
      '    private Date datum;\n'
      '    protected String raum;\n'
      '    private Patient patient;\n'
      '}',
      sprache: 'java',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-8',
      frage: 'Wie schreibst du `protected String raum;` in UML?',
      optionen: [
        '+ raum: String',
        '# String raum',
        '# raum: String',
        '~ raum: String',
      ],
      richtig: 2,
      erklaerung: 'protected wird die Raute. In UML steht erst der Name, dann '
          'Doppelpunkt und Datentyp: `# raum: String`.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-7-9',
      frage: 'Was wird im Diagramm aus der Zeile `private Patient patient;`?',
      optionen: [
        'Ein Attribut `- patient: String`',
        'Eine Linie von Termin zu Patient mit Multiplizität 1 oder 0..1 und '
            'Rolle patient',
        'Eine Vererbung: Termin erbt von Patient',
        'Eine Methode `patient()`',
      ],
      richtig: 1,
      erklaerung: 'Der Datentyp ist eine andere Klasse. Also zeichnest du eine '
          'Linie zu Patient. Es ist kein List, deshalb höchstens ein Patient '
          'je Termin. Der Attributname wird zum Rollennamen.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 7'),
    HinweisBlock(
      '- `-` wird private, `+` public, `#` protected.\n'
      '- UML `name: Typ`, Java `Typ name`. Der Typ wandert nach vorne.\n'
      '- Methode: `+ m(p: int): double` wird `public double m(int p)`.\n'
      '- Linie zu einer anderen Klasse: Attribut mit Rollenname. Bei `*`: '
      '`List<Klasse>`.\n'
      '- Vererbung `extends`, Interface `implements`, abstrakte Klasse '
      '`abstract`.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'uml-7-10',
      frage: 'Bring den Code für `Kunde` mit `- name: String` und '
          '`+ getName(): String` in die Reihenfolge, in der man ihn '
          'üblicherweise schreibt: erst Attribute, dann Methoden.',
      zeilen: [
        'public class Kunde {',
        'private String name;',
        'public String getName() {',
        'return name;',
        '} // Ende der Methode',
        '} // Ende der Klasse',
      ],
      einrueckung: [0, 1, 1, 2, 1, 0],
      erklaerung: 'Erst der Klassenkopf, dann das Attribut, dann die Methode '
          'mit ihrem Inhalt. Zum Schluss werden Methode und Klasse mit je '
          'einer geschweiften Klammer geschlossen.',
    )),
  ],
);
