// lib/data/kurse/struktogramm/lektion_10.dart
//
// Struktogramm-Kurs der App, Lektion 10. Reine Daten, gezeichnet vom
// LektionScreen. Kursplan und Schreibregeln: PROJECT_STATE.md, Eintrag
// „Struktogramm-Kurs in der App“ (10 Lektionen, Start bei null).

import '../../../models/kurs_aufgabe.dart';
import '../../../models/struktogramm.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 10: Prüfungstraining
// ═══════════════════════════════════════════════════════════════════════════
// Drei Aufgaben im Stil der AP1 (aus Web-Lektion 8), umgebaut auf die
// Aufgabentypen der App: Schreibtischtest als Lücken, Fehlersuche, Lücken
// ergänzen, Reihenfolge. Zeichenaufgaben verweisen auf Papier.
// Autor Opus 5.5 (27.09.2026), Gutachten Sonnet (vorläufig), Fable offen.

const _nachbestellung = <SgBlock>[
  SgAnw('Eingabe minimum'),
  SgAnw('anzahl = 0'),
  SgAnw('fehlmenge = 0'),
  SgFuer('für i = 1 bis 4', [
    SgWenn('bestand[i] < minimum', [
      SgAnw('anzahl = anzahl + 1'),
      SgAnw('fehlmenge = fehlmenge + (minimum - bestand[i])'),
    ]),
  ]),
  SgWenn(
    'anzahl == 0',
    [SgAnw('Ausgabe "Alles ausreichend"')],
    [SgAnw('Ausgabe anzahl, fehlmenge')],
  ),
];

const _parkhaus = <SgBlock>[
  SgAnw('Eingabe minuten'),
  SgAnw('Eingabe kundenart'),
  SgAnw('stunden = minuten DIV 60'),
  SgWenn('(1)', [SgAnw('stunden = stunden + 1')]),
  SgFalls(
    'kundenart',
    [
      SgFall('"K"', [SgAnw('satz = 3')]),
      SgFall('"D"', [SgLuecke('2')]),
      SgFall('"M"', [SgAnw('satz = 0')]),
    ],
    sonst: [
      SgAnw('Ausgabe "Unbekannt"'),
      SgAnw('satz = 0'),
    ],
  ),
  SgAnw('gebuehr = stunden * satz'),
  SgWenn('gebuehr > 20', [SgLuecke('3')]),
  SgAnw('Ausgabe gebuehr'),
];

