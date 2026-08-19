// lib/models/kurs_aufgabe.dart
//
// Datenmodell für interaktive Kursaufgaben (Python- und SQL-Kurs).
//
// Grundgedanke: Kursinhalte sind DATEN, keine handgeschriebenen Screens.
// Eine neue Lektion ist dann ein Eintrag in einer Liste, kein neuer Widget-Baum.
// Genau daran krankt der Web-Kurs — dort ist jede Lektion eine eigene TSX-Datei.

/// Gemeinsame Basis aller Aufgabentypen.
sealed class KursAufgabe {
  /// Eindeutig innerhalb des Kurses, z. B. "sql-3-2".
  /// Wird zum Speichern des Fortschritts benutzt.
  final String id;

  /// Aufgabenstellung in normalem Deutsch.
  final String frage;

  /// Wird NACH dem Lösen eingeblendet — das eigentliche Lernmoment.
  final String? erklaerung;

  const KursAufgabe({
    required this.id,
    required this.frage,
    this.erklaerung,
  });
}

/// Lückentext: Code mit Platzhaltern, die gefüllt werden müssen.
///
/// Im Vorlagentext markiert `___` (drei Unterstriche) eine Lücke.
/// Die Reihenfolge in [loesungen] entspricht der Reihenfolge der Lücken.
class LueckenAufgabe extends KursAufgabe {
  /// z. B. "SELECT ___ FROM kunden ___ ort = 'Berlin';"
  final String vorlage;

  /// Pro Lücke eine Liste akzeptierter Antworten.
  /// Mehrere, damit Schreibweisen nicht unfair abgelehnt werden:
  /// `[["*", "alle"], ["WHERE"]]`
  final List<List<String>> loesungen;

  /// Optional: anzutippende Bausteine statt Tastatureingabe.
  /// Sollte auch falsche Kandidaten enthalten, sonst ist es geraten.
  final List<String> bausteine;

  /// Groß-/Kleinschreibung prüfen? Bei SQL-Schlüsselwörtern: nein.
  final bool beachteGrossschreibung;

  const LueckenAufgabe({
    required super.id,
    required super.frage,
    required this.vorlage,
    required this.loesungen,
    this.bausteine = const [],
    this.beachteGrossschreibung = false,
    super.erklaerung,
  });

  /// Anzahl der Lücken laut Vorlage.
  int get anzahlLuecken => '___'.allMatches(vorlage).length;
}

/// Reihenfolge-Aufgabe (Parsons-Problem): Codezeilen in die richtige
/// Reihenfolge ziehen. Trainiert Ablauflogik und Einrückung, ohne dass
/// Tippfehler vom eigentlichen Lernziel ablenken.
class ReihenfolgeAufgabe extends KursAufgabe {
  /// Zeilen in KORREKTER Reihenfolge. Das Mischen macht das Widget.
  final List<String> zeilen;

  /// Einrücktiefe je Zeile (0, 1, 2 …). Wird nur angezeigt, nicht geprüft —
  /// sonst wird die Aufgabe für Einsteiger zu hart.
  final List<int> einrueckung;

  const ReihenfolgeAufgabe({
    required super.id,
    required super.frage,
    required this.zeilen,
    this.einrueckung = const [],
    super.erklaerung,
  });

  int tiefe(int index) =>
      index < einrueckung.length ? einrueckung[index] : 0;
}

/// Fehlersuche: fehlerhafter Code, die kaputte Zeile muss gefunden
/// und richtig geschrieben werden. Das ist das, was im Betrieb
/// tatsächlich den ganzen Tag passiert.
class FehlerAufgabe extends KursAufgabe {
  /// Der fehlerhafte Code, zeilenweise.
  final List<String> zeilen;

  /// Index der kaputten Zeile in [zeilen].
  final int fehlerZeile;

  /// Akzeptierte Korrekturen für diese Zeile.
  final List<String> korrekturen;

  /// Kurzer Hinweis, abrufbar wenn jemand feststeckt.
  final String? tipp;

  const FehlerAufgabe({
    required super.id,
    required super.frage,
    required this.zeilen,
    required this.fehlerZeile,
    required this.korrekturen,
    this.tipp,
    super.erklaerung,
  });
}

/// Klassische Auswahlfrage. Bewusst mit dabei, weil sie für
/// Verständnisfragen ("Was passiert hier?") unschlagbar schnell ist.
class AuswahlAufgabe extends KursAufgabe {
  final List<String> optionen;

  /// Index der richtigen Option in [optionen].
  final int richtig;

  const AuswahlAufgabe({
    required super.id,
    required super.frage,
    required this.optionen,
    required this.richtig,
    super.erklaerung,
  });
}

