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
  ],
);
