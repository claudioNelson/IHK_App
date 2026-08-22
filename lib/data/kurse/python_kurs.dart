// lib/data/kurse/python_kurs.dart
//
// Inhalt des Python-Kurses. Reine Daten, kein Layout, keine Widgets.
// Läuft auf derselben Engine wie der SQL-Kurs (models/kurs_aufgabe.dart).
//
// WICHTIG: Python wird in der App NICHT ausgeführt. Alle Aufgaben sind
// Lückentexte, Reihenfolgen, Fehlersuchen und Auswahlfragen. Das Vorhersagen
// von Ausgaben ("Was gibt dieses Programm aus?") ersetzt das Ausführen und
// prüft das Verständnis oft sogar strenger.
//
// Tonfall wie im SQL-Kurs: direkt, kein Fachjargon ohne Erklärung.
// Roter Faden: die Nordwind GmbH aus dem SQL-Kurs, diesmal aus Sicht
// der kleinen Programme, die dort im Alltag laufen.

import '../../models/kurs_aufgabe.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 1 — Dein erstes Programm
// ═══════════════════════════════════════════════════════════════════════════

const _lektion1 = Lektion(
  nr: 1,
  slug: 'python-1',
  titel: 'Dein erstes Programm',
  kurzbeschreibung:
      'Was ein Programm ist, print() und der Unterschied zwischen Text und Zahl.',
  dauerMinuten: 15,
  bloecke: [
    TextBlock(
      'Ein Programm ist eine Liste von Anweisungen, die der Computer von '
      'oben nach unten abarbeitet. Wie ein Kochrezept: Schritt 1, Schritt 2, '
      'Schritt 3, fertig. Nicht mehr und nicht weniger.',
    ),
    TextBlock(
      'Python ist eine Sprache, in der diese Anweisungen fast wie englische '
      'Sätze aussehen. Deshalb ist sie die beliebteste Einsteigersprache, '
      'und deshalb taucht sie auch in IHK-Prüfungen immer wieder auf.',
    ),
    UeberschriftBlock('Die erste Anweisung: print()'),
    TextBlock(
      '`print()` bedeutet: „gib das hier auf dem Bildschirm aus". Was '
      'ausgegeben werden soll, steht zwischen den Klammern.',
    ),
    CodeBlock(
      'print("Willkommen bei Nordwind")',
      titel: 'Ausgabe: Willkommen bei Nordwind',
    ),
    TextBlock(
      'Wort für Wort gelesen:\n'
      '- `print`: der Befehl „gib aus"\n'
      '- `(` und `)`: die Klammern gehören immer dazu\n'
      '- `"Willkommen bei Nordwind"`: der Text, in Anführungszeichen',
    ),
    HinweisBlock(
      'Die Anführungszeichen sagen Python: das hier ist **Text**, sprich es '
      'nicht als Befehl aus. Programmierer nennen so ein Stück Text einen '
      'String (englisch für Zeichenkette).',
    ),

    // ─── Stufe 1: das Muster einmal bauen, keine Fallen ──────────────
    AufgabenBlock(LueckenAufgabe(
      id: 'py-1-1',
      frage: 'Bau die Anweisung aus dem Beispiel nach: '
          'gib den Text Hallo Nordwind aus.',
      vorlage: '___("Hallo Nordwind")',
      loesungen: [
        ['print'],
      ],
      // Allererste Aufgabe: genau ein Baustein. Es geht nur darum,
      // das Muster einmal selbst zu setzen.
      bausteine: ['print'],
      erklaerung:
          'Das war deine erste Python-Anweisung. print() wirst du in jedem '
          'einzelnen Programm dieses Kurses wiedersehen.',
    )),

    // ─── Stufe 2: Wiederholung mit anderem Inhalt, eine Falle ────────
    TextBlock(
      'Nochmal dasselbe, damit es sitzt. Diesmal fehlt der Text. Denk an '
      'die Anführungszeichen.',
    ),
    AufgabenBlock(LueckenAufgabe(
      id: 'py-1-2',
      frage: 'Gib den Text Lager geöffnet aus.',
      vorlage: 'print(___)',
      loesungen: [
        ['"Lager geöffnet"', "'Lager geöffnet'"],
      ],
      // Genau eine Falle: derselbe Text ohne Anführungszeichen.
      bausteine: ['"Lager geöffnet"', 'Lager geöffnet'],
      erklaerung:
          'Ohne Anführungszeichen würde Python „Lager" für einen Befehl '
          'halten und mit einer Fehlermeldung abbrechen. Mit ihnen ist es '
          'einfach Text.',
    )),

    UeberschriftBlock('Text oder Zahl?'),
    TextBlock(
      'Zahlen schreibst du OHNE Anführungszeichen. Dann rechnet Python '
      'damit, statt sie nur anzuzeigen.',
    ),
    CodeBlock(
      'print(3 + 4)\nprint("3 + 4")',
      titel: 'Zwei sehr verschiedene Zeilen',
    ),
    TextBlock(
      'Die erste Zeile gibt `7` aus, denn 3 + 4 ist eine Rechnung. '
      'Die zweite gibt `3 + 4` aus, denn in Anführungszeichen ist es nur '
      'Text, und Text wird nicht ausgerechnet.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-1-3',
      frage: 'Was gibt print(10 + 5) aus?',
      optionen: [
        '15',
        '10 + 5',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'Keine Anführungszeichen, also rechnet Python: 15. Merksatz: '
          'Anführungszeichen heißt anzeigen, keine Anführungszeichen heißt '
          'ausrechnen.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-1-4',
      frage: 'Und was gibt print("10 + 5") aus?',
      optionen: [
        '10 + 5',
        '15',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'Diesmal stehen Anführungszeichen drum herum. Für Python ist das '
          'reiner Text, und Text wird Zeichen für Zeichen angezeigt, nicht '
          'gerechnet.',
    )),

    UeberschriftBlock('Fehler finden'),
    TextBlock(
      'Im Betrieb wirst du öfter fremden Code reparieren als eigenen neu '
      'schreiben. Deshalb üben wir das von Anfang an.',
    ),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-1-5',
      frage: 'Dieses Programm stürzt ab. Finde die kaputte Zeile und '
          'schreib sie richtig.',
      zeilen: [
        'print("Willkommen bei Nordwind")',
        'print(Schönen Feierabend)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print("Schönen Feierabend")',
        "print('Schönen Feierabend')",
      ],
      tipp: 'Vergleich die zweite Zeile genau mit der ersten. Was fehlt?',
      erklaerung:
          'Ohne Anführungszeichen versucht Python, „Schönen" als Befehl zu '
          'lesen, und bricht ab. Der fehlende String-Rahmen ist einer der '
          'häufigsten Anfängerfehler überhaupt.',
    )),

    UeberschriftBlock('Von oben nach unten'),
    TextBlock(
      'Ein Programm läuft immer Zeile für Zeile von oben nach unten. '
      'Die Reihenfolge der Zeilen bestimmt also die Reihenfolge der '
      'Ausgaben.',
    ),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-1-6',
      frage: 'Das Programm der Lagerverwaltung soll erst begrüßen, dann '
          'den Ladevorgang melden, dann Fertig sagen. Bring die Zeilen in '
          'diese Reihenfolge.',
      zeilen: [
        'print("Willkommen bei Nordwind")',
        'print("Lagerbestand wird geladen")',
        'print("Fertig")',
      ],
      erklaerung:
          'Python macht keinen eigenen Plan: es arbeitet stur von oben nach '
          'unten. Was zuerst passieren soll, muss oben stehen.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 2 — Variablen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion2 = Lektion(
  nr: 2,
  slug: 'python-2',
  titel: 'Variablen',
  kurzbeschreibung:
      'Werte speichern und wiederverwenden: das Gedächtnis deines Programms.',
  dauerMinuten: 18,
  bloecke: [
    // Kurz zurückblicken, wie im SQL-Kurs
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-2-1',
      frage: 'Aufwärmen aus Lektion 1: Was gibt print("2 + 2") aus?',
      optionen: [
        '2 + 2',
        '4',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'Anführungszeichen heißt Text, und Text wird angezeigt statt '
          'gerechnet. Wenn das sitzt, bist du bereit für Variablen.',
    )),

    UeberschriftBlock('Werte aufbewahren'),
    TextBlock(
      'Eine Variable ist eine beschriftete Kiste, in die dein Programm '
      'einen Wert legt. Später holst du den Wert über den Namen der Kiste '
      'wieder heraus.',
    ),
    CodeBlock(
      'preis = 249\nprint(preis)',
      titel: 'Ausgabe: 249',
    ),
    TextBlock(
      'Das Gleichheitszeichen ist hier KEIN Vergleich, sondern eine '
      'Zuweisung: „leg den Wert 249 in die Kiste mit dem Namen preis". '
      'Danach steht `preis` überall im Programm für diesen Wert.',
    ),
    HinweisBlock(
      'Sprich Zuweisungen beim Lesen als „wird zu" aus: „preis wird zu 249". '
      'Das schützt dich später vor der Verwechslung mit dem Vergleich.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-2-2',
      frage: 'Leg den Wert 249 in die Variable preis und gib sie aus.',
      vorlage: 'preis = 249\nprint(___)',
      loesungen: [
        ['preis'],
      ],
      // Eine Falle: der Wert selbst. Es soll die Variable benutzt werden.
      bausteine: ['preis', '"preis"'],
      erklaerung:
          'print(preis) ohne Anführungszeichen gibt den INHALT der Kiste '
          'aus, also 249. Mit Anführungszeichen käme nur das Wort preis.',
    )),

    UeberschriftBlock('Variablen ändern sich'),
    TextBlock(
      'Eine Variable heißt Variable, weil ihr Wert sich ändern darf. Eine '
      'neue Zuweisung überschreibt den alten Wert. Es zählt immer die '
      'letzte Zuweisung vor dem print.',
    ),
    CodeBlock(
      'lagerbestand = 50\nlagerbestand = 47\nprint(lagerbestand)',
      titel: 'Ausgabe: 47',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-2-3',
      frage: 'Drei Monitore wurden verkauft, dann kommen 10 neue an:\n'
          'monitore = 20\nmonitore = 17\nmonitore = 27\nprint(monitore)\n'
          'Was wird ausgegeben?',
      optionen: [
        '27',
        '20',
        '64',
      ],
      richtig: 0,
      erklaerung:
          'Jede Zuweisung überschreibt die vorherige komplett. Am Ende '
          'liegt 27 in der Kiste, die alten Werte sind weg. Python addiert '
          'nichts von selbst.',
    )),

    UeberschriftBlock('Text in Variablen'),
    TextBlock(
      'In eine Variable passt auch Text, mit Anführungszeichen wie in '
      'Lektion 1. Die Regeln bleiben gleich: Zahlen ohne, Text mit.',
    ),
    CodeBlock(
      'artikel = "USB-C Kabel"\nanzahl = 12\nprint(artikel)\nprint(anzahl)',
      titel: 'Zwei Kisten, zwei Ausgaben',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-2-4',
      frage: 'Die Nordwind GmbH hat 12 Drucker auf Lager. Leg die ZAHL 12 '
          'in die Variable anzahl.',
      vorlage: 'anzahl = ___',
      loesungen: [
        ['12'],
      ],
      // Falle: die Zahl als Text. Funktioniert erstmal, rächt sich beim
      // Rechnen. Genau darüber spricht die Erklärung.
      bausteine: ['12', '"12"'],
      erklaerung:
          'Richtig: 12 ohne Anführungszeichen. "12" wäre Text, und mit '
          'Text kann Python nicht rechnen. Warum das wichtig ist, siehst '
          'du in der nächsten Lektion.',
    )),

    UeberschriftBlock('Regeln für Namen'),
    TextBlock(
      'Variablennamen dürfen Buchstaben, Zahlen und Unterstriche '
      'enthalten, aber keine Leerzeichen und keine Umlaute. Gute Namen '
      'sagen, was drin liegt: `preis_brutto` statt `x`.',
    ),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-2-5',
      frage: 'Dieses Programm stürzt ab. Finde die kaputte Zeile und '
          'schreib sie richtig.',
      zeilen: [
        'artikel preis = 199',
        'print(artikel_preis)',
      ],
      fehlerZeile: 0,
      korrekturen: [
        'artikel_preis = 199',
      ],
      tipp: 'Schau dir an, wie die Variable in Zeile 2 heißt.',
      erklaerung:
          'Leerzeichen sind in Namen verboten, Python liest „artikel preis" '
          'als zwei Wörter und versteht die Zeile nicht. Der Unterstrich '
          'verbindet die Wörter zu einem gültigen Namen.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-2-6',
      frage: 'Das Programm soll den Kunden mit Namen begrüßen. Bring die '
          'Zeilen in eine Reihenfolge, die funktioniert: erst anlegen, '
          'dann benutzen.',
      zeilen: [
        'kunde = "Frau Sommer"',
        'gruss = "Guten Tag,"',
        'print(gruss, kunde)',
      ],
      erklaerung:
          'Eine Variable muss angelegt sein, BEVOR sie benutzt wird, denn '
          'das Programm läuft von oben nach unten. print mit Komma gibt '
          'übrigens beide Werte mit Leerzeichen dazwischen aus. Ob kunde '
          'oder gruss zuerst angelegt wird, ist egal, Hauptsache vor dem '
          'print.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 3 — Rechnen und Text
