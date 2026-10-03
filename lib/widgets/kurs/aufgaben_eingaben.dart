// lib/widgets/kurs/aufgaben_eingaben.dart
//
// Was hat der Azubi in einer Kursaufgabe gerade eingegeben?
//
// Die Eingaben stecken im Zustand der einzelnen Aufgaben-Widgets. Damit Ada
// sie kennt (Wunsch 03.10.2026: „Ist meine Lösung richtig?“ ohne alles in
// den Chat abzutippen), meldet jedes Widget beim Aufbau einen Leser an.
// Der LektionScreen fragt ihn ab, sobald jemand Ada öffnet. So wird nichts
// bei jedem Tastendruck hin und her gemeldet.

/// Liefert die aktuelle Eingabe als Text für Ada, oder null.
typedef EingabeLeser = String? Function();

class AufgabenEingaben {
  final _leser = <String, EingabeLeser>{};

  /// Meldet den Leser für die Aufgabe [id] an (im initState).
  void anmelden(String id, EingabeLeser leser) => _leser[id] = leser;

  /// Meldet ihn wieder ab (im dispose). Nur wenn noch derselbe Leser
  /// eingetragen ist, denn beim Blättern kann das neue Widget seinen
  /// Leser schon angemeldet haben, bevor das alte abgebaut wird.
  void abmelden(String id, EingabeLeser leser) {
    if (_leser[id] == leser) _leser.remove(id);
  }

  /// Aktuelle Eingabe der Aufgabe [id], null wenn unbekannt.
  String? lesen(String id) {
    try {
      final text = _leser[id]?.call();
      return (text == null || text.trim().isEmpty) ? null : text;
    } catch (_) {
      // Ada soll nie an einer Eingabe scheitern, dann eben ohne.
      return null;
    }
  }
}
