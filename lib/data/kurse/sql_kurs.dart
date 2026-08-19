// lib/data/kurse/sql_kurs.dart
//
// Inhalt des SQL-Kurses. Reine Daten — kein Layout, keine Widgets.
// Eine neue Lektion ist ein Eintrag in der Liste unten, keine neue Datei.
//
// Tonfall: direkt, ohne Fachjargon ohne Erklärung, ohne "einfach mal".
// Zielgruppe sind Umschüler und Azubis, die vielleicht noch nie eine
// Datenbank gesehen haben, aber in der AP1 damit umgehen müssen.

import '../../models/kurs_aufgabe.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 1 — Was ist eine Datenbank, und wie frage ich sie?
// ═══════════════════════════════════════════════════════════════════════════

const _lektion1 = Lektion(
  nr: 1,
  slug: 'sql-1',
  titel: 'Die erste Abfrage',
  kurzbeschreibung:
      'Tabellen, Zeilen, Spalten und dein erstes SELECT, Schritt für Schritt.',
  dauerMinuten: 18,
  bloecke: [
    TextBlock(
      'Eine Datenbank ist im Kern nichts anderes als eine Sammlung von '
      'Tabellen. Wer schon mal mit Excel gearbeitet hat, kennt das Bild: '
      'oben stehen die **Spalten** mit ihren Namen, darunter die **Zeilen** '
      'mit den eigentlichen Daten.',
    ),
    TextBlock(
      'Der Unterschied zu Excel: eine Datenbank passt auf sich selbst auf. '
      'Sie sorgt dafür, dass in einer Preisspalte keine Telefonnummer landet, '
      'dass zwei Kunden nicht dieselbe Kundennummer bekommen, und dass '
      'hundert Leute gleichzeitig arbeiten können, ohne sich gegenseitig '
      'Daten zu überschreiben.',
    ),
    UeberschriftBlock('Die Datenbank in diesem Kurs'),
    TextBlock(
      'Du arbeitest den ganzen Kurs über mit der **Nordwind GmbH**, einem '
      'Händler für IT-Hardware. Sechs Tabellen:',
    ),
    TextBlock(
      '- `kunden`: wer bestellt\n'
      '- `artikel`: was verkauft wird\n'
      '- `bestellungen`: wer wann bestellt hat\n'
      '- `positionen`: was in einer Bestellung drin war\n'
      '- `mitarbeiter`: wer im Betrieb arbeitet\n'
      '- `abteilungen`: wo diese Leute sitzen',
    ),
    HinweisBlock(
      'Über den Knopf „Tabellen" bei jeder Aufgabe siehst du jederzeit alle '
      'Spaltennamen. Auswendiglernen musst du die nicht. Das macht in der '
      'Praxis auch niemand.',
    ),
    // ─── Stufe 1: eine einzige Spalte ────────────────────────────────
    UeberschriftBlock('Eine Spalte abfragen'),
    TextBlock(
      'Eine Abfrage beantwortet immer zwei Fragen: **welche Spalte** willst '
      'du sehen, und **aus welcher Tabelle**. Genau in dieser Reihenfolge.',
    ),
    CodeBlock(
      'SELECT name FROM kunden;',
      titel: 'Die Namen aller Kunden',
      sprache: 'sql',
    ),
    TextBlock(
      'Wort für Wort gelesen:\n'
      '- `SELECT`: „zeig mir"\n'
      '- `name`: die Spalte, die du sehen willst\n'
      '- `FROM`: „aus"\n'
      '- `kunden`: die Tabelle\n'
      '- `;`: Ende der Anweisung',
    ),
    HinweisBlock(
      'Dieses Muster ändert sich nie: **SELECT Spalte FROM Tabelle;** '
      'Alles Weitere im Kurs wird davor, dahinter oder dazwischen gesetzt. '
      'Dieser Kern bleibt.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-1-1',
      frage: 'Bau die Abfrage aus dem Beispiel nach: '
          'zeig die Namen aller Kunden.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT name FROM kunden;',
      // Allererste Aufgabe: genau die Bausteine, die gebraucht werden.
      // Keine Falle — hier geht es nur darum, das Muster einmal zu bauen.
      bausteine: ['SELECT', 'name', 'FROM', 'kunden', ';'],
      erklaerung:
          'Zwölf Namen. Das war deine erste echte Datenbankabfrage, '
          'genau dieses Muster wirst du noch tausendmal schreiben.',
    )),

    // ─── Stufe 2: dasselbe nochmal, andere Tabelle, eine Falle ───────
    TextBlock(
      'Nochmal dasselbe, damit es sitzt, nur mit einer anderen Tabelle. '
      'Die Artikeltabelle hat eine Spalte `bezeichnung`, darin stehen die '
      'Produktnamen.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-1-2',
      frage: 'Zeig die Bezeichnungen aller Artikel.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung FROM artikel;',
      // Jetzt genau ein falscher Baustein: die andere Tabelle.
      bausteine: ['SELECT', 'bezeichnung', 'FROM', 'artikel', 'kunden', ';'],
      erklaerung:
          'Gleiches Muster, andere Spalte, andere Tabelle. Wenn dir das '
          'leicht fiel, hast du den wichtigsten Teil von SQL schon '
          'verstanden.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-1-3',
      frage: 'Die Tabelle kunden hat zwölf Zeilen. '
          'Wie viele Zeilen liefert SELECT ort FROM kunden;?',
      optionen: [
        'Eine, nämlich nur den ersten Ort',
        'Zwölf, für jeden Kunden eine',
        'So viele, wie es verschiedene Orte gibt',
      ],
      richtig: 1,
      erklaerung:
          'SELECT sucht sich Spalten aus, wirft aber keine Zeilen weg. '
          'Zwölf Kunden bedeuten zwölf Zeilen, auch wenn „Köln" dabei '
          'zweimal auftaucht. Wie man Doppelte loswird, kommt in Lektion 2.',
    )),

    // ─── Stufe 3: mehrere Spalten ────────────────────────────────────
    UeberschriftBlock('Mehrere Spalten auf einmal'),
    TextBlock(
      'Bisher immer nur eine Spalte. Willst du mehrere, schreibst du sie '
      'hintereinander und trennst sie mit einem **Komma**.',
    ),
    CodeBlock(
      'SELECT name, ort FROM kunden;',
      titel: 'Zwei Spalten',
      sprache: 'sql',
    ),
    CodeBlock(
      'SELECT name, ort, plz FROM kunden;',
      titel: 'Drei Spalten, es geht beliebig weiter',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Ein Komma steht immer **zwischen zwei Spalten**. '
      'Direkt vor `FROM` darf keins stehen.\n'
      '\n'
      'Richtig: `SELECT name, ort FROM kunden`\n'
      'Falsch: `SELECT name, ort, FROM kunden`\n'
      '\n'
      'Im falschen Beispiel ist das **zweite** Komma zu viel, also das nach '
      '`ort`. Danach kommt ja keine Spalte mehr, sondern `FROM`. '
      'Passiert oft, wenn man eine Spalte herauslöscht und ihr Komma '
      'stehen lässt.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-1-4',
      frage: 'Zeig Name und Ort aller Kunden, also zwei Spalten.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT name, ort FROM kunden;',
      // Nur die nötigen Bausteine: das Komma ist hier das Neue,
      // daran soll niemand durch Zusatzfallen abgelenkt werden.
      bausteine: ['SELECT', 'name', ',', 'ort', 'FROM', 'kunden', ';'],
      tipp: 'Zwischen die beiden Spaltennamen gehört ein Komma.',
      erklaerung:
          'Die Reihenfolge im SELECT bestimmt die Reihenfolge der Spalten '
          'im Ergebnis. Mit ort, name stünde der Ort links.',
    )),

    TextBlock(
      'Und wieder dasselbe mit einer anderen Tabelle. Die Artikel haben '
      'neben `bezeichnung` auch eine Spalte `preis`.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-1-5',
      frage: 'Zeig Bezeichnung und Preis aller Artikel.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung, preis FROM artikel;',
      // Zwei falsche Bausteine.
      bausteine: [
        'SELECT',
        'bezeichnung',
        ',',
        'preis',
        'bestand',
        'FROM',
        'artikel',
        'kunden',
        ';',
      ],
      erklaerung:
          'Zwei Spalten, 15 Zeilen. Das ist die Grundlage jeder Preisliste.',
    )),

    // ─── Stufe 4: alle Spalten ───────────────────────────────────────
    UeberschriftBlock('Alle Spalten mit dem Stern'),
    TextBlock(
      'Wenn du wirklich alles sehen willst, musst du nicht jede Spalte '
      'einzeln aufzählen. Der Stern `*` steht für „alle Spalten".',
    ),
    CodeBlock(
      'SELECT * FROM kunden;',
      titel: 'Die komplette Tabelle',
      sprache: 'sql',
    ),
    TextBlock(
      'Zum Herumschauen ist das ideal. In fertigem Programmcode gilt der '
      'Stern aber als schlechter Stil: du holst Daten, die du nicht '
      'brauchst, und dein Programm bekommt unbemerkt andere Spalten, '
      'sobald jemand die Tabelle umbaut.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-1-6',
      frage: 'Zeig alle Spalten der Tabelle artikel.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT * FROM artikel;',
      bausteine: [
        'SELECT',
        '*',
        'ALL',
        'FROM',
        'artikel',
        'artikeln',
        ';',
      ],
      tipp: 'Der Stern steht für „alle Spalten".',
      erklaerung:
          '15 Artikel mit allen fünf Spalten. Zu den falschen Bausteinen: '
          'ALL gibt es in SQL, aber an anderer Stelle. Und die Tabelle '
          'heißt artikel, nicht artikeln. Tabellennamen musst du exakt '
          'treffen.',
    )),

    // ─── Stufe 5: ohne Bausteine, aber vertrauter Stoff ──────────────
    UeberschriftBlock('Kurze Wiederholung'),
    TextBlock(
      'Drei Dinge kannst du jetzt: eine Spalte abfragen, mehrere mit Komma, '
      'und alle mit dem Stern. Die letzten beiden Aufgaben mischen das '
      'noch einmal, diesmal ohne Bausteine.',
    ),

    AufgabenBlock(LueckenAufgabe(
      id: 'sql-1-7',
      frage: 'Fülle die Lücken: Name und Gehalt aller Mitarbeiter.',
      vorlage: '___ name, gehalt ___ mitarbeiter;',
      loesungen: [
        ['SELECT'],
        ['FROM'],
      ],
      bausteine: ['SELECT', 'FROM', 'WHERE'],
      erklaerung:
          'SELECT sagt was, FROM sagt woher. Diese beiden Wörter stehen in '
          'jeder Abfrage, die du je schreiben wirst.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-1-8',
      frage: 'Diese Abfrage soll alle Mitarbeiternamen zeigen, '
          'läuft aber nicht. Tippe die fehlerhafte Zeile an.',
      zeilen: [
        'SELECT name',
        'FROM mitarbeiters;',
      ],
      fehlerZeile: 1,
      korrekturen: [
        'FROM mitarbeiter;',
        'FROM mitarbeiter',
      ],
      tipp: 'Wie heißt die Tabelle wirklich? Über „Tabellen" oben rechts '
          'siehst du alle Namen.',
      erklaerung:
          'Die Tabelle heißt mitarbeiter, ohne s. Die Datenbank antwortet '
          'darauf mit „no such table". Solche Meldungen sind übrigens gute '
          'Nachrichten, sie sagen genau, was fehlt.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 2 — Spalten formen: Aliase, Rechnen, DISTINCT
// ═══════════════════════════════════════════════════════════════════════════

const _lektion2 = Lektion(
  nr: 2,
  slug: 'sql-2',
  titel: 'Spalten benennen und berechnen',
  kurzbeschreibung: 'AS, Rechnen im SELECT und doppelte Werte loswerden.',
  dauerMinuten: 14,
  bloecke: [
    // Wiederholung aus Lektion 1. Wer eine Woche Pause hatte, steigt
    // damit sanft wieder ein, statt kalt in neuen Stoff zu fallen.
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Bevor Neues kommt, eine Aufgabe aus Lektion 1. Zeig zwei Spalten '
      'aus einer Tabelle. Das Muster kennst du schon.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-2-0',
      frage: 'Zeig Ort und Land aller Kunden.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT ort, land FROM kunden;',
      bausteine: ['SELECT', 'ort', ',', 'land', 'FROM', 'kunden', ';'],
      erklaerung:
          'Saß sofort? Gut. Falls nicht, geh ruhig nochmal in Lektion 1 zurück, '
          'alles Folgende baut darauf auf.',
    )),

    UeberschriftBlock('Spalten umbenennen mit AS'),
    TextBlock(
      'Spaltennamen aus der Datenbank sind selten das, was auf einer '
      'Rechnung oder in einem Bericht stehen soll. Mit `AS` gibst du einer '
      'Spalte im Ergebnis einen anderen Namen. Die Tabelle selbst ändert '
      'sich dadurch nicht, nur die Ausgabe.',
    ),
    CodeBlock(
      'SELECT bezeichnung AS artikelname, preis AS "Preis in Euro"\n'
      'FROM artikel;',
      titel: 'Zwei Spalten umbenannt',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Enthält der neue Name ein Leerzeichen, muss er in Anführungszeichen. '
      'Ohne Leerzeichen geht es auch ohne.',
    ),

    UeberschriftBlock('Rechnen direkt in der Abfrage'),
    TextBlock(
      'Im SELECT darf gerechnet werden. Die Datenbank berechnet den Wert '
      'für jede Zeile neu und speichert ihn nirgends. Es entsteht eine '
      'reine Anzeigespalte.',
    ),
    CodeBlock(
      'SELECT bezeichnung,\n'
      '       preis,\n'
      '       preis * 1.19 AS brutto\n'
      'FROM artikel;',
      titel: 'Bruttopreis berechnen',
      sprache: 'sql',
    ),
    TextBlock(
      'Erlaubt sind `+`, `-`, `*`, `/`. Für Text gibt es `||`, das hängt '
      'zwei Zeichenketten aneinander.',
    ),
    CodeBlock(
      "SELECT name || ' aus ' || ort AS beschriftung\n"
      'FROM kunden;',
      titel: 'Text zusammensetzen',
      sprache: 'sql',
    ),

    UeberschriftBlock('DISTINCT: jeden Wert nur einmal'),
    TextBlock(
      'Zwölf Kunden, aber nicht zwölf verschiedene Orte. Köln kommt '
      'zweimal vor. `DISTINCT` wirft Doppelte aus dem Ergebnis.',
    ),
    CodeBlock(
      'SELECT DISTINCT ort FROM kunden;',
      titel: 'Jeder Ort einmal',
      sprache: 'sql',
    ),
    HinweisBlock(
      'DISTINCT gilt immer für die GANZE Zeile, nicht für eine einzelne '
      'Spalte. `SELECT DISTINCT ort, land` liefert jede Kombination aus '
      'Ort und Land einmal, nicht jeden Ort einmal.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-2-1',
      frage: 'Wie viele Zeilen liefert SELECT DISTINCT land FROM kunden; '
          'bei zwölf Kunden aus Deutschland, Österreich und der Schweiz?',
      optionen: ['12', '3', '1', 'Kommt auf die Reihenfolge an'],
      richtig: 1,
      erklaerung:
          'DISTINCT reduziert auf die verschiedenen Werte. Drei Länder '
          'kommen vor, also drei Zeilen, egal wie viele Kunden je Land '
          'dahinterstehen.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'sql-2-2',
      frage: 'Bring die Abfrage in die richtige Reihenfolge. '
          'Sie soll Artikelbezeichnung und Nettopreis mit Aufschlag zeigen.',
      zeilen: [
        'SELECT bezeichnung,',
        '       preis * 1.19 AS brutto',
        'FROM artikel;',
      ],
      erklaerung:
          'Erst was (SELECT mit allen Spalten und Berechnungen), dann woher '
          '(FROM). Das AS gehört direkt hinter die Berechnung, auf die es '
          'sich bezieht.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-2-3',
      frage: 'Zeig jede Kategorie der Artikel genau einmal an.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT DISTINCT kategorie FROM artikel;',
      bausteine: [
        'SELECT',
        'DISTINCT',
        'UNIQUE',
        'FROM',
        'kategorie',
        'bezeichnung',
        'artikel',
        'GROUP BY',
        ';',
      ],
      tipp: 'Ohne DISTINCT bekämst du 15 Zeilen, viele davon doppelt.',
      erklaerung:
          'Vier Kategorien: Computer, Peripherie, Speicher, Netzwerk. '
          'Genau so findet man in der Praxis heraus, welche Werte in einer '
          'Spalte überhaupt vorkommen.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-2-4',
      frage: 'Zeig Bezeichnung und Lagerwert jedes Artikels. '
          'Der Lagerwert ist Preis mal Bestand, die Spalte soll '
          '"lagerwert" heißen.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT bezeichnung, preis * bestand AS lagerwert FROM artikel;',
      tipp: 'Zwei Spalten multiplizieren, dann mit AS benennen.',
      erklaerung:
          'Das ist eine typische Auswertung aus der Lagerwirtschaft. '
          'Beachte: der Artikel mit Bestand 0 hat einen Lagerwert von 0, '
          'die Zeile verschwindet nicht, sie ist nur null wert.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-2-5',
      frage: 'Diese Abfrage soll den Kundennamen mit Ort zusammensetzen, '
          'wirft aber einen Fehler.',
      zeilen: [
        'SELECT name + \' aus \' + ort AS beschriftung',
        'FROM kunden;',
      ],
      fehlerZeile: 0,
      korrekturen: [
        "SELECT name || ' aus ' || ort AS beschriftung",
      ],
      tipp: 'Wie verkettet man in SQL Text? Nicht so wie in vielen '
          'Programmiersprachen.',
      erklaerung:
          'Das Pluszeichen ist in SQL für Zahlen da. Text wird mit zwei '
          'senkrechten Strichen verkettet: ||. In manchen Systemen '
          'liefert + bei Text still 0 statt einer Fehlermeldung, '
          'ein Klassiker unter den schwer zu findenden Fehlern.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 3 — WHERE: nur die Zeilen, die du wirklich willst
// ═══════════════════════════════════════════════════════════════════════════

const _lektion3 = Lektion(
  nr: 3,
  slug: 'sql-3',
  titel: 'Filtern mit WHERE',
  kurzbeschreibung:
      'Vergleiche, AND/OR, BETWEEN, IN, LIKE und der Sonderfall NULL.',
  dauerMinuten: 18,
  bloecke: [
    // Wiederholung aus Lektion 2.
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Eine Aufgabe aus Lektion 2 zum Aufwärmen: jeden Wert einer Spalte '
      'nur einmal anzeigen.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-3-0',
      frage: 'Zeig jedes Land, in dem Kunden sitzen, genau einmal.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT DISTINCT land FROM kunden;',
      bausteine: [
        'SELECT',
        'DISTINCT',
        'land',
        'FROM',
        'kunden',
        ';',
      ],
      erklaerung:
          'Drei Länder: DE, AT, CH. Ohne DISTINCT wären es zwölf Zeilen.',
    )),

    UeberschriftBlock('Zeilen filtern'),
    TextBlock(
      'Bisher kamen immer alle Zeilen zurück. `WHERE` setzt eine Bedingung: '
      'nur Zeilen, bei denen sie zutrifft, landen im Ergebnis.',
    ),
    CodeBlock(
      "SELECT name, ort\n"
      'FROM kunden\n'
      "WHERE ort = 'Köln';",
      titel: 'Nur Kölner Kunden',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Text steht in einfachen Anführungszeichen, Zahlen nicht. '
      '`WHERE preis = 189` ohne, `WHERE ort = \'Köln\'` mit.',
    ),

    UeberschriftBlock('Vergleichsoperatoren'),
    TextBlock(
      '- `=` gleich · `<>` oder `!=` ungleich\n'
      '- `<` `>` kleiner, größer\n'
      '- `<=` `>=` kleiner-gleich, größer-gleich',
    ),
    TextBlock(
      'Achtung, häufigste Verwechslung überhaupt: SQL prüft Gleichheit mit '
      '**einem** `=`, nicht mit zwei. Das doppelte `==` aus Java, Python '
      'oder C ist hier falsch.',
    ),

    UeberschriftBlock('Mehrere Bedingungen'),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      "WHERE kategorie = 'Computer' AND preis < 1000;",
      titel: 'AND: beides muss stimmen',
      sprache: 'sql',
    ),
    TextBlock(
      '`AND` verlangt, dass beide Bedingungen zutreffen. `OR` reicht eine '
      'von beiden. Kommen beide in einer Abfrage vor, dann **klammere**. Sonst '
      'bindet AND stärker als OR, und das Ergebnis ist ein anderes, als du '
      'gelesen hast.',
    ),
    CodeBlock(
      'SELECT name, ort, land\n'
      'FROM kunden\n'
      "WHERE (land = 'AT' OR land = 'CH') AND ort <> 'Wien';",
      titel: 'Klammern entscheiden',
      sprache: 'sql',
    ),

    UeberschriftBlock('Abkürzungen: BETWEEN, IN, LIKE'),
    CodeBlock(
      'SELECT bezeichnung, preis FROM artikel\n'
      'WHERE preis BETWEEN 100 AND 200;',
      titel: 'BETWEEN: Bereich, Grenzen eingeschlossen',
      sprache: 'sql',
    ),
    CodeBlock(
      "SELECT name, land FROM kunden\n"
      "WHERE land IN ('AT', 'CH');",
      titel: 'IN: einer aus einer Liste',
      sprache: 'sql',
    ),
    CodeBlock(
      "SELECT bezeichnung FROM artikel\n"
      "WHERE bezeichnung LIKE 'Monitor%';",
      titel: 'LIKE: Textmuster',
      sprache: 'sql',
    ),
    TextBlock(
      'Bei `LIKE` steht `%` für beliebig viele Zeichen und `_` für genau '
      'eines. `\'Monitor%\'` findet alles, was mit Monitor anfängt, '
      '`\'%SSD%\'` alles, was SSD irgendwo enthält.',
    ),

    UeberschriftBlock('NULL, der Sonderfall'),
    TextBlock(
      'NULL bedeutet nicht null und nicht leerer Text. Es bedeutet '
      '**unbekannt**. Und mit Unbekanntem kann man nicht vergleichen: '
      '`WHERE abteilung_id = NULL` liefert nie ein Ergebnis, nicht einmal '
      'für Zeilen, in denen tatsächlich NULL steht.',
    ),
    CodeBlock(
      'SELECT name FROM mitarbeiter\n'
      'WHERE abteilung_id IS NULL;',
      titel: 'Richtig: IS NULL',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Merksatz: NULL prüft man mit IS NULL und IS NOT NULL, niemals mit '
      '= oder <>. Das wird in Prüfungen gern abgefragt.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-3-1',
      frage: 'Warum liefert WHERE abteilung_id = NULL keine einzige Zeile, '
          'obwohl ein Mitarbeiter keine Abteilung hat?',
      optionen: [
        'Weil die Spalte falsch geschrieben ist',
        'Weil NULL "unbekannt" heißt und ein Vergleich damit weder wahr '
            'noch falsch ergibt',
        'Weil NULL nur bei Text funktioniert',
        'Weil man dafür zwei Gleichheitszeichen braucht',
      ],
      richtig: 1,
      erklaerung:
          'Jeder Vergleich mit NULL ergibt selbst wieder "unbekannt", und '
          'WHERE lässt nur Zeilen durch, bei denen die Bedingung eindeutig '
          'wahr ist. Deshalb gibt es die eigenen Operatoren IS NULL und '
          'IS NOT NULL.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'sql-3-2',
      frage: 'Alle Artikel, die zwischen 100 und 200 Euro kosten, '
          'ohne zwei getrennte Vergleiche.',
      vorlage: 'SELECT bezeichnung FROM artikel\nWHERE preis ___ 100 ___ 200;',
      loesungen: [
        ['BETWEEN'],
        ['AND'],
      ],
      bausteine: ['BETWEEN', 'AND', 'OR', 'IN', 'LIKE'],
      erklaerung:
          'BETWEEN schließt beide Grenzen ein: ein Artikel für exakt 100 '
          'Euro ist dabei. Das ist gleichbedeutend mit '
          'preis >= 100 AND preis <= 200.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-3-3',
      frage: 'Zeig Name und Ort aller Kunden aus Köln.',
      datensatz: 'nordwind',
      musterloesung: "SELECT name, ort FROM kunden WHERE ort = 'Köln';",
      bausteine: [
        'SELECT',
        'FROM',
        'WHERE',
        'name',
        'ort',
        ',',
        'kunden',
        '=',
        '==',
        "'Köln'",
        'Köln',
        ';',
      ],
      tipp: 'Text gehört in einfache Anführungszeichen. '
          'Und SQL vergleicht mit einem Gleichheitszeichen.',
      erklaerung:
          'Zwei Kunden sitzen in Köln. Beachte das einfache '
          'Gleichheitszeichen, SQL kennt kein ==.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-3-4',
      frage: 'Welche Artikel sind ausverkauft? Zeig Bezeichnung und '
          'Bestand aller Artikel mit Bestand 0.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung, bestand FROM artikel '
          'WHERE bestand = 0;',
      bausteine: [
        'SELECT',
        'FROM',
        'WHERE',
        'bezeichnung',
        'bestand',
        'preis',
        ',',
        'artikel',
        '=',
        '<',
        '0',
        "'0'",
        ';',
      ],
      tipp: 'Zahlen brauchen keine Anführungszeichen.',
      erklaerung:
          'Eine einzige Dockingstation. Genau diese Abfrage steckt hinter '
          'jeder "nicht auf Lager"-Anzeige in einem Onlineshop.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-3-5',
      frage: 'Alle Kunden aus Österreich oder der Schweiz. '
          'Nutze IN statt zweier OR-Bedingungen.',
      datensatz: 'nordwind',
      musterloesung: "SELECT name, land FROM kunden "
          "WHERE land IN ('AT', 'CH');",
      bausteine: [
        'SELECT',
        'FROM',
        'WHERE',
        'name',
        'land',
        ',',
        'kunden',
        'IN',
        'BETWEEN',
        'OR',
        "('AT', 'CH')",
        "('AT' 'CH')",
        ';',
      ],
      tipp: "Die Werte in der Liste werden mit Komma getrennt und stehen "
          "in Klammern.",
      erklaerung:
          'Vier Kunden. IN ist bei drei oder mehr Werten deutlich lesbarer '
          'als eine Kette aus OR, und weniger fehleranfällig, weil man '
          'die Klammern nicht vergessen kann.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-3-6',
      frage: 'Diese Abfrage soll Mitarbeiter ohne Abteilung finden, '
          'liefert aber nichts.',
      zeilen: [
        'SELECT name',
        'FROM mitarbeiter',
        'WHERE abteilung_id = NULL;',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'WHERE abteilung_id IS NULL;',
        'WHERE abteilung_id IS NULL',
      ],
      tipp: 'NULL vergleicht man nicht mit dem Gleichheitszeichen.',
      erklaerung:
          'Das ist kein Syntaxfehler. Die Abfrage läuft, sie liefert nur '
          'stillschweigend nichts. Solche Fehler sind die unangenehmsten, '
          'weil nichts auf sie hinweist. Richtig ist IS NULL.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-3-7',
      frage: 'Alle Artikel, deren Bezeichnung mit "Monitor" beginnt.',
      datensatz: 'nordwind',
      musterloesung:
          "SELECT bezeichnung, preis FROM artikel "
          "WHERE bezeichnung LIKE 'Monitor%';",
      tipp: 'Das Prozentzeichen steht für "hier darf noch irgendwas folgen".',
      erklaerung:
          'Zwei Monitore. Ohne das % würde LIKE genau wie = arbeiten und '
          'nur einen Artikel finden, der exakt "Monitor" heißt. Den gibt '
          'es nicht.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 4: Sortieren mit ORDER BY, begrenzen mit LIMIT
// ═══════════════════════════════════════════════════════════════════════════

const _lektion4 = Lektion(
  nr: 4,
  slug: 'sql-4',
  titel: 'Sortieren und begrenzen',
  kurzbeschreibung:
      'ORDER BY, aufsteigend und absteigend, und die Top 3 mit LIMIT.',
  dauerMinuten: 16,
  bloecke: [
    // Rückblick auf Lektion 3
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Zum Aufwärmen eine Aufgabe aus Lektion 3: Zeilen filtern mit WHERE.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-4-0',
      frage: 'Zeig Bezeichnung und Preis aller Artikel, die weniger als '
          '100 Euro kosten.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT bezeichnung, preis FROM artikel WHERE preis < 100;',
      bausteine: [
        'SELECT',
        'bezeichnung',
        ',',
        'preis',
        'FROM',
        'artikel',
        'WHERE',
        '<',
        '>',
        '100',
        ';',
      ],
      erklaerung:
          'Sechs günstige Artikel. WHERE filtert Zeilen, bevor sie im '
          'Ergebnis landen. Das brauchst du gleich wieder.',
    )),

    // Stufe 1: ORDER BY kennenlernen
    UeberschriftBlock('Sortieren mit ORDER BY'),
    TextBlock(
      'Bisher kamen die Zeilen in der Reihenfolge, in der die Datenbank '
      'sie gespeichert hat. Darauf darfst du dich nie verlassen. Wenn die '
      'Reihenfolge wichtig ist, sagst du sie ausdrücklich dazu: mit '
      '**ORDER BY** und dem Namen der Spalte, nach der sortiert wird.',
    ),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      'ORDER BY preis;',
      titel: 'Artikel nach Preis sortiert, günstigster zuerst',
      sprache: 'sql',
    ),
    TextBlock(
      'ORDER BY kommt **nach** dem FROM (und nach einem WHERE, falls es '
      'eins gibt). Sortiert wird von klein nach groß: Zahlen aufsteigend, '
      'Text alphabetisch, Datumswerte vom ältesten zum neuesten.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-4-1',
      frage: 'Bau das Beispiel nach: alle Artikel mit Bezeichnung und '
          'Preis, sortiert nach Preis.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT bezeichnung, preis FROM artikel ORDER BY preis;',
      reihenfolgeZaehlt: true,
      bausteine: [
        'SELECT',
        'bezeichnung',
        ',',
        'preis',
        'FROM',
        'artikel',
        'ORDER BY',
        ';',
      ],
      erklaerung:
          'Ganz oben das Netzwerkkabel für 8,50, ganz unten der Laptop '
          'für 1249. Bei dieser Aufgabe wurde zum ersten Mal auch die '
          'Reihenfolge deiner Ergebniszeilen geprüft.',
    )),

    // Stufe 2: absteigend
    UeberschriftBlock('Andersherum: absteigend mit DESC'),
    TextBlock(
      'Meistens will man es andersherum: das Teuerste, das Neueste oder '
      'das Meiste zuerst. Dafür hängst du **DESC** an (descending, '
      'absteigend). Das Gegenstück **ASC** (ascending, aufsteigend) ist '
      'der Standard und wird deshalb fast nie hingeschrieben.',
    ),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      'ORDER BY preis DESC;',
      titel: 'Teuerster Artikel zuerst',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-4-2',
      frage: 'Zeig Name und Gehalt aller Mitarbeiter, das höchste '
          'Gehalt zuerst.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT name, gehalt FROM mitarbeiter ORDER BY gehalt DESC;',
      reihenfolgeZaehlt: true,
      bausteine: [
        'SELECT',
        'name',
        ',',
        'gehalt',
        'FROM',
        'mitarbeiter',
        'ORDER BY',
        'DESC',
        'ASC',
        ';',
      ],
      tipp: 'Absteigend heißt DESC und steht direkt hinter der '
          'Sortierspalte.',
      erklaerung:
          'Erik Sandmann aus der IT verdient mit 5200 am meisten. '
          'Hättest du ASC gewählt (oder nichts), stünde er ganz unten.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-4-3',
      frage: 'Was passiert bei ORDER BY eintritt ohne DESC in der '
          'Tabelle mitarbeiter?',
      optionen: [
        'Die dienstältesten Mitarbeiter stehen oben',
        'Die neuesten Mitarbeiter stehen oben',
        'Die Reihenfolge ist zufällig',
      ],
      richtig: 0,
      erklaerung:
          'Ohne DESC wird aufsteigend sortiert, bei einem Datum also vom '
          'ältesten zum neuesten. Das früheste Eintrittsdatum steht oben, '
          'und das ist der dienstälteste Mitarbeiter.',
    )),

    // Stufe 3: WHERE und ORDER BY kombiniert
    UeberschriftBlock('Filtern und sortieren zusammen'),
    TextBlock(
      'WHERE und ORDER BY schließen sich nicht aus, im Gegenteil: erst '
      'filtern, dann sortieren ist der Normalfall. Die Reihenfolge der '
      'Schlüsselwörter ist fest vorgegeben:',
    ),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      "WHERE kategorie = 'Peripherie'\n"
      'ORDER BY preis DESC;',
      titel: 'Nur Peripherie, teuerste zuerst',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Merkreihenfolge: **SELECT, FROM, WHERE, ORDER BY.** '
      'ORDER BY steht immer hinter dem WHERE. Andersherum gibt es einen '
      'Syntaxfehler.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-4-4',
      frage: 'Zeig Name und Ort aller Kunden aus Deutschland, '
          'alphabetisch nach Ort sortiert.',
      datensatz: 'nordwind',
      musterloesung: "SELECT name, ort FROM kunden WHERE land = 'DE' "
          'ORDER BY ort;',
      reihenfolgeZaehlt: true,
      bausteine: [
        'SELECT',
        'name',
        ',',
        'ort',
        'FROM',
        'kunden',
        'WHERE',
        'ORDER BY',
        'land',
        '=',
        "'DE'",
        'DESC',
        ';',
      ],
      tipp: 'Erst WHERE, dann ORDER BY. Alphabetisch aufsteigend ist der '
          'Standard, DESC brauchst du hier also nicht.',
      erklaerung:
          'Acht deutsche Kunden von Bremen bis Rostock. Genau diese '
          'Kombination, filtern plus sortieren, ist die häufigste '
          'Abfrageform überhaupt.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-4-5',
      frage: 'Diese Abfrage soll günstige Artikel sortiert zeigen, '
          'wirft aber einen Syntaxfehler. Tippe die falsche Zeile an.',
      zeilen: [
        'SELECT bezeichnung, preis',
        'FROM artikel',
        'ORDER BY preis',
        'WHERE preis < 100;',
      ],
      fehlerZeile: 3,
      korrekturen: [
        'WHERE preis < 100',
      ],
      tipp: 'Die Reihenfolge der Schlüsselwörter ist fest: WHERE kommt '
          'vor ORDER BY. Welche Zeile steht am falschen Platz? Markiere '
          'die WHERE-Zeile und überlege, wie die Abfrage richtig '
          'aussehen müsste.',
      erklaerung:
          'WHERE muss vor ORDER BY stehen. Richtig wäre: SELECT ... FROM '
          'artikel WHERE preis < 100 ORDER BY preis; Die Datenbank liest '
          'die Abfrage in fester Reihenfolge und bricht ab, wenn nach dem '
          'Sortieren plötzlich noch ein Filter kommt.',
    )),

    // Stufe 4: LIMIT
    UeberschriftBlock('Nur die ersten Zeilen: LIMIT'),
    TextBlock(
      'Oft interessieren nur die vorderen Plätze: die drei teuersten '
      'Artikel, die fünf neuesten Kunden. **LIMIT** schneidet das '
      'Ergebnis nach einer bestimmten Anzahl Zeilen ab und steht ganz '
      'am Ende der Abfrage.',
    ),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      'ORDER BY preis DESC\n'
      'LIMIT 3;',
      titel: 'Die drei teuersten Artikel',
      sprache: 'sql',
    ),
    HinweisBlock(
      'LIMIT ohne ORDER BY ist fast immer ein Fehler: du bekommst dann '
      '„irgendwelche" drei Zeilen statt der Top 3. Erst sortieren gibt '
      'dem Abschneiden einen Sinn.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-4-6',
      frage: 'Welche drei Mitarbeiter verdienen am meisten? '
          'Zeig Name und Gehalt.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT name, gehalt FROM mitarbeiter '
          'ORDER BY gehalt DESC LIMIT 3;',
      reihenfolgeZaehlt: true,
      bausteine: [
        'SELECT',
        'name',
        ',',
        'gehalt',
        'FROM',
        'mitarbeiter',
        'ORDER BY',
        'DESC',
        'LIMIT',
        'TOP',
        '3',
        ';',
      ],
      tipp: 'Absteigend sortieren, dann auf 3 begrenzen. TOP gibt es in '
          'SQLite nicht, das ist die Schreibweise von SQL Server.',
      erklaerung:
          'Erik, Fatima und Jana, alle aus der IT. Der Baustein TOP war '
          'eine Falle: manche Datenbanken (SQL Server) schreiben '
          'SELECT TOP 3, SQLite und die meisten anderen nutzen LIMIT.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 5: Zählen und rechnen über viele Zeilen (Aggregatfunktionen)
// ═══════════════════════════════════════════════════════════════════════════

const _lektion5 = Lektion(
  nr: 5,
  slug: 'sql-5',
  titel: 'Zählen, summieren, Durchschnitt',
  kurzbeschreibung:
      'COUNT, SUM, AVG, MIN und MAX: eine Antwort statt vieler Zeilen.',
  dauerMinuten: 18,
  bloecke: [
    // Rückblick auf Lektion 4
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Zum Einstieg einmal sortieren und begrenzen, wie in Lektion 4.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-0',
      frage: 'Zeig die zwei günstigsten Artikel mit Bezeichnung und Preis.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung, preis FROM artikel '
          'ORDER BY preis LIMIT 2;',
      reihenfolgeZaehlt: true,
      bausteine: [
        'SELECT',
        'bezeichnung',
        ',',
        'preis',
        'FROM',
        'artikel',
        'ORDER BY',
        'LIMIT',
        'DESC',
        '2',
        ';',
      ],
      erklaerung:
          'Netzwerkkabel und USB-Stick. Günstigste zuerst heißt '
          'aufsteigend, also ohne DESC.',
    )),

    // Stufe 1: COUNT
    UeberschriftBlock('Zählen mit COUNT'),
    TextBlock(
      'Bis jetzt hat jede Abfrage Zeilen zurückgegeben. Manchmal willst '
      'du aber keine Liste, sondern **eine Zahl**: Wie viele Kunden haben '
      'wir? Dafür gibt es **COUNT(*)**. Es zählt die Zeilen und liefert '
      'genau eine Ergebniszeile mit dem Ergebnis.',
    ),
    CodeBlock(
      'SELECT COUNT(*) FROM kunden;',
      titel: 'Wie viele Kunden gibt es?',
      sprache: 'sql',
    ),
    TextBlock(
      'Das Sternchen in der Klammer heißt: zähl die ganzen Zeilen. '
      'COUNT lässt sich mit allem kombinieren, was du schon kennst, '
      'zum Beispiel mit WHERE:',
    ),
    CodeBlock(
      "SELECT COUNT(*) FROM kunden WHERE land = 'DE';",
      titel: 'Wie viele davon aus Deutschland?',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-1',
      frage: 'Bau das Beispiel nach: Wie viele Kunden gibt es insgesamt?',
      datensatz: 'nordwind',
      musterloesung: 'SELECT COUNT(*) FROM kunden;',
      bausteine: ['SELECT', 'COUNT(*)', 'FROM', 'kunden', ';'],
      erklaerung:
          'Zwölf. Beachte: das Ergebnis ist eine einzige Zeile mit einer '
          'einzigen Zahl, keine Liste mehr.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-2',
      frage: 'Wie viele Bestellungen haben den Status „offen"?',
      datensatz: 'nordwind',
      musterloesung:
          "SELECT COUNT(*) FROM bestellungen WHERE status = 'offen';",
      bausteine: [
        'SELECT',
        'COUNT(*)',
        'FROM',
        'bestellungen',
        'WHERE',
        'status',
        '=',
        "'offen'",
        "'geliefert'",
        ';',
      ],
      erklaerung:
          'Vier offene Bestellungen. COUNT plus WHERE beantwortet fast '
          'jede „Wie viele..."-Frage aus dem Tagesgeschäft.',
    )),

    // Stufe 2: SUM und AVG
    UeberschriftBlock('Summe und Durchschnitt'),
    TextBlock(
      'COUNT hat zwei Geschwister für Zahlenspalten: **SUM** addiert '
      'alle Werte einer Spalte, **AVG** (average) berechnet den '
      'Durchschnitt. In die Klammer kommt die Spalte, um die es geht.',
    ),
    CodeBlock(
      'SELECT SUM(gehalt) FROM mitarbeiter;',
      titel: 'Gesamte Gehaltskosten pro Monat',
      sprache: 'sql',
    ),
    CodeBlock(
      'SELECT AVG(preis) FROM artikel;',
      titel: 'Durchschnittlicher Artikelpreis',
      sprache: 'sql',
    ),
    HinweisBlock(
      'AVG liefert oft krumme Zahlen mit vielen Nachkommastellen. '
      'Mit **ROUND(AVG(preis), 2)** rundest du auf 2 Stellen.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-3',
      frage: 'Was kosten alle Mitarbeiter zusammen im Monat? '
          'Berechne die Summe der Gehälter.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT SUM(gehalt) FROM mitarbeiter;',
      bausteine: [
        'SELECT',
        'SUM(gehalt)',
        'AVG(gehalt)',
        'COUNT(*)',
        'FROM',
        'mitarbeiter',
        ';',
      ],
      erklaerung:
          '45350 Euro im Monat. SUM addiert stur alle zwölf Werte der '
          'Spalte, egal wie viele Zeilen es sind.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-4',
      frage: 'Wie hoch ist der durchschnittliche Preis aller Artikel, '
          'gerundet auf 2 Nachkommastellen?',
      datensatz: 'nordwind',
      musterloesung: 'SELECT ROUND(AVG(preis), 2) FROM artikel;',
      bausteine: [
        'SELECT',
        'ROUND(',
        'AVG(preis)',
        'SUM(preis)',
        ', 2)',
        'FROM',
        'artikel',
        ';',
      ],
      tipp: 'ROUND umschließt das AVG: erst der Durchschnitt, dann das '
          'Runden.',
      erklaerung:
          '292,70 Euro. Die Funktionen sind verschachtelt: innen '
          'rechnet AVG, außen rundet ROUND. So lassen sich Funktionen '
          'in SQL beliebig kombinieren.',
    )),

    // Stufe 3: MIN und MAX
    UeberschriftBlock('Kleinster und größter Wert'),
    TextBlock(
      '**MIN** und **MAX** liefern den kleinsten beziehungsweise größten '
      'Wert einer Spalte. Bei Text ist das alphabetisch, bei Datumswerten '
      'das früheste beziehungsweise späteste Datum.',
    ),
    CodeBlock(
      'SELECT MIN(preis), MAX(preis) FROM artikel;',
      titel: 'Preisspanne im Sortiment',
      sprache: 'sql',
    ),
    TextBlock(
      'Mehrere Aggregatfunktionen dürfen nebeneinander im selben SELECT '
      'stehen. Was **nicht** geht: eine normale Spalte einfach '
      'danebenstellen, etwa die Bezeichnung zum Höchstpreis. Wie man an '
      'die kommt, lernst du bei den Unterabfragen. Für den Moment gilt: '
      'Aggregat und normale Spalte mischen sich nicht.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-5-5',
      frage: 'Wann kam der neueste Mitarbeiter? Zeig das späteste '
          'Eintrittsdatum.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT MAX(eintritt) FROM mitarbeiter;',
      bausteine: [
        'SELECT',
        'MAX(eintritt)',
        'MIN(eintritt)',
        'FROM',
        'mitarbeiter',
        ';',
      ],
      erklaerung:
          '2025-05-05, Lena Fricke. Das späteste Datum ist das mit dem '
          'größten Wert, deshalb MAX und nicht MIN.',
    )),

    // Stufe 4: COUNT(spalte) und NULL
    UeberschriftBlock('COUNT und der NULL-Haken'),
    TextBlock(
      'In die COUNT-Klammer darf statt des Sterns auch ein Spaltenname: '
      '**COUNT(spalte)** zählt dann nur Zeilen, in denen diese Spalte '
      '**nicht NULL** ist. Der Unterschied ist eine beliebte '
      'Prüfungsfrage.',
    ),
    CodeBlock(
      'SELECT COUNT(*), COUNT(abteilung_id) FROM mitarbeiter;',
      titel: 'Alle Zeilen gegen gefüllte Zeilen',
      sprache: 'sql',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-5-6',
      frage: 'Die Tabelle mitarbeiter hat 12 Zeilen, bei einer davon ist '
          'abteilung_id NULL. Was liefert die Abfrage aus dem Beispiel?',
      optionen: [
        '12 und 12',
        '12 und 11',
        '11 und 11',
        'Einen Fehler, NULL kann man nicht zählen',
      ],
      richtig: 1,
      erklaerung:
          'COUNT(*) zählt alle 12 Zeilen. COUNT(abteilung_id) überspringt '
          'die eine Zeile mit NULL und kommt auf 11. Lena Fricke hat noch '
          'keine Abteilung, deshalb die Differenz. Probier die Abfrage '
          'ruhig in der vorigen Aufgabe aus.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-5-7',
      frage: 'Diese Abfrage soll die Kunden zählen, wirft aber einen '
          'Fehler. Tippe die falsche Zeile an.',
      zeilen: [
        'SELECT COUNT()',
        'FROM kunden;',
      ],
      fehlerZeile: 0,
      korrekturen: [
        'SELECT COUNT(*)',
      ],
      tipp: 'In der Klammer fehlt etwas. Was zählt COUNT, wenn es alle '
          'Zeilen zählen soll?',
      erklaerung:
          'COUNT braucht ein Argument: entweder den Stern für ganze '
          'Zeilen oder einen Spaltennamen. Eine leere Klammer lehnt die '
          'Datenbank ab.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 6: GROUP BY, eine Zeile pro Gruppe
// ═══════════════════════════════════════════════════════════════════════════

const _lektion6 = Lektion(
  nr: 6,
  slug: 'sql-6',
  titel: 'Gruppieren mit GROUP BY',
  kurzbeschreibung:
      'Eine Auswertung pro Kategorie, Abteilung oder Status: das Herzstück '
      'von SQL.',
  dauerMinuten: 20,
  bloecke: [
    // Rückblick auf Lektion 5
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Zum Aufwärmen einmal zählen mit Bedingung, wie in Lektion 5. '
      'Diesmal ohne Bausteine, tipp die Abfrage selbst.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-6-0',
      frage: 'Wie viele Artikel gehören zur Kategorie „Peripherie"?',
      datensatz: 'nordwind',
      musterloesung:
          "SELECT COUNT(*) FROM artikel WHERE kategorie = 'Peripherie';",
      startCode: 'SELECT ',
      tipp: 'COUNT(*) mit einem WHERE auf die Kategorie. Text in einfache '
          'Anführungszeichen.',
      erklaerung:
          'Sechs Artikel. Merk dir diese Abfrage, gleich siehst du, '
          'warum sie auf Dauer unpraktisch ist.',
    )),

    // Stufe 1: das Problem, das GROUP BY löst
    UeberschriftBlock('Das Problem: eine Zahl pro Kategorie'),
    TextBlock(
      'Eben hast du die Peripherie-Artikel gezählt. Für alle vier '
      'Kategorien müsstest du dieselbe Abfrage viermal schreiben, jedes '
      'Mal mit anderem WHERE. Bei 50 Kategorien wären es 50 Abfragen.',
    ),
    TextBlock(
      '**GROUP BY** erledigt das in einem Schritt: es teilt die Zeilen in '
      'Gruppen (eine pro Kategorie) und wendet die Aggregatfunktion auf '
      'jede Gruppe einzeln an. Das Ergebnis: eine Zeile pro Gruppe.',
    ),
    CodeBlock(
      'SELECT kategorie, COUNT(*)\n'
      'FROM artikel\n'
      'GROUP BY kategorie;',
      titel: 'Artikel pro Kategorie, alles auf einmal',
      sprache: 'sql',
    ),
    TextBlock(
      'Wort für Wort:\n'
      '- `GROUP BY kategorie`: bilde eine Gruppe pro Kategorie\n'
      '- `COUNT(*)`: zähle die Zeilen, aber jetzt PRO GRUPPE\n'
      '- `kategorie` im SELECT: damit du siehst, zu welcher Gruppe die '
      'Zahl gehört',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-6-1',
      frage: 'Bau das Beispiel nach: Wie viele Artikel gibt es pro '
          'Kategorie?',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT kategorie, COUNT(*) FROM artikel GROUP BY kategorie;',
      bausteine: [
        'SELECT',
        'kategorie',
        ',',
        'COUNT(*)',
        'FROM',
        'artikel',
        'GROUP BY',
        ';',
      ],
      erklaerung:
          'Vier Zeilen: Computer 3, Netzwerk 3, Peripherie 6, Speicher 3. '
          'Aus 15 Artikelzeilen wurden 4 Gruppenzeilen. Genau das ist '
          'GROUP BY: eine Ergebniszeile pro Gruppe.',
    )),

    // Stufe 2: die goldene Regel
    UeberschriftBlock('Die goldene Regel'),
    TextBlock(
      'Im SELECT dürfen bei einer Gruppierung nur zwei Sorten von '
      'Spalten stehen: **Spalten, nach denen gruppiert wird**, und '
      '**Aggregatfunktionen**. Nichts anderes.',
    ),
    TextBlock(
      'Warum? Stell dir die Gruppe „Peripherie" mit ihren 6 Artikeln '
      'vor. Fragst du zusätzlich nach `bezeichnung`, müsste die Datenbank '
      '6 verschiedene Bezeichnungen in eine einzige Ergebniszeile '
      'quetschen. Welche sollte sie nehmen? Eben. Deshalb ist es '
      'verboten.',
    ),
    HinweisBlock(
      'In Prüfungen ist das DIE Standardfalle bei GROUP BY: eine Spalte '
      'im SELECT, die weder in der GROUP-BY-Liste steht noch aggregiert '
      'ist. Die meisten Datenbanken lehnen das ab.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-6-2',
      frage: 'Die Tabelle bestellungen hat 15 Zeilen und 3 verschiedene '
          'Status-Werte. Wie viele Zeilen liefert SELECT status, COUNT(*) '
          'FROM bestellungen GROUP BY status;?',
      optionen: [
        '15, eine pro Bestellung',
        '3, eine pro Status',
        '1, weil COUNT immer eine Zeile liefert',
      ],
      richtig: 1,
      erklaerung:
          'GROUP BY macht aus den 15 Bestellzeilen 3 Gruppenzeilen: '
          'geliefert 10, offen 4, storniert 1. Die Anzahl der Zeilen im '
          'Ergebnis entspricht der Anzahl verschiedener Werte in der '
          'Gruppierspalte.',
    )),

    // Stufe 3: andere Aggregate pro Gruppe
    UeberschriftBlock('Nicht nur zählen'),
    TextBlock(
      'In den Gruppen funktioniert jede Aggregatfunktion aus Lektion 5: '
      'SUM, AVG, MIN, MAX. Durchschnittsgehalt pro Abteilung, Umsatz pro '
      'Kunde, teuerster Artikel pro Kategorie, alles dasselbe Muster.',
    ),
    CodeBlock(
      'SELECT abteilung_id, AVG(gehalt)\n'
      'FROM mitarbeiter\n'
      'GROUP BY abteilung_id;',
      titel: 'Durchschnittsgehalt pro Abteilung',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-6-3',
      frage: 'Zeig pro Kategorie den teuersten Artikelpreis.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT kategorie, MAX(preis) FROM artikel GROUP BY kategorie;',
      bausteine: [
        'SELECT',
        'kategorie',
        ',',
        'MAX(preis)',
        'AVG(preis)',
        'preis',
        'FROM',
        'artikel',
        'GROUP BY',
        'ORDER BY',
        ';',
      ],
      tipp: 'Gruppieren nach Kategorie, in jeder Gruppe das Maximum des '
          'Preises. Der Baustein preis allein wäre die goldene Regel '
          'verletzt.',
      erklaerung:
          'Computer 1249, Netzwerk 129, Peripherie 429, Speicher 189. '
          'Der nackte Baustein preis war die Falle: er steht weder im '
          'GROUP BY noch in einer Aggregatfunktion.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-6-4',
      frage: 'Berechne das Durchschnittsgehalt pro Abteilung, gerundet '
          'auf 2 Stellen. Tipp die Abfrage selbst.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT abteilung_id, ROUND(AVG(gehalt), 2) '
          'FROM mitarbeiter GROUP BY abteilung_id;',
      startCode: 'SELECT ',
      tipp: 'Wie das Beispiel oben, nur mit ROUND(AVG(gehalt), 2) statt '
          'dem nackten AVG.',
      erklaerung:
          'Fünf Zeilen, nicht vier: Lena Fricke hat keine Abteilung, und '
          'NULL bildet bei GROUP BY eine eigene Gruppe. Die IT (Abteilung '
          '3) zahlt mit 4833,33 im Schnitt am besten.',
    )),

    // Stufe 4: sortieren nach dem Ergebnis
    UeberschriftBlock('Gruppen sortieren'),
    TextBlock(
      'Das Gruppenergebnis lässt sich wie jedes andere sortieren. '
      'Praktisch: gib der Aggregatspalte mit AS einen Namen und sortiere '
      'nach dem Namen.',
    ),
    CodeBlock(
      'SELECT kategorie, COUNT(*) AS anzahl\n'
      'FROM artikel\n'
      'GROUP BY kategorie\n'
      'ORDER BY anzahl DESC;',
      titel: 'Größte Kategorie zuerst',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-6-5',
      frage: 'Welcher Kunde hat die meisten Bestellungen? Zeig kunden_id '
          'und Anzahl pro Kunde, die meisten zuerst. Tipp selbst.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT kunden_id, COUNT(*) AS anzahl '
          'FROM bestellungen GROUP BY kunden_id ORDER BY anzahl DESC;',
      reihenfolgeZaehlt: false,
      startCode: 'SELECT ',
      tipp: 'Gruppieren nach kunden_id, zählen, absteigend nach der '
          'Anzahl sortieren.',
      erklaerung:
          'Kunde 1 (Elektro Mayer) führt mit 3 Bestellungen. Dass hier '
          'nur die kunden_id steht und nicht der Name, ist unbefriedigend, '
          'stimmt. Den Namen holen wir uns in Lektion 9 mit einem JOIN '
          'aus der Kundentabelle dazu.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 7: HAVING, Gruppen filtern
// ═══════════════════════════════════════════════════════════════════════════

const _lektion7 = Lektion(
  nr: 7,
  slug: 'sql-7',
  titel: 'Gruppen filtern mit HAVING',
  kurzbeschreibung:
      'WHERE filtert Zeilen, HAVING filtert Gruppen. Der Unterschied ist '
      'Prüfungsstoff.',
  dauerMinuten: 16,
  bloecke: [
    // Rückblick auf Lektion 6
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Erst einmal gruppieren wie in Lektion 6, ohne Bausteine.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-7-0',
      frage: 'Wie viele Kunden gibt es pro Land? Zeig land und Anzahl.',
      datensatz: 'nordwind',
      musterloesung:
          'SELECT land, COUNT(*) FROM kunden GROUP BY land;',
      startCode: 'SELECT ',
      tipp: 'Gruppieren nach land, pro Gruppe zählen.',
      erklaerung: 'DE 8, AT 2, CH 2. Sitzt das Muster? Dann weiter.',
    )),

    // Stufe 1: das Problem
    UeberschriftBlock('Das Problem: nur bestimmte Gruppen'),
    TextBlock(
      'Neue Frage: Welche Kategorien haben **mehr als 3 Artikel**? Die '
      'Bedingung bezieht sich auf das Zählergebnis, also auf die ganze '
      'Gruppe. Der erste Reflex wäre WHERE:',
    ),
    CodeBlock(
      'SELECT kategorie, COUNT(*)\n'
      'FROM artikel\n'
      'WHERE COUNT(*) > 3\n'
      'GROUP BY kategorie;',
      titel: 'So NICHT: Fehler',
      sprache: 'sql',
    ),
    TextBlock(
      'Das lehnt die Datenbank ab. Der Grund steckt in der Reihenfolge '
      'der Verarbeitung: WHERE läuft **vor** dem Gruppieren, Zeile für '
      'Zeile. Zu diesem Zeitpunkt gibt es noch gar kein COUNT-Ergebnis, '
      'das man prüfen könnte.',
    ),
    TextBlock(
      'Für Bedingungen **nach** dem Gruppieren gibt es ein eigenes '
      'Schlüsselwort: **HAVING**. Es steht hinter dem GROUP BY.',
    ),
    CodeBlock(
      'SELECT kategorie, COUNT(*)\n'
      'FROM artikel\n'
      'GROUP BY kategorie\n'
      'HAVING COUNT(*) > 3;',
      titel: 'Richtig: Gruppen mit mehr als 3 Artikeln',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-7-1',
      frage: 'Bau das Beispiel nach: Welche Kategorien haben mehr als '
          '3 Artikel? Zeig Kategorie und Anzahl.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT kategorie, COUNT(*) FROM artikel '
          'GROUP BY kategorie HAVING COUNT(*) > 3;',
      bausteine: [
        'SELECT',
        'kategorie',
        ',',
        'COUNT(*)',
        'FROM',
        'artikel',
        'GROUP BY',
        'HAVING',
        'WHERE',
        '>',
        '3',
        ';',
      ],
      tipp: 'Erst gruppieren, dann die Gruppen mit HAVING filtern.',
      erklaerung:
          'Nur Peripherie mit 6 Artikeln. Der Baustein WHERE war die '
          'Falle: mit einer Aggregatfunktion dahinter wäre die Abfrage '
          'abgelehnt worden.',
    )),

    // Stufe 2: WHERE und HAVING zusammen
    UeberschriftBlock('WHERE und HAVING im selben Satz'),
    TextBlock(
      'Beide dürfen gemeinsam auftreten und erledigen verschiedene Jobs: '
      '**WHERE** wirft einzelne Zeilen raus, BEVOR gruppiert wird. '
      '**HAVING** wirft ganze Gruppen raus, NACHDEM gruppiert wurde.',
    ),
    CodeBlock(
      'SELECT kunden_id, COUNT(*) AS anzahl\n'
      'FROM bestellungen\n'
      "WHERE status = 'geliefert'\n"
      'GROUP BY kunden_id\n'
      'HAVING COUNT(*) >= 2;',
      titel: 'Kunden mit mindestens 2 gelieferten Bestellungen',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Die volle Merkreihenfolge lautet jetzt: **SELECT, FROM, WHERE, '
      'GROUP BY, HAVING, ORDER BY.** Die kommt in Prüfungen dran, '
      'präg sie dir als Ganzes ein.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-7-2',
      frage: 'Worin unterscheiden sich WHERE und HAVING?',
      optionen: [
        'HAVING ist nur ein anderes Wort für WHERE',
        'WHERE filtert Zeilen vor dem Gruppieren, HAVING filtert '
            'Gruppen danach',
        'WHERE ist für Zahlen, HAVING für Text',
        'HAVING funktioniert nur zusammen mit ORDER BY',
      ],
      richtig: 1,
      erklaerung:
          'WHERE arbeitet Zeile für Zeile und kennt keine '
          'Aggregat-Ergebnisse. HAVING arbeitet auf den fertigen Gruppen '
          'und darf deshalb COUNT, SUM und Co. benutzen. Diese Frage ist '
          'ein Dauergast in IHK-Prüfungen.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-7-3',
      frage: 'Diese Abfrage soll Länder mit mehr als 2 Kunden zeigen, '
          'wird aber abgelehnt. Tippe die falsche Zeile an.',
      zeilen: [
        'SELECT land, COUNT(*)',
        'FROM kunden',
        'WHERE COUNT(*) > 2',
        'GROUP BY land;',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'HAVING COUNT(*) > 2',
      ],
      tipp: 'Die Bedingung prüft ein Zählergebnis, also eine Gruppe. '
          'Welches Schlüsselwort ist dafür zuständig? Und es gehört '
          'HINTER das GROUP BY, beim Korrigieren der Zeile reicht hier '
          'aber das richtige Schlüsselwort.',
      erklaerung:
          'Aggregatfunktionen sind im WHERE verboten, weil WHERE vor dem '
          'Gruppieren läuft. Richtig: GROUP BY land HAVING COUNT(*) > 2. '
          'Ergebnis wäre übrigens nur DE mit 8 Kunden.',
    )),

    // Stufe 3: alles zusammen, frei getippt
    UeberschriftBlock('Alles zusammen'),
    TextBlock(
      'Zum Abschluss zwei Aufgaben mit allem, was du bis hier kannst. '
      'Ohne Bausteine. Wenn du feststeckst: der Tabellen-Knopf zeigt die '
      'Spalten, der Tipp kommt nach dem zweiten Versuch.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-7-4',
      frage: 'In welchen Orten sitzt mehr als ein Kunde? Zeig Ort und '
          'Anzahl.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT ort, COUNT(*) FROM kunden '
          'GROUP BY ort HAVING COUNT(*) > 1;',
      startCode: 'SELECT ',
      tipp: 'Gruppieren nach ort, dann HAVING mit COUNT(*) > 1.',
      erklaerung:
          'Nur Köln mit 2 Kunden (Bürowelt Schmitt und Rheinland '
          'Technik). Alle anderen Orte fallen durch das HAVING raus.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-7-5',
      frage: 'Welche Abteilungen zahlen im Schnitt mehr als 4000 Euro? '
          'Zeig abteilung_id und Durchschnittsgehalt.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT abteilung_id, AVG(gehalt) FROM mitarbeiter '
          'GROUP BY abteilung_id HAVING AVG(gehalt) > 4000;',
      startCode: 'SELECT ',
      tipp: 'Wie eben, nur mit AVG(gehalt) statt COUNT(*), im SELECT '
          'und im HAVING.',
      erklaerung:
          'Nur die IT (Abteilung 3) mit 4833,33. HAVING darf jede '
          'Aggregatfunktion prüfen, nicht nur COUNT. Damit hast du das '
          'komplette Auswertungswerkzeug beisammen: filtern, gruppieren, '
          'Gruppen filtern, sortieren.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 8: Beziehungen und Schlüssel (Vorbereitung auf Joins)
// ═══════════════════════════════════════════════════════════════════════════

const _lektion8 = Lektion(
  nr: 8,
  premium: true,
  slug: 'sql-8',
  titel: 'Beziehungen und Schlüssel',
  kurzbeschreibung:
      'Warum Daten auf mehrere Tabellen verteilt sind, und wie sie '
      'zusammenhängen.',
  dauerMinuten: 14,
  bloecke: [
    // Rückblick auf Lektion 7
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Einmal gruppieren und die Gruppen filtern, dann geht es an etwas '
      'Neues.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-8-0',
      frage: 'Welche Status-Werte kommen bei den Bestellungen mehr als '
          'einmal vor? Zeig Status und Anzahl.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT status, COUNT(*) FROM bestellungen '
          'GROUP BY status HAVING COUNT(*) > 1;',
      startCode: 'SELECT ',
      tipp: 'GROUP BY status, dann HAVING mit COUNT.',
      erklaerung:
          'geliefert 10 und offen 4. storniert kommt nur einmal vor und '
          'fällt durch das HAVING raus.',
    )),

    // Stufe 1: warum überhaupt mehrere Tabellen
    UeberschriftBlock('Warum nicht alles in eine Tabelle?'),
    TextBlock(
      'Stell dir vor, Bestellungen und Kunden stünden zusammen in einer '
      'einzigen Riesentabelle. Bei jeder Bestellung von Elektro Mayer '
      'stünden dann Name, Ort, PLZ und Land des Kunden **nochmal** drin. '
      'Dreimal bestellt heißt dreimal dieselben Kundendaten.',
    ),
    TextBlock(
      'Das rächt sich beim Ändern: zieht der Kunde um, musst du den Ort '
      'in allen drei Zeilen ändern. Vergisst du eine, hat derselbe Kunde '
      'zwei verschiedene Adressen und niemand weiß, welche stimmt. '
      'Solche Widersprüche nennt man **Anomalien**, und sie sind der '
      'Grund, warum Datenbanken Daten aufteilen.',
    ),
    TextBlock(
      'Deshalb gilt: **jede Information steht genau einmal** in genau '
      'einer Tabelle. Der Kunde steht in kunden, die Bestellung in '
      'bestellungen, und die Bestellung merkt sich nur, **zu welchem '
      'Kunden sie gehört**.',
    ),

    // Stufe 2: Primärschlüssel
    UeberschriftBlock('Der Primärschlüssel'),
    TextBlock(
      'Damit man sich auf eine Zeile beziehen kann, braucht jede Zeile '
      'ein eindeutiges Kennzeichen: den **Primärschlüssel** (englisch '
      'primary key). In der Kundentabelle ist das kunden_id: keine zwei '
      'Kunden haben dieselbe.',
    ),
    TextBlock(
      'Warum nicht einfach der Name? Weil Namen nicht eindeutig sind: '
      'es kann zwei Firmen namens Müller Elektronik geben. Und weil sie '
      'sich ändern können, nach einer Umfirmierung zeigt sonst nichts '
      'mehr aufeinander. Deshalb nimmt man fast immer eine künstliche, '
      'unveränderliche Nummer.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-8-1',
      frage: 'Was muss für einen Primärschlüssel immer gelten?',
      optionen: [
        'Er ist eindeutig und darf nicht leer (NULL) sein',
        'Er ist immer eine fortlaufende Zahl',
        'Er darf sich täglich ändern',
        'Er muss aus mehreren Spalten bestehen',
      ],
      richtig: 0,
      erklaerung:
          'Eindeutig und nie NULL, das sind die beiden Pflichten. Ob es '
          'eine Zahl, ein Kürzel oder eine Kombination aus Spalten ist, '
          'ist dagegen freie Entscheidung. Diese Definition wird in der '
          'AP1 gern wörtlich abgefragt.',
    )),

    // Stufe 3: Fremdschlüssel
    UeberschriftBlock('Der Fremdschlüssel'),
    TextBlock(
      'Jetzt der Gegenpart: die Tabelle bestellungen hat eine Spalte '
      'kunden_id. Da steht **der Primärschlüssel des Kunden** drin, dem '
      'die Bestellung gehört. Eine Spalte, die auf den Primärschlüssel '
      'einer anderen Tabelle zeigt, heißt **Fremdschlüssel** '
      '(foreign key).',
    ),
    CodeBlock(
      'bestellungen                     kunden\n'
      'bestell_id | kunden_id           kunden_id | name\n'
      '1001       | 1  ─────────────►   1         | Elektro Mayer GmbH\n'
      '1005       | 2  ─────────────►   2         | Technik Nord AG\n'
      '1008       | 1  ─────────────►   1         | Elektro Mayer GmbH',
      titel: 'Der Fremdschlüssel zeigt auf den Primärschlüssel',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Merksatz für die Prüfung: der Primärschlüssel identifiziert die '
      'eigene Zeile, der Fremdschlüssel verweist auf eine fremde. '
      'Eine 1:n-Beziehung (ein Kunde, viele Bestellungen) entsteht, '
      'indem die n-Seite den Fremdschlüssel trägt.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-8-2',
      frage: 'Ein Kunde kann viele Bestellungen haben, eine Bestellung '
          'gehört genau einem Kunden. In welcher Tabelle steht der '
          'Fremdschlüssel?',
      optionen: [
        'In kunden, als Liste aller Bestellnummern',
        'In bestellungen, als kunden_id',
        'In beiden Tabellen',
        'In einer dritten Tabelle',
      ],
      richtig: 1,
      erklaerung:
          'Der Fremdschlüssel steht immer auf der "viele"-Seite. Eine '
          'Bestellung hat genau einen Kunden, also passt genau eine '
          'kunden_id in die Zeile. Andersherum ginge es nicht: in eine '
          'Kundenzeile passen nicht beliebig viele Bestellnummern.',
    )),

    // Stufe 4: den Join von Hand machen
    UeberschriftBlock('Die Verbindung von Hand'),
    TextBlock(
      'Bevor du in der nächsten Lektion das Werkzeug dafür bekommst, '
      'machst du die Verknüpfung einmal zu Fuß. Zwei Abfragen: erst den '
      'Fremdschlüssel nachschlagen, dann damit in der anderen Tabelle '
      'suchen. Genau das wird der JOIN später in einem Schritt erledigen.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-8-3',
      frage: 'Welcher Kunde hat Bestellung 1003 aufgegeben? Schlag erst '
          'die kunden_id der Bestellung nach, dann den Namen. Du kannst '
          'beide Abfragen nacheinander in dasselbe Feld schreiben, '
          'jeweils mit Semikolon.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT name FROM kunden WHERE kunden_id = 1;',
      startCode: 'SELECT kunden_id FROM bestellungen '
          'WHERE bestell_id = 1003;\n',
      tipp: 'Die erste Abfrage liefert dir eine Zahl. Die setzt du in '
          'die zweite ein: SELECT name FROM kunden WHERE kunden_id = ...',
      erklaerung:
          'Elektro Mayer GmbH. Merk dir dieses Umständliche: '
          'nachschlagen, Zahl merken, woanders einsetzen. Ab der '
          'nächsten Lektion macht das der JOIN in einer einzigen Abfrage.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-8-4',
      frage: 'In der Tabelle positionen stehen bestell_id UND artikel_id. '
          'Was ist das für eine Konstruktion?',
      optionen: [
        'Zwei Primärschlüssel',
        'Zwei Fremdschlüssel: positionen verbindet Bestellungen '
            'mit Artikeln',
        'Ein Fehler im Datenbankentwurf',
      ],
      richtig: 1,
      erklaerung:
          'positionen ist eine Zwischentabelle: eine Bestellung enthält '
          'viele Artikel, ein Artikel steckt in vielen Bestellungen. '
          'Solche n:m-Beziehungen brauchen immer eine dritte Tabelle '
          'mit zwei Fremdschlüsseln. Auch das ist ein Klassiker der AP1.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 9: INNER JOIN, zwei Tabellen in einer Abfrage
// ═══════════════════════════════════════════════════════════════════════════

const _lektion9 = Lektion(
  nr: 9,
  premium: true,
  slug: 'sql-9',
  titel: 'Tabellen verbinden mit JOIN',
  kurzbeschreibung:
      'INNER JOIN mit ON, Tabellen-Aliase, und endlich Namen statt IDs.',
  dauerMinuten: 22,
  bloecke: [
    // Rückblick auf Lektion 8
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'In Lektion 8 hast du eine Verbindung von Hand gemacht: '
      'Fremdschlüssel nachschlagen, Wert in der anderen Tabelle suchen. '
      'Einmal zur Erinnerung.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-9-0',
      frage: 'Zu welchem Kunden gehört Bestellung 1012? Zeig den Namen. '
          'Zwei Abfragen nacheinander sind erlaubt.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT name FROM kunden WHERE kunden_id = 10;',
      startCode: '',
      tipp: 'Erst: SELECT kunden_id FROM bestellungen WHERE '
          'bestell_id = 1012; Dann die Zahl in die Kundenabfrage '
          'einsetzen.',
      erklaerung:
          'Rheinland Technik. Und jetzt lernst du, wie das ohne '
          'Zwischenschritt geht.',
    )),

    // Stufe 1: der JOIN
    UeberschriftBlock('Der JOIN'),
    TextBlock(
      'Ein **INNER JOIN** hängt an jede Zeile der einen Tabelle die '
      'passende Zeile der anderen. Woran er erkennt, was zusammengehört, '
      'sagst du ihm mit **ON**: Fremdschlüssel gleich Primärschlüssel.',
    ),
    CodeBlock(
      'SELECT bestellungen.bestell_id, kunden.name\n'
      'FROM bestellungen\n'
      'INNER JOIN kunden\n'
      '  ON bestellungen.kunden_id = kunden.kunden_id;',
      titel: 'Jede Bestellung mit ihrem Kundennamen',
      sprache: 'sql',
    ),
    TextBlock(
      'Wort für Wort:\n'
      '- `FROM bestellungen`: die Ausgangstabelle\n'
      '- `INNER JOIN kunden`: häng die Kundentabelle dazu\n'
      '- `ON ... = ...`: verbinde die Zeilen, bei denen der '
      'Fremdschlüssel zum Primärschlüssel passt\n'
      '- im SELECT stehen die Spalten mit Tabellennamen davor, weil es '
      'jetzt zwei Tabellen gibt',
    ),
    HinweisBlock(
      'Das Wort INNER darfst du weglassen, `JOIN` allein bedeutet '
      'dasselbe. In Prüfungen wird meist die volle Form geschrieben.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-9-1',
      frage: 'Bau das Beispiel nach: jede Bestellnummer mit dem Namen '
          'des Kunden.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bestellungen.bestell_id, kunden.name '
          'FROM bestellungen INNER JOIN kunden '
          'ON bestellungen.kunden_id = kunden.kunden_id;',
      bausteine: [
        'SELECT',
        'bestellungen.bestell_id',
        ',',
        'kunden.name',
        'FROM',
        'bestellungen',
        'INNER JOIN',
        'kunden',
        'ON',
        'bestellungen.kunden_id',
        '=',
        'kunden.kunden_id',
        ';',
      ],
      tipp: 'FROM, dann INNER JOIN, dann ON mit dem Schlüsselpaar.',
      erklaerung:
          '15 Bestellungen, jede mit Klarnamen statt Nummer. Die Abfrage '
          'aus Lektion 8 mit zwei Schritten steckt hier komplett in '
          'einer einzigen.',
    )),

    // Stufe 2: Aliase
    UeberschriftBlock('Kürzer schreiben mit Aliasen'),
    TextBlock(
      'Die vollen Tabellennamen vor jeder Spalte machen Abfragen lang. '
      'Deshalb gibt man Tabellen im FROM einen Kurznamen, meist einen '
      'Buchstaben. Das ist dasselbe AS wie bei den Spalten in Lektion 2, '
      'das Wort wird bei Tabellen nur üblicherweise weggelassen.',
    ),
    CodeBlock(
      'SELECT b.bestell_id, k.name\n'
      'FROM bestellungen b\n'
      'INNER JOIN kunden k\n'
      '  ON b.kunden_id = k.kunden_id;',
      titel: 'Dasselbe mit Aliasen b und k',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-9-2',
      frage: 'Zeig jeden Mitarbeiter mit dem Namen seiner Abteilung. '
          'Nutze Aliase.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT m.name, a.name FROM mitarbeiter m '
          'INNER JOIN abteilungen a ON m.abteilung_id = a.abteilung_id;',
      startCode: 'SELECT ',
      tipp: 'Beide Tabellen haben eine Spalte name, du musst also '
          'm.name und a.name schreiben, sonst meckert die Datenbank '
          '"ambiguous column name".',
      erklaerung:
          'Elf Zeilen, obwohl es zwölf Mitarbeiter gibt. Lena Fricke '
          'fehlt: ihre abteilung_id ist NULL, dafür findet der INNER '
          'JOIN keinen Partner, also fliegt die Zeile raus. Merk dir '
          'das, es ist der Kern der nächsten Lektion.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-9-3',
      frage: 'Kunde 12 (Zürich Office Supply) hat noch nie bestellt. '
          'Was passiert mit ihm bei bestellungen INNER JOIN kunden?',
      optionen: [
        'Er taucht mit leeren Bestellfeldern auf',
        'Er taucht gar nicht auf',
        'Die Abfrage wirft einen Fehler',
      ],
      richtig: 1,
      erklaerung:
          'INNER JOIN liefert nur Zeilen, die auf BEIDEN Seiten einen '
          'Partner haben. Ohne Bestellung kein Treffer, also keine '
          'Zeile. Wer solche Kunden trotzdem sehen will, braucht den '
          'LEFT JOIN aus der nächsten Lektion.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-9-4',
      frage: 'Diese Abfrage soll Bestellungen mit Kundennamen zeigen, '
          'wirft aber einen Syntaxfehler. Tippe die falsche Zeile an.',
      zeilen: [
        'SELECT b.bestell_id, k.name',
        'FROM bestellungen b',
        'INNER JOIN kunden k;',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'INNER JOIN kunden k ON b.kunden_id = k.kunden_id;',
        'INNER JOIN kunden k ON b.kunden_id = k.kunden_id',
      ],
      tipp: 'Dem JOIN fehlt die Angabe, WORAN er die Zeilen '
          'zusammenfügen soll.',
      erklaerung:
          'Ohne ON weiß die Datenbank nicht, welche Zeilen '
          'zusammengehören. Vergisst man es, gibt es in SQLite einen '
          'Fehler. Manche Datenbanken kombinieren dann still jede Zeile '
          'mit jeder, bei 15 Bestellungen und 12 Kunden wären das 180 '
          'Unsinnszeilen.',
    )),

    // Stufe 3: JOIN + alles Bisherige
    UeberschriftBlock('JOIN trifft GROUP BY'),
    TextBlock(
      'Erinnerst du dich an Lektion 6? Da stand am Ende eine Auswertung '
      'mit kunden_id statt Namen, und der Name war nicht erreichbar. '
      'Mit dem JOIN löst du das jetzt: erst verbinden, dann gruppieren.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-9-5',
      frage: 'Zeig pro Kunde den NAMEN und die Anzahl seiner '
          'Bestellungen.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT k.name, COUNT(*) FROM bestellungen b '
          'INNER JOIN kunden k ON b.kunden_id = k.kunden_id '
          'GROUP BY k.name;',
      startCode: 'SELECT ',
      tipp: 'Wie die Aufgabe aus Lektion 6, nur mit vorgeschaltetem '
          'JOIN und GROUP BY k.name statt kunden_id.',
      erklaerung:
          'Elf Kunden mit ihren Bestellzahlen, Elektro Mayer vorn mit 3. '
          'Damit beherrschst du das wichtigste Muster der Praxis: '
          'JOIN, dann GROUP BY, dann bei Bedarf HAVING und ORDER BY. '
          'Der Großteil aller echten Auswertungen sieht genau so aus.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 10: LEFT JOIN, auch die Zeilen ohne Partner
// ═══════════════════════════════════════════════════════════════════════════

const _lektion10 = Lektion(
  nr: 10,
  premium: true,
  slug: 'sql-10',
  titel: 'LEFT JOIN und die fehlenden Zeilen',
  kurzbeschreibung:
      'Auch Zeilen ohne Partner behalten, und gezielt danach suchen.',
  dauerMinuten: 16,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock(
      'Einmal INNER JOIN zum Aufwärmen, dann geht es um seine Schwäche.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-10-0',
      frage: 'Zeig jede Bestellnummer mit dem Ort des Kunden.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT b.bestell_id, k.ort FROM bestellungen b '
          'INNER JOIN kunden k ON b.kunden_id = k.kunden_id;',
      startCode: 'SELECT ',
      tipp: 'Wie in Lektion 9, nur mit k.ort statt k.name.',
      erklaerung: '15 Zeilen. Sitzt der JOIN? Dann weiter.',
    )),

    UeberschriftBlock('Das Problem mit INNER'),
    TextBlock(
      'In Lektion 9 sind zwei Zeilen sang- und klanglos verschwunden: '
      'Lena Fricke (keine Abteilung) und Zürich Office Supply (keine '
      'Bestellung). INNER JOIN behält nur Zeilen mit Partner auf beiden '
      'Seiten. Oft will man aber genau das Gegenteil: **alle** Zeilen '
      'der einen Tabelle, egal ob es einen Partner gibt.',
    ),
    TextBlock(
      'Dafür gibt es den **LEFT JOIN**: er behält jede Zeile der '
      '**linken** Tabelle (die im FROM). Findet sich rechts kein '
      'Partner, werden dessen Spalten mit NULL aufgefüllt.',
    ),
    CodeBlock(
      'SELECT k.name, b.bestell_id\n'
      'FROM kunden k\n'
      'LEFT JOIN bestellungen b\n'
      '  ON b.kunden_id = k.kunden_id;',
      titel: 'Alle Kunden, auch die ohne Bestellung',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-10-1',
      frage: 'Bau das Beispiel nach: alle Kunden mit ihren '
          'Bestellnummern, auch Kunden ohne Bestellung.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT k.name, b.bestell_id FROM kunden k '
          'LEFT JOIN bestellungen b ON b.kunden_id = k.kunden_id;',
      bausteine: [
        'SELECT',
        'k.name',
        ',',
        'b.bestell_id',
        'FROM',
        'kunden k',
        'LEFT JOIN',
        'INNER JOIN',
        'bestellungen b',
        'ON',
        'b.kunden_id',
        '=',
        'k.kunden_id',
        ';',
      ],
      tipp: 'Die Tabelle, von der du ALLE Zeilen willst, kommt ins '
          'FROM, also links.',
      erklaerung:
          '16 Zeilen statt 15: ganz unten Zürich Office Supply mit NULL '
          'als Bestellnummer. Genau diese eine Zeile hätte der INNER '
          'JOIN verschluckt.',
    )),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-10-2',
      frage: 'Zeig ALLE zwölf Mitarbeiter mit ihrem Abteilungsnamen, '
          'auch die ohne Abteilung.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT m.name, a.name FROM mitarbeiter m '
          'LEFT JOIN abteilungen a ON m.abteilung_id = a.abteilung_id;',
      startCode: 'SELECT ',
      tipp: 'Dieselbe Abfrage wie in Lektion 9, nur mit LEFT JOIN '
          'statt INNER JOIN.',
      erklaerung:
          'Zwölf Zeilen, Lena Fricke ist wieder da, mit NULL als '
          'Abteilung. Ein einziges Wort hat den Unterschied gemacht.',
    )),

    UeberschriftBlock('Der Trick: gezielt die Partnerlosen finden'),
    TextBlock(
      'Der LEFT JOIN kann noch mehr: kombiniert mit IS NULL findet er '
      'genau die Zeilen **ohne** Partner. Kunden, die nie bestellt '
      'haben. Artikel, die nie verkauft wurden. Das ist eine der '
      'meistgestellten Fragen im Berufsalltag.',
    ),
    CodeBlock(
      'SELECT k.name\n'
      'FROM kunden k\n'
      'LEFT JOIN bestellungen b ON b.kunden_id = k.kunden_id\n'
      'WHERE b.bestell_id IS NULL;',
      titel: 'Kunden ohne einzige Bestellung',
      sprache: 'sql',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-10-3',
      frage: 'Welche Artikel wurden noch NIE bestellt? Die Verbindung '
          'läuft über positionen.artikel_id.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT a.bezeichnung FROM artikel a '
          'LEFT JOIN positionen p ON p.artikel_id = a.artikel_id '
          'WHERE p.position_id IS NULL;',
      startCode: 'SELECT ',
      tipp: 'artikel LEFT JOIN positionen, dann WHERE auf eine '
          'positionen-Spalte IS NULL.',
      erklaerung:
          'Keine einzige Zeile: jeder Artikel wurde schon mal bestellt. '
          'Ein leeres Ergebnis ist hier die richtige Antwort, auch das '
          'muss man aushalten können. Die Abfrage selbst ist das '
          'Standardrezept für "Karteileichen finden".',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-10-4',
      frage: 'Worin unterscheiden sich INNER JOIN und LEFT JOIN?',
      optionen: [
        'LEFT JOIN ist schneller',
        'INNER JOIN behält nur Zeilen mit Partner, LEFT JOIN alle '
            'Zeilen der linken Tabelle',
        'LEFT JOIN funktioniert nur mit zwei Tabellen',
        'Es gibt keinen Unterschied',
      ],
      richtig: 1,
      erklaerung:
          'INNER: nur Paare. LEFT: alle Zeilen von links, rechts wird '
          'notfalls mit NULL aufgefüllt. Es gibt auch RIGHT JOIN '
          '(dasselbe von rechts), aber in der Praxis dreht man einfach '
          'die Tabellen um und nimmt LEFT.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 11: Unterabfragen
// ═══════════════════════════════════════════════════════════════════════════

const _lektion11 = Lektion(
  nr: 11,
  premium: true,
  slug: 'sql-11',
  titel: 'Unterabfragen',
  kurzbeschreibung:
      'Eine Abfrage in der Abfrage: vergleichen mit Werten, die erst '
      'berechnet werden müssen.',
  dauerMinuten: 16,
  bloecke: [
    UeberschriftBlock('Kurz zurückblicken'),
    TextBlock('Einmal den LEFT-JOIN-Trick aus Lektion 10.'),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-11-0',
      frage: 'Welche Kunden haben noch nie bestellt? Zeig die Namen.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT k.name FROM kunden k '
          'LEFT JOIN bestellungen b ON b.kunden_id = k.kunden_id '
          'WHERE b.bestell_id IS NULL;',
      startCode: 'SELECT ',
      tipp: 'LEFT JOIN plus IS NULL auf eine Spalte der rechten Tabelle.',
      erklaerung: 'Nur Zürich Office Supply. Und jetzt etwas Neues.',
    )),

    UeberschriftBlock('Das Problem: der Vergleichswert ist unbekannt'),
    TextBlock(
      'Aufgabe: alle Artikel, die teurer sind als der Durchschnitt. '
      'Der Durchschnitt steht aber nirgends, er muss erst berechnet '
      'werden. Du könntest ihn von Hand nachschlagen und eintippen, '
      'aber sobald sich ein Preis ändert, stimmt deine Zahl nicht mehr.',
    ),
    TextBlock(
      'Die Lösung: eine **Unterabfrage**. Eine komplette Abfrage in '
      'Klammern, deren Ergebnis an Ort und Stelle eingesetzt wird.',
    ),
    CodeBlock(
      'SELECT bezeichnung, preis\n'
      'FROM artikel\n'
      'WHERE preis > (SELECT AVG(preis) FROM artikel);',
      titel: 'Teurer als der Durchschnitt',
      sprache: 'sql',
    ),
    TextBlock(
      'Die Datenbank rechnet zuerst die innere Abfrage aus (292,70), '
      'setzt das Ergebnis ein und führt dann die äußere aus. Die '
      'Klammern sind Pflicht.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-11-1',
      frage: 'Bau das Beispiel nach: alle Artikel, die teurer sind als '
          'der Durchschnittspreis.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung, preis FROM artikel '
          'WHERE preis > (SELECT AVG(preis) FROM artikel);',
      bausteine: [
        'SELECT',
        'bezeichnung',
        ',',
        'preis',
        'FROM',
        'artikel',
        'WHERE',
        '>',
        '(SELECT AVG(preis) FROM artikel)',
        'AVG(preis)',
        ';',
      ],
      tipp: 'Der Vergleichswert ist die komplette Klammer mit dem '
          'inneren SELECT.',
      erklaerung:
          'Vier Artikel: die drei Computer und der 4K-Monitor. Der '
          'nackte Baustein AVG(preis) war die Falle: im WHERE sind '
          'Aggregate verboten (Lektion 7!), in einer Unterabfrage '
          'dagegen erlaubt.',
    )),

    UeberschriftBlock('Das Versprechen aus Lektion 5'),
    TextBlock(
      'Erinnerst du dich? MAX(preis) liefert nur die Zahl, und die '
      'Bezeichnung daneben war verboten. Mit einer Unterabfrage geht '
      'es jetzt: hol den Höchstpreis innen, such außen den Artikel, '
      'der genau so viel kostet.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-11-2',
      frage: 'Wie heißt der teuerste Artikel? Zeig Bezeichnung und '
          'Preis, ohne die Zahl von Hand einzutippen.',
      datensatz: 'nordwind',
      musterloesung: 'SELECT bezeichnung, preis FROM artikel '
          'WHERE preis = (SELECT MAX(preis) FROM artikel);',
      startCode: 'SELECT ',
      tipp: 'WHERE preis = (SELECT MAX(preis) FROM artikel)',
      erklaerung:
          'Laptop UltraSlim 13 für 1249. Damit ist das Versprechen aus '
          'Lektion 5 eingelöst. Der Vorteil gegenüber Eintippen: die '
          'Abfrage stimmt auch noch, wenn morgen ein teurerer Artikel '
          'dazukommt.',
    )),

    UeberschriftBlock('Unterabfragen mit IN'),
    TextBlock(
      'Liefert die innere Abfrage **mehrere** Werte, vergleichst du '
      'nicht mit = sondern mit IN, das kennst du aus Lektion 3.',
    ),
    CodeBlock(
      'SELECT name FROM kunden\n'
      'WHERE kunden_id IN (SELECT kunden_id FROM bestellungen);',
      titel: 'Kunden, die mindestens einmal bestellt haben',
      sprache: 'sql',
    ),
    HinweisBlock(
      'Viele Unterabfragen lassen sich auch als JOIN schreiben und '
      'umgekehrt. Faustregel: brauchst du Spalten aus beiden Tabellen '
      'im Ergebnis, nimm den JOIN. Brauchst du die zweite Tabelle nur '
      'zum Filtern, ist die Unterabfrage oft lesbarer.',
    ),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-11-3',
      frage: 'Diese Abfrage soll Mitarbeiter zeigen, die mehr als der '
          'Durchschnitt verdienen, wirft aber einen Fehler.',
      zeilen: [
        'SELECT name, gehalt',
        'FROM mitarbeiter',
        'WHERE gehalt > SELECT AVG(gehalt) FROM mitarbeiter;',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'WHERE gehalt > (SELECT AVG(gehalt) FROM mitarbeiter);',
        'WHERE gehalt > (SELECT AVG(gehalt) FROM mitarbeiter)',
      ],
      tipp: 'Der Unterabfrage fehlt etwas, das sie zur Unterabfrage '
          'macht.',
      erklaerung:
          'Ohne Klammern erkennt die Datenbank das innere SELECT nicht '
          'als Unterabfrage und stolpert über das zweite SELECT '
          'mitten im Satz. Klammern drum, fertig.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 12: Daten ändern mit INSERT, UPDATE, DELETE
