// Erzeugt die App-Store-Screenshots auf einem iOS-Simulator.
//
// Ausgefuehrt ueber:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshots_test.dart \
//     -d <simulator-id> \
//     --dart-define=SHOT_EMAIL=... --dart-define=SHOT_PASSWORD=...
//
// Ablauf: Onboarding ueberspringen -> Login -> Tabs abfotografieren.
// Jeder Schritt protokolliert die sichtbaren Texte, damit im Codemagic-Log
// nachvollziehbar ist, wo der Test steht, falls ein Screen anders aussieht.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ihk_app/main.dart' as app;

const String kEmail = String.fromEnvironment('SHOT_EMAIL');
const String kPassword = String.fromEnvironment('SHOT_PASSWORD');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Wartet ohne pumpAndSettle — das bleibt bei Dauer-Animationen haengen.
  Future<void> ruhe(WidgetTester tester,
      {int sekunden = 3, int schritte = 12}) async {
    for (var i = 0; i < schritte; i++) {
      await tester.pump(Duration(milliseconds: sekunden * 1000 ~/ schritte));
    }
  }

  /// Schreibt die sichtbaren Texte ins Log — unverzichtbar zur Fehlersuche,
  /// weil man den Simulator im CI nicht sehen kann.
  void protokolliereScreen(WidgetTester tester, String wo) {
    final texte = <String>[];
    for (final element in find.byType(Text).evaluate()) {
      final w = element.widget as Text;
      final s = w.data ?? w.textSpan?.toPlainText() ?? '';
      if (s.trim().isNotEmpty && s.length < 60) texte.add(s.trim());
    }
    debugPrint('--- SICHTBAR bei "$wo" (${texte.length}): '
        '${texte.take(25).join(" | ")}');
  }

  /// Schliesst ueberlagernde Dialoge (Streak-Begruessung, Hinweise), die
  /// sonst den eigentlichen Screen verdecken.
  Future<void> schliesseDialoge(WidgetTester tester) async {
    // Reihenfolge zaehlt: "Los geht's!" ist der Knopf des Streak-Dialogs
    // ab mehreren Tagen Serie — bei 1 Tag heisst er "Später".
    for (final knopf in const [
      "Los geht's!",
      "Los geht's",
      'Später',
      'Spaeter',
      'Schließen',
      'Weiter lernen',
      'Verstanden',
      'Abbrechen',
      'OK',
    ]) {
      final f = find.text(knopf);
      if (f.evaluate().isNotEmpty) {
        await tester.tap(f.first, warnIfMissed: false);
        await ruhe(tester, sekunden: 2);
        tester.takeException();
        debugPrint('Dialog geschlossen ueber "$knopf"');
      }
    }
  }

  Future<void> schuss(WidgetTester tester, String name) async {
    await schliesseDialoge(tester);
    await ruhe(tester, sekunden: 1);
    protokolliereScreen(tester, name);
    await binding.takeScreenshot(name);
    debugPrint('>>> Screenshot: $name');
  }

  /// Scrollt die erste scrollbare Flaeche nach unten.
  Future<void> scrolle(WidgetTester tester, double pixel) async {
    final s = find.byType(Scrollable);
    if (s.evaluate().isEmpty) return;
    try {
      await tester.drag(s.first, Offset(0, -pixel));
      await ruhe(tester, sekunden: 2);
      tester.takeException();
    } catch (e) {
      debugPrint('Scrollen fehlgeschlagen: $e');
    }
  }

  /// Geht einen Bildschirm zurueck; faellt auf den Tab-Wechsel zurueck.
  Future<void> zurueck(WidgetTester tester, String tab) async {
    try {
      await tester.pageBack();
      await ruhe(tester, sekunden: 3);
      tester.takeException();
    } catch (_) {
      final f = find.text(tab);
      if (f.evaluate().isNotEmpty) {
        await tester.tap(f.first, warnIfMissed: false);
        await ruhe(tester, sekunden: 3);
        tester.takeException();
      }
    }
  }

  /// Tippt auf einen Text, wenn er existiert.
  Future<bool> tippeText(WidgetTester tester, String text,
      {int warteSekunden = 2}) async {
    final f = find.text(text);
    if (f.evaluate().isEmpty) return false;
    await tester.tap(f.first, warnIfMissed: false);
    await ruhe(tester, sekunden: warteSekunden);
    tester.takeException(); // aufgelaufene Warnungen verwerfen
    debugPrint('Getippt: "$text"');
    return true;
  }

  testWidgets('App-Store-Screenshots', (WidgetTester tester) async {
    // Dies ist ein Screenshot-Lauf, kein Korrektheitstest. Flutter-eigene
    // Debug-Warnungen (z.B. "ListTile is wrapped in a DecoratedBox...")
    // wuerden den Lauf sonst am Ende scheitern lassen, obwohl alle Bilder
    // bereits erzeugt wurden. Deshalb nur protokollieren.
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('IGNORIERT: '
          '${details.exceptionAsString().split("\n").first}');
    };

    app.main();
    await ruhe(tester, sekunden: 8, schritte: 32);
    protokolliereScreen(tester, 'Start');

    // ---- 1) Onboarding ueberspringen -------------------------------
    // Die App zeigt beim ersten Start vier Onboarding-Seiten.
    if (!await tippeText(tester, 'Überspringen', warteSekunden: 3)) {
      // Kein Skip-Knopf? Dann bis zu sechsmal "Weiter"/"Los geht's" tippen.
      for (var i = 0; i < 6; i++) {
        final weiter = await tippeText(tester, 'Weiter') ||
            await tippeText(tester, "Los geht's") ||
            await tippeText(tester, 'Starten');
        if (!weiter) break;
      }
    }
    await ruhe(tester, sekunden: 4, schritte: 16);
    protokolliereScreen(tester, 'nach Onboarding');

    // ---- 2) Login ---------------------------------------------------
    var felder = find.byType(TextFormField);
    if (felder.evaluate().length < 2) {
      // Manche Apps zeigen erst eine Auswahl "Anmelden / Registrieren".
      await tippeText(tester, 'Anmelden', warteSekunden: 3);
      await tippeText(tester, 'Login', warteSekunden: 3);
      felder = find.byType(TextFormField);
    }

    if (felder.evaluate().length >= 2) {
      if (kEmail.isEmpty || kPassword.isEmpty) {
        debugPrint('WARNUNG: SHOT_EMAIL/SHOT_PASSWORD fehlen — Login uebersprungen.');
      } else {
        await tester.enterText(felder.at(0), kEmail);
        await ruhe(tester, sekunden: 1);
        await tester.enterText(felder.at(1), kPassword);
        await ruhe(tester, sekunden: 1);

        // Login-Knopf: erst per Beschriftung, sonst der erste ElevatedButton.
        final getippt = await tippeText(tester, 'Anmelden', warteSekunden: 1) ||
            await tippeText(tester, 'Einloggen', warteSekunden: 1) ||
            await tippeText(tester, 'Login', warteSekunden: 1);
        if (!getippt) {
          final knopf = find.byType(ElevatedButton);
          if (knopf.evaluate().isNotEmpty) {
            await tester.tap(knopf.first, warnIfMissed: false);
            debugPrint('Login-Knopf per ElevatedButton getippt');
          }
        }
        // Supabase-Login plus Startdaten laden
        await ruhe(tester, sekunden: 15, schritte: 60);
      }
    } else {
      debugPrint('Keine Login-Felder gefunden — vermutlich bereits angemeldet.');
    }
    protokolliereScreen(tester, 'nach Login');

    // ---- 3) Aufnahmen ------------------------------------------------
    // Die ersten zwei Bilder erscheinen in der App-Store-Suchliste, ohne
    // dass jemand die Produktseite oeffnet — dort das Staerkste zeigen.
    await schliesseDialoge(tester);
    await schuss(tester, '01_lernen');

    // --- Pruefungsbereich, der Kern des Produkts ---------------------
    if (await tippeText(tester, 'Prüfen', warteSekunden: 5)) {
      await schuss(tester, '02_pruefen');

      // In die IHK-Pruefungsliste hinein
      var drin = await tippeText(tester, 'Anwendungsentwicklung', warteSekunden: 6);
      if (!drin) {
        drin = await tippeText(tester, 'Systemintegration', warteSekunden: 6);
      }
      if (drin) {
        await schuss(tester, '03_pruefungsliste');

        // Erste Pruefung oeffnen -> Detailansicht
        final karten = find.byType(Card);
        final tiles = find.byType(ListTile);
        final ziel = karten.evaluate().isNotEmpty
            ? karten
            : (tiles.evaluate().isNotEmpty ? tiles : null);
        if (ziel != null) {
          try {
            await tester.tap(ziel.first, warnIfMissed: false);
            await ruhe(tester, sekunden: 6, schritte: 24);
            tester.takeException();
            await schuss(tester, '04_pruefung_detail');
            await zurueck(tester, 'Prüfen');
          } catch (e) {
            debugPrint('Pruefungsdetail uebersprungen: $e');
          }
        }
        await zurueck(tester, 'Prüfen');
      }

      // Zertifikate liegen weiter unten auf derselben Seite
      await tippeText(tester, 'Prüfen', warteSekunden: 3);
      await scrolle(tester, 900);
      await schuss(tester, '05_zertifikate');
    }

    if (await tippeText(tester, 'Arena', warteSekunden: 5)) {
      await schuss(tester, '06_arena');
    }

    // --- Lernbereich -------------------------------------------------
    // "Module" bewusst NICHT: dieser Screen liest den Fortschritt aus
    // SharedPreferences (app_cache_service.dart, 'fortschritt_modul_<id>')
    // und zeigt auf einem frischen Simulator immer 0 %. Levels und Kurse
    // lesen dagegen aus der Datenbank und zeigen echte Werte.
    for (final ziel in const [
      ('Levels', '07_levels'),
      ('SQL von Grund auf', '08_kurs'),
      ('Anschlüsse', '09_anschluesse'),
    ]) {
      await tippeText(tester, 'Lernen', warteSekunden: 3);
      await schliesseDialoge(tester);
      if (await tippeText(tester, ziel.$1, warteSekunden: 6)) {
        await schuss(tester, ziel.$2);
        await zurueck(tester, 'Lernen');
      } else {
        debugPrint('"${ziel.$1}" nicht gefunden — uebersprungen.');
      }
    }

    // Profil bewusst NICHT aufnehmen: der Screen zeigt E-Mail-Adresse und
    // Klarnamen des angemeldeten Kontos. Solche Daten gehoeren nicht in
    // oeffentliche App-Store-Bilder.

    tester.takeException();
    debugPrint('=== Screenshot-Lauf abgeschlossen ===');
  });
}