const struktogrammLektion10 = Lektion(
  nr: 10,
  slug: 'struktogramm-10-pruefungstraining',
  titel: 'Prüfungstraining',
  kurzbeschreibung:
      'Drei Aufgaben wie in der AP1: Schreibtischtest und Fehlersuche, '
      'Lücken ergänzen, eine Funktion entwerfen. Mit Vorgehen und '
      'typischen Punktabzügen.',
  dauerMinuten: 60,
  bloecke: [
    // ── Seite: Aufgabentypen ───────────────────────────────────────────
    UeberschriftBlock('Was dich in der Prüfung erwartet'),
    TextBlock(
      'In der AP1 kommt oft eine Aufgabe mit einem Struktogramm oder '
      'Pseudocode. An der Formulierung erkennst du, was verlangt ist:',
    ),
    SchreibtischtestBlock(
      spalten: ['So steht es in der Aufgabe', 'Was du tun sollst'],
      zeilen: [
        ['„Ermitteln Sie die Ausgabe …“', 'Ablauf lesen, Ergebnis nennen'],
        ['„Führen Sie einen Schreibtischtest durch …“', 'Wertetabelle '
            'Schritt für Schritt'],
        ['„Ergänzen Sie das Struktogramm …“', 'Lücken füllen'],
        ['„Finden und korrigieren Sie den Fehler …“', 'Fehlersuche mit der '
            'Prüfliste aus Lektion 9'],
        ['„Entwerfen Sie den Algorithmus …“', 'selbst zeichnen oder '
            'Pseudocode schreiben'],
      ],
      aenderungenMarkieren: false,
    ),
    TextBlock(
      'Bewertet wird in kleinen Portionen: ein Punkt für den Startwert, '
      'einer für die richtige Schleife, einer für die Bedingung, einer für '
      'die Ausgabe an der richtigen Stelle. Wer die Form beherrscht, sammelt '
      'diese Punkte auch dann, wenn nicht alles perfekt ist. Andere '
      'richtige Lösungen zählen ebenfalls.\n'
      '\n'
      'Die Punkte in dieser Lektion sind Richtwerte. Wie die Punkte '
      'tatsächlich verteilt werden, legt die jeweilige Prüfung fest.',
    ),

    // ── Seite: Vorgehen ────────────────────────────────────────────────
    UeberschriftBlock('Vorgehen in sechs Schritten'),
    TextBlock(
      'Prüfungsaufgaben sind selten schwer, aber oft lang. Mit einem festen '
      'Vorgehen verlierst du keine Punkte, die du eigentlich sicher hast:\n'
      '- **Text lesen und Wörter markieren**: „wie viele“, „der größte“, '
      '„bis die Eingabe gültig ist“. Dazu alle Zahlen: Anzahl, Grenzen, und '
      'ob der Index bei 0 oder 1 beginnt.\n'
      '- **Variablen und Startwerte notieren**: 0 für Summe und Zähler, das '
      'erste Fach für das Maximum, falsch für einen Merker.\n'
      '- **Muster erkennen**: Fast jede Aufgabe ist eines der Muster aus '
      'Lektion 7 oder eine Kombination.\n'
      '- **Form zeichnen**: erst die groben Kästen, dann die Details.\n'
      '- **Schreibtischtest** mit einem kleinen Beispiel. Achte besonders auf '
      'den ersten und letzten Durchlauf.\n'
      '- **Zeit einteilen**: etwa eine Minute pro Punkt. Hängst du fest, mach '
      'mit der nächsten Teilaufgabe weiter.',
    ),

    // ── Aufgabe 1 ──────────────────────────────────────────────────────
    UeberschriftBlock('Aufgabe 1: Getränkehandel'),
    TextBlock(
      'Ein Getränkehandel prüft jeden Abend, welche Artikel nachbestellt '
      'werden müssen. Die Bestände von fünf Artikeln stehen im Feld '
      '`bestand`. **Das erste Fach hat hier den Index 0**, das letzte den '
      'Index 4.\n'
      '\n'
      'Ein Mindestbestand `minimum` wird eingegeben. Gezählt wird, wie viele '
      'Artikel darunter liegen und wie viele Stück insgesamt fehlen. Liegt '
      'kein Artikel darunter, erscheint „Alles ausreichend“.\n'
      '\n'
      'Ein Azubi hat dieses Struktogramm entworfen:',
    ),
    StruktogrammBlock(
      _nachbestellung,
      titel: 'Nachbestellung',
    ),
    TextBlock(
      'Merke dir die Schleife „für i = 1 bis 4“. Die nächsten Aufgaben '
      'beziehen sich auf dieses Struktogramm.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-10-1',
      frage: 'Teil a) Schreibtischtest, etwa 10 Punkte. Zur Erinnerung: '
          'Für i von 1 bis 4 wird geprüft, ob bestand[i] kleiner als minimum '
          'ist. Wenn ja, wird anzahl um 1 erhöht und minimum - bestand[i] zu '
          'fehlmenge addiert. Ist anzahl am Ende 0, erscheint „Alles '
          'ausreichend“, sonst anzahl und fehlmenge. Führe das genau so aus. '
          'Das Feld ist bestand = 30, 8, 15, 4, 12 (Index 0 bis 4), minimum '
          'ist 10. Welche Werte werden ausgegeben?',
      vorlage: 'anzahl    = ___\n'
          'fehlmenge = ___',
      loesungen: [
        ['2'],
        ['8'],
      ],
      erklaerung: 'Geprüft werden bestand[1] bis bestand[4], also 8, 15, 4, '
          '12. Unter 10 liegen die 8 (fehlt 2) und die 4 (fehlt 6). anzahl '
          'ist 2, fehlmenge ist 2 + 6 = 8. Die 30 in bestand[0] wird nie '
          'angeschaut, das ändert hier aber nichts.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-10-2',
      frage: 'Teil b) etwa 5 Punkte. Dasselbe Struktogramm „Nachbestellung“: '
          'Für i von 1 bis 4 zählt es, wie viele bestand[i] unter minimum '
          'liegen. Ist die Anzahl 0, erscheint „Alles ausreichend“, sonst '
          'anzahl und fehlmenge. Jetzt ist bestand = 20, 25, 11, 30, 18 und '
          'minimum 10. Was wird ausgegeben?',
      optionen: [
        '1, 0',
        'Alles ausreichend',
        '0, 0',
        '1, 1',
      ],
      richtig: 1,
      erklaerung: 'Geprüft werden 25, 11, 30, 18. Keiner liegt unter 10, auch '
          'die 11 nicht. anzahl bleibt 0, deshalb läuft nach der Schleife '
          'der Ja-Zweig: „Alles ausreichend“.',
    )),
    AufgabenBlock(FehlerAufgabe(
      id: 'struktogramm-10-3',
      frage: 'Teil c) etwa 10 Punkte. Für bestand = 3, 20, 20, 20, 20 und '
          'minimum 10 kommt „Alles ausreichend“, obwohl der erste Artikel nur '
          '3 Stück hat. Das Feld beginnt beim Index 0. Tippe die fehlerhafte '
          'Zeile an und korrigiere sie.',
      zeilen: [
        'EINGABE minimum',
        'anzahl = 0',
        'fehlmenge = 0',
        'FÜR i = 1 BIS 4',
        '    WENN bestand[i] < minimum DANN',
        '        anzahl = anzahl + 1',
        '        fehlmenge = fehlmenge + (minimum - bestand[i])',
        '    ENDE WENN',
        'ENDE FÜR',
      ],
      fehlerZeile: 3,
      korrekturen: [
        'FÜR i = 0 BIS 4',
        'FÜR i=0 BIS 4',
      ],
      tipp: 'Bei welchem Index beginnt das Feld, und bei welchem die '
          'Schleife?',
      erklaerung: 'Das Feld beginnt bei Index 0, die Schleife aber bei 1. '
          'bestand[0] wird nie geprüft. In a) und b) fiel das nicht auf, weil '
          'dort das erste Fach genug Bestand hatte. Richtig ist '
          '`FÜR i = 0 BIS 4`. Dann kommt hier 1 und 7 heraus.',
    )),

    // ── Seite: Aufgabe 1, Punktabzüge ──────────────────────────────────
    UeberschriftBlock('Aufgabe 1: typische Punktabzüge'),
    HinweisBlock(
      '- Im Schreibtischtest die Schleife bei 0 beginnen lassen, weil das '
      'richtiger wäre. Getestet wird das **gegebene** Struktogramm. Die '
      'Korrektur gehört erst in Teil c.\n'
      '- Die Fehlmenge falsch herum rechnen: bestand minus minimum ergibt '
      'Minuszahlen.\n'
      '- Die Ausgabe in jede Zeile der Tabelle schreiben statt nur dorthin, '
      'wo sie wirklich erreicht wird.\n'
      '- In c) nur „die Schleife ist falsch“ schreiben, ohne zu sagen, welches '
      'Fach fehlt und wie der Kopf richtig lautet.',
    ),

    // ── Aufgabe 2 ──────────────────────────────────────────────────────
    UeberschriftBlock('Aufgabe 2: Parkhaus'),
    TextBlock(
      'Ein Parkhaus rechnet am Automaten ab. Eingegeben werden die Parkdauer '
      'in Minuten und die Kundenart. Die Regeln:\n'
      '- Jede **angefangene** Stunde zählt. 61 Minuten sind 2 Stunden, genau '
      '60 Minuten sind 1 Stunde.\n'
      '- Kurzparker („K“) zahlen 3 Euro pro Stunde, Dauerparker („D“) 2 Euro, '
      'Mitarbeiter („M“) nichts.\n'
      '- Bei einer unbekannten Kundenart gibt es einen Hinweis und keine '
      'Gebühr.\n'
      '- Mehr als 20 Euro werden nie berechnet.\n'
      '\n'
      'Das Struktogramm hat drei Lücken:',
    ),
    StruktogrammBlock(
      _parkhaus,
      titel: 'Parkgebühr',
      unterschrift: 'Lücke (1) steht im Dreieck der ersten Verzweigung, '
          'Lücke (2) im Fall „D“, Lücke (3) im Ja-Zweig der letzten '
          'Verzweigung.',
    ),
    TextBlock(
      'Ein Tipp zu Lücke (1): `minuten DIV 60` zählt nur die **vollen** '
      'Stunden. Wann muss noch eine Stunde dazu? Denk an MOD aus Lektion 4.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-10-4',
      frage: 'Teil a) etwa 10 Punkte. Zur Erinnerung: Jede angefangene '
          'Stunde zählt voll. Kurzparker zahlen 3 Euro pro Stunde, '
          'Dauerparker 2 Euro, Mitarbeiter nichts. Mehr als 20 Euro werden '
          'nie berechnet. Ergänze die drei Lücken.',
      vorlage: 'stunden = minuten DIV 60\n'
          'WENN ___ DANN\n'
          '    stunden = stunden + 1\n'
          'ENDE WENN\n'
          '…\n'
          'FALL "D": ___\n'
          '…\n'
          'WENN gebuehr > 20 DANN\n'
          '    ___\n'
          'ENDE WENN',
      loesungen: [
        [
          'minuten MOD 60 > 0',
          'minuten MOD 60>0',
          'minuten MOD 60 != 0',
          'minuten MOD 60!=0',
          'minuten MOD 60 <> 0',
        ],
        ['satz = 2', 'satz=2'],
        ['gebuehr = 20', 'gebuehr=20', 'gebühr = 20', 'gebühr=20'],
      ],
      erklaerung: '(1) Bleibt beim Teilen durch 60 ein Rest, ist eine '
          'weitere Stunde angefangen: `minuten MOD 60 > 0`. (2) Dauerparker '
          'zahlen 2 Euro: `satz = 2`. (3) Mehr als 20 Euro werden nicht '
          'berechnet: `gebuehr = 20`.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-10-5',
      frage: 'Teil b) etwa 5 Punkte. Zur Erinnerung: Jede angefangene '
          'Stunde zählt voll. Kurzparker zahlen 3 Euro pro Stunde, '
          'Dauerparker 2 Euro. Mehr als 20 Euro werden nie berechnet. '
          'Wie viel Euro kostet es jeweils?',
      vorlage: '125 Minuten, Kurzparker:  ___ Euro\n'
          '500 Minuten, Kurzparker:  ___ Euro\n'
          ' 45 Minuten, Dauerparker: ___ Euro',
      loesungen: [
        ['9'],
        ['20'],
        ['2'],
      ],
      erklaerung: '125 Minuten: 125 DIV 60 = 2, Rest 5, also 3 Stunden. '
          '3 * 3 = 9 Euro. 500 Minuten: 500 DIV 60 = 8, Rest 20, also 9 '
          'Stunden. 9 * 3 = 27, das ist mehr als 20, also 20 Euro. '
          '45 Minuten: 0 volle Stunden, Rest 45, also 1 Stunde. 1 * 2 = 2 Euro.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-10-6',
      frage: 'Teil c) etwa 10 Punkte. Die Parkdauer soll nur weiterverarbeitet werden, wenn '
          'sie von 1 bis 1440 Minuten reicht. Sonst soll neu eingegeben '
          'werden. Welche Schleife um die Eingabe ist richtig?',
      optionen: [
        'WIEDERHOLE Eingabe BIS minuten >= 1 UND minuten <= 1440',
        'WIEDERHOLE Eingabe BIS minuten < 1 ODER minuten > 1440',
        'SOLANGE minuten < 1 UND minuten > 1440: Eingabe',
        'FÜR i = 1 BIS 1440: Eingabe',
      ],
      richtig: 0,
      erklaerung: 'Erst eingeben, dann prüfen: fußgesteuert. Bei BIS steht '
          'unten, wann Schluss ist, also wenn die Eingabe gültig ist. Die '
          'zweite Option hört genau bei einer ungültigen Eingabe auf. Die '
          'dritte Bedingung ist nie wahr, denn keine Zahl ist zugleich '
          'kleiner als 1 und größer als 1440.',
    )),

    // ── Aufgabe 3 ──────────────────────────────────────────────────────
    UeberschriftBlock('Aufgabe 3: Wetterstation'),
    TextBlock(
      'Eine Wetterstation speichert die Höchsttemperaturen eines Monats im '
      'Feld `temperaturen` mit n Werten. **Das erste Fach hat hier den '
      'Index 1**, der Index ist also der Tag im Monat.\n'
      '\n'
      'Ein **Frosttag** ist ein Tag unter 0 Grad. Gesucht ist eine Funktion '
      '`anzahlFrosttage(temperaturen: Feld, n: Ganzzahl): Ganzzahl`, die '
      'zurückgibt, wie viele Frosttage es gab.\n'
      '\n'
      'In der Prüfung zeichnest du so etwas selbst. Nimm dir dafür Papier '
      'und versuch es, bevor du weiterblätterst. Welches Muster ist es?',
    ),
    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'struktogramm-10-7',
      frage: 'Teil a) etwa 10 Punkte. Bring die Funktion '
          '`anzahlFrosttage` als Pseudocode in die richtige Reihenfolge.',
      zeilen: [
        'FUNKTION anzahlFrosttage(temperaturen: Feld, n: Ganzzahl): Ganzzahl',
        'anzahl = 0',
        'FÜR i = 1 BIS n',
        'WENN temperaturen[i] < 0 DANN',
        'anzahl = anzahl + 1',
        'ENDE WENN',
        'ENDE FÜR',
        'RÜCKGABE anzahl',
        'ENDE FUNKTION',
      ],
      einrueckung: [0, 1, 1, 2, 3, 2, 1, 1, 0],
      erklaerung: 'Es ist das Muster Zählen aus Lektion 7 als Funktion: '
          'Zähler vor der Schleife auf 0, Verzweigung im Rumpf, Rückgabe nach '
          'der Schleife. Eine Funktion gibt nichts aus, sie gibt das Ergebnis '
          'zurück.',
    )),
    AufgabenBlock(AuswahlAufgabe(
      id: 'struktogramm-10-8',
      frage: 'Teil b) etwa 5 Punkte. Genau 0 Grad ist kein Frosttag. Welche Bedingung gehört '
          'in die Verzweigung?',
      optionen: [
        'temperaturen[i] <= 0',
        'temperaturen[i] < 0',
        'temperaturen[i] == 0',
        'temperaturen[i] > 0',
      ],
      richtig: 1,
      erklaerung: '„Unter 0 Grad“ schließt die 0 nicht ein, also `< 0`. Mit '
          '`<= 0` würde ein Tag mit genau 0 Grad falsch mitgezählt.',
    )),
    AufgabenBlock(LueckenAufgabe(
      id: 'struktogramm-10-9',
      frage: 'Teil c) etwa 5 Punkte. Das Hauptprogramm ruft die Funktion auf '
          'und sucht außerdem den wärmsten Tag, wie das Maximum mit Position '
          'aus Lektion 7. Führe beides für temperaturen = 3, -2, 5, -1 '
          '(n = 4) durch.',
      vorlage: 'Frosttage:            ___\n'
          'wärmster Tag (Index):  ___\n'
          'Temperatur an dem Tag: ___',
      loesungen: [
        ['2'],
        ['3'],
        ['5'],
      ],
      erklaerung: 'Unter 0 liegen -2 und -1, das sind 2 Frosttage. Beim '
          'Maximum startet max mit 3 an Tag 1. -2 ist nicht größer, 5 ist '
          'größer (Tag 3), -1 nicht. Wärmster Tag ist Tag 3 mit 5 Grad.',
    )),

    // ── Seite: Abschluss ───────────────────────────────────────────────
    UeberschriftBlock('Geschafft'),
    TextBlock(
      'Wenn du bis hier gekommen bist, kannst du alles, was Struktogramm-'
      'Aufgaben in der AP1 typischerweise verlangen: ein Struktogramm mit '
      'dem Schreibtischtest sicher lesen, Fehler in Grenzen und Startwerten '
      'finden, Lücken füllen und die Grundmuster erkennen.\n'
      '\n'
      'Was jetzt noch fehlt, ist Übung im **Zeichnen**. Nimm dir eine '
      'Aufgabe aus dieser Lektion und zeichne das Struktogramm auf Papier, '
      'ohne nachzusehen. Wiederhole die Lektion, die dir am schwersten fiel, '
      'in ein paar Tagen noch einmal.',
    ),
    HinweisBlock(
      '- Signalwörter markieren, Index 0 oder 1 prüfen.\n'
      '- Startwerte zuerst: 0, erstes Fach oder falsch.\n'
      '- Muster erkennen: Summe, Durchschnitt, Maximum, Zählen, Suchen.\n'
      '- Grenzen genau lesen: „ab“, „bis“, „über“, „unter“.\n'
      '- Im Schreibtischtest das Gegebene ausführen, nicht das, was richtig '
      'wäre.\n'
      '- Jede Teilaufgabe zählt einzeln. Nie ganz leer lassen.',
    ),
  ],
);
