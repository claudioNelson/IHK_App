// lib/models/uml.dart
//
// Datenformat für UML-Diagramme im App-Kurs (Use-Case-, Klassen-,
// Aktivitäts-, Sequenz- und Zustandsdiagramm). Gezeichnet von
// widgets/kurs/uml_ansicht.dart.
//
// Wie beim Web-Kurs (web/app/uml-kurs/_components/UmlDiagramme*.tsx) sind
// die Diagramme von Hand angeordnet: Jedes Element hat feste Koordinaten
// in einer Zeichenfläche von breite x hoehe Punkten. Die Ansicht skaliert
// die Fläche auf die Bildschirmbreite (nicht kleiner als 75 %, darunter
// scrollt sie seitlich) und öffnet sie beim Antippen im Vollbild zum
// Zoomen.
//
// Alle Klassen haben const-Konstruktoren, damit Lektionen `const` bleiben.
// Koordinaten: x nach rechts, y nach unten, Einheit logische Pixel.

import 'dart:ui' show Offset;

class UmlDiagramm {
  final double breite;
  final double hoehe;
  final List<UmlElement> elemente;

  /// Kurzbeschreibung für Screenreader.
  final String beschreibung;

  const UmlDiagramm({
    required this.breite,
    required this.hoehe,
    required this.elemente,
    this.beschreibung = 'UML-Diagramm',
  });
}

/// Gemeinsame Basis aller Zeichenelemente. Die Reihenfolge in der Liste ist
/// die Zeichenreihenfolge: später Gezeichnetes liegt oben.
sealed class UmlElement {
  const UmlElement();
}

// ───────────────────────────────────────────────────────────────────────────
// Klassendiagramm
// ───────────────────────────────────────────────────────────────────────────

/// Klasse mit Namensfach, Attributfach und Methodenfach.
///
/// Höhe: Kopf 30 (mit Stereotyp oder abstrakt 44), je Fach 10 + 18 pro
/// Zeile, ein leeres Fach 12. `null` heißt: Fach wird nicht gezeichnet.
class UmlKlasse extends UmlElement {
  final double x;
  final double y;
  final double b;
  final String name;
  final List<String>? attribute;
  final List<String>? methoden;

  /// Zweite Kopfzeile, z. B. '«interface»'. Wird über dem Namen gezeigt.
  final String? stereotyp;

  /// Abstrakte Klasse: Name kursiv und {abstract} im Kopf.
  final bool abstrakt;

  /// Objekt statt Klasse: Name unterstrichen, z. B. 'rad7 : Lastenrad'.
  final bool objekt;

  const UmlKlasse({
    required this.x,
    required this.y,
    required this.b,
    required this.name,
    this.attribute,
    this.methoden,
    this.stereotyp,
    this.abstrakt = false,
    this.objekt = false,
  });

  static const double kopf = 30;
  static const double kopfZusatz = 14;
  static const double zeile = 18;

  static double fachHoehe(int n) => n == 0 ? 12 : 10 + n * zeile;

  double get kopfHoehe =>
      kopf + ((stereotyp != null || abstrakt) ? kopfZusatz : 0);

  double get hoehe {
    var h = kopfHoehe;
    if (attribute != null) h += fachHoehe(attribute!.length);
    if (methoden != null) h += fachHoehe(methoden!.length);
    return h;
  }
}

enum UmlKantenArt {
  /// durchgezogene Linie ohne Spitze
  assoziation,

  /// durchgezogen, offene Pfeilspitze am Ende (navigierbar)
  gerichtet,

  /// gestrichelt, offene Pfeilspitze am Ende
  abhaengigkeit,

  /// leere Raute am Start (Ganzes), Linie zum Teil
  aggregation,

  /// gefüllte Raute am Start (Ganzes), Linie zum Teil
  komposition,

  /// durchgezogen, hohles Dreieck am Ende (Oberklasse)
  vererbung,

  /// gestrichelt, hohles Dreieck am Ende (Interface)
  realisierung,
}

/// Beziehung zwischen Klassen, Akteuren oder Anwendungsfällen.
/// [punkte] ist ein Linienzug, der erste Punkt ist der Start.
class UmlKante extends UmlElement {
  final List<Offset> punkte;
  final UmlKantenArt art;

  /// Multiplizität am Start bzw. am Ende.
  final String? von;
  final String? nach;

  /// Rollenname am Start bzw. am Ende.
  final String? rolleVon;
  final String? rolleNach;

  /// Name der Beziehung an der Mitte, z. B. 'bucht' oder '«include»'.
  final String? name;

  const UmlKante({
    required this.punkte,
    this.art = UmlKantenArt.assoziation,
    this.von,
    this.nach,
    this.rolleVon,
    this.rolleNach,
    this.name,
  });
}

// ───────────────────────────────────────────────────────────────────────────
// Use-Case-Diagramm
// ───────────────────────────────────────────────────────────────────────────

/// Strichmännchen. [x] ist die Mitte, [y] die Oberkante des Kopfes.
/// Figur 50 hoch, der Name steht darunter (bis etwa y + 72).
class UmlAkteur extends UmlElement {
  final double x;
  final double y;
  final String name;
  const UmlAkteur({required this.x, required this.y, required this.name});
}

/// Anwendungsfall als Ellipse um den Mittelpunkt.
class UmlUseCase extends UmlElement {
  final double cx;
  final double cy;
  final double rx;
  final double ry;
  final String text;
  const UmlUseCase({
    required this.cx,
    required this.cy,
    required this.rx,
    this.ry = 24,
    required this.text,
  });
}

