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

  Future<void> schuss(WidgetTester tester, String name) async {
    await ruhe(tester, sekunden: 1);
    protokolliereScreen(tester, name);
    await binding.takeScreenshot(name);
    debugPrint('>>> Screenshot: $name');
  }

  /// Tippt auf einen Text, wenn er existiert.
  Future<bool> tippeText(WidgetTester tester, String text,
      {int warteSekunden = 2}) async {
    final f = find.text(text);
    if (f.evaluate().isEmpty) return false;
    await tester.tap(f.first, warnIfMissed: false);
    await ruhe(tester, sekunden: warteSekunden);
    debugPrint('Getippt: "$text"');
    return true;
  }

  testWidgets('App-Store-Screenshots', (WidgetTester tester) async {
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

    // ---- 3) Die vier Tabs -------------------------------------------
    await schuss(tester, '01_lernen');

    for (final tab in const [
      ('Prüfen', '02_pruefen'),
      ('Arena', '03_arena'),
      ('Profil', '04_profil'),
    ]) {
      if (await tippeText(tester, tab.$1, warteSekunden: 4)) {
        await schuss(tester, tab.$2);
      } else {
        debugPrint('Tab "${tab.$1}" nicht gefunden — uebersprungen.');
      }
    }

    // ---- 4) Ein Inhaltsbildschirm -----------------------------------
    if (await tippeText(tester, 'Lernen', warteSekunden: 3)) {
      final karten = find.byType(Card);
      final tiles = find.byType(ListTile);
      final ziel = karten.evaluate().isNotEmpty
          ? karten
          : (tiles.evaluate().isNotEmpty ? tiles : null);
      if (ziel != null) {
        await tester.tap(ziel.first, warnIfMissed: false);
        await ruhe(tester, sekunden: 5, schritte: 20);
        await schuss(tester, '05_inhalt');
      }
    }
  });
}
