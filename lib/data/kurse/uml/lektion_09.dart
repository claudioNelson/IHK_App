// lib/data/kurse/uml/lektion_09.dart
//
// UML-Kurs der App, Lektion 9: Sequenzdiagramm.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _login = UmlDiagramm(
  breite: 480,
  hoehe: 250,
  beschreibung: 'Sequenzdiagramm Anmeldung: App schickt anmelden an Server, Server schickt pruefe an Datenbank, Datenbank antwortet ok, Server antwortet angemeldet.',
  elemente: [
    UmlLebenslinie(x: 80, y: 10, b: 110, name: ':App', bis: 240),
    UmlLebenslinie(x: 240, y: 10, b: 110, name: ':Server', bis: 240),
    UmlLebenslinie(x: 400, y: 10, b: 110, name: ':Datenbank', bis: 240),
    UmlAktivierung(x: 80, von: 60, bis: 215),
    UmlAktivierung(x: 240, von: 70, bis: 195),
    UmlAktivierung(x: 400, von: 100, bis: 130),
    UmlPfeil(punkte: [Offset(86, 70), Offset(234, 70)], spitze: UmlSpitze.voll, text: 'anmelden(name, pw)'),
    UmlPfeil(punkte: [Offset(246, 100), Offset(394, 100)], spitze: UmlSpitze.voll, text: 'pruefe(name, pw)'),
    UmlPfeil(punkte: [Offset(394, 130), Offset(246, 130)], gestrichelt: true, text: 'ok'),
    UmlPfeil(punkte: [Offset(234, 195), Offset(86, 195)], gestrichelt: true, text: 'angemeldet'),
  ],
);

const _arten = UmlDiagramm(
  breite: 420,
  hoehe: 215,
  beschreibung: 'Drei Nachrichtenarten zwischen Kunde und Shop: synchron mit gefüllter Spitze, Antwort gestrichelt, asynchron mit offener Spitze.',
  elemente: [
    UmlLebenslinie(x: 90, y: 10, b: 110, name: ':Kunde', bis: 205),
    UmlLebenslinie(x: 330, y: 10, b: 110, name: ':Shop', bis: 205),
    UmlAktivierung(x: 90, von: 60, bis: 195),
    UmlAktivierung(x: 330, von: 70, bis: 110),
    UmlAktivierung(x: 330, von: 160, bis: 190),
    UmlPfeil(punkte: [Offset(96, 70), Offset(324, 70)], spitze: UmlSpitze.voll, text: 'bestellen(artikel)'),
    UmlPfeil(punkte: [Offset(324, 110), Offset(96, 110)], gestrichelt: true, text: 'bestellnummer'),
    UmlPfeil(punkte: [Offset(96, 160), Offset(324, 160)], text: 'newsletterAbonnieren()'),
  ],
);

