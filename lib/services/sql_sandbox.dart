// lib/services/sql_sandbox.dart
//
// Führt SQL-Abfragen des Kurses gegen eine echte SQLite-Datenbank aus —
// im Arbeitsspeicher, auf dem Gerät, ohne Netz.
//
// Für jede Ausführung wird die Datenbank FRISCH aufgebaut. Damit kann ein
// Nutzer nichts kaputtmachen, DELETE-Übungen sind gefahrlos, und zwei
// Aufgaben beeinflussen sich nie gegenseitig.
//
// Braucht in pubspec.yaml:
//   sqlite3: ^2.4.0
//   sqlite3_flutter_libs: ^0.5.24

import 'package:sqlite3/sqlite3.dart';

import '../data/kurse/sql_datensaetze.dart';

/// Ergebnis einer Ausführung: entweder Tabelle oder Fehler.
class SqlErgebnis {
  final List<String> spalten;
  final List<List<Object?>> zeilen;

  /// Verständliche deutsche Fehlermeldung, sonst null.
  final String? fehler;

  /// Wurde die Ausgabe gekürzt?
  final bool gekuerzt;

  const SqlErgebnis({
    this.spalten = const [],
    this.zeilen = const [],
    this.fehler,
    this.gekuerzt = false,
  });

  bool get istFehler => fehler != null;
  bool get istLeer => !istFehler && zeilen.isEmpty;

  /// Vergleichbare Form: Werte als Text, damit 1 und 1.0 nicht auseinanderfallen.
  String _normiert(bool reihenfolgeZaehlt) {
    String zelle(Object? w) {
      if (w == null) return '∅';
      if (w is double && w == w.roundToDouble()) {
        return w.toInt().toString();
      }
      return w.toString().trim();
    }

    final reihen = zeilen.map((z) => z.map(zelle).join('')).toList();
    if (!reihenfolgeZaehlt) reihen.sort();
    return reihen.join('');
  }

  /// Inhaltlicher Vergleich mit dem Ergebnis der Musterlösung.
  ///
  /// Bewusst OHNE Spaltennamen: wer `SELECT name` schreibt statt
  /// `SELECT name AS kunde`, hat die Aufgabe trotzdem gelöst.
  bool gleichWie(SqlErgebnis andere, {bool reihenfolgeZaehlt = false}) {
    if (istFehler || andere.istFehler) return false;
    if (spalten.length != andere.spalten.length) return false;
    if (zeilen.length != andere.zeilen.length) return false;
    return _normiert(reihenfolgeZaehlt) ==
        andere._normiert(reihenfolgeZaehlt);
  }
}

class SqlSandbox {
  /// Mehr Zeilen sieht sich auf einem Handy ohnehin niemand an.
  static const int maxZeilen = 200;

  /// Führt [abfrage] gegen den Datensatz [datensatzName] aus.
  ///
  /// Mehrere Anweisungen sind erlaubt (z. B. INSERT gefolgt von SELECT) —
  /// zurückgegeben wird das Ergebnis der LETZTEN Anweisung, die Zeilen liefert.
  static SqlErgebnis ausfuehren(String datensatzName, String abfrage) {
    final datensatz = sqlDatensaetze[datensatzName];
    if (datensatz == null) {
      return SqlErgebnis(
        fehler: 'Übungsdatenbank »$datensatzName« nicht gefunden.',
      );
    }

    if (abfrage.trim().isEmpty) {
      return const SqlErgebnis(fehler: 'Da steht noch nichts zum Ausführen.');
    }

    Database? db;
    try {
      db = sqlite3.openInMemory();
      db.execute(datensatz.schema);

      SqlErgebnis? letztes;

      for (final anweisung in _zerlegen(abfrage)) {
        if (_liefertZeilen(anweisung)) {
          final ergebnis = db.select(anweisung);
          final zeilen = ergebnis.rows
              .take(maxZeilen)
              .map((r) => r.toList())
              .toList();

          letztes = SqlErgebnis(
            spalten: ergebnis.columnNames,
            zeilen: zeilen,
            gekuerzt: ergebnis.rows.length > maxZeilen,
          );
        } else {
          db.execute(anweisung);
          letztes ??= const SqlErgebnis();
        }
      }

      return letztes ?? const SqlErgebnis();
    } on SqliteException catch (e) {
      return SqlErgebnis(fehler: _uebersetze(e));
    } catch (e) {
      return SqlErgebnis(fehler: 'Unerwarteter Fehler: $e');
    } finally {
      db?.dispose();
    }
  }

