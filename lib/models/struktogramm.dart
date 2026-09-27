// lib/models/struktogramm.dart
//
// Datenformat für Struktogramme (Nassi-Shneiderman, DIN 66261).
//
// Gegenstück zu web/app/struktogramm-kurs/_components/struktogramm-typen.ts:
// dieselben Bausteine, dieselbe Reihenfolge der Angaben. Lektionen aus dem
// Web lassen sich dadurch fast Zeile für Zeile übernehmen:
//
//   Web:  wenn("x > 0", [anw("Ausgabe x")], [])
//   App:  SgWenn('x > 0', [SgAnw('Ausgabe x')])
//
// Anders als im Web sind die Bausteine Klassen mit const-Konstruktoren statt
// Hilfsfunktionen. Nur so bleiben die Lektionen `const` wie im SQL- und
// Python-Kurs (Funktionsaufrufe sind in const-Ausdrücken nicht erlaubt).
//
// Ein Struktogramm ist eine Liste von Blöcken, gelesen von oben nach unten.
// Verzweigungen und Schleifen enthalten wieder Listen von Blöcken.
//
// Beispiel „Summe von 1 bis n":
//   [
//     SgAnw('Eingabe n'),
//     SgAnw('summe = 0'),
//     SgFuer('für i = 1 bis n', [SgAnw('summe = summe + i')]),
//     SgAnw('Ausgabe summe'),
//   ]

/// Gemeinsame Basis aller Bausteine.
sealed class SgBlock {
  const SgBlock();
}

/// Anweisung: Zuweisung, Eingabe, Ausgabe. Ein Rechteck.
class SgAnw extends SgBlock {
  final String text;
  const SgAnw(this.text);
}

/// Zweiseitige Auswahl: Bedingung im Dreieck, links der Ja-Zweig,
/// rechts der Nein-Zweig. Ein leerer Zweig wird als ∅ gezeichnet.
class SgWenn extends SgBlock {
  final String bedingung;
  final List<SgBlock> ja;
  final List<SgBlock> nein;

  /// Abweichende Beschriftung, z. B. „wahr" / „falsch".
  final String jaText;
  final String neinText;

  const SgWenn(
    this.bedingung,
    this.ja, [
    this.nein = const [],
  ])  : jaText = 'ja',
        neinText = 'nein';

  const SgWenn.beschriftet(
    this.bedingung,
    this.ja,
    this.nein, {
    required this.jaText,
    required this.neinText,
  });
}

/// Ein Fall der Mehrfachauswahl: Wert im Kopf, Blöcke in der Spalte.
class SgFall {
  final String wert;
  final List<SgBlock> bloecke;
  const SgFall(this.wert, this.bloecke);
}

/// Mehrfachauswahl (FALLS): ein Ausdruck, mehrere Fälle, optional „sonst".
class SgFalls extends SgBlock {
  final String ausdruck;
  final List<SgFall> faelle;
  final List<SgBlock>? sonst;
  const SgFalls(this.ausdruck, this.faelle, {this.sonst});
}

/// Kopfgesteuerte Schleife: Bedingung wird vor jedem Durchlauf geprüft,
/// gezeichnet als „solange …" über dem Rumpf.
class SgSolange extends SgBlock {
  final String bedingung;
  final List<SgBlock> rumpf;
  const SgSolange(this.bedingung, this.rumpf);
}

/// Fußgesteuerte Schleife: der Rumpf läuft mindestens einmal, die
/// Bedingung steht darunter.
///
/// `SgWiederhole.bis`: Abbruchbedingung, gezeichnet „bis …" (Standard).
/// `SgWiederhole.solange`: Fortsetzungsbedingung wie do-while,
/// gezeichnet „solange …".
class SgWiederhole extends SgBlock {
  final String bedingung;
  final List<SgBlock> rumpf;
  final bool bis;

  const SgWiederhole.bis(this.bedingung, this.rumpf) : bis = true;
  const SgWiederhole.solange(this.bedingung, this.rumpf) : bis = false;
}

/// Zählschleife: der Kopf steht wörtlich da, z. B. „für i = 1 bis n".
class SgFuer extends SgBlock {
  final String kopf;
  final List<SgBlock> rumpf;
  const SgFuer(this.kopf, this.rumpf);
}

/// Aufruf eines Unterprogramms: Rechteck mit doppelten Seitenlinien.
class SgAufruf extends SgBlock {
  final String text;
  const SgAufruf(this.text);
}

/// Lücke für Aufgaben „Ergänzen Sie …": schraffiertes Feld mit Marke,
/// z. B. „1".
class SgLuecke extends SgBlock {
  final String marke;
  const SgLuecke(this.marke);
}
