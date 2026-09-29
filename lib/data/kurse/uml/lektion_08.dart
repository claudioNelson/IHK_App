// lib/data/kurse/uml/lektion_08.dart
//
// UML-Kurs der App, Lektion 8: Aktivitätsdiagramm.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig) und Fable (29.09.2026), eingearbeitet.

import 'dart:ui' show Offset;

import '../../../models/kurs_aufgabe.dart';
import '../../../models/uml.dart';

const _ablauf = UmlDiagramm(
  breite: 300,
  hoehe: 285,
  beschreibung: 'Start, drei Aktionen nacheinander: Rad auswählen, Zeitraum wählen, Bezahlen, dann Ende.',
  elemente: [
    UmlStart(x: 150, y: 15),
    UmlAktion(x: 75, y: 45, b: 150, text: 'Rad auswählen'),
    UmlAktion(x: 75, y: 115, b: 150, text: 'Zeitraum wählen'),
    UmlAktion(x: 75, y: 185, b: 150, text: 'Bezahlen'),
    UmlEnde(x: 150, y: 262),
    UmlPfeil(punkte: [Offset(150, 24), Offset(150, 45)]),
    UmlPfeil(punkte: [Offset(150, 85), Offset(150, 115)]),
    UmlPfeil(punkte: [Offset(150, 155), Offset(150, 185)]),
    UmlPfeil(punkte: [Offset(150, 225), Offset(150, 251)]),
  ],
);

const _entscheidung = UmlDiagramm(
  breite: 460,
  hoehe: 325,
  beschreibung: 'Nach Verfügbarkeit prüfen folgt eine Entscheidung: bei Rad frei Buchung anlegen, bei Rad belegt Hinweis anzeigen. Beide Wege treffen sich in einer Raute vor dem Ende.',
  elemente: [
    UmlStart(x: 230, y: 15),
    UmlAktion(x: 155, y: 45, b: 150, text: 'Verfügbarkeit prüfen'),
    UmlRaute(x: 230, y: 120),
    UmlAktion(x: 35, y: 160, b: 150, text: 'Buchung anlegen'),
    UmlAktion(x: 275, y: 160, b: 150, text: 'Hinweis anzeigen'),
    UmlRaute(x: 230, y: 240),
    UmlEnde(x: 230, y: 300),
    UmlPfeil(punkte: [Offset(230, 24), Offset(230, 45)]),
    UmlPfeil(punkte: [Offset(230, 85), Offset(230, 104)]),
    UmlPfeil(punkte: [Offset(214, 120), Offset(110, 120), Offset(110, 160)], text: '[Rad frei]'),
    UmlPfeil(punkte: [Offset(246, 120), Offset(350, 120), Offset(350, 160)], text: '[Rad belegt]'),
    UmlPfeil(punkte: [Offset(110, 200), Offset(110, 240), Offset(214, 240)]),
    UmlPfeil(punkte: [Offset(350, 200), Offset(350, 240), Offset(246, 240)]),
    UmlPfeil(punkte: [Offset(230, 256), Offset(230, 289)]),
  ],
);

const _schleife = UmlDiagramm(
  breite: 400,
  hoehe: 330,
  beschreibung: 'Schleife: Nach Artikel scannen folgt eine Raute. Bei weitere Artikel geht der Pfeil zurück vor Artikel scannen, bei keine weiteren zu Summe anzeigen.',
  elemente: [
    UmlStart(x: 170, y: 15),
    UmlRaute(x: 170, y: 55),
    UmlAktion(x: 95, y: 90, b: 150, text: 'Artikel scannen'),
    UmlRaute(x: 170, y: 175),
    UmlAktion(x: 95, y: 225, b: 150, text: 'Summe anzeigen'),
    UmlEnde(x: 170, y: 305),
    UmlPfeil(punkte: [Offset(170, 24), Offset(170, 39)]),
    UmlPfeil(punkte: [Offset(170, 71), Offset(170, 90)]),
    UmlPfeil(punkte: [Offset(170, 130), Offset(170, 159)]),
    UmlPfeil(punkte: [Offset(186, 175), Offset(330, 175), Offset(330, 55), Offset(186, 55)], text: '[weitere Artikel]'),
    UmlPfeil(punkte: [Offset(170, 191), Offset(170, 225)], text: '[keine weiteren]'),
    UmlPfeil(punkte: [Offset(170, 265), Offset(170, 294)]),
  ],
);

