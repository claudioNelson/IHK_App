// lib/data/kurse/uml/lektion_11.dart
//
// UML-Kurs der App, Lektion 11: Prüfungstraining mit einem durchgehenden
// Fall (Kino-App) über alle fünf Diagrammarten.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _kinoUC = UmlDiagramm(
  breite: 650,
  hoehe: 300,
  beschreibung: 'Musterlösung Use-Case-Diagramm Kino-App: Besucher reserviert Plätze und storniert, Plätze reservieren bindet Anmelden ein, Snacks vorbestellen erweitert Plätze reservieren, Mitarbeiter legt Vorstellungen an. Eine Notiz nennt die Bedingung für extend.',
  elemente: [
    UmlRahmen(x: 120, y: 10, b: 400, h: 280, titel: 'Kino-App'),
    UmlUseCase(cx: 250, cy: 70, rx: 82, text: 'Plätze reservieren'),
    UmlUseCase(cx: 460, cy: 70, rx: 52, text: 'Anmelden'),
    UmlUseCase(cx: 250, cy: 160, rx: 86, text: 'Snacks vorbestellen'),
    UmlUseCase(cx: 250, cy: 245, rx: 100, text: 'Reservierung stornieren'),
    UmlUseCase(cx: 440, cy: 240, rx: 72, text: 'Vorstellung anlegen'),
    UmlAkteur(x: 50, y: 120, name: 'Besucher'),
    UmlAkteur(x: 590, y: 214, name: 'Mitarbeiter'),
    UmlKante(punkte: [Offset(66, 146), Offset(202.6, 89.6)]),
    UmlKante(punkte: [Offset(66, 146), Offset(209.3, 223.1)]),
    UmlKante(punkte: [Offset(574, 240), Offset(512, 240)]),
    UmlKante(punkte: [Offset(332, 70), Offset(408, 70)], art: UmlKantenArt.abhaengigkeit, name: '«include»'),
    UmlKante(punkte: [Offset(250, 136), Offset(250, 94)], art: UmlKantenArt.abhaengigkeit, name: '«extend»'),
    UmlNotiz(x: 352, y: 112, b: 150, text: 'Bedingung:\nBesucher wünscht\nSnacks', anker: Offset(250, 128), ankerVon: Offset(352, 140)),
  ],
);

const _kinoFehler = UmlDiagramm(
  breite: 620,
  hoehe: 180,
  beschreibung: 'Klassendiagramm mit den Klassen Vorstellung, Saal, Sitzplatz und Reservierung. Vorstellung * zu 1 Saal, Saal 1 zu 1..* Sitzplatz mit einer Raute, Reservierung * zu 1 Vorstellung und * zu 1..* Sitzplatz.',
  elemente: [
    UmlKlasse(x: 10, y: 20, b: 130, name: 'Vorstellung'),
    UmlKlasse(x: 240, y: 20, b: 130, name: 'Saal'),
    UmlKlasse(x: 470, y: 20, b: 130, name: 'Sitzplatz'),
    UmlKlasse(x: 10, y: 125, b: 130, name: 'Reservierung'),
    UmlKante(punkte: [Offset(140, 35), Offset(240, 35)], von: '*', nach: '1'),
    UmlKante(punkte: [Offset(470, 35), Offset(370, 35)], art: UmlKantenArt.komposition, von: '1..*', nach: '1'),
    UmlKante(punkte: [Offset(75, 125), Offset(75, 50)], von: '*', nach: '1'),
    UmlKante(punkte: [Offset(140, 140), Offset(535, 140), Offset(535, 50)], von: '*', nach: '1..*'),
  ],
);