const _alt = UmlDiagramm(
  breite: 490,
  hoehe: 290,
  beschreibung: 'Sequenzdiagramm mit alt-Fragment: Bei Rad frei speichert der Server die Buchung und bestätigt, sonst lehnt er ab.',
  elemente: [
    UmlLebenslinie(x: 110, y: 10, b: 110, name: ':App', bis: 280),
    UmlLebenslinie(x: 260, y: 10, b: 110, name: ':Server', bis: 280),
    UmlLebenslinie(x: 410, y: 10, b: 110, name: ':Datenbank', bis: 280),
    UmlAktivierung(x: 110, von: 60, bis: 265),
    UmlAktivierung(x: 260, von: 70, bis: 245),
    UmlAktivierung(x: 410, von: 150, bis: 165),
    UmlPfeil(punkte: [Offset(116, 70), Offset(254, 70)], spitze: UmlSpitze.voll, text: 'buchen(rad)'),
    UmlRahmen(x: 20, y: 105, b: 450, h: 155, titel: 'alt', fragment: true),
    UmlText(x: 126, y: 110, text: '[Rad frei]', code: true),
    UmlPfeil(punkte: [Offset(266, 150), Offset(404, 150)], spitze: UmlSpitze.voll, text: 'speichere(buchung)'),
    UmlPfeil(punkte: [Offset(254, 180), Offset(116, 180)], gestrichelt: true, text: 'bestätigt'),
    UmlPfeil(punkte: [Offset(20, 200), Offset(470, 200)], spitze: UmlSpitze.keine, gestrichelt: true),
    UmlText(x: 126, y: 206, text: '[sonst]', code: true),
    UmlPfeil(punkte: [Offset(254, 245), Offset(116, 245)], gestrichelt: true, text: 'abgelehnt'),
  ],
);
const umlLektion9 = Lektion(
  nr: 9,
  slug: 'uml-9-sequenz',
  titel: 'Das Sequenzdiagramm',
  kurzbeschreibung:
      'Wer schickt wem wann eine Nachricht? Lebenslinien, synchrone und '
      'asynchrone Nachrichten, Antworten und das Fragment alt.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Gespräch ────────────────────────────────────────────────
    UeberschriftBlock('Ein Gespräch aufschreiben'),
    TextBlock(
      'Stell dir vor, du bestellst im Restaurant. Du sagst dem Kellner, was '
      'du möchtest. Der Kellner gibt es an die Küche weiter. Die Küche meldet '
      '„fertig“, und der Kellner bringt dir das Essen.\n'
      '\n'
      'Hier reden drei Beteiligte miteinander, und die **Reihenfolge** ist '
      'wichtig. Genau das zeigt das **Sequenzdiagramm**. „Sequenz“ heißt '
      'Abfolge. Es beantwortet die Frage: **Wer schickt wem wann welche '
      'Nachricht?**\n'
      '\n'
      'In der Informatik sind die Beteiligten meist Programmteile, zum '
      'Beispiel eine App, ein Server und eine Datenbank. Eine **Nachricht** '
      'ist ein Aufruf: Der eine bittet den anderen, etwas zu tun, so wie ein '
      'Methodenaufruf aus Lektion 7.',
    ),

    // ── Seite: Lebenslinie ─────────────────────────────────────────────
    UeberschriftBlock('Lebenslinien: die Zeit läuft nach unten'),
    TextBlock('So sieht das Anmelden in einer App aus:'),
    UmlBlock(
      _login,
      unterschrift: 'Drei Beteiligte nebeneinander. Die Nachrichten laufen '
          'von oben nach unten. Wer die App anstößt, also der Nutzer, ist '
          'hier weggelassen. In Prüfungen steht dafür oft ein Strichmännchen '
          'ganz links.',
    ),
    TextBlock(
      '- Oben stehen die Beteiligten in Kästen. `:Server` heißt: ein Objekt '
      'der Klasse Server. Vor dem Doppelpunkt könnte ein eigener Name '
      'stehen, er ist hier weggelassen. Oft wird der Text wie bei Objekten '
      'in Lektion 4 unterstrichen. Pflicht ist das im Sequenzdiagramm '
      'nicht, beides wird in der Prüfung akzeptiert.\n'
      '- Unter jedem Kasten hängt eine gestrichelte Linie. Sie heißt '
      '**Lebenslinie**. Die **Zeit läuft nach unten**: Was weiter oben steht, '
      'passiert früher.\n'
      '- Die schmalen Rechtecke auf den Lebenslinien heißen '
      '**Aktivierungsbalken**. Sie zeigen, wann ein Objekt gerade arbeitet.\n'
      '- Die waagerechten Pfeile sind die **Nachrichten**.',
    ),
    UmlBlock(_login, zurAufgabe: true),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'uml-9-1',
      frage: 'Bring die Nachrichten aus dem Diagramm in die zeitliche '
          'Reihenfolge.',
      zeilen: [
        'App an Server: anmelden(name, pw)',
        'Server an Datenbank: pruefe(name, pw)',
        'Datenbank an Server: ok',
        'Server an App: angemeldet',
      ],
      erklaerung: 'Die Zeit läuft von oben nach unten. Die App fragt den '
          'Server, der Server fragt die Datenbank, dann laufen die Antworten '
          'zurück.',
    )),

    // ── Seite: Nachrichtenarten ────────────────────────────────────────
    UeberschriftBlock('Anrufen oder SMS schreiben'),
    TextBlock(
      'Wenn du jemanden **anrufst**, wartest du am Telefon auf die Antwort. '
      'Wenn du eine **SMS** schreibst, legst du das Handy weg und machst '
      'etwas anderes. So gibt es auch zwei Arten von Nachrichten:',
    ),
    UmlBlock(
      _arten,
      unterschrift: 'Oben eine synchrone Nachricht mit Antwort, unten eine '
          'asynchrone.',
    ),
    SchreibtischtestBlock(
      spalten: ['Pfeil', 'Name', 'Bedeutung'],
      zeilen: [
        ['durchgezogen, gefüllte Spitze', 'synchrone Nachricht',
            'Absender wartet auf Antwort (Anruf)'],
        ['gestrichelt, offene Spitze', 'Antwort', 'Ergebnis kommt zurück'],
        ['durchgezogen, offene Spitze', 'asynchrone Nachricht',
            'Absender wartet nicht (SMS)'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'An der Antwort steht, was zurückkommt, hier die `bestellnummer`. '
      'Antworten darf man weglassen, wenn nichts Wichtiges zurückkommt. Nach '
      'einer asynchronen Nachricht gibt es keine Antwort, auf die gewartet '
      'wird.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-2',
      frage: 'Welcher Pfeil bedeutet: Der Absender wartet, bis die Antwort '
          'da ist?',
      optionen: [
        'Durchgezogen mit gefüllter Spitze',
        'Durchgezogen mit offener Spitze',
        'Gestrichelt mit offener Spitze',
        'Gestrichelt ohne Spitze',
      ],
      richtig: 0,
      erklaerung: 'Die gefüllte Spitze steht für eine synchrone Nachricht: Der '
          'Absender wartet, wie bei einem Anruf.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-3',
      frage: 'Ein gestrichelter Pfeil mit offener Spitze führt von `:Server` '
          'zu `:App`, beschriftet mit `angemeldet`. Was ist das?',
      optionen: [
        'Eine asynchrone Nachricht an die App',
        'Die Antwort des Servers auf eine vorherige Nachricht',
        'Eine Vererbung',
        'Ein neuer Anmeldeversuch',
      ],
      richtig: 1,
      erklaerung: 'Gestrichelt mit offener Spitze ist eine Antwort. Der Server '
          'meldet das Ergebnis an die App zurück.',
    )),

    // ── Seite: Fragmente ───────────────────────────────────────────────
    UeberschriftBlock('Wenn, sonst: das Fragment alt'),
    TextBlock(
      'Manchmal geht das Gespräch unterschiedlich weiter. Ist das Rad frei, '
      'wird gebucht. Ist es belegt, gibt es eine Absage. Dafür zeichnet man '
      'einen Rahmen um die betroffenen Nachrichten:',
    ),
    UmlBlock(
      _alt,
      unterschrift: 'Oben der Fall [Rad frei], unter der gestrichelten Linie '
          'der Fall [sonst].',
    ),
    TextBlock(
      'So ein Rahmen heißt **kombiniertes Fragment**. Oben links steht in '
      'einem kleinen Fünfeck, welche Art es ist. `alt` steht für '
      '„Alternative“: Es wird **genau einer** der Bereiche ausgeführt. Die '
      'gestrichelte Linie trennt die Bereiche, und jeder bekommt einen '
      '**Wächter**, also eine Bedingung in eckigen Klammern, wie im '
      'Aktivitätsdiagramm.\n'
      '\n'
      'Zwei weitere Fragmente kommen in Prüfungen vor:\n'
      '- `opt`: Gibt der Kunde einen Rabattcode ein, prüft der Server ihn. '
      'Gibt er keinen ein, passiert an dieser Stelle nichts.\n'
      '- `loop`: Der Server schickt jedem Empfänger nacheinander eine '
      'Rechnung, einmal je Empfänger.',
    ),
    SchreibtischtestBlock(
      spalten: ['Fragment', 'Bedeutung', 'Wie im Struktogramm'],
      zeilen: [
        ['alt', 'genau einer von mehreren Bereichen',
            'Verzweigung (zwei oder mehr Fälle)'],
        ['opt', 'ein Bereich, nur wenn die Bedingung stimmt',
            'einseitige Verzweigung'],
        ['loop', 'Bereich wird wiederholt', 'Schleife'],
      ],
      aenderungenMarkieren: false,
    ),
    UmlBlock(_alt, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-4',
      frage: 'Im Diagramm ist das Rad belegt. Welche Nachrichten werden '
          'nach `buchen(rad)` geschickt?',
      optionen: [
        'speichere(buchung) und bestätigt',
        'Nur abgelehnt',
        'speichere(buchung) und abgelehnt',
        'Alle drei',
      ],
      richtig: 1,
      erklaerung: 'Bei alt wird genau ein Bereich ausgeführt. Bei belegtem Rad '
          'gilt [sonst], dort steht nur die Antwort abgelehnt.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-5',
      frage: 'Eine App fragt den Server so lange nach neuen Nachrichten, bis '
          'keine mehr kommen. Welches Fragment passt?',
      optionen: ['alt', 'opt', 'loop', 'Keins, das geht nicht'],
      richtig: 2,
      erklaerung: 'Eine Wiederholung zeichnet man mit dem Fragment loop.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-6',
      frage: 'Nur wenn der Kunde es wünscht, schickt der Shop eine '
          'Bestätigung per E-Mail. Sonst passiert nichts. Welches Fragment '
          'passt am besten?',
      optionen: ['alt', 'opt', 'loop', 'Ein zweiter Aktivierungsbalken'],
      richtig: 1,
      erklaerung: 'Ein einziger Bereich, der nur bei einer Bedingung '
          'ausgeführt wird, ohne Sonst-Fall: Das ist opt, kurz für '
          '„optional“.',
    )),

    // ── Seite: Abgrenzung ──────────────────────────────────────────────
    UeberschriftBlock('Sequenz oder Aktivität?'),
    TextBlock(
      'Beide Diagramme zeigen einen Ablauf. Der Unterschied:\n'
      '- Das **Aktivitätsdiagramm** zeigt die **Schritte**. Wer sie ausführt, '
      'ist Nebensache, höchstens über Schwimmbahnen.\n'
      '- Das **Sequenzdiagramm** zeigt die **Nachrichten zwischen '
      'Beteiligten**. Es geht darum, wer mit wem redet und in welcher '
      'Reihenfolge.\n'
      '\n'
      'Stehen in der Aufgabe Wörter wie „Client“ (das Programm beim Nutzer, '
      'etwa Browser oder App), „Server“, „Nachricht“, '
      '„Anfrage“ oder „Antwort“, ist fast immer das Sequenzdiagramm gemeint.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-9-7',
      frage: 'Ergänze.',
      vorlage: 'Im Sequenzdiagramm läuft die Zeit von ___ nach ___.',
      loesungen: [
        ['oben'],
        ['unten'],
      ],
      bausteine: ['oben', 'unten', 'links', 'rechts'],
      erklaerung: 'Was weiter oben steht, passiert früher. Deshalb liest man '
          'ein Sequenzdiagramm von oben nach unten.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 9'),
    HinweisBlock(
      '- Oben die Beteiligten (`:Klasse`), darunter gestrichelte '
      '**Lebenslinien**. Die Zeit läuft nach unten.\n'
      '- **Aktivierungsbalken**: Das Objekt arbeitet gerade.\n'
      '- **Synchron**: durchgezogen, gefüllte Spitze, wartet. **Asynchron**: '
      'durchgezogen, offene Spitze, wartet nicht. **Antwort**: gestrichelt, '
      'offene Spitze.\n'
      '- Fragmente: **alt** (wenn, sonst), **opt** (nur wenn), **loop** '
      '(Wiederholung).',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-9-8',
      frage: 'In der Aufgabe steht: „Stellen Sie dar, wie Client, Webserver '
          'und Datenbank beim Abrufen einer Seite Nachrichten austauschen.“ '
          'Welches Diagramm zeichnest du?',
      optionen: [
        'Aktivitätsdiagramm',
        'Sequenzdiagramm',
        'Klassendiagramm',
        'Use-Case-Diagramm',
      ],
      richtig: 1,
      erklaerung: 'Mehrere Beteiligte tauschen Nachrichten aus: Das ist die '
          'Frage, die das Sequenzdiagramm beantwortet.',
    )),
  ],
);
