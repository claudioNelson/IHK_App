// lib/data/kurse/uml/lektion_02.dart
//
// UML-Kurs der App, Lektion 2: Use-Case-Diagramm (Grundlagen).
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _leihGrund = UmlDiagramm(
  breite: 530,
  hoehe: 290,
  beschreibung: 'Use-Case-Diagramm Lastenrad-Verleih mit Systemgrenze, drei Akteuren und vier Anwendungsfällen.',
  elemente: [
    UmlRahmen(x: 130, y: 10, b: 260, h: 270, titel: 'Lastenrad-Verleih'),
    UmlUseCase(cx: 260, cy: 72, rx: 72, text: 'Rad buchen'),
    UmlUseCase(cx: 260, cy: 132, rx: 60, text: 'Bezahlen'),
    UmlUseCase(cx: 260, cy: 192, rx: 92, text: 'Buchung stornieren'),
    UmlUseCase(cx: 260, cy: 252, rx: 66, text: 'Rad warten'),
    UmlAkteur(x: 55, y: 105, name: 'Kunde'),
    UmlAkteur(x: 465, y: 60, name: 'Zahlungsanbieter'),
    UmlAkteur(x: 465, y: 200, name: 'Mitarbeiter'),
    UmlKante(punkte: [Offset(71, 131), Offset(207.4, 88.4)]),
    UmlKante(punkte: [Offset(71, 131), Offset(200, 131.7)]),
    UmlKante(punkte: [Offset(71, 131), Offset(202.2, 173.3)]),
    UmlKante(punkte: [Offset(449, 86), Offset(311.3, 119.5)]),
    UmlKante(punkte: [Offset(449, 226), Offset(321.7, 243.5)]),
  ],
);