// ═══════════════════════════════════════════════════════════════════════════

const _lektion12 = Lektion(
  nr: 12,
  premium: true,
  slug: 'sql-12',
  titel: 'Daten einfügen, ändern, löschen',
  kurzbeschreibung:
      'INSERT, UPDATE und DELETE, und warum das WHERE dabei '
      'überlebenswichtig ist.',
  dauerMinuten: 18,
  bloecke: [
    TextBlock(
      'Bisher hast du Daten nur gelesen. Jetzt veränderst du sie. '
      'Keine Sorge: deine Übungsdatenbank wird vor jeder Ausführung '
      'frisch aufgebaut, du kannst hier nichts dauerhaft kaputtmachen. '
      'Im echten Betrieb gilt das NICHT, deshalb üben wir hier auch '
      'die Vorsichtsregeln mit.',
    ),

    UeberschriftBlock('INSERT: eine Zeile einfügen'),
    CodeBlock(
      "INSERT INTO kunden (kunden_id, name, ort, plz, land, kunde_seit)\n"
      "VALUES (13, 'Byte & Co', 'Bonn', '53111', 'DE', '2026-08-19');",
      titel: 'Neuer Kunde',
      sprache: 'sql',
    ),
    TextBlock(
      'Erst die Spaltenliste, dann VALUES mit den Werten in derselben '
      'Reihenfolge. Die Spaltenliste darf man weglassen, wenn man ALLE '
      'Spalten in Tabellenreihenfolge angibt, aber ausgeschrieben ist '
      'es sicherer: die Abfrage bricht nicht, wenn jemand die Tabelle '
      'umbaut.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-12-1',
      frage: "Füge den Kunden ein: kunden_id 13, Name 'Byte & Co', "
          "Ort 'Bonn', PLZ '53111', Land 'DE', Kunde seit '2026-08-19'. "
          'Zeig danach alle Kunden aus Bonn.',
      datensatz: 'nordwind',
      musterloesung:
          "INSERT INTO kunden (kunden_id, name, ort, plz, land, kunde_seit) "
          "VALUES (13, 'Byte & Co', 'Bonn', '53111', 'DE', '2026-08-19'); "
          "SELECT * FROM kunden WHERE ort = 'Bonn';",
      startCode: 'INSERT INTO kunden ',
      tipp: 'Zwei Anweisungen nacheinander, beide mit Semikolon: erst '
          'INSERT, dann SELECT.',
      erklaerung:
          'Eine Zeile: dein neuer Kunde. Das SELECT danach ist eine '
          'gute Angewohnheit, so siehst du sofort, ob das Einfügen '
          'getan hat, was du wolltest.',
    )),

    UeberschriftBlock('UPDATE: Werte ändern'),
    CodeBlock(
      "UPDATE artikel\n"
      "SET bestand = 25\n"
      "WHERE artikel_id = 15;",
      titel: 'Dockingstation wieder auf Lager',
      sprache: 'sql',
    ),
    TextBlock(
      'SET sagt was geändert wird, WHERE sagt **in welchen Zeilen**. '
      'Und jetzt der wichtigste Satz dieser Lektion: lässt du das '
      'WHERE weg, ändert UPDATE **jede einzelne Zeile der Tabelle**. '
      'Kein Rückfragen, keine Warnung.',
    ),
    HinweisBlock(
      'Profi-Angewohnheit: vor jedem UPDATE oder DELETE erst dieselbe '
      'Bedingung als SELECT laufen lassen. Was das SELECT zeigt, wird '
      'geändert. Zeigt es zu viel, hast du gerade einen Unfall '
      'verhindert.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-12-2',
      frage: 'Die Dockingstation (artikel_id 15) ist wieder lieferbar: '
          'setz ihren Bestand auf 25. Zeig danach Bezeichnung und '
          'Bestand dieses Artikels.',
      datensatz: 'nordwind',
      musterloesung: 'UPDATE artikel SET bestand = 25 '
          'WHERE artikel_id = 15; '
          'SELECT bezeichnung, bestand FROM artikel WHERE artikel_id = 15;',
      startCode: 'UPDATE ',
      tipp: 'UPDATE artikel SET bestand = ... WHERE artikel_id = ...; '
          'danach ein SELECT auf denselben Artikel.',
      erklaerung:
          'Dockingstation USB-C, Bestand 25. Ohne das WHERE hätten '
          'jetzt ALLE 15 Artikel Bestand 25, aus einer Korrektur wäre '
          'ein Datenverlust geworden.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-12-3',
      frage: 'Was passiert bei UPDATE artikel SET preis = 10; '
          'ohne WHERE?',
      optionen: [
        'Nichts, die Datenbank verlangt ein WHERE',
        'Nur die erste Zeile wird geändert',
        'JEDER Artikel kostet danach 10 Euro',
      ],
      richtig: 2,
      erklaerung:
          'Alle 15 Artikel, ein Statement, kein Zurück. Solche Unfälle '
          'passieren in echten Firmen regelmäßig. Deshalb: erst als '
          'SELECT testen, und im Betrieb nie ohne Backup arbeiten.',
    )),

    UeberschriftBlock('DELETE: Zeilen löschen'),
    CodeBlock(
      "DELETE FROM bestellungen\n"
      "WHERE status = 'storniert';",
      titel: 'Stornierte Bestellungen entfernen',
      sprache: 'sql',
    ),
    TextBlock(
      'DELETE löscht ganze Zeilen, und für das WHERE gilt dieselbe '
      'Warnung wie beim UPDATE: ohne Bedingung ist die Tabelle danach '
      'leer. Die Tabelle selbst bleibt übrigens bestehen, es '
      'verschwinden nur die Zeilen.',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-12-4',
      frage: 'Lösche alle stornierten Bestellungen. Zeig danach, '
          'welche Status-Werte noch vorkommen.',
      datensatz: 'nordwind',
      musterloesung: "DELETE FROM bestellungen WHERE status = 'storniert'; "
          'SELECT DISTINCT status FROM bestellungen;',
      startCode: 'DELETE ',
      tipp: 'DELETE FROM ... WHERE ...; danach SELECT DISTINCT status.',
      erklaerung:
          'Nur noch geliefert und offen. Die eine stornierte Bestellung '
          '(1004) ist weg. In der Praxis löscht man solche Daten '
          'übrigens selten wirklich, meist setzt man nur ein '
          'Kennzeichen, damit die Historie erhalten bleibt.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 13: Tabellen anlegen mit CREATE TABLE
// ═══════════════════════════════════════════════════════════════════════════

const _lektion13 = Lektion(
  nr: 13,
  premium: true,
  slug: 'sql-13',
  titel: 'Tabellen anlegen',
  kurzbeschreibung:
      'CREATE TABLE, Datentypen und Constraints, die schlechte Daten '
      'gar nicht erst reinlassen.',
  dauerMinuten: 16,
  bloecke: [
    TextBlock(
      'Bis jetzt waren die Tabellen einfach da. In dieser Lektion baust '
      'du selbst eine, mit allem, was dazugehört: Datentypen und '
      'Regeln, die falsche Daten von vornherein abweisen.',
    ),

    UeberschriftBlock('CREATE TABLE und Datentypen'),
    CodeBlock(
      'CREATE TABLE lieferanten (\n'
      '  lieferant_id INTEGER PRIMARY KEY,\n'
      '  name         TEXT NOT NULL,\n'
      '  ort          TEXT,\n'
      '  rabatt       REAL DEFAULT 0\n'
      ');',
      titel: 'Eine neue Tabelle',
      sprache: 'sql',
    ),
    TextBlock(
      'Pro Spalte: Name, Datentyp, optionale Regeln. Die wichtigsten '
      'Typen:\n'
      '- `INTEGER`: ganze Zahlen\n'
      '- `REAL`: Kommazahlen\n'
      '- `TEXT`: Zeichenketten\n'
      '- Datumswerte speichert SQLite als TEXT im Format JJJJ-MM-TT, '
      'andere Datenbanken haben eigene DATE-Typen',
    ),
    UeberschriftBlock('Constraints: der Türsteher'),
    TextBlock(
      'Die Regeln hinter dem Typ heißen **Constraints**. Sie sind der '
      'Grund, warum eine Datenbank besser auf Daten aufpasst als eine '
      'Excel-Tabelle:\n'
      '- `PRIMARY KEY`: eindeutig und nie NULL (Lektion 8!)\n'
      '- `NOT NULL`: Pflichtfeld\n'
      '- `UNIQUE`: kein Wert doppelt, z. B. für E-Mail-Adressen\n'
      '- `DEFAULT`: Wert, falls beim INSERT nichts angegeben wird\n'
      '- `REFERENCES tabelle(spalte)`: Fremdschlüssel',
    ),

    AufgabenBlock(SqlAufgabe(
      id: 'sql-13-1',
      frage: "Leg die Tabelle lieferanten aus dem Beispiel an, füge den "
          "Lieferanten (1, 'TechGross GmbH', 'Hamburg', 0) ein und zeig "
          'danach die ganze Tabelle.',
      datensatz: 'nordwind',
      musterloesung: 'CREATE TABLE lieferanten ('
          'lieferant_id INTEGER PRIMARY KEY, '
          'name TEXT NOT NULL, ort TEXT, rabatt REAL DEFAULT 0); '
          "INSERT INTO lieferanten VALUES (1, 'TechGross GmbH', 'Hamburg', 0); "
          'SELECT * FROM lieferanten;',
      startCode: 'CREATE TABLE lieferanten (\n',
      tipp: 'Drei Anweisungen: CREATE TABLE, INSERT, SELECT. Das '
          'Beispiel oben darfst du abschreiben.',
      erklaerung:
          'Eine Zeile, vier Spalten. Du hast gerade den kompletten '
          'Lebenszyklus durch: Struktur anlegen, Daten rein, Daten '
          'lesen.',
    )),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-13-2',
      frage: 'Die Spalte name ist NOT NULL. Was passiert bei '
          'INSERT INTO lieferanten (lieferant_id) VALUES (2);?',
      optionen: [
        'Die Zeile wird eingefügt, name bleibt leer',
        'Die Datenbank weist das INSERT mit einem Fehler ab',
        'Die Datenbank trägt automatisch einen Platzhalter ein',
      ],
      richtig: 1,
      erklaerung:
          'NOT NULL heißt Pflichtfeld: ohne Wert für name wird die '
          'ganze Zeile abgewiesen. Genau dafür sind Constraints da, '
          'der Fehler passiert beim Einfügen und nicht erst Wochen '
          'später beim Auswerten.',
    )),

    AufgabenBlock(LueckenAufgabe(
      id: 'sql-13-3',
      frage: 'Vervollständige: eine Bewertungstabelle, deren '
          'artikel_id auf die Artikeltabelle verweist.',
      vorlage: 'CREATE TABLE bewertungen (\n'
          '  bewertung_id INTEGER ___,\n'
          '  artikel_id   INTEGER ___ artikel(artikel_id),\n'
          '  sterne       INTEGER NOT NULL\n'
          ');',
      loesungen: [
        ['PRIMARY KEY'],
        ['REFERENCES'],
      ],
      bausteine: ['PRIMARY KEY', 'REFERENCES', 'UNIQUE', 'DEFAULT'],
      erklaerung:
          'PRIMARY KEY für die eigene Identität, REFERENCES für den '
          'Verweis auf die fremde Tabelle. Diese zwei Zeilen sind das '
          'Muster für jede 1:n-Beziehung, die du je anlegen wirst.',
    )),

    AufgabenBlock(FehlerAufgabe(
      id: 'sql-13-4',
      frage: 'Dieses CREATE TABLE wirft einen Syntaxfehler. '
          'Tippe die falsche Zeile an.',
      zeilen: [
        'CREATE TABLE projekte (',
        '  projekt_id INTEGER PRIMARY KEY,',
        '  titel TEXT NOT NULL',
        '  budget REAL',
        ');',
      ],
      fehlerZeile: 2,
      korrekturen: [
        'titel TEXT NOT NULL,',
        '  titel TEXT NOT NULL,',
      ],
      tipp: 'Womit werden Spaltendefinitionen voneinander getrennt? '
          'Vergleich Zeile 2 und 3 mit dem Beispiel oben.',
      erklaerung:
          'Nach titel TEXT NOT NULL fehlt das Komma zur nächsten '
          'Spalte. Derselbe Fehler wie bei den Spaltenlisten in '
          'Lektion 1, nur an neuer Stelle: Trennzeichen zwischen den '
          'Definitionen, keins nach der letzten.',
    )),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════
// Lektion 14: Normalisierung und ER-Modell (AP1-Kernstoff)
// ═══════════════════════════════════════════════════════════════════════════

const _lektion14 = Lektion(
  nr: 14,
  premium: true,
  slug: 'sql-14',
  titel: 'Normalisierung und ER-Modell',
  kurzbeschreibung:
      '1. bis 3. Normalform und Kardinalitäten, das Prüfungsthema '
      'schlechthin.',
  dauerMinuten: 20,
  bloecke: [
    TextBlock(
      'Zum Abschluss das Thema, das in der AP1 fast jedes Jahr '
      'drankommt: Wie entwirft man Tabellen richtig? Die gute '
      'Nachricht: du kennst die Antworten längst aus der Praxis der '
      'letzten 13 Lektionen. Jetzt bekommen sie ihre offiziellen Namen.',
    ),

    UeberschriftBlock('1. Normalform: atomare Werte'),
    TextBlock(
      'Eine Tabelle ist in der **1. Normalform (1NF)**, wenn in jedem '
      'Feld genau EIN Wert steht. Kein "Monitor, Tastatur, Maus" in '
      'einer Zelle, keine Spalten artikel1, artikel2, artikel3.',
    ),
    CodeBlock(
      'VERLETZT die 1NF:\n'
      'bestell_id | artikel\n'
      '1001       | Laptop, Monitor, Tastatur\n'
      '\n'
      'ERFÜLLT die 1NF (so macht es unsere positionen-Tabelle):\n'
      'bestell_id | artikel_id\n'
      '1001       | 1\n'
      '1001       | 4\n'
      '1001       | 6',
      titel: 'Vorher und nachher',
      sprache: 'sql',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-14-1',
      frage: 'Warum ist "Laptop, Monitor, Tastatur" in einer Zelle ein '
          'Problem?',
      optionen: [
        'Es verbraucht zu viel Speicherplatz',
        'Man kann nicht mehr sauber danach filtern, zählen oder joinen',
        'Text darf keine Kommas enthalten',
      ],
      richtig: 1,
      erklaerung:
          'Versuch mal, alle Bestellungen mit einem Monitor zu finden '
          'oder zu zählen, wie oft die Tastatur verkauft wurde. Mit '
          'allem in einer Zelle wird jede dieser Fragen zur Bastelei. '
          'Ein Wert pro Feld, dann funktionieren WHERE, COUNT und JOIN.',
    )),

    UeberschriftBlock('2. und 3. Normalform: alles hängt am Schlüssel'),
    TextBlock(
      'Die **2NF** verlangt: jedes Feld hängt vom GANZEN Schlüssel ab. '
      'Das Thema betrifft Tabellen mit zusammengesetztem Schlüssel, wie '
      'positionen (bestell_id + artikel_id). Stünde dort auch der '
      'Artikelname, hinge der nur an der artikel_id, also nur an einem '
      'TEIL des Schlüssels. Deshalb steht er in artikel.',
    ),
    TextBlock(
      'Die **3NF** verlangt zusätzlich: kein Feld hängt von einem '
      'anderen Nicht-Schlüsselfeld ab. Stünde in mitarbeiter neben der '
      'abteilung_id auch der Abteilungs-STANDORT, hinge der am Feld '
      'abteilung_id statt am Mitarbeiter. Ändert die Abteilung ihren '
      'Standort, müsste man zwölf Mitarbeiterzeilen anfassen. Deshalb '
      'gibt es die eigene Tabelle abteilungen.',
    ),
    HinweisBlock(
      'Merksätze für die Prüfung: 1NF "nur atomare Werte". '
      '2NF "abhängig vom ganzen Schlüssel". 3NF "keine Abhängigkeiten '
      'unter Nicht-Schlüsselfeldern". Und als Eselsbrücke für alle '
      'drei: jedes Feld hängt vom Schlüssel ab, vom ganzen Schlüssel, '
      'und von nichts als dem Schlüssel.',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-14-2',
      frage: 'In einer Rechnungstabelle stehen kunden_id UND der '
          'Kundenname. Welche Normalform ist verletzt?',
      optionen: [
        'Die 1. Normalform',
        'Die 3. Normalform: der Name hängt an der kunden_id, nicht '
            'am Rechnungsschlüssel',
        'Keine, das ist erlaubt und üblich',
      ],
      richtig: 1,
      erklaerung:
          'Der Name hängt von der kunden_id ab, einem '
          'Nicht-Schlüsselfeld. Benennt sich der Kunde um, müssten '
          'alle seine Rechnungen geändert werden. Richtig: nur die '
          'kunden_id speichern und den Namen bei Bedarf joinen. Genau '
          'diese Sorte Aufgabe kommt in der AP1.',
    )),

    UeberschriftBlock('Das ER-Modell'),
    TextBlock(
      'Bevor man Tabellen anlegt, zeichnet man den Plan: das '
      '**Entity-Relationship-Modell**. Drei Zutaten:\n'
      '- **Entität**: ein Ding, das es gibt (Kunde, Artikel, Bestellung)\n'
      '- **Attribut**: eine Eigenschaft davon (Name, Preis, Datum)\n'
      '- **Beziehung**: wie Entitäten zusammenhängen, mit ihrer '
      '**Kardinalität**',
    ),
    TextBlock(
      'Die drei Kardinalitäten, alle in unserer Nordwind-Datenbank:\n'
      '- **1:1**: selten, z. B. Mitarbeiter und Firmenlaptop\n'
      '- **1:n**: Kunde und Bestellungen. Fremdschlüssel auf der '
      'n-Seite (Lektion 8)\n'
      '- **n:m**: Bestellungen und Artikel. Braucht eine '
      'Zwischentabelle, unsere positionen',
    ),

    AufgabenBlock(AuswahlAufgabe(
      id: 'sql-14-3',
      frage: 'Schüler besuchen mehrere AGs, jede AG hat mehrere '
          'Schüler. Wie setzt du das in Tabellen um?',
      optionen: [
        'Spalte ag_id in der Schülertabelle',
        'Spalte schueler_id in der AG-Tabelle',
        'Drei Tabellen: schueler, ags und eine Zwischentabelle mit '
            'beiden Fremdschlüsseln',
      ],
      richtig: 2,
      erklaerung:
          'Eine n:m-Beziehung passt in keine der beiden Tabellen, sie '
          'braucht immer die dritte. Ein Fremdschlüssel in einer der '
          'beiden würde bedeuten: ein Schüler hat nur eine AG oder '
          'umgekehrt. Diese Frage ist ein AP1-Dauergast.',
    )),

    AufgabenBlock(ReihenfolgeAufgabe(
      id: 'sql-14-4',
      frage: 'Bring den Weg vom Chaos zur sauberen Datenbank in die '
          'richtige Reihenfolge.',
      zeilen: [
        'Mehrfachwerte auf eigene Zeilen aufteilen (1NF)',
        'Felder, die nur an einem Teil des Schlüssels hängen, '
            'auslagern (2NF)',
        'Felder, die an anderen Nicht-Schlüsselfeldern hängen, '
            'auslagern (3NF)',
        'Beziehungen über Fremdschlüssel wiederherstellen',
      ],
      erklaerung:
          'Erst atomar, dann die Abhängigkeiten in Schichten auflösen, '
          'zum Schluss alles über Schlüssel wieder verbinden. In der '
          'Prüfung reicht fast immer die Normalisierung bis zur 3NF.',
    )),

    UeberschriftBlock('Geschafft'),
    TextBlock(
      'Das war der Kurs: von SELECT über Joins bis zum '
      'Datenbankentwurf. Damit deckst du den kompletten '
      'SQL-und-Datenbanken-Teil der AP1 ab. Zum Festigen: der '
      'Level-Modus hat ein eigenes Modul Datenbanken & SQL mit '
      'Prüfungsfragen im Drill-Format. Und wenn du beim Üben '
      'feststeckst, ist Ada nur einen Fingertipp entfernt.',
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════════════════

const sqlKurs = Kurs(
  slug: 'sql',
  titel: 'SQL von Grund auf',
  beschreibung:
      'Von der ersten Abfrage bis zur Normalisierung. Alle Aufgaben laufen '
      'gegen eine echte Datenbank auf deinem Gerät, auch ohne Internet.',
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