const _parallel = UmlDiagramm(
  breite: 460,
  hoehe: 345,
  beschreibung: 'Nach Bestellung bestätigen teilt ein Balken den Ablauf: Ware verpacken und Rechnung erstellen laufen gleichzeitig. Ein zweiter Balken führt sie zusammen, dann Ware versenden.',
  elemente: [
    UmlStart(x: 230, y: 15),
    UmlAktion(x: 140, y: 45, b: 180, text: 'Bestellung bestätigen'),
    UmlBalken(x1: 90, x2: 370, y: 110),
    UmlAktion(x: 75, y: 140, b: 150, text: 'Ware verpacken'),
    UmlAktion(x: 235, y: 140, b: 150, text: 'Rechnung erstellen'),
    UmlBalken(x1: 90, x2: 370, y: 210),
    UmlAktion(x: 155, y: 240, b: 150, text: 'Ware versenden'),
    UmlEnde(x: 230, y: 320),
    UmlPfeil(punkte: [Offset(230, 24), Offset(230, 45)]),
    UmlPfeil(punkte: [Offset(230, 85), Offset(230, 108)]),
    UmlPfeil(punkte: [Offset(150, 112), Offset(150, 140)]),
    UmlPfeil(punkte: [Offset(310, 112), Offset(310, 140)]),
    UmlPfeil(punkte: [Offset(150, 180), Offset(150, 208)]),
    UmlPfeil(punkte: [Offset(310, 180), Offset(310, 208)]),
    UmlPfeil(punkte: [Offset(230, 212), Offset(230, 240)]),
    UmlPfeil(punkte: [Offset(230, 280), Offset(230, 309)]),
  ],
);

const _bahnen = UmlDiagramm(
  breite: 480,
  hoehe: 380,
  beschreibung: 'Zwei Schwimmbahnen: links Kunde mit Rad wählen und Bestätigung lesen, rechts Verleih-System mit Verfügbarkeit prüfen und Buchung speichern.',
  elemente: [
    UmlRahmen(x: 10, y: 10, b: 230, h: 360, titel: 'Kunde'),
    UmlRahmen(x: 240, y: 10, b: 230, h: 360, titel: 'Verleih-System'),
    UmlStart(x: 125, y: 55),
    UmlAktion(x: 50, y: 80, b: 150, text: 'Rad wählen'),
    UmlAktion(x: 280, y: 80, b: 170, text: 'Verfügbarkeit prüfen'),
    UmlAktion(x: 280, y: 160, b: 170, text: 'Buchung speichern'),
    UmlAktion(x: 50, y: 240, b: 150, text: 'Bestätigung lesen'),
    UmlEnde(x: 125, y: 330),
    UmlPfeil(punkte: [Offset(125, 64), Offset(125, 80)]),
    UmlPfeil(punkte: [Offset(200, 100), Offset(280, 100)]),
    UmlPfeil(punkte: [Offset(365, 120), Offset(365, 160)]),
    UmlPfeil(punkte: [Offset(365, 200), Offset(365, 260), Offset(200, 260)]),
    UmlPfeil(punkte: [Offset(125, 280), Offset(125, 319)]),
  ],
);