const _bibliothek = UmlDiagramm(
  breite: 510,
  hoehe: 240,
  beschreibung: 'Use-Case-Diagramm Stadtbibliothek: Leser leiht aus und verlängert, Bibliothekar nimmt Rückgaben an.',
  elemente: [
    UmlRahmen(x: 130, y: 10, b: 250, h: 220, titel: 'Stadtbibliothek'),
    UmlUseCase(cx: 255, cy: 72, rx: 84, text: 'Medium ausleihen'),
    UmlUseCase(cx: 255, cy: 132, rx: 92, text: 'Ausleihe verlängern'),
    UmlUseCase(cx: 255, cy: 192, rx: 90, text: 'Rückgabe annehmen'),
    UmlAkteur(x: 55, y: 70, name: 'Leser'),
    UmlAkteur(x: 450, y: 150, name: 'Bibliothekar'),
    UmlKante(punkte: [Offset(71, 96), Offset(178.6, 82)]),
    UmlKante(punkte: [Offset(71, 96), Offset(181.4, 117.6)]),
    UmlKante(punkte: [Offset(434, 176), Offset(340.3, 184.4)]),
  ],
);
const umlLektion2 = Lektion(
  nr: 2,
  slug: 'uml-2-use-case',
  titel: 'Das Use-Case-Diagramm',
  kurzbeschreibung:
      'Akteure, Anwendungsfälle und Systemgrenze: Wer benutzt das Programm '
      'wofür? Mit Übungen vom Aufgabentext zum fertigen Diagramm.',
  dauerMinuten: 20,
  bloecke: [
    // ── Seite: Wozu ────────────────────────────────────────────────────
    UeberschriftBlock('Die Speisekarte des Programms'),
    TextBlock(
      'Eine Speisekarte zeigt dir, was du bestellen kannst. Wie die Küche das '
      'Essen kocht, steht nicht darauf. Das interessiert dich als Gast auch '
      'nicht.\n'
      '\n'
      'Das **Use-Case-Diagramm** ist die Speisekarte eines Programms. '
      '„Use Case“ ist Englisch und heißt **Anwendungsfall**. Das Diagramm '
      'zeigt:\n'
      '- **wer** das Programm benutzt und\n'
      '- **was** diese Benutzer damit erreichen wollen.\n'
      '\n'
      'Wie das Programm innen arbeitet, zeigt es bewusst nicht. Man nennt das '
      'den **Blick von außen**. Deshalb zeichnet man es ganz am Anfang eines '
      'Projekts, oft zusammen mit dem Kunden, der noch nichts von '
      'Programmierung verstehen muss.',
    ),
    TextBlock('Das Diagramm besteht aus nur vier Bausteinen:'),
    SchreibtischtestBlock(
      spalten: ['Baustein', 'Zeichen', 'Bedeutung'],
      zeilen: [
        ['Akteur', 'Strichmännchen', 'wer das Programm benutzt'],
        ['Anwendungsfall', 'Oval mit Text', 'was er damit erreichen will'],
        ['Systemgrenze', 'Rechteck mit Namen', 'wo das Programm aufhört'],
        ['Assoziation', 'Linie', 'wer bei welchem Fall mitmacht'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock('Wir schauen uns alle vier nacheinander an.'),

    // ── Seite: Akteur ──────────────────────────────────────────────────
    UeberschriftBlock('Der Akteur ist eine Rolle'),
    TextBlock(
      'Anna arbeitet im Lastenrad-Verleih und wartet dort die Räder. Am '
      'Wochenende leiht sie sich selbst ein Rad aus. Wie zeichnet man Anna?\n'
      '\n'
      'Gar nicht. Im Diagramm stehen die **Rollen** „Mitarbeiter“ und '
      '„Kunde“. Anna spielt mal die eine, mal die andere. Denk an ein '
      'Theaterstück: Die Rolle „König“ bleibt dieselbe, egal welcher '
      'Schauspieler sie heute spielt.\n'
      '\n'
      'So eine Rolle heißt in UML **Akteur**. Ein Akteur arbeitet von außen '
      'mit dem Programm. Gezeichnet wird er als Strichmännchen, der Name '
      'steht darunter.\n'
      '\n'
      'Deshalb stehen am Strichmännchen nie Namen wie „Anna“ oder „Herr '
      'Meier“, sondern Rollen wie „Kunde“, „Mitarbeiter“ oder '
      '„Administrator“.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-1',
      frage: 'Welche Beschriftung passt an ein Strichmännchen?',
      optionen: [
        'Frau Schulz',
        'Anmeldeseite',
        'Bibliothekar',
        'Buch ausleihen',
      ],
      richtig: 2,
      erklaerung: '„Bibliothekar“ ist eine Rolle. „Frau Schulz“ ist eine '
          'bestimmte Person, die „Anmeldeseite“ ist ein Teil des Programms, '
          'und „Buch ausleihen“ ist etwas, das man tut, also ein '
          'Anwendungsfall.',
    )),

    // ── Seite: Fremdsystem ─────────────────────────────────────────────
    UeberschriftBlock('Auch ein Programm kann Akteur sein'),
    TextBlock(
      'Ein Akteur muss kein Mensch sein. Wenn der Lastenrad-Verleih für das '
      'Bezahlen einen fremden **Zahlungsanbieter** nutzt, arbeitet dieser '
      'Anbieter von außen mit unserem Programm zusammen. Also ist er ein '
      'Akteur.\n'
      '\n'
      'Die Regel ist einfach: Alles, was **außerhalb** unseres Programms '
      'liegt und mit ihm Daten austauscht, ist ein Akteur. Das kann ein '
      'Mensch sein, ein anderes Programm oder ein Gerät, zum Beispiel ein '
      'Kartenlesegerät.\n'
      '\n'
      'Die eigene Datenbank ist dagegen **kein** Akteur. Sie gehört zum '
      'Programm dazu, genau wie die Küche zum Restaurant gehört.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-2',
      frage: 'Ein Onlineshop schickt Pakete über einen fremden Paketdienst '
          'und fragt dafür dessen Schnittstelle an. Wie erscheint der '
          'Paketdienst im Use-Case-Diagramm des Shops?',
      optionen: [
        'Gar nicht, weil er kein Mensch ist',
        'Als Anwendungsfall innerhalb des Shops',
        'Als Akteur außerhalb des Shops',
        'Als Teil der Datenbank',
      ],
      richtig: 2,
      erklaerung: 'Der Paketdienst ist ein fremdes System. Er liegt außerhalb '
          'des Shops und tauscht mit ihm Daten aus. Damit ist er ein Akteur, '
          'auch wenn er kein Mensch ist.',
    )),

    // ── Seite: Anwendungsfall ──────────────────────────────────────────
    UeberschriftBlock('Der Anwendungsfall ist ein Ziel'),
    TextBlock(
      'Warum öffnet ein Kunde die App des Lastenrad-Verleihs? Um ein Rad zu '
      'buchen. Oder um eine Buchung zu stornieren. Genau diese Ziele sind die '
      '**Anwendungsfälle**. Gezeichnet wird ein Anwendungsfall als Oval, der '
      'Name steht darin.\n'
      '\n'
      'Für den Namen gibt es eine feste Form: **Nomen plus Verb**. Zum '
      'Beispiel „Rad buchen“, „Buchung stornieren“, „Rechnung drucken“.\n'
      '\n'
      'Ein guter Anwendungsfall hat für den Akteur einen **Nutzen**. Prüf das '
      'mit einer Frage: Hat der Akteur danach etwas erreicht, das ihm nützt?\n'
      '- „Rad buchen“: Ja, danach hat der Kunde ein Rad.\n'
      '- „Knopf klicken“: Nein, das ist nur ein Handgriff unterwegs.\n'
      '- „Daten in Tabelle speichern“: Nein, das passiert innen im Programm. '
      'Der Kunde sieht davon nichts.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-3',
      frage: 'Welcher Name ist ein guter Anwendungsfall für einen Onlineshop?',
      optionen: [
        'Bestellung aufgeben',
        'Warenkorb-Button drücken',
        'INSERT in Tabelle bestellung',
        'Kunde',
      ],
      richtig: 0,
      erklaerung: '„Bestellung aufgeben“ ist ein Ziel mit Nutzen, in der Form '
          'Nomen plus Verb. Den Button zu drücken ist nur ein Handgriff, das '
          'INSERT passiert innen im Programm, und „Kunde“ ist ein Akteur.',
    )),

    // ── Seite: Systemgrenze ────────────────────────────────────────────
    UeberschriftBlock('Die Systemgrenze'),
    TextBlock(
      'Um alle Anwendungsfälle zeichnet man ein Rechteck. Oben links steht '
      'der Name des Programms. Dieses Rechteck heißt **Systemgrenze**. Es '
      'zeigt, wo unser Programm anfängt und aufhört.\n'
      '\n'
      'Die Regel dazu kannst du dir leicht merken:\n'
      '- **Anwendungsfälle** stehen **innerhalb** der Grenze. Sie sind das, '
      'was unser Programm anbietet.\n'
      '- **Akteure** stehen **außerhalb** der Grenze. Sie benutzen das '
      'Programm, sind aber kein Teil davon.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-2-4',
      frage: 'Setz die passenden Wörter ein.',
      vorlage: 'Ein Akteur steht ___ der Systemgrenze. '
          'Ein Anwendungsfall steht ___ der Systemgrenze.',
      loesungen: [
        ['außerhalb'],
        ['innerhalb'],
      ],
      bausteine: ['außerhalb', 'innerhalb', 'auf', 'unter'],
      erklaerung: 'Akteure benutzen das Programm von außen. Die '
          'Anwendungsfälle sind das, was das Programm anbietet, deshalb '
          'stehen sie drinnen.',
    )),

    // ── Seite: Assoziation ─────────────────────────────────────────────
    UeberschriftBlock('Linien verbinden Akteur und Fall'),
    TextBlock(
      'Jetzt fehlen nur noch die Linien. Hier ist das vollständige Diagramm '
      'für den Lastenrad-Verleih:',
    ),
    UmlBlock(
      _leihGrund,
      unterschrift: 'Drei Akteure außen, vier Anwendungsfälle innen, Linien '
          'für jede Beteiligung.',
    ),
    TextBlock(
      'So liest du es:\n'
      '- Der **Kunde** kann ein Rad buchen, bezahlen und eine Buchung '
      'stornieren.\n'
      '- Beim **Bezahlen** macht auch der **Zahlungsanbieter** mit. An einem '
      'Anwendungsfall können also mehrere Akteure beteiligt sein.\n'
      '- Der **Mitarbeiter** wartet die Räder.\n'
      '\n'
      'Eine solche Linie zwischen Akteur und Anwendungsfall heißt '
      '**Assoziation**. Sie bedeutet: Dieser Akteur macht bei diesem '
      'Anwendungsfall mit. Die Linie hat normalerweise **keine Pfeilspitze**. Sie zeigt nur, wer '
      'beteiligt ist, nicht in welche Richtung etwas läuft.',
    ),
    UmlBlock(_leihGrund, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-5',
      frage: 'Welche Akteure sind im Diagramm am Anwendungsfall „Bezahlen“ '
          'beteiligt?',
      optionen: [
        'Nur der Kunde',
        'Nur der Zahlungsanbieter',
        'Kunde und Mitarbeiter',
        'Kunde und Zahlungsanbieter',
      ],
      richtig: 3,
      erklaerung: 'Zu „Bezahlen“ führen zwei Linien: eine vom Kunden, eine vom '
          'Zahlungsanbieter.',
    )),
    UmlBlock(_leihGrund, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-6',
      frage: 'Was sagt dir das Diagramm **nicht**?',
      optionen: [
        'Dass der Mitarbeiter Räder wartet',
        'Dass der Kunde Buchungen stornieren kann',
        'Welche Schritte beim Buchen nacheinander passieren',
        'Dass ein fremder Zahlungsanbieter beteiligt ist',
      ],
      richtig: 2,
      erklaerung: 'Das Use-Case-Diagramm zeigt nur, wer was erreichen will. '
          'Die Schritte eines Ablaufs zeigt das Aktivitätsdiagramm, das du in '
          'Lektion 8 kennenlernst.',
    )),

    // ── Seite: Fehler ──────────────────────────────────────────────────
    UeberschriftBlock('Typische Fehler'),
    TextBlock(
      'Diese Fehler kosten in der Prüfung am häufigsten Punkte:\n'
      '- **Ablauf statt Ziel**: Ovale wie „Anmelden“, „Rad auswählen“, '
      '„Bestätigen“ hintereinander. Das sind Schritte eines Ablaufs, kein '
      'Use-Case-Diagramm.\n'
      '- **Akteur in der Grenze**: Das Strichmännchen steht im Rechteck. '
      'Akteure gehören immer nach außen.\n'
      '- **Personennamen**: „Anna“ statt „Mitarbeiter“.\n'
      '- **Innere Technik**: Ovale wie „Datenbank aktualisieren“. Der '
      'Akteur sieht davon nichts.\n'
      '- **Pfeile zwischen Anwendungsfällen** ohne Beschriftung. Es gibt zwar '
      'Linien zwischen Ovalen, aber nur mit fester Bedeutung. Die lernst du '
      'in Lektion 3.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-7',
      frage: 'Ein Azubi hat für eine Bibliothek diese Ovale gezeichnet. '
          'Welches ist falsch?',
      optionen: [
        'Medium ausleihen',
        'Ausleihe verlängern',
        'Datensatz in Tabelle ausleihe anlegen',
        'Medium zurückgeben',
      ],
      richtig: 2,
      erklaerung: 'Einen Datensatz anzulegen ist innere Technik. Der Leser '
          'will ein Medium ausleihen, dass dabei ein Datensatz entsteht, '
          'sieht er nicht.',
    )),

    // ── Seite: Vom Text zum Diagramm ───────────────────────────────────
    UeberschriftBlock('Vom Aufgabentext zum Diagramm'),
    TextBlock(
      'In der Prüfung bekommst du einen Text und sollst das Diagramm '
      'zeichnen. Hier ein Beispiel:\n'
      '\n'
      '„Die Stadtbibliothek möchte ein neues Programm. **Leser** sollen damit '
      'Medien **ausleihen** und ihre Ausleihe **verlängern** können. '
      '**Bibliothekare** nehmen zurückgegebene Medien **an**.“\n'
      '\n'
      'Der Trick: Die **Nomen für Personen** werden Akteure, die '
      '**Tätigkeiten** werden Anwendungsfälle. Die Bibliothek selbst ist das '
      'Programm, also die Systemgrenze.',
    ),
    UmlBlock(
      _bibliothek,
      unterschrift: 'Aus dem Text: zwei Akteure, drei Anwendungsfälle.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'uml-2-8',
      frage: 'Bring die Arbeitsschritte in eine sinnvolle Reihenfolge.',
      zeilen: [
        'Rollen und Tätigkeiten im Text markieren.',
        'Rechteck mit dem Namen des Programms zeichnen.',
        'Anwendungsfälle hinein, Akteure nach außen.',
        'Jeden Akteur mit seinen Anwendungsfällen verbinden.',
      ],
      erklaerung: 'Erst sammeln, dann zeichnen: Rollen und Tätigkeiten aus dem '
          'Text holen, dann Grenze, Ovale und Strichmännchen, zum Schluss die '
          'Linien.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-2-9',
      frage: 'Eine Tierarztpraxis will ein Programm: „Tierhalter buchen '
          'online einen Termin. Die Tierärztin sieht ihre Termine für den '
          'Tag.“ Ergänze.',
      vorlage: 'Akteure: Tierhalter und ___. '
          'Anwendungsfall des Tierhalters: Termin ___.',
      loesungen: [
        ['Tierärztin'],
        ['buchen'],
      ],
      bausteine: ['Tierärztin', 'Praxis', 'buchen', 'speichern'],
      erklaerung: 'Die Tierärztin ist eine Rolle und damit Akteur. Die Praxis '
          'ist hier das Programm selbst. Der Tierhalter will einen Termin '
          'buchen, das Speichern passiert innen.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 2'),
    HinweisBlock(
      '- Das Use-Case-Diagramm zeigt **wer** das Programm **wofür** benutzt. '
      'Blick von außen, keine Abläufe.\n'
      '- **Akteur**: Strichmännchen, eine Rolle, außerhalb. Auch fremde '
      'Systeme können Akteure sein.\n'
      '- **Anwendungsfall**: Oval, Nomen plus Verb, mit Nutzen für den '
      'Akteur.\n'
      '- **Systemgrenze**: Rechteck mit Programmnamen, Anwendungsfälle '
      'innen.\n'
      '- **Assoziation**: Linie ohne Pfeil, Akteur macht beim Fall mit.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-2-10',
      frage: 'Welche Aussage über Akteure ist richtig?',
      optionen: [
        'Ein Akteur steht innerhalb der Systemgrenze.',
        'Ein Akteur ist immer ein Mensch.',
        'Die eigene Datenbank ist ein Akteur.',
        'Ein Akteur ist eine Rolle, die von außen mit dem Programm arbeitet.',
      ],
      richtig: 3,
      erklaerung: 'Akteure sind Rollen außerhalb der Systemgrenze. Das können '
          'Menschen oder fremde Systeme sein. Die eigene Datenbank gehört zum '
          'Programm und ist deshalb kein Akteur.',
    )),
  ],
);
