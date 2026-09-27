// lib/data/kurse/struktogramm/lektion_01.dart
//
// Struktogramm-Kurs der App, Lektion 1. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 1: Was ist ein Ablauf?
// ═══════════════════════════════════════════════════════════════════════════
// Startet bei null: kein Vorwissen, keine Variablen, keine Bedingungen.
// Nur Schritte der Reihe nach, Eingabe und Ausgabe. Autor Opus 5.5
// (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _tee = <SgBlock>[
  SgAnw('Teebeutel in die Tasse hängen'),
  SgAnw('Wasser in den Wasserkocher füllen'),
  SgAnw('Wasserkocher einschalten'),
  SgAnw('Warten, bis das Wasser kocht'),
  SgAnw('Wasser in die Tasse gießen'),
  SgAnw('Drei Minuten warten'),
  SgAnw('Teebeutel herausnehmen'),
];

const _begruessung = <SgBlock>[
  SgAnw('Ausgabe "Wie heißt du?"'),
  SgAnw('Eingabe name'),
  SgAnw('Ausgabe "Hallo"'),
  SgAnw('Ausgabe name'),
];

const _begruessungFalsch = <SgBlock>[
  SgAnw('Ausgabe "Wie heißt du?"'),
  SgAnw('Ausgabe "Hallo"'),
  SgAnw('Ausgabe name'),
  SgAnw('Eingabe name'),
];

