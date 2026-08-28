// Erzeugt die App-Store-Screenshots auf einem iOS-Simulator.
//
// Wird NICHT als normaler Test ausgefuehrt, sondern ueber:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshots_test.dart \
//     -d <simulator-id> \
//     --dart-define=SHOT_EMAIL=... --dart-define=SHOT_PASSWORD=...
//
// Die Bilder landen in screenshots/ und werden von Codemagic als
// Artefakt bereitgestellt.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ihk_app/main.dart' as app;

/// Zugangsdaten kommen aus --dart-define, damit nichts im Repo landet.
const String kEmail = String.fromEnvironment('SHOT_EMAIL');
const String kPassword = String.fromEnvironment('SHOT_PASSWORD');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Wartet, bis die UI zur Ruhe kommt — aber ohne pumpAndSettle, das bei
  /// Dauer-Animationen (Confetti, Ladespinner) haengen bleibt.
  Future<void> ruhe(WidgetTester tester,
      {int sekunden = 3, int schritte = 12}) async {
    for (var i = 0; i < schritte; i++) {
      await tester.pump(Duration(milliseconds: sekunden * 1000 ~/ schritte));
    }
  }

  Future<void> schuss(WidgetTester tester, String name) async {
    await ruhe(tester, sekunden: 1);
    await binding.takeScreenshot(name);
    debugPrint('Screenshot aufgenommen: $name');
  }

  /// Tippt auf einen Text, falls er da ist. Gibt zurueck, ob es geklappt hat —
  /// so bricht der Lauf nicht ab, wenn ein Screen anders heisst als erwartet.
  Future<bool> tippeAufText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    if (finder.evaluate().isEmpty) {
      debugPrint('Nicht gefunden, wird uebersprungen: "$text"');
      return false;
    }
    await tester.tap(finder.first, warnIfMissed: false);
    await ruhe(tester, sekunden: 2);
    return true;
  }

  testWidgets('App-Store-Screenshots', (WidgetTester tester) async {
    app.main();
    await ruhe(tester, sekunden: 6, schritte: 24);

    // 1 — Startbildschirm (Login oder direkt die App, falls Session besteht)
    await schuss(tester, '01_start');

    // Login, falls Eingabefelder sichtbar sind
    final felder = find.byType(TextFormField);
    if (felder.evaluate().length >= 2) {
      if (kEmail.isEmpty || kPassword.isEmpty) {
        debugPrint(
            'WARNUNG: SHOT_EMAIL/SHOT_PASSWORD nicht gesetzt — Login uebersprungen.');
      } else {
        await tester.enterText(felder.at(0), kEmail);
        await ruhe(tester, sekunden: 1);
        await tester.enterText(felder.at(1), kPassword);
        await ruhe(tester, sekunden: 1);

        final knopf = find.byType(ElevatedButton);
        if (knopf.evaluate().isNotEmpty) {
          await tester.tap(knopf.first, warnIfMissed: false);
        }
        // Supabase-Login plus Laden der Startdaten braucht einen Moment
        await ruhe(tester, sekunden: 12, schritte: 48);
      }
    }

    // 2 — Lernen (Standard-Tab nach dem Login)
    await schuss(tester, '02_lernen');

    // 3-5 — die restlichen Tabs aus nav_root.dart
    for (final tab in const [
      ('Prüfen', '03_pruefen'),
      ('Arena', '04_arena'),
      ('Profil', '05_profil'),
    ]) {
      if (await tippeAufText(tester, tab.$1)) {
        await schuss(tester, tab.$2);
      }
    }

    // 6 — zurueck auf Lernen und in ein Thema hinein, damit auch ein
    //     Inhaltsbildschirm dabei ist
    if (await tippeAufText(tester, 'Lernen')) {
      await ruhe(tester, sekunden: 2);
      final karten = find.byType(Card);
      if (karten.evaluate().isNotEmpty) {
        await tester.tap(karten.first, warnIfMissed: false);
        await ruhe(tester, sekunden: 4, schritte: 16);
        await schuss(tester, '06_inhalt');
      }
    }
  });
}