  /// Naive Aufteilung an Semikolons. Reicht für Kursaufgaben — Semikolons
  /// innerhalb von Zeichenketten kommen dort nicht vor.
  static List<String> _zerlegen(String eingabe) {
    // Kommentare entfernen, sonst schluckt eine "-- ..."-Zeile das Semikolon.
    final ohneKommentare = eingabe
        .replaceAll(RegExp(r'--[^\n]*'), '')
        .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');

    return ohneKommentare
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static bool _liefertZeilen(String anweisung) {
    final anfang = anweisung.trimLeft().toUpperCase();
    return anfang.startsWith('SELECT') ||
        anfang.startsWith('WITH') ||
        anfang.startsWith('PRAGMA') ||
        anfang.startsWith('EXPLAIN') ||
        anfang.contains('RETURNING');
  }

  /// SQLite-Meldungen sind englisch und knapp. Für jemanden, der gerade
  /// erst anfängt, ist "no such column: nmae" kein hilfreicher Satz.
  static String _uebersetze(SqliteException e) {
    final roh = e.message;

    final spalte = RegExp(r'no such column:\s*(\S+)').firstMatch(roh);
    if (spalte != null) {
      return 'Die Spalte »${spalte.group(1)}« gibt es nicht. '
          'Tippfehler? Schau in der Tabellenübersicht nach den Spaltennamen.';
    }

    final tabelle = RegExp(r'no such table:\s*(\S+)').firstMatch(roh);
    if (tabelle != null) {
      return 'Die Tabelle »${tabelle.group(1)}« gibt es nicht. '
          'Achte auf die Mehrzahl: kunden, artikel, bestellungen, '
          'positionen, mitarbeiter, abteilungen.';
    }

    final funktion = RegExp(r'no such function:\s*(\S+)').firstMatch(roh);
    if (funktion != null) {
      return 'Die Funktion »${funktion.group(1)}« kennt SQLite nicht. '
          'Andere Datenbanken haben teils andere Funktionsnamen.';
    }

    if (roh.contains('syntax error')) {
      return 'Syntaxfehler. Irgendwo stimmt die Reihenfolge oder ein '
          'Zeichen nicht. Häufig: fehlendes Komma zwischen Spalten, '
          'ein Klammerpaar unvollständig, oder FROM vergessen.';
    }

    if (roh.contains('incomplete input')) {
      return 'Die Abfrage bricht mittendrin ab. Fehlt am Ende etwas, '
          'vielleicht eine schließende Klammer oder ein Anführungszeichen?';
    }

    if (roh.contains('ambiguous column name')) {
      return 'Der Spaltenname kommt in mehreren Tabellen vor. '
          'Schreib dazu, welche gemeint ist, z. B. kunden.name '
          'statt nur name.';
    }

    if (roh.contains('UNIQUE constraint failed')) {
      return 'Dieser Schlüssel ist schon vergeben. '
          'Zwei Datensätze dürfen nicht dieselbe ID haben.';
    }

    if (roh.contains('NOT NULL constraint failed')) {
      return 'Eine Pflichtspalte ist leer geblieben. '
          'Spalten mit NOT NULL brauchen immer einen Wert.';
    }

    if (roh.contains('FOREIGN KEY constraint failed')) {
      return 'Der Fremdschlüssel zeigt ins Leere, '
          'der verwiesene Datensatz existiert nicht.';
    }

    return 'SQL-Fehler: $roh';
  }
}