const struktogrammLektion1 = Lektion(
  nr: 1,
  slug: 'struktogramm-1-ablauf',
  titel: 'Was ist ein Ablauf?',
  kurzbeschreibung:
      'Warum ein Computer jeden Schritt einzeln braucht und wie dein erstes '
      'Struktogramm aussieht. Ganz ohne Vorwissen.',
  dauerMinuten: 15,
  bloecke: [
    // ── Seite: Einstieg ────────────────────────────────────────────────
    UeberschriftBlock('Worum es in diesem Kurs geht'),
    TextBlock(
      'Ein **Programm** ist eine Anleitung für einen Computer. '
      'Es sagt ihm, was er tun soll, Schritt für Schritt.\n'
      '\n'
      'Bevor jemand ein Programm schreibt, plant er den **Ablauf**: '
      'Was soll passieren, und in welcher Reihenfolge? '
      'Diesen Plan kann man zeichnen. Die Zeichnung heißt **Struktogramm**.\n'
      '\n'
      'Dieser Kurs fängt ganz vorne an. Du brauchst kein Vorwissen.\n'
      '\n'
      'Warum das wichtig ist: In der Abschlussprüfung Teil 1, kurz **AP1**, '
      'kommt oft eine Aufgabe mit einem Struktogramm. Du sollst es lesen '
      'oder selbst zeichnen.',
    ),

    // ── Seite: Alltag ──────────────────────────────────────────────────
    UeberschriftBlock('Ein Ablauf aus dem Alltag'),
    TextBlock(
      'Du kennst Abläufe schon, auch wenn du sie nicht so nennst. '
      'Denk an eine Tasse Tee:\n'
      '- Teebeutel in die Tasse hängen\n'
      '- Wasser in den Wasserkocher füllen\n'
      '- Wasserkocher einschalten\n'
      '- Warten, bis das Wasser kocht\n'
      '- Wasser in die Tasse gießen\n'
      '- Drei Minuten warten\n'
      '- Teebeutel herausnehmen\n'
      '\n'
      'Das ist ein **Ablauf**: mehrere Schritte, die nacheinander passieren.\n'
      '\n'
      'Bei manchen Schritten ist die Reihenfolge egal. Den Teebeutel kannst '
      'du auch erst später in die Tasse hängen. Bei anderen ist sie '
      'wichtig: Gießt du das Wasser ein, bevor es kocht, wird der Tee nichts.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-1-1',
      frage: 'Bring die Schritte in die richtige Reihenfolge. '
          'Der Teebeutel hängt schon in der Tasse.',
      zeilen: [
        'Wasser in den Wasserkocher füllen',
        'Wasserkocher einschalten',
        'Warten, bis das Wasser kocht',
        'Wasser in die Tasse gießen',
        'Teebeutel herausnehmen',
      ],
      erklaerung: 'Erst Wasser einfüllen, dann einschalten, dann warten. '
          'Erst wenn das Wasser kocht, kommt es in die Tasse. '
          'Der Teebeutel kommt ganz zum Schluss heraus.',
    )),

    // ── Seite: Computer ────────────────────────────────────────────────
    UeberschriftBlock('Ein Computer rät nicht'),
    TextBlock(
      'Sagst du zu einem Freund „Mach mir bitte einen Tee“, weiß er, '
      'was zu tun ist. Er denkt mit.\n'
      '\n'
      'Ein Computer denkt nicht mit. Er macht **genau** das, was in der '
      'Anleitung steht. Nicht mehr und nicht weniger. Fehlt ein Schritt in '
      'der Anleitung, führt der Computer ihn auch nicht aus. Dann stimmt '
      'das Ergebnis nicht. Ist ein Schritt ungenau, weiß der Computer nicht '
      'weiter.\n'
      '\n'
      'Eine Anleitung, die so genau ist, dass man sie ohne Nachdenken '
      'Schritt für Schritt ausführen kann, heißt **Algorithmus**. '
      'Das Wort klingt schwierig, meint aber nur das: eine sehr genaue '
      'Anleitung.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-2',
      frage: 'Welcher Schritt ist für einen Computer zu ungenau?',
      optionen: [
        'Wasserkocher einschalten',
        'Drei Minuten warten',
        'Wasser heiß genug machen',
        'Teebeutel herausnehmen',
      ],
      richtig: 2,
      erklaerung: 'Was heißt „heiß genug“? Ein Mensch schätzt das ab, ein '
          'Computer kann das nicht. Genauer wäre: „Warten, bis das Wasser '
          'kocht“. Die anderen Schritte sind eindeutig.',
    )),

    // ── Seite: Erstes Struktogramm ─────────────────────────────────────
    UeberschriftBlock('Dein erstes Struktogramm'),
    TextBlock(
      'So sieht der Tee als **Struktogramm** aus. Jeder Schritt steht in '
      'einem eigenen Kasten. Die Kästen liegen übereinander wie ein Stapel.',
    ),
    StruktogrammBlock(
      _tee,
      titel: 'Tee kochen',
      unterschrift: 'Du liest von oben nach unten. Oben ist der erste '
          'Schritt, unten der letzte.',
    ),
    TextBlock(
      'Schritte, die einfach nacheinander ablaufen, nennt man **Sequenz**. '
      'Das Wort bedeutet „Folge“.\n'
      '\n'
      'Mehr gibt es hier noch nicht zu wissen. Später kommen Kästen dazu, '
      'die etwas entscheiden oder wiederholen. Aber jedes Struktogramm '
      'liest du so: von oben nach unten, Kasten für Kasten.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-3',
      frage: 'In welcher Richtung liest du ein Struktogramm?',
      optionen: [
        'Von unten nach oben',
        'Von oben nach unten',
        'Von rechts nach links',
        'In beliebiger Reihenfolge',
      ],
      richtig: 1,
      erklaerung: 'Der oberste Kasten ist der erste Schritt. Dann geht es '
          'Kasten für Kasten nach unten, bis zum letzten.',
    )),

    // ── Seite: Eingabe und Ausgabe ─────────────────────────────────────
    UeberschriftBlock('Eingabe und Ausgabe'),
    TextBlock(
      'Tee kochen kann ein Computer nicht. Aber er kann mit dir reden. '
      'Dafür gibt es zwei Arten von Schritten:\n'
      '- **Ausgabe**: Der Computer zeigt etwas auf dem Bildschirm an.\n'
      '- **Eingabe**: Der Computer wartet, bis du etwas eintippst.\n'
      '\n'
      'Ein kleines Programm, das dich begrüßt:',
    ),
    StruktogrammBlock(
      _begruessung,
      titel: 'Begrüßung',
    ),
    TextBlock(
      'Achte auf die Anführungszeichen:\n'
      '- `Ausgabe "Hallo"` zeigt genau den Text **Hallo** an. '
      'Was in Anführungszeichen steht, erscheint Wort für Wort.\n'
      '- `Eingabe name` merkt sich, was du eintippst, unter dem Namen '
      '**name**. Stell dir einen Zettel vor, auf dem „name“ steht. '
      'Darauf schreibt der Computer deine Antwort.\n'
      '- `Ausgabe name` hat **keine** Anführungszeichen. Deshalb erscheint '
      'nicht das Wort „name“, sondern das, was auf dem Zettel steht.\n'
      '\n'
      'Tippst du „Lena“ ein, steht auf dem Bildschirm erst **Hallo** und '
      'dann **Lena**. Wie solche Zettel genau funktionieren, lernst du in '
      'Lektion 2.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-4',
      frage: 'Beim Programm „Begrüßung“ tippt jemand „Tom“ ein. '
          'Was steht danach auf dem Bildschirm?',
      optionen: [
        'Erst name, dann Hallo',
        'Erst Hallo, dann name',
        'Erst Tom, dann Hallo',
        'Erst Hallo, dann Tom',
      ],
      richtig: 3,
      erklaerung: 'Zuerst kommt `Ausgabe "Hallo"`, also das Wort Hallo. '
          'Danach `Ausgabe name` ohne Anführungszeichen. Das zeigt den '
          'Inhalt des Zettels an, also Tom.',
    )),

    // ── Seite: Reihenfolge ─────────────────────────────────────────────
    UeberschriftBlock('Die Reihenfolge zählt'),
    TextBlock(
      'Hier steht die Eingabe zu spät, nämlich ganz am Ende:',
    ),
    StruktogrammBlock(
      _begruessungFalsch,
      titel: 'Begrüßung mit Fehler',
    ),
    TextBlock(
      'Der Computer will den Namen anzeigen, bevor jemand ihn eingetippt '
      'hat. Der Zettel „name“ ist noch leer. Also erscheint nach Hallo '
      'nichts Sinnvolles.\n'
      '\n'
      'Merke dir: Etwas kann erst **ausgegeben** werden, wenn es vorher '
      '**eingegeben** wurde.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-1-5',
      frage: 'Das Programm soll erst nach der Lieblingsfarbe fragen, dann '
          'die Antwort einlesen und danach „Du magst:“ und die Farbe '
          'anzeigen. Bring die Kästen in die richtige Reihenfolge.',
      zeilen: [
        'Ausgabe "Welche Farbe magst du?"',
        'Eingabe farbe',
        'Ausgabe "Du magst:"',
        'Ausgabe farbe',
      ],
      erklaerung: 'Zuerst die Frage, damit man weiß, was man eintippen '
          'soll. Dann die Eingabe. Erst danach kann die Farbe angezeigt '
          'werden, weil sie vorher noch gar nicht bekannt ist.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 1'),
    HinweisBlock(
      '- Ein **Ablauf** ist eine Folge von Schritten.\n'
      '- Ein **Algorithmus** ist eine so genaue Anleitung, dass auch ein '
      'Computer sie ausführen kann.\n'
      '- Im **Struktogramm** steht jeder Schritt in einem Kasten. '
      'Du liest von oben nach unten.\n'
      '- Schritte nacheinander heißen **Sequenz**.\n'
      '- **Ausgabe** zeigt etwas an, **Eingabe** liest etwas ein.\n'
      '- Text in Anführungszeichen erscheint genau so. Ein Name ohne '
      'Anführungszeichen steht für seinen Inhalt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-1-6',
      frage: 'Was ist eine Sequenz?',
      optionen: [
        'Schritte, die nacheinander ablaufen',
        'Ein Schritt, der etwas entscheidet',
        'Ein Schritt, der sich wiederholt',
        'Ein Fehler im Struktogramm',
      ],
      richtig: 0,
      erklaerung: 'Sequenz heißt Folge. Die Schritte laufen einfach '
          'nacheinander ab, von oben nach unten. Entscheiden und '
          'Wiederholen lernst du in den nächsten Lektionen.',
    )),
  ],
);
