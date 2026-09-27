// lib/data/kurse/uml/lektion_01.dart
//
// UML-Kurs der App, Lektion 1. Reine Daten, gezeichnet vom LektionScreen,
// Diagramme von widgets/kurs/uml_ansicht.dart. Kursplan: PROJECT_STATE.md,
// Eintrag „UML-Kurs in der App“ (11 Lektionen, Start bei null).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _leihMini = UmlDiagramm(
  breite: 480,
  hoehe: 240,
  beschreibung: 'Use-Case-Diagramm Lastenrad-Verleih: Kunde bucht und storniert, Mitarbeiter wartet die Räder.',
  elemente: [
    UmlRahmen(x: 120, y: 10, b: 240, h: 220, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 240, cy: 72, rx: 78, text: 'Rad buchen'),
    UmlUseCase(cx: 240, cy: 132, rx: 92, text: 'Buchung stornieren'),
    UmlUseCase(cx: 240, cy: 192, rx: 70, text: 'Rad warten'),
    UmlAkteur(x: 52, y: 70, name: 'Kunde'),
    UmlAkteur(x: 420, y: 150, name: 'Mitarbeiter'),
    UmlKante(punkte: [Offset(68, 96), Offset(169, 81.9)]),
    UmlKante(punkte: [Offset(68, 96), Offset(168.2, 117)]),
    UmlKante(punkte: [Offset(404, 176), Offset(307.3, 185.4)]),
  ],
);
const umlLektion1 = Lektion(
  nr: 1,
  slug: 'uml-1-was-ist-uml',
  titel: 'Was ist UML?',
  kurzbeschreibung:
      'Warum man Software erst zeichnet und dann baut, welche fünf '
      'Diagramme in der Prüfung vorkommen und woran du sie erkennst.',
  dauerMinuten: 15,
  bloecke: [
    // ── Seite: Planen ──────────────────────────────────────────────────
    UeberschriftBlock('Erst planen, dann bauen'),
    TextBlock(
      'Bevor ein Haus gebaut wird, zeichnet eine Architektin einen '
      '**Bauplan**. Darauf sieht man, wo Wände, Türen und Fenster hinkommen. '
      'Bauherr, Maurer und Elektriker schauen auf denselben Plan und wissen '
      'Bescheid.\n'
      '\n'
      'Bei Software ist es genauso. Bevor jemand programmiert, wird geplant: '
      'Wer benutzt das Programm? Welche Daten werden gespeichert? Was passiert '
      'in welcher Reihenfolge? So einen Plan nennt man **Modell**. Eine '
      'einzelne Zeichnung davon heißt **Diagramm**.\n'
      '\n'
      'Damit alle die Zeichnungen gleich verstehen, gibt es eine gemeinsame '
      'Zeichensprache: **UML**. Das steht für „Unified Modeling Language“, '
      'auf Deutsch etwa „vereinheitlichte Sprache zum Modellieren“. Jedes '
      'Symbol hat darin eine feste Bedeutung, egal wer das Diagramm '
      'gezeichnet hat.',
    ),

    // ── Seite: Erstes Diagramm ─────────────────────────────────────────
    UeberschriftBlock('Ein erstes Diagramm'),
    TextBlock(
      'So sieht ein kleines UML-Diagramm aus. Es gehört zu einem Verleih für '
      'Lastenräder, also Fahrräder mit großer Ladefläche:',
    ),
    UmlBlock(
      _leihMini,
      unterschrift: 'Die Strichmännchen sind die Menschen, die das Programm '
          'benutzen. In den Ovalen steht, was sie damit tun. Das Rechteck '
          'zeigt, wo das Programm anfängt und aufhört.',
    ),
    TextBlock(
      'Auch ohne Vorwissen kannst du es lesen: Ein Kunde kann ein Rad buchen '
      'und eine Buchung stornieren. Ein Mitarbeiter wartet die Räder. Genau '
      'das ist der Sinn von UML: Man versteht auf einen Blick, worum es geht.\n'
      '\n'
      'Du kannst jedes Diagramm antippen. Dann öffnet es sich groß, und du '
      'kannst mit zwei Fingern hineinzoomen.',
    ),
    UmlBlock(_leihMini, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-1',
      frage: 'Im Diagramm „Lastenrad-Verleih“: Wer wartet die Räder?',
      optionen: [
        'Der Kunde',
        'Der Mitarbeiter',
        'Beide',
        'Das steht nicht im Diagramm',
      ],
      richtig: 1,
      erklaerung: 'Vom Strichmännchen „Mitarbeiter“ führt eine Linie zum Oval '
          '„Rad warten“. Der Kunde ist nur mit „Rad buchen“ und „Buchung '
          'stornieren“ verbunden.',
    )),

    // ── Seite: Struktur und Verhalten ──────────────────────────────────
    UeberschriftBlock('Was es gibt und was passiert'),
    TextBlock(
      'Denk an eine Küche. Ein Plan zeigt, **was es gibt**: Herd, Spüle, '
      'Schrank, und wo sie stehen. Ein Rezept zeigt, **was passiert**: erst '
      'Wasser kochen, dann Nudeln hinein, dann abgießen.\n'
      '\n'
      'UML-Diagramme gibt es in genau diesen zwei Arten:\n'
      '- **Struktur**: Was gibt es im Programm, und wie hängt es zusammen? '
      'Das zeigt vor allem das **Klassendiagramm**.\n'
      '- **Verhalten**: Was passiert, und in welcher Reihenfolge? Das zeigen '
      'alle anderen Diagramme dieses Kurses.\n'
      '\n'
      'Wenn du in einer Aufgabe unsicher bist, frag dich: Geht es um Dinge '
      'oder um Abläufe?',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-2',
      frage: 'Welches Diagramm zeigt die **Struktur** eines Programms, also '
          'was es gibt und wie es zusammenhängt?',
      optionen: [
        'Aktivitätsdiagramm',
        'Sequenzdiagramm',
        'Klassendiagramm',
        'Zustandsdiagramm',
      ],
      richtig: 2,
      erklaerung: 'Das Klassendiagramm zeigt, welche Dinge es gibt, was sie '
          'speichern und wie sie zusammenhängen. Die anderen drei zeigen '
          'Abläufe, also Verhalten.',
    )),

    // ── Seite: Fünf Diagramme ──────────────────────────────────────────
    UeberschriftBlock('Die fünf Diagramme der Prüfung'),
    TextBlock(
      'UML kennt vierzehn Diagrammarten. Für die Prüfung brauchst du nur '
      'fünf. Jedes beantwortet eine andere Frage:',
    ),
    SchreibtischtestBlock(
      spalten: ['Diagramm', 'Beantwortet die Frage', 'Lektion'],
      zeilen: [
        ['Use-Case-Diagramm', 'Wer benutzt das Programm wofür?', '2 und 3'],
        ['Klassendiagramm', 'Welche Dinge gibt es, was speichern sie?',
            '4 bis 7'],
        ['Aktivitätsdiagramm', 'In welcher Reihenfolge laufen die Schritte?',
            '8'],
        ['Sequenzdiagramm', 'Wer schickt wem wann eine Nachricht?', '9'],
        ['Zustandsdiagramm', 'In welchen Zuständen kann etwas sein?', '10'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Das **Klassendiagramm** kommt in der Prüfung am häufigsten vor, '
      'deshalb hat es vier Lektionen. In der Abschlussprüfung Teil 1 (AP1) '
      'kann UML in jeder Fachrichtung vorkommen. In Teil 2 ist es vor allem '
      'bei Anwendungsentwicklern ein großes Thema.',
    ),

    // ── Seite: Erkennen ────────────────────────────────────────────────
    UeberschriftBlock('Das richtige Diagramm erkennen'),
    TextBlock(
      'Oft nennt die Aufgabe das Diagramm direkt. Manchmal steht aber nur da, '
      'was gezeigt werden soll. Dann helfen dir diese Wörter:',
    ),
    SchreibtischtestBlock(
      spalten: ['Steht in der Aufgabe', 'Diagramm'],
      zeilen: [
        ['„Wer nutzt …“, „Anforderungen“, „Anwendungsfälle“',
            'Use-Case'],
        ['„Klassen“, „Attribute“, „Beziehungen“', 'Klassen'],
        ['„Ablauf“, „Prozess“, „Verzweigungen“', 'Aktivität'],
        ['„Nachrichten“, „zeitliche Abfolge“, „Client und Server“',
            'Sequenz'],
        ['„Zustände“, „Status wechselt“', 'Zustand'],
      ],
      aenderungenMarkieren: false,
    ),
    HinweisBlock(
      'Die häufigste Verwechslung: Aktivitäts- und Sequenzdiagramm. Geht es '
      'um die **Schritte eines Ablaufs** mit Entscheidungen, ist es das '
      'Aktivitätsdiagramm. Geht es darum, **wer mit wem redet**, zum Beispiel '
      'App, Server und Datenbank, ist es das Sequenzdiagramm.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-3',
      frage: 'In der Aufgabe steht: „Stellen Sie den Ablauf der '
          'Bestellabwicklung mit allen Verzweigungen dar.“ Welches Diagramm '
          'ist gemeint?',
      optionen: [
        'Klassendiagramm',
        'Use-Case-Diagramm',
        'Aktivitätsdiagramm',
        'Zustandsdiagramm',
      ],
      richtig: 2,
      erklaerung: '„Ablauf“ und „Verzweigungen“ sind die Signalwörter für das '
          'Aktivitätsdiagramm. Es zeigt die Schritte eines Ablaufs mit '
          'Entscheidungen.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-4',
      frage: 'Gezeigt werden soll, in welcher zeitlichen Abfolge App, Server '
          'und Datenbank beim Anmelden Nachrichten austauschen. Welches '
          'Diagramm passt?',
      optionen: [
        'Sequenzdiagramm',
        'Aktivitätsdiagramm',
        'Klassendiagramm',
        'Use-Case-Diagramm',
      ],
      richtig: 0,
      erklaerung: 'Wer schickt wem wann welche Nachricht: Genau diese Frage '
          'beantwortet das Sequenzdiagramm.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-5',
      frage: '„Welche Zustände kann eine Bestellung haben, und wodurch '
          'wechselt sie in den nächsten?“ Welches Diagramm passt?',
      optionen: [
        'Aktivitätsdiagramm',
        'Sequenzdiagramm',
        'Use-Case-Diagramm',
        'Zustandsdiagramm',
      ],
      richtig: 3,
      erklaerung: 'Zustände wie „offen“, „bezahlt“, „versendet“ und die '
          'Ereignisse, die sie wechseln, zeigt das Zustandsdiagramm.',
    )),

    // ── Seite: Punkte ──────────────────────────────────────────────────
    UeberschriftBlock('So gibt es Punkte'),
    TextBlock(
      'UML-Aufgaben werden in der Prüfung meist **Stück für Stück** bewertet: '
      'ein Punkt für jede richtige Klasse, einer für die richtigen Linien, '
      'einer für die Zahlen an den Linien und so weiter.\n'
      '\n'
      'Das heißt zweierlei:\n'
      '- Auch ein unvollständiges Diagramm bringt Punkte. Lass eine '
      'UML-Aufgabe nie leer.\n'
      '- Jedes Zeichen zählt. Eine leere Raute bedeutet etwas anderes als '
      'eine gefüllte, eine gestrichelte Linie etwas anderes als eine '
      'durchgezogene. Diese Unterschiede lernst du in den nächsten '
      'Lektionen.',
    ),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 1'),
    HinweisBlock(
      '- Ein **Modell** ist ein Plan für Software, ein **Diagramm** eine '
      'Zeichnung davon.\n'
      '- **UML** ist eine einheitliche Zeichensprache: Jedes Symbol hat eine '
      'feste Bedeutung.\n'
      '- **Struktur** (was es gibt): Klassendiagramm. **Verhalten** (was '
      'passiert): Use-Case, Aktivität, Sequenz, Zustand.\n'
      '- Signalwörter in der Aufgabe verraten das Diagramm.\n'
      '- Bewertet wird Stück für Stück. Nie leer lassen.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-1-6',
      frage: 'Welche Frage beantwortet ein Use-Case-Diagramm?',
      optionen: [
        'In welcher Reihenfolge laufen die Schritte ab?',
        'Wer benutzt das Programm wofür?',
        'Welche Daten speichert eine Klasse?',
        'Wie ist die Datenbank aufgebaut?',
      ],
      richtig: 1,
      erklaerung: 'Das Use-Case-Diagramm zeigt die Benutzer und das, was sie '
          'mit dem Programm erreichen wollen. Wie es intern abläuft, zeigt es '
          'bewusst nicht.',
    )),
  ],
);