/// Rechteck mit Titel oben links: Systemgrenze, Schwimmbahn, Rahmen.
/// Mit [fragment] wird der Titel in einem Fünfeck gezeigt (alt, loop).
class UmlRahmen extends UmlElement {
  final double x;
  final double y;
  final double b;
  final double h;
  final String titel;
  final bool fragment;
  const UmlRahmen({
    required this.x,
    required this.y,
    required this.b,
    required this.h,
    this.titel = '',
    this.fragment = false,
  });
}

// ───────────────────────────────────────────────────────────────────────────
// Aktivitäts- und Zustandsdiagramm
// ───────────────────────────────────────────────────────────────────────────

/// Startknoten: gefüllter Kreis um (x, y), Radius 9.
class UmlStart extends UmlElement {
  final double x;
  final double y;
  const UmlStart({required this.x, required this.y});
}

/// Endknoten: Kreis mit gefülltem Kern um (x, y), Radius 11.
class UmlEnde extends UmlElement {
  final double x;
  final double y;
  const UmlEnde({required this.x, required this.y});
}

/// Ablaufende: Kreis mit Kreuz um (x, y), Radius 10.
class UmlAblaufende extends UmlElement {
  final double x;
  final double y;
  const UmlAblaufende({required this.x, required this.y});
}

/// Aktion (Aktivitätsdiagramm) oder Zustand (Zustandsdiagramm):
/// abgerundetes Rechteck mit zentriertem Text, Zeilen mit '\n'.
/// Bei [zustand] wird der Text oben fett gezeigt und [zusatz] darunter
/// hinter einer Trennlinie (z. B. 'entry / Licht an').
class UmlAktion extends UmlElement {
  final double x;
  final double y;
  final double b;
  final double h;
  final String text;
  final bool zustand;
  final List<String> zusatz;
  const UmlAktion({
    required this.x,
    required this.y,
    required this.b,
    this.h = 40,
    required this.text,
    this.zustand = false,
    this.zusatz = const [],
  });
}

/// Entscheidung oder Zusammenführung: Raute um (x, y), halbe Diagonale 16.
class UmlRaute extends UmlElement {
  final double x;
  final double y;
  const UmlRaute({required this.x, required this.y});
}

/// Gabelung oder Vereinigung: dicker waagerechter Balken.
class UmlBalken extends UmlElement {
  final double x1;
  final double x2;
  final double y;
  const UmlBalken({required this.x1, required this.x2, required this.y});
}

enum UmlSpitze {
  /// keine Spitze
  keine,

  /// offene Spitze (Kontrollfluss, Übergang, asynchrone Nachricht)
  offen,

  /// gefüllte Spitze (synchrone Nachricht)
  voll,
}

/// Pfeil oder Linie für Kontrollfluss, Übergänge und Nachrichten.
/// [text] steht an der Mitte des Segments [textSegment]; [textVersatz]
/// verschiebt ihn, Standard: 6 über waagerechten, 8 rechts neben
/// senkrechten Segmenten.
class UmlPfeil extends UmlElement {
  final List<Offset> punkte;
  final UmlSpitze spitze;
  final bool gestrichelt;
  final String? text;
  final int textSegment;
  final Offset textVersatz;

  /// Textausrichtung: -1 links, 0 Mitte, 1 rechts vom Ankerpunkt.
  final int textAusrichtung;

  const UmlPfeil({
    required this.punkte,
    this.spitze = UmlSpitze.offen,
    this.gestrichelt = false,
    this.text,
    this.textSegment = 0,
    this.textVersatz = Offset.zero,
    this.textAusrichtung = 0,
  });
}

// ───────────────────────────────────────────────────────────────────────────
// Sequenzdiagramm
// ───────────────────────────────────────────────────────────────────────────

/// Lebenslinie: Kopf (b breit, 36 hoch) mit unterstrichenem Namen, darunter
/// die gestrichelte Linie bis [bis]. [x] ist die Mitte.
class UmlLebenslinie extends UmlElement {
  final double x;
  final double y;
  final double b;
  final String name;
  final double bis;
  const UmlLebenslinie({
    required this.x,
    required this.y,
    this.b = 120,
    required this.name,
    required this.bis,
  });
}

/// Aktivierungsbalken auf einer Lebenslinie, 12 breit, mittig auf [x].
class UmlAktivierung extends UmlElement {
  final double x;
  final double von;
  final double bis;
  const UmlAktivierung({required this.x, required this.von, required this.bis});
}

// ───────────────────────────────────────────────────────────────────────────
// Allgemein
// ───────────────────────────────────────────────────────────────────────────

/// Freier Text. [x] ist je nach [ausrichtung] linker Rand (-1), Mitte (0)
/// oder rechter Rand (1), [y] die Oberkante.
class UmlText extends UmlElement {
  final double x;
  final double y;
  final String text;
  final int ausrichtung;
  final bool kursiv;
  final bool fett;
  final bool code;
  const UmlText({
    required this.x,
    required this.y,
    required this.text,
    this.ausrichtung = -1,
    this.kursiv = false,
    this.fett = false,
    this.code = false,
  });
}

/// Notiz mit Eselsohr, Zeilen mit '\n'. Mit [anker] führt eine gestrichelte
/// Linie von der Notiz zu diesem Punkt.
class UmlNotiz extends UmlElement {
  final double x;
  final double y;
  final double b;
  final String text;
  final Offset? anker;
  final Offset? ankerVon;
  const UmlNotiz({
    required this.x,
    required this.y,
    required this.b,
    required this.text,
    this.anker,
    this.ankerVon,
  });
}