const _reservierungZ = UmlDiagramm(
  breite: 540,
  hoehe: 170,
  beschreibung: 'Zustände einer Reservierung: reserviert, bezahlt, eingelöst, verfallen. Aus reserviert führt bezahlen nach bezahlt und Frist abgelaufen nach verfallen.',
  elemente: [
    UmlStart(x: 22, y: 50),
    UmlAktion(x: 45, y: 30, b: 120, text: 'reserviert', zustand: true),
    UmlAktion(x: 245, y: 30, b: 110, text: 'bezahlt', zustand: true),
    UmlAktion(x: 420, y: 30, b: 110, text: 'eingelöst', zustand: true),
    UmlAktion(x: 45, y: 120, b: 120, text: 'verfallen', zustand: true),
    UmlPfeil(punkte: [Offset(31, 50), Offset(45, 50)]),
    UmlPfeil(punkte: [Offset(165, 50), Offset(245, 50)], text: 'bezahlen'),
    UmlPfeil(punkte: [Offset(355, 50), Offset(420, 50)], text: 'einlassen'),
    UmlPfeil(punkte: [Offset(105, 70), Offset(105, 120)], text: 'Frist abgelaufen'),
    UmlPfeil(punkte: [Offset(475, 70), Offset(475, 109)]),
    UmlEnde(x: 475, y: 120),
    UmlPfeil(punkte: [Offset(165, 140), Offset(199, 140)]),
    UmlEnde(x: 210, y: 140),
  ],
);
const umlLektion11 = Lektion(
  nr: 11,
  slug: 'uml-11-pruefungstraining',
  titel: 'Prüfungstraining',
  kurzbeschreibung:
      'Ein durchgehender Prüfungsfall mit allen fünf Diagrammen, typische '
      'Fehler und eine Strategie für die UML-Aufgabe in der Prüfung.',
  dauerMinuten: 30,
  bloecke: [
    // ── Seite: Strategie ───────────────────────────────────────────────
    UeberschriftBlock('So gehst du in der Prüfung vor'),
    TextBlock(
      'Eine UML-Aufgabe in der Prüfung sieht fast immer gleich aus: ein Text, '
      'der ein Programm beschreibt, und ein Auftrag wie „Erstellen Sie ein '
      '… Diagramm“. Mit diesen Schritten verlierst du keine Punkte:\n'
      '- **Auftrag zuerst lesen.** Welches Diagramm ist verlangt? Was genau '
      'soll drin sein, zum Beispiel „mit Multiplizitäten“?\n'
      '- **Text markieren.** Rollen, Nomen mit eigenen Daten, Tätigkeiten, '
      'Signalwörter wie „immer“, „auf Wunsch“, „gleichzeitig“, „solange“.\n'
      '- **Erst sammeln, dann zeichnen.** Eine kurze Liste auf dem '
      'Konzeptpapier (das Schmierpapier, das du in der Prüfung bekommst) '
      'spart Korrekturen.\n'
      '- **Sauber zeichnen.** Raute, Dreieck, gestrichelt oder nicht: Jedes '
      'Zeichen zählt.\n'
      '- **Probe machen.** Beim Klassendiagramm jede Linie mit der Satzprobe '
      'lesen, bei include und extend die Pfeilrichtung prüfen.',
    ),

    // ── Seite: Der Fall ────────────────────────────────────────────────
    UeberschriftBlock('Der Prüfungsfall: Kino-App'),
    TextBlock(
      'Alle Aufgaben dieser Lektion gehören zu diesem Text. Lies ihn einmal '
      'in Ruhe. Du kannst jederzeit zurückblättern.\n'
      '\n'
      '„Das Kino Lichtspiel möchte eine App. **Besucher** reservieren damit '
      'Plätze für eine **Vorstellung**. Bevor ein Besucher Plätze reserviert, '
      'muss er sich immer anmelden. Auf Wunsch kann ein Besucher bei der '
      'Reservierung Snacks vorbestellen. Besucher können ihre Reservierungen '
      'selbst wieder stornieren. **Mitarbeiter** legen die Vorstellungen '
      'an.\n'
      '\n'
      'Jede Vorstellung läuft in genau einem **Saal**, ein Saal zeigt viele '
      'Vorstellungen nacheinander. Ein Saal besteht aus vielen '
      '**Sitzplätzen**. Wird ein Saal abgerissen, gibt es auch seine '
      'Sitzplätze nicht mehr. Eine **Reservierung** gilt für genau eine '
      'Vorstellung und für einen oder mehrere Sitzplätze. Für eine '
      'Vorstellung gibt es viele Reservierungen, und ein Sitzplatz wird im '
      'Lauf der Zeit viele Male reserviert.\n'
      '\n'
      'Eine Reservierung muss bis 30 Minuten vor Beginn bezahlt werden, sonst '
      'verfällt sie. Beim Einlass wird eine bezahlte Reservierung '
      'eingelöst.“',
    ),

    // ── Seite: Use-Case ────────────────────────────────────────────────
    UeberschriftBlock('Teil 1: Use-Case-Diagramm'),
    TextBlock(
      'Zuerst sollst du das Use-Case-Diagramm entwerfen. Beantworte dafür '
      'die nächsten Fragen. Die Lösung siehst du danach.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-1',
      frage: 'Welche Akteure hat das Diagramm?',
      optionen: [
        'Besucher, Mitarbeiter und Kino Lichtspiel',
        'Besucher und Mitarbeiter',
        'Besucher, Mitarbeiter und Saal',
        'Nur der Besucher',
      ],
      richtig: 1,
      erklaerung: 'Besucher und Mitarbeiter arbeiten von außen mit der App. '
          'Das Kino ist der Auftraggeber, der Saal ist ein Ding mit Daten, '
          'also später eine Klasse.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-2',
      frage: '„Bevor ein Besucher Plätze reserviert, muss er sich immer '
          'anmelden.“ Wie zeichnest du das?',
      optionen: [
        '«include» von „Anmelden“ zu „Plätze reservieren“',
        '«extend» von „Anmelden“ zu „Plätze reservieren“',
        '«include» von „Plätze reservieren“ zu „Anmelden“',
        'Als eigenen Akteur „Anmeldung“',
      ],
      richtig: 2,
      erklaerung: '„Immer“ heißt include. Der Pfeil zeigt vom Basisfall '
          '„Plätze reservieren“ weg zum eingebundenen Fall „Anmelden“.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-3',
      frage: '„Auf Wunsch kann ein Besucher bei der Reservierung Snacks '
          'vorbestellen.“ Wie zeichnest du das?',
      optionen: [
        '«extend» von „Snacks vorbestellen“ zu „Plätze reservieren“',
        '«extend» von „Plätze reservieren“ zu „Snacks vorbestellen“',
        '«include» von „Plätze reservieren“ zu „Snacks vorbestellen“',
        'Gar nicht, Snacks sind kein Anwendungsfall',
      ],
      richtig: 0,
      erklaerung: '„Auf Wunsch“ heißt nur manchmal, also extend. Der Pfeil '
          'zeigt von der Erweiterung zum Basisfall.',
    )),
    UeberschriftBlock('Lösung Teil 1'),
    UmlBlock(
      _kinoUC,
      unterschrift: 'Eine mögliche Musterlösung. Die Notiz nennt die '
          'Bedingung für extend, wie in Lektion 3.',
    ),
    TextBlock(
      'Vergleiche Punkt für Punkt: zwei Akteure außen, Systemgrenze mit '
      'Namen, fünf Anwendungsfälle, include und extend mit der richtigen '
      'Richtung. „Reservierung stornieren“ ist ein eigener Fall, weil es '
      'später und für sich allein passiert.',
    ),

    // ── Seite: Klassen ─────────────────────────────────────────────────
    UeberschriftBlock('Teil 2: Klassendiagramm'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-4',
      frage: 'Welche Beziehung besteht zwischen Saal und Sitzplatz?',
      optionen: [
        'Aggregation',
        'Komposition',
        'Vererbung',
        'Abhängigkeit',
      ],
      richtig: 1,
      erklaerung: '„Ein Saal besteht aus Sitzplätzen“ und die Sitzplätze '
          'verschwinden mit dem Saal: Komposition.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-11-5',
      frage: '„Eine Reservierung gilt für einen oder mehrere Sitzplätze.“ '
          'Welche Multiplizität steht an der Klasse Sitzplatz?',
      vorlage: 'Multiplizität am Sitzplatz-Ende der Linie zu Reservierung: '
          '___',
      loesungen: [
        ['1..*'],
      ],
      bausteine: ['1..*', '*', '1', '0..1'],
      erklaerung: '„Eine Reservierung hat einen oder mehrere Sitzplätze“: '
          'mindestens eins, also `1..*` am Sitzplatz.',
    )),
    UmlBlock(_kinoFehler, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-6',
      frage: 'Ein Azubi hat dieses Klassendiagramm abgegeben. Es enthält '
          'genau einen Fehler. Welchen?',
      optionen: [
        'Die Raute sitzt am Sitzplatz statt am Saal.',
        'An Saal müsste gegenüber Vorstellung `*` stehen statt `1`.',
        'Reservierung darf keine Linie zu Sitzplatz haben.',
        'Sitzplatz müsste von Saal erben.',
      ],
      richtig: 0,
      erklaerung: 'Die Raute gehört immer ans Ganze. Hier ist der Saal das '
          'Ganze, die Sitzplätze sind die Teile. Alle Multiplizitäten passen '
          'zum Text.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-7',
      frage: 'Die Klasse `Reservierung` kennt ihre Sitzplätze, Rolle '
          '`plaetze`. Welche Java-Zeile gehört in `Reservierung`?',
      optionen: [
        'private Sitzplatz plaetze;',
        'private List<Sitzplatz> plaetze;',
        'private List<Reservierung> plaetze;',
        'public Sitzplatz extends plaetze;',
      ],
      richtig: 1,
      erklaerung: 'Bei `1..*` braucht die Reservierung eine Liste von '
          'Sitzplätzen. Der Rollenname wird der Attributname.',
    )),

    // ── Seite: Ablauf ──────────────────────────────────────────────────
    UeberschriftBlock('Teil 3: Ablauf und Nachrichten'),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'uml-11-8',
      frage: 'Aktivitätsdiagramm „Plätze reservieren“: Bring die Elemente für '
          'den Fall „Plätze frei“ in die richtige Reihenfolge.',
      zeilen: [
        'Startknoten',
        'Vorstellung wählen',
        'Plätze wählen',
        'Raute mit [Plätze frei] und [sonst]',
        'Reservierung speichern',
        'Endknoten',
      ],
      erklaerung: 'Erst die Vorstellung, dann die Plätze darin. Ob sie frei '
          'sind, lässt sich erst prüfen, wenn sie gewählt sind. Auf dem Weg '
          '[Plätze frei] wird gespeichert, dann endet der Ablauf. Das '
          'Anmelden davor ist hier weggelassen.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-9',
      frage: 'Im Sequenzdiagramm schickt die App `reserviere(plaetze)` an den '
          'Server und wartet auf die Reservierungsnummer. Wie zeichnest du '
          'die Nachricht und die Antwort?',
      optionen: [
        'Nachricht gestrichelt, Antwort durchgezogen',
        'Nachricht durchgezogen mit gefüllter Spitze, Antwort gestrichelt '
            'mit offener Spitze',
        'Nachricht durchgezogen mit offener Spitze, keine Antwort',
        'Beide mit hohlem Dreieck',
      ],
      richtig: 1,
      erklaerung: 'Die App wartet, also eine synchrone Nachricht mit gefüllter '
          'Spitze. Die Antwort ist gestrichelt mit offener Spitze.',
    )),

    // ── Seite: Zustand ─────────────────────────────────────────────────
    UeberschriftBlock('Teil 4: Zustandsdiagramm'),
    TextBlock(
      'Aus dem letzten Absatz des Textes entsteht dieses Diagramm. Das '
      'Stornieren aus dem ersten Absatz lassen wir hier bewusst weg, damit '
      'das Diagramm klein bleibt. In der Prüfung müsstest du einen Zustand '
      '„storniert“ ergänzen.',
    ),
    UmlBlock(
      _reservierungZ,
      unterschrift: 'Eine Reservierung verfällt nur, solange sie noch nicht '
          'bezahlt ist.',
    ),
    UmlBlock(_reservierungZ, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-10',
      frage: 'Eine Reservierung ist **bezahlt**. Jetzt ist es 20 Minuten vor '
          'Beginn, die Frist ist also abgelaufen. Was passiert?',
      optionen: [
        'Sie wechselt nach „verfallen“.',
        'Sie bleibt „bezahlt“, denn aus „bezahlt“ führt kein Pfeil „Frist '
            'abgelaufen“.',
        'Sie wechselt nach „eingelöst“.',
        'Sie wechselt zurück nach „reserviert“.',
      ],
      richtig: 1,
      erklaerung: 'Ein Ereignis wirkt nur, wenn aus dem aktuellen Zustand ein '
          'passender Pfeil führt. Das passt auch zum Text: Verfallen kann nur '
          'eine unbezahlte Reservierung.',
    )),

    // ── Seite: Diagramm wählen ─────────────────────────────────────────
    UeberschriftBlock('Teil 5: Welches Diagramm?'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-11',
      frage: 'Das Kino möchte wissen, welche Daten die App speichert und wie '
          'Vorstellung, Saal und Reservierung zusammenhängen. Welches '
          'Diagramm zeigst du?',
      optionen: [
        'Use-Case-Diagramm',
        'Aktivitätsdiagramm',
        'Klassendiagramm',
        'Zustandsdiagramm',
      ],
      richtig: 2,
      erklaerung: 'Welche Dinge es gibt, was sie speichern und wie sie '
          'zusammenhängen, zeigt das Klassendiagramm.',
    )),

    // ── Seite: Typische Fehler ─────────────────────────────────────────
    UeberschriftBlock('Die zehn häufigsten Punktverluste'),
    TextBlock(
      '- Akteur innerhalb der Systemgrenze.\n'
      '- include und extend mit falscher Pfeilrichtung.\n'
      '- Anwendungsfälle als Ablaufschritte („Button klicken“).\n'
      '- Attribute ohne Datentyp oder ohne Sichtbarkeit.\n'
      '- Methoden ohne Klammern.\n'
      '- Multiplizität am falschen Ende. Satzprobe machen!\n'
      '- Raute am Teil statt am Ganzen.\n'
      '- Vererbungsdreieck an der Unterklasse statt an der Oberklasse.\n'
      '- Bedingungen an Rauten ohne eckige Klammern, oder so, dass ein Fall '
      'fehlt (zum Beispiel `[alter > 18]` und `[alter < 18]`, aber nichts für '
      'genau 18).\n'
      '- Im Sequenzdiagramm Antwort nicht gestrichelt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-11-12',
      frage: 'Welche dieser Aussagen ist **kein** Fehler?',
      optionen: [
        'Das Vererbungsdreieck sitzt an der Unterklasse.',
        'Die gefüllte Raute sitzt am Ganzen.',
        'Ein Akteur steht in der Systemgrenze.',
        'Ein Attribut steht ohne Datentyp da.',
      ],
      richtig: 1,
      erklaerung: 'Die Raute gehört ans Ganze, das ist richtig. Die anderen '
          'drei kosten in der Prüfung Punkte.',
    )),

    // ── Seite: Abschluss ───────────────────────────────────────────────
    UeberschriftBlock('Geschafft'),
    HinweisBlock(
      'Du kennst jetzt alle fünf UML-Diagramme der Prüfung:\n'
      '- **Use-Case**: wer benutzt das Programm wofür.\n'
      '- **Klassen**: welche Dinge es gibt und wie sie zusammenhängen.\n'
      '- **Aktivität**: welche Schritte in welcher Reihenfolge.\n'
      '- **Sequenz**: wer schickt wem wann eine Nachricht.\n'
      '- **Zustand**: in welchen Zuständen etwas sein kann.\n'
      '\n'
      'Übe weiter mit alten Prüfungsaufgaben. Zeichne auf Papier, dann '
      'vergleiche mit der Lösung Punkt für Punkt.',
    ),
  ],
);
