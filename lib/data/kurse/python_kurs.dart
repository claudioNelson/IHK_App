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
// Lektion 4 — Eingabe und Ausgabe
// ═══════════════════════════════════════════════════════════════════════════

const _lektion4 = Lektion(
  nr: 4,
  slug: 'python-4',
  titel: 'Eingabe und Ausgabe',
  kurzbeschreibung:
      'Mit input() Werte entgegennehmen und mit f-Strings schöne Ausgaben bauen.',
  dauerMinuten: 16,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-4-1',
      frage: 'Aufwärmen aus Lektion 3:\n'
          'anzahl = int("3")\nprint(anzahl * 2)\n'
          'Was wird ausgegeben?',
      optionen: [
        '6',
        '33',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'int("3") macht aus dem Text die Zahl 3, und 3 mal 2 ist 6. '
          'Ohne int() wäre "33" herausgekommen, der Text zweimal '
          'hintereinander. Diese Umwandlung brauchst du gleich wieder.',
    )),

    UeberschriftBlock('Das Programm fragt zurück'),
    TextBlock(
      'Bis jetzt standen alle Werte fest im Code. Mit `input()` fragt dein '
      'Programm den Benutzer und wartet, bis er etwas eintippt und Enter '
      'drückt.',
    ),
    CodeBlock(
      'name = input("Wie heißt du? ")\nprint("Hallo", name)',
      titel: 'Das Programm wartet auf eine Antwort',
    ),
    TextBlock(
      'Der Text in den Klammern ist die Frage, die angezeigt wird. Was der '
      'Benutzer eintippt, landet in der Variablen, hier in `name`.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-4-2',
      frage: 'Frag den Benutzer nach dem Artikelnamen und speichere die '
          'Antwort.',
      vorlage: 'artikel = ___("Welcher Artikel? ")\nprint(artikel)',
      loesungen: [
        ['input'],
      ],
      bausteine: ['input', 'print', 'frage'],
      erklaerung:
          'input() zeigt die Frage an, wartet auf die Eingabe und gibt sie '
          'ans Programm zurück. print() dagegen gibt nur aus und wartet '
          'auf nichts.',
    )),

    HinweisBlock(
      'Wichtig zu wissen: `input()` liefert IMMER Text, auch wenn jemand '
      '17 eintippt. Zum Rechnen musst du die Eingabe erst mit `int()` '
      'umwandeln, genau wie in Lektion 3.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-4-3',
      frage: 'alter = input("Dein Alter: ")\n'
          'Der Benutzer tippt 17 ein. Was liegt jetzt in alter?',
      optionen: [
        'Der Text "17"',
        'Die Zahl 17',
        'Nichts, das Programm stürzt ab',
      ],
      richtig: 0,
      erklaerung:
          'input() liefert immer Text. Wer damit rechnen will, schreibt '
          'alter = int(input("Dein Alter: ")). Das vergessen selbst '
          'Fortgeschrittene regelmäßig.',
    )),

    UeberschriftBlock('Schöne Ausgaben mit f-Strings'),
    TextBlock(
      'Werte in einen Satz einzubauen war bisher umständlich. Der '
      'f-String löst das elegant: ein `f` vor den Anführungszeichen, und '
      'in geschweiften Klammern kannst du Variablen direkt in den Text '
      'setzen.',
    ),
    CodeBlock(
      'artikel = "Monitor"\npreis = 249\n'
      'print(f"Der {artikel} kostet {preis} Euro")',
      titel: 'Ausgabe: Der Monitor kostet 249 Euro',
    ),
    TextBlock(
      'Das f steht für format. Alles in geschweiften Klammern wird durch '
      'seinen Wert ersetzt, der Rest bleibt normaler Text. Kein Ankleben '
      'mit +, kein str() mehr nötig.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-4-4',
      frage: 'Begrüße den Kunden mit Namen. Setz die Variable in die '
          'geschweiften Klammern.',
      vorlage: 'kunde = "Frau Sommer"\nprint(f"Guten Tag, {___}!")',
      loesungen: [
        ['kunde'],
      ],
      bausteine: ['kunde', '"kunde"', 'name'],
      erklaerung:
          'In den geschweiften Klammern steht der Variablenname ohne '
          'Anführungszeichen. Ausgegeben wird: Guten Tag, Frau Sommer!',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-4-5',
      frage: 'Was gibt print(f"{3 + 4} Artikel auf Lager") aus?',
      optionen: [
        '7 Artikel auf Lager',
        '3 + 4 Artikel auf Lager',
        'Eine Fehlermeldung',
      ],
      richtig: 0,
      erklaerung:
          'In den geschweiften Klammern darf sogar gerechnet werden. '
          'Python setzt das Ergebnis ein: 7 Artikel auf Lager.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-4-6',
      frage: 'Die Ausgabe zeigt wörtlich {gesamt} statt der Zahl. '
          'Repariere die kaputte Zeile.',
      zeilen: [
        'gesamt = 747',
        'print("Rechnungsbetrag: {gesamt} Euro")',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print(f"Rechnungsbetrag: {gesamt} Euro")',
      ],
      tipp: 'Vor den Anführungszeichen fehlt ein einzelner Buchstabe.',
      erklaerung:
          'Ohne das f sind die geschweiften Klammern nur normale Zeichen '
          'im Text. Erst das f macht daraus Platzhalter. Dieser fehlende '
          'Buchstabe ist der häufigste f-String-Fehler.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-4-7',
      frage: 'Das Bestellprogramm soll nach der Stückzahl fragen, in eine '
          'Zahl umwandeln, den Preis berechnen und ihn ausgeben. Bring '
          'die Zeilen in die richtige Reihenfolge.',
      zeilen: [
        'eingabe = input("Wie viele Webcams? ")',
        'anzahl = int(eingabe)',
        'gesamt = anzahl * 89',
        'print(f"Das macht {gesamt} Euro")',
      ],
      erklaerung:
          'Erst fragen, dann umwandeln, dann rechnen, dann ausgeben. '
          'Diese Kette aus input, int und f-String ist das Grundgerüst '
          'fast jedes kleinen Python-Programms.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 5 — Entscheidungen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion5 = Lektion(
  nr: 5,
  slug: 'python-5',
  titel: 'Entscheidungen',
  kurzbeschreibung:
      'Mit if, elif und else reagiert dein Programm unterschiedlich auf Werte.',
  dauerMinuten: 20,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-5-1',
      frage: 'Aufwärmen aus Lektion 3: Was gibt print(5 > 8) aus?',
      optionen: [
        'False',
        'True',
        '3',
      ],
      richtig: 0,
      erklaerung:
          '5 ist nicht größer als 8, also False. Genau solche Wahr-oder-'
          'Falsch-Prüfungen steuern gleich die Entscheidungen.',
    )),

    UeberschriftBlock('Wenn, dann'),
    TextBlock(
      'Bis jetzt lief jedes Programm stur alle Zeilen durch. Mit `if` '
      'führt Python eine Zeile nur aus, WENN eine Bedingung wahr ist. '
      'Wie ein Türsteher: nur wer die Bedingung erfüllt, kommt rein.',
    ),
    CodeBlock(
      'lagerbestand = 0\nif lagerbestand == 0:\n'
      '    print("Nachbestellen!")',
      titel: 'Ausgabe: Nachbestellen!',
    ),
    TextBlock(
      'Drei Dinge gehören zum if:\n'
      '- die Bedingung, hier `lagerbestand == 0`\n'
      '- der Doppelpunkt am Zeilenende\n'
      '- die eingerückte Zeile darunter, die nur bei wahr läuft',
    ),
    HinweisBlock(
      'Die Einrückung (vier Leerzeichen) ist in Python keine Deko, sie IST '
      'die Struktur. Alles, was eingerückt unter dem if steht, gehört zum '
      'if. Die erste nicht eingerückte Zeile läuft wieder immer.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-5-2',
      frage: 'Das Programm soll warnen, wenn der Lagerbestand genau 0 ist.',
      vorlage: 'if lagerbestand ___ 0:\n    print("Nachbestellen!")',
      loesungen: [
        ['=='],
      ],
      bausteine: ['==', '=', '>'],
      erklaerung:
          'Der Vergleich braucht das doppelte Gleichheitszeichen aus '
          'Lektion 3. Das einfache = wäre eine Zuweisung und im if ein '
          'Fehler.',
    )),

    UeberschriftBlock('Sonst: else'),
    TextBlock(
      'Oft soll auch etwas passieren, wenn die Bedingung NICHT stimmt. '
      'Dafür gibt es `else`, das Sonst.',
    ),
    CodeBlock(
      'if lagerbestand == 0:\n    print("Nachbestellen!")\n'
      'else:\n    print("Alles da")',
      titel: 'Einer von beiden Zweigen läuft, nie beide',
    ),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-5-3',
      frage: 'Bring die Zeilen in die richtige Reihenfolge: erst die '
          'Prüfung auf 0 mit Warnung, dann das Sonst mit Entwarnung.',
      zeilen: [
        'if lagerbestand == 0:',
        'print("Nachbestellen!")',
        'else:',
        'print("Alles da")',
      ],
      einrueckung: [0, 1, 0, 1],
      erklaerung:
          'if und else stehen auf gleicher Höhe, ihre Folgen sind '
          'eingerückt. Die Einrückung zeigt Python, welche Zeile zu '
          'welchem Zweig gehört.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-5-4',
      frage: 'alter = 20\nif alter >= 18:\n    print("Volljährig")\n'
          'else:\n    print("Minderjährig")\n'
          'Was wird ausgegeben?',
      optionen: [
        'Volljährig',
        'Minderjährig',
        'Beides',
      ],
      richtig: 0,
      erklaerung:
          '20 >= 18 ist wahr, also läuft nur der if-Zweig. Der else-Zweig '
          'wird komplett übersprungen. Es läuft immer genau einer von '
          'beiden.',
    )),

    UeberschriftBlock('Mehrere Fälle: elif'),
    TextBlock(
      'Zwischen if und else passen beliebig viele weitere Prüfungen: '
      '`elif`, kurz für else if. Python prüft von oben nach unten und '
      'nimmt den ERSTEN Zweig, der passt.',
    ),
    CodeBlock(
      'punkte = 75\nif punkte >= 90:\n    print("Sehr gut")\n'
      'elif punkte >= 50:\n    print("Bestanden")\n'
      'else:\n    print("Durchgefallen")',
      titel: 'Ausgabe: Bestanden',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-5-5',
      frage: 'Gleicher Code, aber punkte = 95. Was wird ausgegeben?',
      optionen: [
        'Sehr gut',
        'Sehr gut und Bestanden',
        'Bestanden',
      ],
      richtig: 0,
      erklaerung:
          '95 erfüllt zwar BEIDE Bedingungen, aber Python nimmt den '
          'ersten passenden Zweig und hört dann auf. Deshalb prüft man '
          'immer vom strengsten zum lockersten Fall.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-5-6',
      frage: 'Dieses Programm stürzt ab. Finde die kaputte Zeile und '
          'schreib sie richtig.',
      zeilen: [
        'preis = 120',
        'if preis > 100',
        '    print("Versandkostenfrei")',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'if preis > 100:',
      ],
      tipp: 'Schau ans Ende der if-Zeile. Was fehlt da?',
      erklaerung:
          'Nach jeder if-, elif- und else-Zeile MUSS ein Doppelpunkt '
          'stehen. Der vergessene Doppelpunkt ist der Klassiker unter den '
          'Python-Fehlern, die Fehlermeldung heißt dann SyntaxError.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-5-7',
      frage: 'Die Nordwind GmbH gibt ab 500 Euro Bestellwert Rabatt. '
          'Vervollständige die Prüfung: größer oder gleich 500.',
      vorlage: 'if bestellwert ___ 500:\n    print("10 Prozent Rabatt")\n'
          '___:\n    print("Kein Rabatt")',
      loesungen: [
        ['>='],
        ['else'],
      ],
      bausteine: ['>=', '<=', '==', 'else', 'elif'],
      erklaerung:
          '>= heißt größer oder gleich, damit gilt der Rabatt auch bei '
          'genau 500 Euro. Und weil es nur zwei Fälle gibt, reicht ein '
          'else, elif bräuchte eine eigene Bedingung.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 6 — Listen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion6 = Lektion(
  nr: 6,
  slug: 'python-6',
  titel: 'Listen',
  kurzbeschreibung:
      'Viele Werte in einer Variablen: das Lager der Nordwind GmbH als Liste.',
  dauerMinuten: 18,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-6-1',
      frage: 'Aufwärmen aus Lektion 5:\n'
          'preis = 80\nif preis > 100:\n    print("teuer")\n'
          'else:\n    print("okay")\n'
          'Was wird ausgegeben?',
      optionen: [
        'okay',
        'teuer',
        'Nichts',
      ],
      richtig: 0,
      erklaerung:
          '80 > 100 ist falsch, also läuft der else-Zweig. Wenn das '
          'sitzt, bist du bereit für Listen.',
    )),

    UeberschriftBlock('Viele Werte, eine Variable'),
    TextBlock(
      'Bisher passte in jede Variable genau ein Wert. Eine **Liste** '
      'sammelt beliebig viele Werte in einer festen Reihenfolge, wie ein '
      'Einkaufszettel. Die eckigen Klammern machen sie erkennbar.',
    ),
    CodeBlock(
      'lager = ["Maus", "Tastatur", "Monitor"]\nprint(lager)',
      titel: 'Ausgabe: [\'Maus\', \'Tastatur\', \'Monitor\']',
    ),

    UeberschriftBlock('Zugriff über die Position'),
    TextBlock(
      'Jeder Eintrag hat eine Position, den **Index**. Und jetzt kommt '
      'die Stolperfalle Nummer eins: **Python zählt ab 0.** Der erste '
      'Eintrag ist `lager[0]`, der zweite `lager[1]`.',
    ),
    CodeBlock(
      'print(lager[0])\nprint(lager[1])',
      titel: 'Ausgabe: Maus, dann Tastatur',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-6-2',
      frage: 'lager = ["Maus", "Tastatur", "Monitor"]\n'
          'Was gibt print(lager[1]) aus?',
      optionen: [
        'Tastatur',
        'Maus',
        'Monitor',
      ],
      richtig: 0,
      erklaerung:
          'Index 1 ist der ZWEITE Eintrag, weil Python bei 0 anfängt zu '
          'zählen. Diese Frage kommt in Prüfungen ständig, genau wegen '
          'dieser Falle.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-6-3',
      frage: 'Gib den ERSTEN Artikel aus dem Lager aus.',
      vorlage: 'lager = ["Maus", "Tastatur", "Monitor"]\n'
          'print(lager[___])',
      loesungen: [
        ['0'],
      ],
      bausteine: ['0', '1'],
      erklaerung:
          'Der erste Eintrag sitzt auf Index 0. Merksatz: der Index sagt '
          'nicht „der wievielte", sondern „wie viele Schritte vom Anfang".',
    )),

    UeberschriftBlock('Anhängen und zählen'),
    TextBlock(
      'Zwei Dinge braucht man täglich:\n'
      '- `lager.append("Webcam")` hängt einen Eintrag hinten an\n'
      '- `len(lager)` sagt, wie viele Einträge drin sind (len wie length, '
      'englisch für Länge)',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-6-4',
      frage: 'Eine Lieferung Webcams kommt an. Häng "Webcam" ans Lager an.',
      vorlage: 'lager = ["Maus", "Tastatur", "Monitor"]\n'
          'lager.___("Webcam")',
      loesungen: [
        ['append'],
      ],
      bausteine: ['append', 'add', 'plus'],
      erklaerung:
          'append heißt anhängen und packt den neuen Eintrag immer ans '
          'Ende. add und plus gibt es bei Listen nicht, das ist eine '
          'beliebte Verwechslung mit anderen Sprachen.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-6-5',
      frage: 'lager = ["Maus", "Tastatur", "Monitor"]\n'
          'lager.append("Webcam")\nprint(len(lager))\n'
          'Was wird ausgegeben?',
      optionen: [
        '4',
        '3',
        'Webcam',
      ],
      richtig: 0,
      erklaerung:
          'Drei Einträge plus die angehängte Webcam macht 4. len() zählt '
          'ganz normal ab 1, nur der INDEX startet bei 0. Der letzte '
          'Eintrag sitzt deshalb immer auf Index len minus 1.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-6-6',
      frage: 'Dieses Programm stürzt mit einem IndexError ab. Es soll den '
          'LETZTEN Artikel ausgeben. Repariere die kaputte Zeile.',
      zeilen: [
        'lager = ["Maus", "Tastatur", "Monitor"]',
        'print(lager[3])',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print(lager[2])',
        'print(lager[-1])',
      ],
      tipp: 'Drei Einträge, aber der Index startet bei 0. Auf welchem '
          'Index sitzt dann der letzte?',
      erklaerung:
          'Bei drei Einträgen gibt es die Indizes 0, 1 und 2. Index 3 '
          'liegt dahinter, deshalb der IndexError. Profi-Trick: '
          'lager[-1] nimmt immer den letzten Eintrag, egal wie lang die '
          'Liste ist.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-6-7',
      frage: 'Das Programm soll ein leeres Lager anlegen, zwei Artikel '
          'aufnehmen und dann die Anzahl melden. Bring die Zeilen in die '
          'richtige Reihenfolge.',
      zeilen: [
        'lager = []',
        'lager.append("Drucker")',
        'lager.append("Scanner")',
        'print(f"{len(lager)} Artikel im Lager")',
      ],
      erklaerung:
          '[] ist eine leere Liste, die beiden append hängen nacheinander '
          'an, len zählt am Ende 2. Dass der Drucker vor dem Scanner '
          'kommt, ist hier Absicht: append hält die Reihenfolge der '
          'Ankunft fest.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 7 — Die for-Schleife
// ═══════════════════════════════════════════════════════════════════════════

const _lektion7 = Lektion(
  nr: 7,
  slug: 'python-7',
  titel: 'Die for-Schleife',
  kurzbeschreibung:
      'Eine Anweisung für jeden Eintrag: Listen durchlaufen mit for und range.',
  dauerMinuten: 20,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-7-1',
      frage: 'Aufwärmen aus Lektion 6:\n'
          'preise = [10, 20, 30]\nprint(preise[0])\n'
          'Was wird ausgegeben?',
      optionen: [
        '10',
        '20',
        '[10, 20, 30]',
      ],
      richtig: 0,
      erklaerung:
          'Index 0 ist der erste Eintrag. Gleich lernst du, wie du ALLE '
          'Einträge auf einmal verarbeitest, ohne jeden Index einzeln zu '
          'tippen.',
    )),

    UeberschriftBlock('Eine Zeile für alle'),
    TextBlock(
      'Stell dir vor, das Lager hat 500 Artikel und du sollst jeden '
      'ausgeben. 500 print-Zeilen? Die **for-Schleife** macht daraus '
      'zwei Zeilen: sie wiederholt ihren eingerückten Block einmal pro '
      'Eintrag.',
    ),
    CodeBlock(
      'lager = ["Maus", "Tastatur", "Monitor"]\n'
      'for artikel in lager:\n    print(artikel)',
      titel: 'Ausgabe: Maus, Tastatur, Monitor, je eine Zeile',
    ),
    TextBlock(
      'Lies die Zeile wie einen Satz: „FÜR jeden artikel IN lager: mach '
      'das hier." Bei jedem Durchlauf liegt der nächste Eintrag in der '
      'Variablen `artikel`, den Namen darfst du frei wählen.',
    ),
    HinweisBlock(
      'Doppelpunkt und Einrückung kennst du schon vom if aus Lektion 5. '
      'Es sind exakt dieselben Regeln: der Doppelpunkt kündigt den Block '
      'an, die Einrückung zeigt, was dazugehört.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-7-2',
      frage: 'Gib jeden Artikel aus dem Lager aus.',
      vorlage: 'for artikel ___ lager:\n    print(artikel)',
      loesungen: [
        ['in'],
      ],
      bausteine: ['in', 'aus', 'von'],
      erklaerung:
          'Das Schlüsselwort heißt in: für jeden Artikel in der Liste. '
          'Die Schleife läuft dreimal, einmal pro Eintrag.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-7-3',
      frage: 'kunden = ["Sommer", "Winter", "Herbst", "Lenz"]\n'
          'for k in kunden:\n    print("Hallo", k)\n'
          'Wie viele Zeilen gibt das Programm aus?',
      optionen: [
        '4',
        '1',
        'Unendlich viele',
      ],
      richtig: 0,
      erklaerung:
          'Die Schleife läuft einmal pro Eintrag, die Liste hat 4 '
          'Einträge, also 4 Zeilen. Die Länge der Liste bestimmt die '
          'Anzahl der Durchläufe.',
    )),

    UeberschriftBlock('Zählen mit range()'),
    TextBlock(
      'Manchmal gibt es keine Liste, du willst einfach x-mal etwas tun. '
      'Dafür liefert `range(n)` die Zahlen von 0 bis n minus 1. Auch '
      'hier zählt Python ab 0, wie beim Listen-Index.',
    ),
    CodeBlock(
      'for i in range(3):\n    print(i)',
      titel: 'Ausgabe: 0, 1, 2',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-7-4',
      frage: 'Die Schleife soll die Zahlen 0, 1, 2 und 3 ausgeben. Was '
          'gehört in die Klammer?',
      vorlage: 'for i in range(___):\n    print(i)',
      loesungen: [
        ['4'],
      ],
      bausteine: ['4', '3', '0,3'],
      erklaerung:
          'range(4) liefert 0, 1, 2, 3: vier Zahlen, aber die letzte ist '
          'immer eins WENIGER als die Zahl in der Klammer. Diese '
          'Verschiebung um eins ist DIE range-Falle in Prüfungen.',
    )),

    UeberschriftBlock('Das Summen-Muster'),
    TextBlock(
      'Das wichtigste Schleifenmuster überhaupt: einen Zähler vor der '
      'Schleife auf 0 setzen und in jedem Durchlauf etwas draufrechnen. '
      'So berechnet die Nordwind GmbH den Wert einer ganzen Bestellung.',
    ),
    CodeBlock(
      'preise = [10, 20, 30]\nsumme = 0\n'
      'for preis in preise:\n    summe = summe + preis\n'
      'print(summe)',
      titel: 'Ausgabe: 60',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-7-5',
      frage: 'Gleiches Muster, andere Zahlen:\n'
          'preise = [100, 50]\nsumme = 0\n'
          'for preis in preise:\n    summe = summe + preis\n'
          'print(summe)\n'
          'Was wird ausgegeben?',
      optionen: [
        '150',
        '10050',
        '50',
      ],
      richtig: 0,
      erklaerung:
          'Erster Durchlauf: 0 + 100 ist 100. Zweiter: 100 + 50 ist 150. '
          'Die Summe wächst mit jedem Durchlauf, weil summe immer den '
          'Stand von davor enthält. Es sind Zahlen, kein Text, deshalb '
          'wird gerechnet statt angeklebt.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-7-6',
      frage: 'Dieses Programm stürzt ab. Finde die kaputte Zeile und '
          'schreib sie richtig.',
      zeilen: [
        'lager = ["Maus", "Tastatur"]',
        'for artikel in lager',
        '    print(artikel)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'for artikel in lager:',
      ],
      tipp: 'Dieselbe Kleinigkeit, die auch beim if gern vergessen wird.',
      erklaerung:
          'Der Doppelpunkt fehlt. Er gehört ans Ende JEDER Zeile, die '
          'einen eingerückten Block ankündigt: if, else, for, und später '
          'auch while und def.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-7-7',
      frage: 'Das Programm soll die Bestellsumme berechnen: Zähler '
          'anlegen, alle Preise aufaddieren, Ergebnis ausgeben. Bring die '
          'Zeilen in die richtige Reihenfolge.',
      zeilen: [
        'preise = [249, 89, 45]',
        'summe = 0',
        'for preis in preise:',
        'summe = summe + preis',
        'print(f"Bestellwert: {summe} Euro")',
      ],
      einrueckung: [0, 0, 0, 1, 0],
      erklaerung:
          'summe muss VOR der Schleife auf 0 stehen, sonst gäbe es beim '
          'ersten Draufrechnen nichts zum Draufrechnen. Das print steht '
          'NICHT eingerückt, es soll ja nur einmal am Ende laufen, nicht '
          'bei jedem Durchlauf. Ergebnis: 383 Euro.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 8 — Die while-Schleife
// ═══════════════════════════════════════════════════════════════════════════

const _lektion8 = Lektion(
  nr: 8,
  slug: 'python-8',
  titel: 'Die while-Schleife',
  kurzbeschreibung:
      'Wiederholen, solange eine Bedingung gilt, und die Endlosschleifen-Falle.',
  dauerMinuten: 18,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-8-1',
      frage: 'Aufwärmen aus Lektion 7:\n'
          'for i in range(3):\n    print(i)\n'
          'Was wird ausgegeben?',
      optionen: [
        '0, 1, 2',
        '1, 2, 3',
        '0, 1, 2, 3',
      ],
      richtig: 0,
      erklaerung:
          'range(3) startet bei 0 und hört VOR der 3 auf. Die for-Schleife '
          'kennt ihre Rundenzahl vorher. Jetzt kommt die Schleife für '
          'Fälle, in denen man sie nicht kennt.',
    )),

    UeberschriftBlock('Solange, nicht x-mal'),
    TextBlock(
      'Die for-Schleife läuft eine feste Anzahl Runden. Die '
      '**while-Schleife** läuft, SOLANGE eine Bedingung wahr ist. Wie ein '
      'Wasserhahn: er läuft nicht dreimal, er läuft, solange er offen ist.',
    ),
    CodeBlock(
      'restbestand = 3\nwhile restbestand > 0:\n'
      '    print("Artikel verkauft")\n'
      '    restbestand = restbestand - 1',
      titel: 'Ausgabe: dreimal „Artikel verkauft"',
    ),
    TextBlock(
      'Vor jeder Runde prüft Python die Bedingung. Ist sie wahr, läuft '
      'der eingerückte Block. Ist sie falsch, geht es unter der Schleife '
      'weiter. Doppelpunkt und Einrückung: gleiche Regeln wie bei if und '
      'for.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-8-2',
      frage: 'Die Schleife soll laufen, solange noch Vorrat da ist, also '
          'solange vorrat größer als 0 ist.',
      vorlage: 'while vorrat ___ 0:\n    print("verkauft")\n'
          '    vorrat = vorrat - 1',
      loesungen: [
        ['>'],
      ],
      bausteine: ['>', '<', '=='],
      erklaerung:
          'Solange vorrat GRÖSSER als 0 ist, wird verkauft. Mit < würde '
          'die Schleife bei vollem Lager gar nicht erst starten.',
    )),

    UeberschriftBlock('Der Zähler in der Schleife'),
    TextBlock(
      'Das Wichtigste an while: **in der Schleife muss sich etwas '
      'ändern**, das die Bedingung irgendwann falsch macht. Meistens ist '
      'das ein Zähler, der rauf- oder runterzählt.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-8-3',
      frage: 'Bei jedem Verkauf soll der Vorrat um 1 sinken. '
          'Vervollständige die Zeile.',
      vorlage: 'while vorrat > 0:\n    print("verkauft")\n'
          '    vorrat = vorrat ___ 1',
      loesungen: [
        ['-'],
      ],
      bausteine: ['-', '+', '='],
      erklaerung:
          'vorrat = vorrat - 1 zieht bei jeder Runde eins ab. Mit + würde '
          'der Vorrat wachsen und die Schleife NIE enden. Genau das '
          'schauen wir uns jetzt an.',
    )),

    UeberschriftBlock('Die Endlosschleife'),
    TextBlock(
      'Vergisst du die Änderung, bleibt die Bedingung für immer wahr und '
      'das Programm hängt fest. Das nennt man **Endlosschleife**, und '
      'jeder Entwickler hat schon versehentlich eine gebaut.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-8-4',
      frage: 'i = 1\nwhile i <= 3:\n    print(i)\n'
          'Was passiert bei diesem Programm?',
      optionen: [
        'Es gibt endlos 1 aus und hängt fest',
        'Es gibt 1, 2, 3 aus und endet',
        'Es gibt nichts aus',
      ],
      richtig: 0,
      erklaerung:
          'i bleibt für immer 1, denn in der Schleife fehlt das '
          'i = i + 1. Die Bedingung 1 <= 3 ist ewig wahr. In der Praxis '
          'heißt das: Programm eingefroren, Lüfter dreht auf.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-8-5',
      frage: 'Dieses Programm soll 1, 2, 3 ausgeben, gibt aber NICHTS '
          'aus. Finde die kaputte Zeile und schreib sie richtig.',
      zeilen: [
        'i = 1',
        'while i >= 3:',
        '    print(i)',
        '    i = i + 1',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'while i <= 3:',
      ],
      tipp: 'Prüf die Bedingung mit i = 1 im Kopf: ist 1 >= 3 wahr?',
      erklaerung:
          '1 >= 3 ist von Anfang an falsch, die Schleife startet nie. '
          'Richtig ist i <= 3: laufen, solange i höchstens 3 ist. '
          'Verdrehte Vergleiche sind der zweithäufigste while-Fehler nach '
          'der Endlosschleife.',
    )),

    HinweisBlock(
      'Faustregel für die Wahl der Schleife: Anzahl bekannt oder eine '
      'Liste da? Nimm for. Läuft es „bis etwas passiert"? Nimm while. '
      'Mit `break` kannst du übrigens jede Schleife sofort verlassen, '
      'das brauchen wir später beim Suchen.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-8-6',
      frage: 'Die Nordwind GmbH will jeden Artikel einer Liste einmal '
          'ausgeben. Welche Schleife passt am besten?',
      optionen: [
        'for, weil eine Liste mit bekannter Länge da ist',
        'while, weil sie flexibler ist',
        'Beide gehen überhaupt nicht',
      ],
      richtig: 0,
      erklaerung:
          'Für Listen ist for gebaut: kein Zähler, keine Bedingung, kein '
          'Endlos-Risiko. while glänzt, wenn die Rundenzahl vorher '
          'unbekannt ist, etwa „frage, bis die Eingabe passt".',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-8-7',
      frage: 'Der Ausverkauf: solange Vorrat da ist, wird verkauft, '
          'danach kommt die Meldung. Bring die Zeilen in die richtige '
          'Reihenfolge.',
      zeilen: [
        'restbestand = 3',
        'while restbestand > 0:',
        'print("Artikel verkauft")',
        'restbestand = restbestand - 1',
        'print("Ausverkauft")',
      ],
      einrueckung: [0, 0, 1, 1, 0],
      erklaerung:
          'Der Zähler startet vor der Schleife, verkaufen und runterzählen '
          'sind eingerückt, und das nicht eingerückte „Ausverkauft" läuft '
          'genau einmal, wenn die Bedingung falsch geworden ist.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 9 — Funktionen, Teil 1
// ═══════════════════════════════════════════════════════════════════════════

const _lektion9 = Lektion(
  nr: 9,
  slug: 'python-9',
  titel: 'Funktionen, Teil 1',
  kurzbeschreibung:
      'Code einmal schreiben, überall benutzen: def, Parameter und return.',
  dauerMinuten: 20,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-9-1',
      frage: 'Aufwärmen aus Lektion 8:\n'
          'i = 5\nwhile i > 0:\n    i = i - 1\n'
          'Endet diese Schleife?',
      optionen: [
        'Ja, nach 5 Runden ist i gleich 0',
        'Nein, sie läuft endlos',
        'Sie startet gar nicht',
      ],
      richtig: 0,
      erklaerung:
          'i sinkt jede Runde, nach 5 Runden ist 0 > 0 falsch und die '
          'Schleife endet sauber. Weiter zu einem der wichtigsten Themen '
          'überhaupt.',
    )),

    UeberschriftBlock('Werkzeuge bauen'),
    TextBlock(
      'Stell dir vor, die Rabattberechnung der Nordwind GmbH wird an '
      'zehn Stellen im Programm gebraucht. Zehnmal kopieren? Und wenn '
      'sich der Rabatt ändert, zehn Stellen anfassen? Eine **Funktion** '
      'löst das: Code bekommt einen Namen und wird bei Bedarf aufgerufen.',
    ),
    CodeBlock(
      'def begruessung():\n    print("Willkommen bei Nordwind")\n\n'
      'begruessung()\nbegruessung()',
      titel: 'Ausgabe: zweimal „Willkommen bei Nordwind"',
    ),
    TextBlock(
      '`def` heißt define, also festlegen. Danach kommt der selbst '
      'gewählte Name, Klammern, Doppelpunkt, eingerückter Block. '
      'Aufgerufen wird die Funktion über ihren Namen mit Klammern.',
    ),
    HinweisBlock(
      'Die Definition allein TUT noch nichts. Sie legt das Werkzeug nur '
      'in die Werkzeugkiste. Erst der Aufruf mit den Klammern holt es '
      'raus und benutzt es.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-9-2',
      frage: 'Definiere eine Funktion namens begruessung.',
      vorlage: '___ begruessung():\n    print("Willkommen")',
      loesungen: [
        ['def'],
      ],
      bausteine: ['def', 'funktion', 'make'],
      erklaerung:
          'def ist das Schlüsselwort für neue Funktionen. Es gehört zu '
          'den Wörtern, die in der AP1 gern abgefragt werden.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-9-3',
      frage: 'def gruss():\n    print("Hallo")\n\n'
          'Das ist das GANZE Programm. Was gibt es aus?',
      optionen: [
        'Nichts',
        'Hallo',
        'gruss',
      ],
      richtig: 0,
      erklaerung:
          'Die Funktion wird definiert, aber nie aufgerufen. Ohne '
          'gruss() am Ende bleibt das Werkzeug in der Kiste. Dieser '
          'Unterschied zwischen Definieren und Aufrufen ist die halbe '
          'Miete beim Verstehen von Funktionen.',
    )),

    UeberschriftBlock('Parameter: Werte hineingeben'),
    TextBlock(
      'Richtig nützlich werden Funktionen mit **Parametern**: '
      'Platzhaltern in den Klammern, die beim Aufruf gefüllt werden.',
    ),
    CodeBlock(
      'def begruessung(name):\n    print(f"Hallo, {name}!")\n\n'
      'begruessung("Frau Sommer")\nbegruessung("Herr Winter")',
      titel: 'Ausgabe: Hallo, Frau Sommer! / Hallo, Herr Winter!',
    ),

    UeberschriftBlock('return: Werte herausgeben'),
    TextBlock(
      'print zeigt nur etwas an. **return** gibt einen Wert ans Programm '
      'ZURÜCK, damit dort weitergerechnet werden kann. Das ist der '
      'Unterschied zwischen „Ergebnis auf einen Zettel schreiben" und '
      '„Ergebnis in die Hand drücken".',
    ),
    CodeBlock(
      'def rabattpreis(preis):\n    return preis * 0.9\n\n'
      'neu = rabattpreis(200)\nprint(neu)',
      titel: 'Ausgabe: 180.0',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-9-4',
      frage: 'Die Funktion soll den Preis mit Mehrwertsteuer ans Programm '
          'zurückgeben, nicht nur anzeigen.',
      vorlage: 'def brutto(netto):\n    ___ netto * 1.19',
      loesungen: [
        ['return'],
      ],
      bausteine: ['return', 'print', 'ergebnis'],
      erklaerung:
          'return liefert den Wert an den Aufrufer, der damit '
          'weiterarbeiten kann. Mit print würde die Zahl nur auf dem '
          'Bildschirm landen und wäre fürs Programm verloren.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-9-5',
      frage: 'def rabattpreis(preis):\n    return preis * 0.9\n\n'
          'print(rabattpreis(100))\n'
          'Was wird ausgegeben?',
      optionen: [
        '90.0',
        '100',
        '0.9',
      ],
      richtig: 0,
      erklaerung:
          'Der Aufruf füllt preis mit 100, die Funktion gibt 100 mal 0.9 '
          'zurück, print zeigt 90.0. Das .0 kommt daher, dass beim '
          'Rechnen mit Kommazahlen eine Kommazahl herauskommt.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-9-6',
      frage: 'Die Funktion soll den doppelten Wert ZURÜCKGEBEN, damit '
          'die letzte Zeile funktioniert. Momentan kommt dort None an. '
          'Repariere die kaputte Zeile.',
      zeilen: [
        'def doppelt(x):',
        '    print(x * 2)',
        '',
        'ergebnis = doppelt(5)',
        'print(ergebnis + 1)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'return x * 2',
        '    return x * 2',
      ],
      tipp: 'Anzeigen und Zurückgeben sind zwei verschiedene Dinge.',
      erklaerung:
          'Eine Funktion ohne return liefert automatisch None, das '
          'Python-Wort für „nichts". None + 1 stürzt ab. Mit return x * 2 '
          'bekommt ergebnis die 10 und die Rechnung klappt. Merke: print '
          'ist für Menschen, return ist fürs Programm.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-9-7',
      frage: 'Baue das komplette Programm: Funktion für den Gesamtpreis '
          'definieren, dann aufrufen, dann das Ergebnis ausgeben.',
      zeilen: [
        'def gesamtpreis(preis, anzahl):',
        'return preis * anzahl',
        'betrag = gesamtpreis(45, 3)',
        'print(f"Zu zahlen: {betrag} Euro")',
      ],
      einrueckung: [0, 1, 0, 0],
      erklaerung:
          'Erst die Definition, dann der Aufruf, dann die Ausgabe: 135 '
          'Euro. Zwei Parameter werden beim Aufruf in derselben '
          'Reihenfolge gefüllt: preis wird 45, anzahl wird 3. Mehr dazu '
          'in der nächsten Lektion.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 10 — Funktionen, Teil 2
// ═══════════════════════════════════════════════════════════════════════════

const _lektion10 = Lektion(
  nr: 10,
  slug: 'python-10',
  titel: 'Funktionen, Teil 2',
  kurzbeschreibung:
      'Mehrere Parameter, Standardwerte und was in der Funktion bleibt.',
  dauerMinuten: 18,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-10-1',
      frage: 'Aufwärmen aus Lektion 9:\n'
          'def halb(x):\n    return x / 2\n\nprint(halb(10))\n'
          'Was wird ausgegeben?',
      optionen: [
        '5.0',
        '10',
        'None',
      ],
      richtig: 0,
      erklaerung:
          'x wird 10, zurück kommt 5.0. Teilen liefert in Python immer '
          'eine Kommazahl, auch wenn es aufgeht.',
    )),

    UeberschriftBlock('Die Reihenfolge der Argumente'),
    TextBlock(
      'Bei mehreren Parametern füllt Python die Werte stur der Reihe '
      'nach: erster Wert in ersten Parameter, zweiter in zweiten. '
      'Vertauschen ändert das Ergebnis.',
    ),
    CodeBlock(
      'def teile(a, b):\n    return a / b\n\n'
      'print(teile(10, 2))\nprint(teile(2, 10))',
      titel: 'Ausgabe: 5.0, dann 0.2',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-10-2',
      frage: 'def abziehen(von, wert):\n    return von - wert\n\n'
          'print(abziehen(100, 30))\n'
          'Was wird ausgegeben?',
      optionen: [
        '70',
        '-70',
        '130',
      ],
      richtig: 0,
      erklaerung:
          'von wird 100, wert wird 30, also 100 minus 30. Bei '
          'abziehen(30, 100) käme -70 heraus: gleiche Funktion, andere '
          'Reihenfolge, anderes Ergebnis.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-10-3',
      frage: 'Schreib eine Funktion, die den Lagerwert berechnet: '
          'Stückpreis mal Stückzahl.',
      vorlage: 'def lagerwert(stueckpreis, stueckzahl):\n'
          '    return stueckpreis ___ stueckzahl',
      loesungen: [
        ['*'],
      ],
      bausteine: ['*', '+', '/'],
      erklaerung:
          'Wert im Lager heißt Preis mal Menge. lagerwert(249, 4) liefert '
          '996. Die Funktion funktioniert für jeden Artikel, das ist der '
          'ganze Sinn der Parameter.',
    )),

    UeberschriftBlock('Standardwerte'),
    TextBlock(
      'Ein Parameter kann einen **Standardwert** haben, der gilt, wenn '
      'beim Aufruf nichts angegeben wird. Praktisch für Dinge, die '
      'meistens gleich sind.',
    ),
    CodeBlock(
      'def versandkosten(gewicht, express=False):\n'
      '    if express:\n        return gewicht * 2.0\n'
      '    return gewicht * 0.5\n\n'
      'print(versandkosten(10))\nprint(versandkosten(10, True))',
      titel: 'Ausgabe: 5.0, dann 20.0',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-10-4',
      frage: 'Die Begrüßung soll standardmäßig auf Deutsch laufen. Setz '
          'den Standardwert.',
      vorlage: 'def gruss(name, sprache___"de"):\n'
          '    print(name, sprache)',
      loesungen: [
        ['='],
      ],
      bausteine: ['=', '==', ':'],
      erklaerung:
          'In der Klammer setzt das EINFACHE Gleichheitszeichen den '
          'Standardwert. Das doppelte == wäre ein Vergleich und gehört '
          'hier nicht hin. Ausnahmsweise ist also = richtig und == falsch.',
    )),

    UeberschriftBlock('Was in der Funktion bleibt'),
    TextBlock(
      'Variablen, die INNERHALB einer Funktion angelegt werden, '
      'existieren nur dort. Von außen sind sie unsichtbar, wie Werkzeug, '
      'das nach Feierabend wieder in der Kiste liegt. Der Fachbegriff '
      'dafür ist Gültigkeitsbereich, englisch Scope.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-10-5',
      frage: 'def rechne():\n    zwischensumme = 50\n\nrechne()\n'
          'print(zwischensumme)\n'
          'Was passiert?',
      optionen: [
        'Fehlermeldung: zwischensumme ist außerhalb unbekannt',
        'Es gibt 50 aus',
        'Es gibt None aus',
      ],
      richtig: 0,
      erklaerung:
          'zwischensumme lebt nur innerhalb von rechne() und wird nach '
          'dem Aufruf entsorgt. Wer den Wert draußen braucht, gibt ihn '
          'mit return heraus. Genau dafür ist return da.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-10-6',
      frage: 'Dieses Programm stürzt mit einem SyntaxError ab. Finde die '
          'kaputte Zeile und schreib sie richtig.',
      zeilen: [
        'def gesamt(preis anzahl):',
        '    return preis * anzahl',
        '',
        'print(gesamt(89, 5))',
      ],
      fehlerZeile: 0,
      korrekturen: [
        'def gesamt(preis, anzahl):',
      ],
      tipp: 'Wie werden mehrere Parameter in der Klammer getrennt?',
      erklaerung:
          'Zwischen Parametern gehört ein Komma. Ohne Komma liest Python '
          '„preis anzahl" als ein kaputtes Wort und bricht ab. Ergebnis '
          'nach dem Fix: 445.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-10-7',
      frage: 'Das Kassenprogramm: Funktion mit Rabatt-Standardwert '
          'definieren, normal aufrufen, Ergebnis ausgeben.',
      zeilen: [
        'def kasse(betrag, rabatt=0):',
        'return betrag - rabatt',
        'zu_zahlen = kasse(500, 50)',
        'print(f"{zu_zahlen} Euro")',
      ],
      einrueckung: [0, 1, 0, 0],
      erklaerung:
          'kasse(500, 50) überschreibt den Standardwert 0 mit 50, es '
          'bleiben 450 Euro. Bei kasse(500) hätte der Standardwert '
          'gegriffen und es wären 500 geblieben.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 11 — Dictionaries
// ═══════════════════════════════════════════════════════════════════════════

const _lektion11 = Lektion(
  nr: 11,
  slug: 'python-11',
  titel: 'Dictionaries',
  kurzbeschreibung:
      'Daten mit Namen statt Nummern: der Artikel-Steckbrief der Nordwind GmbH.',
  dauerMinuten: 18,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-11-1',
      frage: 'Aufwärmen aus Lektion 10:\n'
          'def netto(brutto, steuer=19):\n'
          '    return brutto / (1 + steuer / 100)\n\n'
          'Welcher Aufruf nutzt den Standardwert?',
      optionen: [
        'netto(119)',
        'netto(119, 7)',
        'netto()',
      ],
      richtig: 0,
      erklaerung:
          'netto(119) lässt steuer weg, also greifen die 19 Prozent. '
          'netto() würde abstürzen, denn brutto hat KEINEN Standardwert.',
    )),

    UeberschriftBlock('Daten mit Namen'),
    TextBlock(
      'In einer Liste findest du Werte über ihre Position: lager[0], '
      'lager[1]. Bei einem Artikel mit Name, Preis und Bestand sind '
      'Nummern aber unhandlich. Was war nochmal Position 2?',
    ),
    TextBlock(
      'Das **Dictionary** (englisch für Wörterbuch) speichert Werte '
      'unter frei gewählten **Schlüsseln**, wie ein Steckbrief: jedes '
      'Feld hat einen Namen.',
    ),
    CodeBlock(
      'artikel = {\n    "name": "Monitor",\n    "preis": 249,\n'
      '    "bestand": 12,\n}\nprint(artikel["preis"])',
      titel: 'Ausgabe: 249',
    ),
    TextBlock(
      'Geschweifte Klammern statt eckiger, und jeder Eintrag ist ein '
      'Paar aus `"schluessel": wert`. Zugreifen funktioniert wie bei der '
      'Liste, nur steht in den eckigen Klammern der Schlüssel statt '
      'einer Nummer.',
    ),
    HinweisBlock(
      'Kommt dir das bekannt vor? Ein Dictionary ist wie EINE ZEILE aus '
      'einer SQL-Tabelle: Spaltenname und Wert. Wer den SQL-Kurs gemacht '
      'hat, ist hier sofort zu Hause.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-11-2',
      frage: 'artikel = {"name": "Monitor", "preis": 249}\n'
          'Was gibt print(artikel["name"]) aus?',
      optionen: [
        'Monitor',
        'name',
        '249',
      ],
      richtig: 0,
      erklaerung:
          'Der Schlüssel "name" führt zum Wert "Monitor". Der Schlüssel '
          'ist die Beschriftung, der Wert ist der Inhalt.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-11-3',
      frage: 'Gib den Bestand des Artikels aus.',
      vorlage: 'artikel = {"name": "Monitor", "preis": 249, "bestand": 12}\n'
          'print(artikel[___])',
      loesungen: [
        ['"bestand"', "'bestand'"],
      ],
      bausteine: ['"bestand"', 'bestand', '2'],
      erklaerung:
          'Der Schlüssel ist ein Text und braucht deshalb '
          'Anführungszeichen. Ohne sie sucht Python eine Variable namens '
          'bestand, und die Nummer 2 funktioniert nur bei Listen, nicht '
          'bei Dictionaries.',
    )),

    UeberschriftBlock('Ändern und ergänzen'),
    TextBlock(
      'Werte änderst du per Zuweisung an den Schlüssel. Und weist du '
      'einem NEUEN Schlüssel etwas zu, wird das Feld einfach angelegt.',
    ),
    CodeBlock(
      'artikel["preis"] = 199\nartikel["lagerplatz"] = "B12"',
      titel: 'Preis geändert, neues Feld angelegt',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-11-4',
      frage: 'Der Monitor ist im Angebot. Setz den Preis auf 199.',
      vorlage: 'artikel["preis"] ___ 199',
      loesungen: [
        ['='],
      ],
      bausteine: ['=', '==', 'ist'],
      erklaerung:
          'Die Zuweisung mit einfachem = überschreibt den Wert hinter dem '
          'Schlüssel, genau wie bei einer normalen Variablen. == wäre '
          'wieder nur die Frage, ob der Preis 199 IST.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-11-5',
      frage: 'kunde = {"name": "Sommer"}\nkunde["ort"] = "Berlin"\n'
          'Was steht danach im Dictionary?',
      optionen: [
        'name Sommer und ort Berlin',
        'Nur ort Berlin, name ist weg',
        'Nichts, das Programm stürzt ab',
      ],
      richtig: 0,
      erklaerung:
          'Die Zuweisung an den neuen Schlüssel "ort" legt das Feld '
          'zusätzlich an, vorhandene Felder bleiben unberührt. So wächst '
          'ein Steckbrief Feld für Feld.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-11-6',
      frage: 'Dieses Programm stürzt mit einem KeyError ab. Finde die '
          'kaputte Zeile und schreib sie richtig.',
      zeilen: [
        'artikel = {"name": "Monitor", "preis": 249}',
        'print(artikel["Preis"])',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print(artikel["preis"])',
      ],
      tipp: 'Vergleich den Schlüssel im print ganz genau mit dem im '
          'Dictionary. Auch die Groß- und Kleinschreibung.',
      erklaerung:
          '"Preis" mit großem P ist für Python ein KOMPLETT anderer '
          'Schlüssel als "preis". KeyError heißt: diesen Schlüssel gibt '
          'es hier nicht. Schlüssel müssen aufs Zeichen genau stimmen.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-11-7',
      frage: 'Der Artikel-Steckbrief: anlegen, Preis senken, dann Name '
          'und neuer Preis in einem Satz ausgeben.',
      zeilen: [
        'artikel = {"name": "Webcam", "preis": 89}',
        'artikel["preis"] = 79',
        'print(f"{artikel[\'name\']} kostet jetzt {artikel[\'preis\']} Euro")',
      ],
      erklaerung:
          'Anlegen, ändern, ausgeben: Webcam kostet jetzt 79 Euro. Im '
          'f-String stehen die Schlüssel in EINFACHEN Anführungszeichen, '
          'damit sie sich nicht mit den doppelten des f-Strings beißen. '
          'Ein kleiner, aber wichtiger Praxis-Trick.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 12 — Strings können mehr
// ═══════════════════════════════════════════════════════════════════════════

const _lektion12 = Lektion(
  nr: 12,
  slug: 'python-12',
  titel: 'Strings können mehr',
  kurzbeschreibung:
      'Text untersuchen, zerlegen und umbauen: upper, in, split und Ausschnitte.',
  dauerMinuten: 18,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-12-1',
      frage: 'Aufwärmen aus Lektion 11:\n'
          'kunde = {"name": "Sommer", "ort": "Berlin"}\n'
          'print(kunde["ort"])\n'
          'Was wird ausgegeben?',
      optionen: [
        'Berlin',
        'ort',
        'Sommer',
      ],
      richtig: 0,
      erklaerung:
          'Der Schlüssel "ort" liefert seinen Wert. Jetzt schauen wir '
          'uns an, was man mit den Werten anstellen kann, wenn sie Text '
          'sind.',
    )),

    UeberschriftBlock('Text hat eingebaute Werkzeuge'),
    TextBlock(
      'Jeder String bringt eigene Fähigkeiten mit, die du mit einem '
      'Punkt dahinter aufrufst. Solche angehängten Befehle heißen '
      '**Methoden**. Die zwei bekanntesten:',
    ),
    CodeBlock(
      'name = "Monitor"\nprint(name.upper())\nprint(name.lower())',
      titel: 'Ausgabe: MONITOR, dann monitor',
    ),
    TextBlock(
      'upper macht alles groß, lower alles klein. Der Wert in `name` '
      'bleibt dabei unverändert, die Methode liefert eine NEUE Version '
      'des Textes.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-12-2',
      frage: 'Was gibt print("Nordwind".upper()) aus?',
      optionen: [
        'NORDWIND',
        'nordwind',
        'Nordwind',
      ],
      richtig: 0,
      erklaerung:
          'upper wandelt jeden Buchstaben in einen Großbuchstaben um. '
          'Praktisch zum Beispiel, um Eingaben zu vergleichen, ohne dass '
          'die Schreibweise stört.',
    )),

    UeberschriftBlock('Ist etwas enthalten? Das in'),
    TextBlock(
      'Mit dem Schlüsselwort `in` prüfst du, ob ein Text in einem '
      'anderen vorkommt. Heraus kommt True oder False, wie bei den '
      'Vergleichen aus Lektion 3. Der Klassiker: die Mini-Prüfung, ob '
      'eine E-Mail-Adresse echt aussehen KÖNNTE.',
    ),
    CodeBlock(
      'email = "info@nordwind.de"\nprint("@" in email)',
      titel: 'Ausgabe: True',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-12-3',
      frage: 'Prüfe, ob im eingegebenen Text ein @ vorkommt.',
      vorlage: 'if "@" ___ eingabe:\n    print("Könnte eine E-Mail sein")',
      loesungen: [
        ['in'],
      ],
      bausteine: ['in', '==', 'hat'],
      erklaerung:
          'in kennst du schon aus der for-Schleife, hier prüft es das '
          'Vorkommen. == würde fragen, ob die GANZE Eingabe nur aus dem '
          '@ besteht, das ist etwas völlig anderes.',
    )),

    UeberschriftBlock('Zerlegen mit split'),
    TextBlock(
      '`split` zerschneidet einen Text an einem Trennzeichen und liefert '
      'eine Liste der Teile. Damit landest du wieder in der Welt von '
      'Lektion 6 und kannst mit for darüberlaufen.',
    ),
    CodeBlock(
      'zeile = "Maus,Tastatur,Monitor"\nteile = zeile.split(",")\n'
      'print(teile)',
      titel: 'Ausgabe: [\'Maus\', \'Tastatur\', \'Monitor\']',
    ),
    HinweisBlock(
      'Genau so liest man CSV-Dateien, das Standardformat für '
      'Datenexporte: eine Zeile, Kommas dazwischen, split, fertig ist '
      'die Liste. Das begegnet dir im Betrieb garantiert.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-12-4',
      frage: 'Die Lagerliste kommt als ein langer Text mit Kommas. '
          'Zerlege sie in einzelne Artikel.',
      vorlage: 'zeile = "Maus,Tastatur,Monitor"\n'
          'artikel = zeile.___(",")',
      loesungen: [
        ['split'],
      ],
      bausteine: ['split', 'cut', 'teilen'],
      erklaerung:
          'split heißt spalten. artikel ist danach eine Liste mit drei '
          'Einträgen, und artikel[0] wäre wieder die Maus.',
    )),

    UeberschriftBlock('Ausschnitte: Slicing'),
    TextBlock(
      'Mit eckigen Klammern und Doppelpunkt schneidest du ein Stück aus '
      'einem Text: `"Monitor"[0:3]` ergibt `"Mon"`. Start bei 0, Ende '
      'VOR dem zweiten Index, dieselbe Logik wie bei range aus '
      'Lektion 7.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-12-5',
      frage: 'Was gibt print("Tastatur"[0:4]) aus?',
      optionen: [
        'Tast',
        'Tasta',
        'astat',
      ],
      richtig: 0,
      erklaerung:
          'Die Zeichen auf Index 0, 1, 2 und 3, also Tast. Der Index 4 '
          'ist wie bei range NICHT mehr dabei. Einmal verstanden, gilt '
          'die Regel überall in Python.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-12-6',
      frage: 'Das Programm soll MONITOR ausgeben, zeigt aber etwas '
          'Seltsames mit "built-in method" an. Repariere die kaputte '
          'Zeile.',
      zeilen: [
        'name = "Monitor"',
        'print(name.upper)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print(name.upper())',
      ],
      tipp: 'Eine Methode ist wie eine Funktion. Was gehört bei jedem '
          'Aufruf dahinter?',
      erklaerung:
          'Ohne Klammern wird die Methode nicht AUSGEFÜHRT, sondern nur '
          'als Objekt angezeigt. Die Klammern sind der Startknopf, bei '
          'Methoden genauso wie bei Funktionen.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-12-7',
      frage: 'Die Nordwind GmbH baut Kundenkürzel: die ersten drei '
          'Buchstaben des Nachnamens, großgeschrieben. Bring die Zeilen '
          'in die richtige Reihenfolge.',
      zeilen: [
        'nachname = "Sommer"',
        'kuerzel = nachname[0:3].upper()',
        'print(f"Kundenkürzel: {kuerzel}")',
      ],
      erklaerung:
          'Erst der Ausschnitt Som, darauf direkt upper zu SOM: Methoden '
          'lassen sich verketten, es wird von links nach rechts '
          'abgearbeitet. Ausgabe: Kundenkürzel: SOM.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 13 — Fehler lesen und abfangen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion13 = Lektion(
  nr: 13,
  slug: 'python-13',
  titel: 'Fehler lesen und abfangen',
  kurzbeschreibung:
      'Fehlermeldungen verstehen statt fürchten, und mit try/except absichern.',
  dauerMinuten: 20,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-13-1',
      frage: 'Aufwärmen aus Lektion 12:\n'
          'print("Drucker"[0:2])\n'
          'Was wird ausgegeben?',
      optionen: [
        'Dr',
        'Dru',
        'ru',
      ],
      richtig: 0,
      erklaerung:
          'Index 0 und 1, Schluss vor Index 2: Dr. Und jetzt zu dem '
          'Thema, vor dem Anfänger am meisten Respekt haben, völlig '
          'unnötigerweise.',
    )),

    UeberschriftBlock('Fehlermeldungen sind Wegweiser'),
    TextBlock(
      'Eine Fehlermeldung ist kein Vorwurf, sie ist eine Wegbeschreibung: '
      'Sie nennt die **Zeilennummer** und den **Fehlertyp**. Die '
      'wichtigste Zeile steht immer GANZ UNTEN.',
    ),
    CodeBlock(
      'Traceback (most recent call last):\n'
      '  File "programm.py", line 2\n'
      'NameError: name \'anzhal\' is not defined',
      titel: 'So sieht eine echte Fehlermeldung aus',
      sprache: 'text',
    ),
    TextBlock(
      'Die Fehlertypen kennst du fast alle schon aus diesem Kurs:\n'
      '- `SyntaxError`: Tippfehler im Aufbau, oft fehlt ein Doppelpunkt\n'
      '- `NameError`: unbekannter Name, oft ein Tippfehler\n'
      '- `TypeError`: Typen passen nicht, etwa Text plus Zahl\n'
      '- `IndexError`: Listenindex zu groß\n'
      '- `KeyError`: Dictionary-Schlüssel gibt es nicht',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-13-2',
      frage: 'preis = 249\nprint(pries)\n'
          'Welcher Fehlertyp erscheint?',
      optionen: [
        'NameError, pries ist nicht definiert',
        'SyntaxError',
        'TypeError',
      ],
      richtig: 0,
      erklaerung:
          'pries statt preis: für Python ein unbekannter Name, also '
          'NameError. Bei einem NameError lohnt IMMER der Blick auf '
          'Tippfehler, das ist in neun von zehn Fällen die Ursache.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-13-3',
      frage: 'Das Programm bricht mit NameError: name \'anzhal\' is not '
          'defined ab. Nutze die Meldung und repariere die kaputte Zeile.',
      zeilen: [
        'anzahl = 12',
        'print(anzhal * 2)',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'print(anzahl * 2)',
      ],
      tipp: 'Die Fehlermeldung nennt dir den falsch geschriebenen Namen '
          'wörtlich.',
      erklaerung:
          'anzhal war ein Buchstabendreher. So arbeitet man mit '
          'Fehlermeldungen: Typ lesen, genannten Namen suchen, mit der '
          'Definition vergleichen. Ausgabe nach dem Fix: 24.',
    )),

    UeberschriftBlock('Der Fehler, der keiner sein muss'),
    TextBlock(
      'Manche Fehler entstehen nicht durch kaputten Code, sondern durch '
      'Dinge von außen: der Benutzer tippt "abc", wo eine Zahl erwartet '
      'wird. `int("abc")` stürzt mit einem **ValueError** ab, und dein '
      'Programm ist raus, obwohl der Code korrekt war.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-13-4',
      frage: 'eingabe = input("Stückzahl: ")\nanzahl = int(eingabe)\n'
          'Der Benutzer tippt "drei". Was passiert?',
      optionen: [
        'ValueError, "drei" lässt sich nicht in eine Zahl wandeln',
        'anzahl wird 3',
        'anzahl wird 0',
      ],
      richtig: 0,
      erklaerung:
          'int() versteht nur Ziffern, das Wort drei nicht. Ohne '
          'Absicherung stürzt hier das ganze Programm ab, wegen einer '
          'einzigen Eingabe. Dagegen gibt es das Sicherheitsnetz.',
    )),

    UeberschriftBlock('Das Sicherheitsnetz: try und except'),
    TextBlock(
      'Mit `try` sagst du: „versuch das hier". Geht dabei etwas schief, '
      'springt Python in den `except`-Block, statt abzustürzen. Wie ein '
      'Netz unter dem Hochseil: der Sturz passiert, aber er tut nicht '
      'weh.',
    ),
    CodeBlock(
      'try:\n    anzahl = int(eingabe)\n    print(anzahl * 89)\n'
      'except ValueError:\n    print("Bitte eine Zahl eingeben")',
      titel: 'Absturz abgefangen',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-13-5',
      frage: 'Sichere die Umwandlung der Benutzereingabe ab.',
      vorlage: '___:\n    anzahl = int(eingabe)\n'
          '___ ValueError:\n    print("Bitte eine Zahl eingeben")',
      loesungen: [
        ['try'],
        ['except'],
      ],
      bausteine: ['try', 'except', 'if', 'else'],
      erklaerung:
          'try umschließt den riskanten Teil, except fängt den genannten '
          'Fehler. if/else können das nicht: sie prüfen Bedingungen, '
          'aber sie fangen keine Abstürze.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-13-6',
      frage: 'try:\n    anzahl = int("7")\n    print("Alles gut")\n'
          'except ValueError:\n    print("Keine Zahl")\n'
          'Was wird ausgegeben?',
      optionen: [
        'Alles gut',
        'Keine Zahl',
        'Beides',
      ],
      richtig: 0,
      erklaerung:
          '"7" lässt sich problemlos umwandeln, es passiert kein Fehler, '
          'und der except-Block wird komplett übersprungen. Er läuft NUR '
          'im Fehlerfall, wie else beim if nur im Sonst-Fall.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-13-7',
      frage: 'Die abgesicherte Stückzahl-Abfrage der Nordwind GmbH: '
          'bring die Zeilen in die richtige Reihenfolge.',
      zeilen: [
        'eingabe = input("Stückzahl: ")',
        'try:',
        'anzahl = int(eingabe)',
        'print(f"Preis: {anzahl * 89} Euro")',
        'except ValueError:',
        'print("Bitte eine ganze Zahl eingeben")',
      ],
      einrueckung: [0, 0, 1, 1, 0, 1],
      erklaerung:
          'Die Eingabe selbst ist harmlos und steht vor dem try. '
          'Riskant ist nur die Umwandlung, deshalb stehen int und die '
          'Preisrechnung im try-Block, und except steht auf gleicher '
          'Höhe wie try. Genau so sehen robuste Eingaben in der Praxis '
          'aus.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 14 — Alles zusammen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion14 = Lektion(
  nr: 14,
  slug: 'python-14',
  titel: 'Alles zusammen',
  kurzbeschreibung:
      'Komplette Programme lesen, Pseudocode übersetzen und das große Finale.',
  dauerMinuten: 22,
  premium: true,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    AufgabenBlock(AuswahlAufgabe(
      id: 'py-14-1',
      frage: 'Aufwärmen aus Lektion 13: Wann läuft der except-Block?',
      optionen: [
        'Nur wenn im try-Block ein passender Fehler passiert',
        'Immer, direkt nach dem try-Block',
        'Nie, er ist nur Dokumentation',
      ],
      richtig: 0,
      erklaerung:
          'except ist das Sicherheitsnetz und bleibt unsichtbar, solange '
          'nichts schiefgeht. Und jetzt: alles aus 13 Lektionen in einem '
          'Finale.',
    )),

    UeberschriftBlock('Programme lesen wie ein Profi'),
    TextBlock(
      'In der AP1 bekommst du fertigen Code und die Frage: „Was gibt '
      'dieses Programm aus?" Die Technik dafür heißt Trockenlauf: geh '
      'Zeile für Zeile durch und führ Buch über jede Variable, wie '
      'Python es tun würde.',
    ),
    CodeBlock(
      'preise = [249, 89, 512]\nteuer = 0\n'
      'for preis in preise:\n    if preis > 100:\n'
      '        teuer = teuer + 1\nprint(teuer)',
      titel: 'Schleife und if, ineinander verschachtelt',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-14-2',
      frage: 'Geh das Programm oben im Kopf durch. Was gibt es aus?',
      optionen: [
        '2',
        '3',
        '761',
      ],
      richtig: 0,
      erklaerung:
          'Trockenlauf: 249 > 100, teuer wird 1. 89 nicht, bleibt 1. '
          '512 > 100, teuer wird 2. Das if steckt IN der Schleife und '
          'wird bei jedem Durchlauf neu geprüft. So löst man diese '
          'Fragen sicher: mitschreiben statt raten.',
    )),

    UeberschriftBlock('Vom Pseudocode zu Python'),
    TextBlock(
      'Prüfungsaufgaben beschreiben Abläufe oft in **Pseudocode** oder '
      'als Struktogramm: deutsche Wörter, keine echte Sprache. Die '
      'Übersetzung ist ein Wörterbuch mit vier Einträgen:\n'
      '- WENN / SONST wird zu `if` / `else`\n'
      '- SOLANGE wird zu `while`\n'
      '- FÜR JEDES wird zu `for ... in`\n'
      '- GIB AUS wird zu `print`',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'py-14-3',
      frage: 'Im Struktogramm steht: „SOLANGE Vorrat größer 0: verkaufe". '
          'Welche Python-Zeile passt?',
      optionen: [
        'while vorrat > 0:',
        'if vorrat > 0:',
        'for vorrat in range(0):',
      ],
      richtig: 0,
      erklaerung:
          'SOLANGE ist wörtlich das while: wiederholen, bis die '
          'Bedingung kippt. Ein if würde nur EINMAL prüfen und genau '
          'einmal verkaufen.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'py-14-4',
      frage: 'Übersetze den Pseudocode in Python: „WENN der Bestand '
          'kleiner als 5 ist, GIB AUS: Nachbestellen"',
      vorlage: '___ bestand ___ 5:\n    print("Nachbestellen")',
      loesungen: [
        ['if'],
        ['<'],
      ],
      bausteine: ['if', 'while', '<', '>', '=='],
      erklaerung:
          'WENN ist eine einmalige Prüfung, also if, und „kleiner als" '
          'ist das <. Mit while würde die Warnung endlos wiederholt, '
          'denn in der Schleife ändert sich der Bestand nicht.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'py-14-5',
      frage: 'Das Programm soll die Summe ALLER Preise ausgeben, zeigt '
          'aber nur 45. Finde die kaputte Zeile und schreib sie richtig.',
      zeilen: [
        'preise = [249, 89, 45]',
        'summe = 0',
        'for preis in preise:',
        '    summe = preis',
        'print(summe)',
      ],
      fehlerZeile: 3,
      korrekturen: [
        'summe = summe + preis',
        '    summe = summe + preis',
        'summe += preis',
        '    summe += preis',
      ],
      tipp: 'Vergleich die Zeile mit dem Summen-Muster aus Lektion 7. '
          'Was fehlt auf der rechten Seite?',
      erklaerung:
          'summe = preis ÜBERSCHREIBT die Summe bei jedem Durchlauf, am '
          'Ende bleibt nur der letzte Preis übrig. summe = summe + preis '
          'rechnet ihn DAZU. Ein einziger fehlender Ausdruck, ein völlig '
          'anderes Programm. Übrigens: summe += preis ist die Kurzform '
          'davon.',
    )),

    UeberschriftBlock('Das Finale'),
    TextBlock(
      'Zum Abschluss ein komplettes Programm mit allem, was du gelernt '
      'hast: Funktion, Liste, Schleife, if und f-String. Die Nordwind '
      'GmbH will wissen, wie viele Artikel nachbestellt werden müssen.',
    ),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'py-14-6',
      frage: 'Bring das komplette Nachbestell-Programm in die richtige '
          'Reihenfolge. Achte auf die Einrückung: das if steckt in der '
          'Schleife.',
      zeilen: [
        'def ist_knapp(bestand):',
        'return bestand < 5',
        'bestaende = [12, 3, 7, 1]',
        'knapp = 0',
        'for bestand in bestaende:',
        'if ist_knapp(bestand):',
        'knapp = knapp + 1',
        'print(f"{knapp} Artikel nachbestellen")',
      ],
      einrueckung: [0, 1, 0, 0, 0, 1, 2, 0],
      erklaerung:
          'Funktion definieren, Daten anlegen, Zähler auf 0, dann pro '
          'Bestand prüfen und zählen: 3 und 1 sind knapp, Ausgabe: 2 '
          'Artikel nachbestellen. Wenn du dieses Programm fließend lesen '
          'kannst, hast du das Fundament von Python komplett.',
    )),

    UeberschriftBlock('Geschafft!'),
    TextBlock(
      'Das war der Python-Kurs: von print("Hallo") bis zu einem '
      'Programm aus Funktion, Liste, Schleife und Bedingung. Damit '
      'liest du den Python-Code der AP1 nicht mehr als Zeichensalat, '
      'sondern als das, was er ist: eine Anleitung von oben nach unten.',
    ),
    HinweisBlock(
      'So bleibt es hängen: übe die Muster regelmäßig in den Levels, '
      'fordere andere im Duell heraus, und wenn du Datenbanken noch '
      'nicht hattest, wartet der SQL-Kurs mit derselben Nordwind GmbH '
      'auf dich.',
    ),
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
  // Kurs im Aufbau: Badges rechnen gegen die geplanten 14 Lektionen,
  // nicht gegen die schon vorhandenen.
  lektionenGeplant: 14,
  lektionen: [
    _lektion1,
    _lektion2,
    _lektion3,
    _lektion4,
    _lektion5,
    _lektion6,
    _lektion7,
    _lektion8,
    _lektion9,
    _lektion10,
    _lektion11,
    _lektion12,
    _lektion13,
    _lektion14,
  ],
);