// ═══════════════════════════════════════════════════════════════════════════

const _lektion3 = Lektion(
  nr: 3,
  slug: 'python-3',
  titel: 'Rechnen und Text',
  kurzbeschreibung:
      'Plus, Mal, Vergleiche, und warum "3" + "4" nicht 7 ergibt.',
  dauerMinuten: 18,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-3-1',
      frage: 'Aufwärmen aus Lektion 2:\n'
          'preis = 100\npreis = 80\nprint(preis)\n'
          'Was wird ausgegeben?',
      optionen: [
        '80',
        '100',
        '180',
      ],
      richtig: 0,
      erklaerung:
          'Die letzte Zuweisung gewinnt. Mit diesem Wissen kannst du jetzt '
          'anfangen zu rechnen.',
    )),

    UeberschriftBlock('Die Grundrechenarten'),
    TextBlock(
      'Python rechnet mit den Zeichen, die du von der Tastatur kennst: '
      '`+` und `-` wie gewohnt, `*` für Mal, `/` für Geteilt.',
    ),
    CodeBlock(
      'preis = 249\nanzahl = 3\ngesamt = preis * anzahl\nprint(gesamt)',
      titel: 'Ausgabe: 747',
    ),
    TextBlock(
      'Rechts vom Gleichheitszeichen wird zuerst gerechnet, das Ergebnis '
      'landet dann in der Kiste links. `gesamt` enthält also 747, nicht '
      'die Formel.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-3-2',
      frage: 'Ein Kunde kauft 5 Webcams zu je 89 Euro. Berechne den '
          'Gesamtpreis.',
      vorlage: 'preis = 89\nanzahl = 5\ngesamt = preis ___ anzahl\n'
          'print(gesamt)',
      loesungen: [
        ['*'],
      ],
      bausteine: ['*', '+', 'x'],
      erklaerung:
          'gesamt enthält 445. Das x von der Schultafel gibt es in Python '
          'nicht, Mal schreibt sich immer mit dem Sternchen.',
    )),

    UeberschriftBlock('Plus bei Text: aneinanderhängen'),
    TextBlock(
      'Das Pluszeichen kann noch etwas Zweites: zwei Texte '
      'aneinanderhängen. Was es tut, hängt davon ab, ob links und rechts '
      'Zahlen oder Texte stehen.',
    ),
    CodeBlock(
      'print(3 + 4)\nprint("3" + "4")',
      titel: 'Ausgabe: 7, dann 34',
    ),
    TextBlock(
      '`"3" + "4"` ergibt `"34"`, denn für Python sind das zwei Texte, und '
      'Texte werden aneinandergeklebt wie zwei Zettel. Das ist DIE '
      'klassische Prüfungsfrage zu diesem Thema.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-3-3',
      frage: 'Was gibt print("10" + "20") aus?',
      optionen: [
        '1020',
        '30',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'Beides sind Texte, also werden sie aneinandergehängt: 1020. '
          'Gerechnet wird nur mit Zahlen ohne Anführungszeichen.',
    )),

    UeberschriftBlock('Umwandeln mit int() und str()'),
    TextBlock(
      'Manchmal liegt eine Zahl als Text vor, zum Beispiel aus einem '
      'Formular. Dann wandelst du sie um:\n'
      '- `int("42")` macht aus dem Text die Zahl 42\n'
      '- `str(42)` macht aus der Zahl den Text "42"',
    ),
    HinweisBlock(
      'int steht für integer, das englische Wort für Ganzzahl. str steht '
      'für String, also Text. Kommazahlen heißen float, um die kümmern wir '
      'uns, wenn wir sie brauchen.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-3-4',
      frage: 'Aus dem Bestellformular kommt die Stückzahl als Text. '
          'Wandle sie in eine Zahl um, damit gerechnet werden kann.',
      vorlage: 'eingabe = "4"\nanzahl = ___(eingabe)\nprint(anzahl * 25)',
      loesungen: [
        ['int'],
      ],
      bausteine: ['int', 'str', 'zahl'],
      erklaerung:
          'int("4") ergibt die Zahl 4, damit ist anzahl * 25 gleich 100. '
          'Ohne die Umwandlung würde "4" * 25 den Text 4 fünfundzwanzigmal '
          'hintereinander ergeben. Wirklich.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-3-5',
      frage: 'Dieses Programm stürzt ab, weil Text und Zahl mit + '
          'zusammengehängt werden sollen. Repariere die kaputte Zeile.',
      zeilen: [
        'preis = 249',
        'print("Der Preis ist: " + preis)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print("Der Preis ist: " + str(preis))',
        'print("Der Preis ist:", preis)',
      ],
      tipp: 'Text plus Zahl geht nicht. Mach aus der Zahl erst einen Text, '
          'mit str().',
      erklaerung:
          'Python weigert sich, Text und Zahl mit + zu mischen, weil unklar '
          'wäre, ob rechnen oder ankleben gemeint ist. str(preis) macht aus '
          '249 den Text "249", dann klappt das Ankleben. Der zweite Weg: '
          'print mit Komma nimmt beide Werte, wie du es aus Lektion 2 '
          'kennst.',
    )),

    UeberschriftBlock('Vergleichen'),
    TextBlock(
      'Neben dem Rechnen kann Python Werte vergleichen. Das Ergebnis ist '
      'immer eines von zwei Dingen: `True` (wahr) oder `False` (falsch).',
    ),
    CodeBlock(
      'print(10 > 3)\nprint(5 == 7)',
      titel: 'Ausgabe: True, dann False',
    ),
    TextBlock(
      'Merk dir vor allem das doppelte Gleichheitszeichen: `==` prüft, ob '
      'zwei Werte gleich sind. Das einfache `=` kennst du schon, es ist '
      'die Zuweisung. Zwei Zeichen, zwei völlig verschiedene Jobs.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-3-6',
      frage: 'Prüfe, ob der Lagerbestand genau 0 ist.',
      vorlage: 'lagerbestand = 3\nprint(lagerbestand ___ 0)',
      loesungen: [
        ['=='],
      ],
      bausteine: ['==', '=', '>'],
      erklaerung:
          'lagerbestand == 0 ergibt hier False, denn 3 ist nicht 0. Das '
          'einfache = wäre eine Zuweisung und an dieser Stelle ein Fehler. '
          'Diese Prüfungen sind die Grundlage für die Entscheidungen in '
          'Lektion 5.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-3-7',
      frage: 'Zum Abschluss ein komplettes Mini-Programm: Es soll den '
          'Rechnungsbetrag für 3 Tastaturen berechnen und dann ausgeben. '
          'Bring die Zeilen in die richtige Reihenfolge.',
      zeilen: [
        'preis = 45',
        'anzahl = 3',
        'gesamt = preis * anzahl',
        'print("Betrag:", gesamt)',
      ],
      erklaerung:
          'Erst brauchen beide Kisten einen Wert, dann kann gerechnet '
          'werden, und ausgeben geht erst, wenn gesamt existiert. Genau so '
          'sehen die kleinen Rechenprogramme in der AP1 aus. Ob preis oder '
          'anzahl zuerst kommt, ist egal.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Der Kurs
// ═══════════════════════════════════════════════════════════════════════════
// Lektion 4 bis 14 folgen. Reihenfolge laut Plan:
// 4 Eingabe/f-Strings · 5 if/elif/else · 6 Listen · 7 for · 8 while ·
// 9+10 Funktionen · 11 Dictionaries · 12 Strings · 13 Fehler/try ·
// 14 Alles zusammen (Pseudocode, AP1)

const pythonKurs = Kurs(
  slug: 'python',
  titel: 'Python von Grund auf',
  beschreibung:
      'Vom ersten print() bis zum fertigen Mini-Programm. Ohne Vorwissen, '
      'Schritt für Schritt, mit den Beispielen der Nordwind GmbH.',
  lektionen: [
    _lektion1,
    _lektion2,
    _lektion3,
  ],
);