const _enden = UmlDiagramm(
  breite: 440,
  hoehe: 225,
  beschreibung: 'Nach einer Gabelung endet der linke Weg Hinweis anzeigen in einem Ablaufende, der rechte Weg Bestellung abschließen im Endknoten.',
  elemente: [
    UmlStart(x: 220, y: 15),
    UmlBalken(x1: 70, x2: 370, y: 45),
    UmlAktion(x: 45, y: 75, b: 150, text: 'Hinweis anzeigen'),
    UmlAktion(x: 245, y: 75, b: 150, text: 'Bestellung abschließen'),
    UmlAblaufende(x: 120, y: 170),
    UmlEnde(x: 320, y: 170),
    UmlPfeil(punkte: [Offset(220, 24), Offset(220, 43)]),
    UmlPfeil(punkte: [Offset(120, 47), Offset(120, 75)]),
    UmlPfeil(punkte: [Offset(320, 47), Offset(320, 75)]),
    UmlPfeil(punkte: [Offset(120, 115), Offset(120, 160)]),
    UmlPfeil(punkte: [Offset(320, 115), Offset(320, 159)]),
    UmlText(x: 120, y: 188, text: 'Ablaufende', ausrichtung: 0),
    UmlText(x: 320, y: 188, text: 'Endknoten', ausrichtung: 0),
  ],
);
const umlLektion8 = Lektion(
  nr: 8,
  slug: 'uml-8-aktivitaet',
  titel: 'Das Aktivitätsdiagramm',
  kurzbeschreibung:
      'Abläufe Schritt für Schritt zeichnen: Start und Ende, Aktionen, '
      'Entscheidungen mit Bedingungen, Schleifen, parallele Schritte und '
      'Schwimmbahnen.',
  dauerMinuten: 25,
  bloecke: [
    // ── Seite: Rezept ──────────────────────────────────────────────────
    UeberschriftBlock('Ein Ablauf wie ein Rezept'),
    TextBlock(
      'Ein Rezept sagt dir, was du in welcher Reihenfolge tun musst: erst '
      'Wasser kochen, dann Nudeln hinein, dann abgießen. Manchmal gibt es '
      'eine Entscheidung: „Wenn die Nudeln noch hart sind, zwei Minuten '
      'weiterkochen.“\n'
      '\n'
      'Genau so einen Ablauf zeigt das **Aktivitätsdiagramm**. Es beantwortet '
      'die Frage: **Welche Schritte passieren in welcher Reihenfolge?** Wenn '
      'du den Struktogramm-Kurs kennst: Es ist dieselbe Idee, nur mit anderen '
      'Zeichen.\n'
      '\n'
      'Hier ist der einfachste Fall, das Buchen eines Lastenrads:',
    ),
    UmlBlock(
      _ablauf,
      unterschrift: 'Oben startet der Ablauf, unten endet er. Dazwischen drei '
          'Schritte.',
    ),
    TextBlock(
      'Vier Zeichen reichen dafür:\n'
      '- Der **gefüllte Kreis** oben ist der **Startknoten**. Hier beginnt '
      'der Ablauf.\n'
      '- Jedes abgerundete Rechteck ist eine **Aktion**, also ein Schritt. '
      'Der Name beschreibt, was getan wird, oft als Nomen plus Verb wie „Rad '
      'auswählen“. Manchmal reicht ein Verb wie „Bezahlen“.\n'
      '- Die **Pfeile** zeigen, was als Nächstes kommt. Sie heißen '
      '**Kontrollfluss**.\n'
      '- Der Kreis mit Punkt unten ist der **Endknoten**. Hier ist der Ablauf '
      'fertig.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-1',
      frage: 'Wie wird im Aktivitätsdiagramm ein einzelner Schritt '
          'gezeichnet, zum Beispiel „Bezahlen“?',
      optionen: [
        'Als Oval',
        'Als abgerundetes Rechteck',
        'Als Raute',
        'Als Strichmännchen',
      ],
      richtig: 1,
      erklaerung: 'Eine Aktion ist ein abgerundetes Rechteck. Ovale gehören '
          'zum Use-Case-Diagramm, die Raute steht für eine Entscheidung.',
    )),

    // ── Seite: Entscheidung ────────────────────────────────────────────
    UeberschriftBlock('Entscheidungen'),
    TextBlock(
      'Was, wenn das Rad schon belegt ist? Dann teilt sich der Weg:',
    ),
    UmlBlock(
      _entscheidung,
      unterschrift: 'Die obere Raute teilt den Weg, die untere führt ihn '
          'wieder zusammen.',
    ),
    TextBlock(
      '- Die **Raute** ist eine **Entscheidung**. Ein Pfeil kommt hinein, '
      'mehrere gehen hinaus.\n'
      '- An jedem ausgehenden Pfeil steht in **eckigen Klammern** die '
      'Bedingung, wann dieser Weg genommen wird: `[Rad frei]` oder `[Rad '
      'belegt]`. So eine Bedingung heißt **Wächter**.\n'
      '- Die Bedingungen müssen sich **ausschließen**, und zusammen müssen '
      'sie **alle Fälle** abdecken. Es darf nie unklar sein, welcher Weg '
      'gilt. Oft schreibt man deshalb beim zweiten Weg einfach `[sonst]`, '
      'in vielen Prüfungsvorlagen englisch `[else]`.\n'
      '- Unten treffen sich die Wege wieder in einer Raute. Sie heißt '
      '**Zusammenführung**: mehrere Pfeile hinein, einer hinaus.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-2',
      frage: 'Wie schreibt man eine Bedingung an einen Pfeil nach einer '
          'Raute richtig?',
      optionen: [
        '„Rad frei“',
        '[Rad frei]',
        '(Rad frei)',
        '«Rad frei»',
      ],
      richtig: 1,
      erklaerung: 'Bedingungen stehen in eckigen Klammern. Die spitzen '
          'Klammern «…» sind für Stereotypen wie «include».',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-3',
      frage: 'Nach einer Raute stehen die Bedingungen `[alter > 18]` und '
          '`[alter < 18]`. Was ist das Problem?',
      optionen: [
        'Es gibt kein Problem.',
        'Für genau 18 gilt keine der beiden Bedingungen.',
        'Bedingungen dürfen keine Zahlen enthalten.',
        'Es dürfen nur drei Pfeile aus einer Raute kommen.',
      ],
      richtig: 1,
      erklaerung: 'Bei alter = 18 ist weder „größer“ noch „kleiner“ wahr. Die '
          'Bedingungen müssen alle Fälle abdecken, richtig wäre zum Beispiel '
          '`[alter >= 18]` und `[sonst]`.',
    )),

    // ── Seite: Schleife ────────────────────────────────────────────────
    UeberschriftBlock('Schleifen'),
    TextBlock(
      'An der Supermarktkasse wird ein Artikel nach dem anderen gescannt, bis '
      'keiner mehr übrig ist. Ein Schritt wiederholt sich also. Im '
      'Aktivitätsdiagramm gibt es dafür kein eigenes Zeichen. Man führt '
      'einfach einen Pfeil **zurück nach oben**:',
    ),
    UmlBlock(
      _schleife,
      unterschrift: 'Solange es weitere Artikel gibt, geht es zurück zu '
          '„Artikel scannen“.',
    ),
    TextBlock(
      'Die untere Raute entscheidet: weitermachen oder aufhören. Der Pfeil '
      'zurück endet an der oberen Raute, einer Zusammenführung. Dort treffen '
      'sich der Weg vom Start und der Weg zurück.\n'
      '\n'
      'In Prüfungslösungen zeigt der Pfeil zurück oft direkt auf „Artikel '
      'scannen“, ohne Raute. Beides ist richtig.',
    ),
    UmlBlock(_schleife, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-4',
      frage: 'Es werden drei Artikel gekauft. Wie oft wird „Artikel scannen“ '
          'ausgeführt?',
      optionen: ['Einmal', 'Zweimal', 'Dreimal', 'Viermal'],
      richtig: 2,
      erklaerung: 'Nach dem ersten und zweiten Scan gibt es noch weitere '
          'Artikel, also zurück. Nach dem dritten nicht mehr. Das sind drei '
          'Durchläufe.',
    )),

    // ── Seite: Parallel ────────────────────────────────────────────────
    UeberschriftBlock('Gleichzeitig: Gabelung und Vereinigung'),
    TextBlock(
      'Ist eine Bestellung bestätigt, packt das Lager die Ware, und '
      'gleichzeitig schreibt die Buchhaltung die Rechnung. Keiner muss auf '
      'den anderen warten. Erst wenn **beides** fertig ist, wird verschickt.',
    ),
    UmlBlock(
      _parallel,
      unterschrift: 'Oberer Balken: Gabelung. Unterer Balken: Vereinigung.',
    ),
    TextBlock(
      '- Der obere dicke **Balken** ist eine **Gabelung**. Ein Pfeil kommt '
      'hinein, mehrere gehen hinaus. Alle Wege laufen **gleichzeitig** los.\n'
      '- Der untere Balken ist eine **Vereinigung**. Es geht erst weiter, wenn '
      '**alle** Wege angekommen sind.\n'
      '\n'
      'Vorsicht, Verwechslungsgefahr: Bei der **Raute** wird **ein** Weg '
      'gewählt. Beim **Balken** laufen **alle** Wege.\n'
      '\n'
      'Beide Balken zusammen heißen auch **Synchronisationsbalken**.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-5',
      frage: 'Was ist der Unterschied zwischen Raute und Balken?',
      optionen: [
        'Keiner, beide teilen den Weg.',
        'Nach der Raute wird genau ein Weg gewählt, nach dem Balken laufen '
            'alle Wege gleichzeitig.',
        'Nach dem Balken wird genau ein Weg gewählt, nach der Raute laufen '
            'alle gleichzeitig.',
        'Die Raute beendet den Ablauf.',
      ],
      richtig: 1,
      erklaerung: 'Die Raute ist eine Entscheidung: ein Weg. Der Balken ist '
          'eine Gabelung: alle Wege gleichzeitig.',
    )),
    UmlBlock(_parallel, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-6',
      frage: 'Die Rechnung ist fertig, die Ware wird noch verpackt. Was '
          'passiert?',
      optionen: [
        'Die Ware wird sofort versendet.',
        'Der Ablauf endet.',
        'Es wird gewartet, bis auch die Ware verpackt ist.',
        'Die Rechnung wird noch einmal erstellt.',
      ],
      richtig: 2,
      erklaerung: 'An der Vereinigung geht es erst weiter, wenn alle Wege '
          'angekommen sind. Also wird auf das Verpacken gewartet.',
    )),

    // ── Seite: Schwimmbahnen ───────────────────────────────────────────
    UeberschriftBlock('Schwimmbahnen: wer macht was?'),
    TextBlock(
      'Oft machen verschiedene Beteiligte verschiedene Schritte. Dann teilt '
      'man das Diagramm in Spalten auf, wie die Bahnen im Schwimmbad. Oben '
      'steht, wer in dieser Bahn arbeitet. Jede Aktion steht in der Bahn '
      'dessen, der sie ausführt:',
    ),
    UmlBlock(
      _bahnen,
      unterschrift: 'Links arbeitet der Kunde, rechts das Verleih-System.',
    ),
    TextBlock(
      'Diese Bahnen heißen **Schwimmbahnen** oder **Partitionen**. Die Pfeile '
      'dürfen von einer Bahn in die andere laufen. So sieht man auf einen '
      'Blick, wann die Arbeit den Besitzer wechselt.',
    ),
    UmlBlock(_bahnen, zurAufgabe: true),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-7',
      frage: 'Im Diagramm mit Schwimmbahnen: Wer führt „Buchung speichern“ '
          'aus?',
      optionen: ['Der Kunde', 'Das Verleih-System', 'Beide', 'Niemand'],
      richtig: 1,
      erklaerung: '„Buchung speichern“ steht in der rechten Bahn, also führt '
          'das Verleih-System die Aktion aus.',
    )),

    // ── Seite: Zwei Enden ──────────────────────────────────────────────
    UeberschriftBlock('Zwei Arten von Ende'),
    TextBlock(
      'Du kennst den Endknoten: Kreis mit Punkt. Er beendet den **ganzen** '
      'Ablauf, auch wenn gerade noch andere Wege parallel laufen.\n'
      '\n'
      'Daneben gibt es das **Ablaufende**: ein Kreis mit einem **Kreuz**. Es '
      'beendet nur **diesen einen** Weg. Andere parallele Wege laufen weiter. '
      'In Prüfungen kommt es selten vor, du solltest es aber erkennen.',
    ),
    UmlBlock(
      _enden,
      unterschrift: 'Links endet nur der Weg „Hinweis anzeigen“. Rechts endet '
          'der ganze Ablauf.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'uml-8-8',
      frage: 'Ergänze.',
      vorlage: 'Der Startknoten ist ein gefüllter ___. Das Ablaufende ist ein '
          'Kreis mit einem ___.',
      loesungen: [
        ['Kreis'],
        ['Kreuz'],
      ],
      bausteine: ['Kreis', 'Kreuz', 'Balken', 'Raute'],
      erklaerung: 'Start: gefüllter Kreis. Ende des ganzen Ablaufs: Kreis mit '
          'Punkt. Ende nur eines Weges: Kreis mit Kreuz.',
    )),

    // ── Seite: Aus Text ────────────────────────────────────────────────
    UeberschriftBlock('Vom Aufgabentext zum Ablauf'),
    TextBlock(
      'In der Prüfung steht ein Text wie dieser:\n'
      '\n'
      '„Der Kunde steckt seine Karte in den Automaten und gibt die PIN ein. '
      'Ist die PIN falsch, wird die Karte ausgegeben. Ist sie richtig, wählt '
      'der Kunde den Betrag, und das Geld wird ausgegeben.“\n'
      '\n'
      'So gehst du vor: Jedes Verb wird eine Aktion. Jedes „wenn“, „falls“ '
      'oder ein Satz wie „Ist die PIN falsch, …“ wird eine Raute mit '
      'Bedingungen. „Gleichzeitig“, „während“ oder „parallel“ wird ein '
      'Balken. „Solange“ oder „bis“ wird ein Pfeil zurück.',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'uml-8-9',
      frage: 'Bring die Elemente für den Fall „PIN richtig“ in die Reihenfolge '
          'des Ablaufs.',
      zeilen: [
        'Startknoten',
        'Karte einstecken',
        'PIN eingeben',
        'Raute mit [PIN richtig] und [PIN falsch]',
        'Betrag wählen',
        'Geld ausgeben',
        'Endknoten',
      ],
      erklaerung: 'Erst Karte und PIN, dann die Entscheidung. Auf dem Weg '
          '[PIN richtig] folgen Betrag wählen und Geld ausgeben, danach das '
          'Ende.',
    )),

    // ── Seite: Zusammenfassung ─────────────────────────────────────────
    UeberschriftBlock('Das Wichtigste aus Lektion 8'),
    HinweisBlock(
      '- **Startknoten**: gefüllter Kreis. **Endknoten**: Kreis mit Punkt. '
      '**Ablaufende**: Kreis mit Kreuz.\n'
      '- **Aktion**: abgerundetes Rechteck, Pfeile zeigen die Reihenfolge.\n'
      '- **Raute**: Entscheidung mit `[Bedingungen]`, die sich ausschließen '
      'und alles abdecken. Auch Zusammenführung.\n'
      '- **Schleife**: Pfeil zurück zu einer Raute weiter oben.\n'
      '- **Balken**: Gabelung und Vereinigung, alle Wege gleichzeitig.\n'
      '- **Schwimmbahnen**: wer welche Aktion ausführt.',
    ),
    AufgabenBlock(AuswahlAufgabe(
      id: 'uml-8-10',
      frage: 'Text: „Während der Server die Datei speichert, zeigt die App '
          'bereits eine Vorschau an.“ Welches Element brauchst du?',
      optionen: [
        'Eine Raute mit zwei Bedingungen',
        'Eine Gabelung mit Balken',
        'Einen Pfeil zurück nach oben',
        'Ein Ablaufende',
      ],
      richtig: 1,
      erklaerung: '„Während“ bedeutet gleichzeitig. Dafür gibt es die '
          'Gabelung mit Balken, später wieder vereint.',
    )),
  ],
);