/// SQL-Aufgabe mit echter Ausführung: der Nutzer schreibt eine Abfrage,
/// sie läuft gegen eine SQLite-Datenbank im Gerät, und geprüft wird das
/// ERGEBNIS — nicht der Wortlaut. Damit zählt jede korrekte Lösung,
/// auch eine, an die beim Schreiben der Aufgabe niemand gedacht hat.
class SqlAufgabe extends KursAufgabe {
  /// Name des Datensatzes (siehe sql_datensaetze.dart), z. B. "kunden".
  final String datensatz;

  /// Musterlösung. Sie wird ausgeführt, ihr Ergebnis ist die Zielvorgabe.
  final String musterloesung;

  /// Muss die Zeilenreihenfolge übereinstimmen?
  /// Nur bei Aufgaben mit ORDER BY sinnvoll.
  final bool reihenfolgeZaehlt;

  /// Startinhalt des Editors, z. B. "SELECT " als Anschubhilfe.
  /// Wird im Baustein-Modus ignoriert.
  final String startCode;

  /// Antippbare Bausteine statt Tastatur.
  ///
  /// Ist die Liste nicht leer, wird die Abfrage durch Antippen
  /// zusammengesetzt — wie bei Sprachlern-Apps. Das nimmt Einsteigern
  /// die Tippfehler aus dem Weg, damit sie sich auf die Logik
  /// konzentrieren können.
  ///
  /// Die Liste sollte mehr Bausteine enthalten als die Lösung braucht,
  /// sonst ist die Aufgabe durch bloßes Aneinanderreihen lösbar.
  /// Bausteine dürfen mehrfach benutzt werden.
  final List<String> bausteine;

  /// Darf trotz Bausteinen auf Tastatur umgeschaltet werden?
  /// Sinnvoll ab der Mitte des Kurses.
  final bool tastaturErlaubt;

  final String? tipp;

  const SqlAufgabe({
    required super.id,
    required super.frage,
    required this.datensatz,
    required this.musterloesung,
    this.reihenfolgeZaehlt = false,
    this.startCode = '',
    this.bausteine = const [],
    this.tastaturErlaubt = true,
    this.tipp,
    super.erklaerung,
  });

  bool get bausteinModus => bausteine.isNotEmpty;
}

// ───────────────────────────────────────────────────────────────────────────
// Lektionen und Kurse
// ───────────────────────────────────────────────────────────────────────────

/// Ein Abschnitt innerhalb einer Lektion: entweder Erklärtext, ein
/// Codebeispiel oder eine Aufgabe. Dadurch lassen sich Übungen mitten
/// im Erklärtext platzieren statt nur am Ende.
sealed class LektionsBlock {
  const LektionsBlock();
}

class TextBlock extends LektionsBlock {
  /// Unterstützt einfaches Markdown: **fett**, `code`, Listen mit "- ".
  final String text;
  const TextBlock(this.text);
}

class UeberschriftBlock extends LektionsBlock {
  final String text;
  const UeberschriftBlock(this.text);
}

class CodeBlock extends LektionsBlock {
  final String code;
  final String? titel;

  /// Für Syntaxhervorhebung: "python" oder "sql".
  final String sprache;

  const CodeBlock(this.code, {this.titel, this.sprache = 'python'});
}

class HinweisBlock extends LektionsBlock {
  final String text;
  const HinweisBlock(this.text);
}

class AufgabenBlock extends LektionsBlock {
  final KursAufgabe aufgabe;
  const AufgabenBlock(this.aufgabe);
}

class Lektion {
  final int nr;
  final String slug;
  final String titel;

  /// Ein Satz, der auf der Übersichtskachel steht.
  final String kurzbeschreibung;

  /// Geschätzte Dauer in Minuten — Nutzer planen danach ihre Lernsession.
  final int dauerMinuten;

  final List<LektionsBlock> bloecke;

  /// Nur für zahlende Nutzer? Die ersten Lektionen sollten frei sein,
  /// sonst sieht niemand, ob der Kurs etwas taugt.
  final bool premium;

  const Lektion({
    required this.nr,
    required this.slug,
    required this.titel,
    required this.kurzbeschreibung,
    required this.dauerMinuten,
    required this.bloecke,
    this.premium = false,
  });

  /// Alle Aufgaben dieser Lektion, in Reihenfolge.
  List<KursAufgabe> get aufgaben => bloecke
      .whereType<AufgabenBlock>()
      .map((b) => b.aufgabe)
      .toList(growable: false);
}

class Kurs {
  final String slug; // "python" | "sql"
  final String titel;
  final String beschreibung;
  final List<Lektion> lektionen;

  const Kurs({
    required this.slug,
    required this.titel,
    required this.beschreibung,
    required this.lektionen,
  });

  int get gesamtDauer =>
      lektionen.fold(0, (summe, l) => summe + l.dauerMinuten);

  int get anzahlAufgaben =>
      lektionen.fold(0, (summe, l) => summe + l.aufgaben.length);
}
