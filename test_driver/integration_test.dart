// Treiber fuer den Screenshot-Lauf.
// Nimmt die Bilder entgegen, die screenshots_test.dart per
// binding.takeScreenshot(name) erzeugt, und legt sie unter screenshots/ ab.

import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      final ordner = Directory('screenshots');
      if (!ordner.existsSync()) {
        ordner.createSync(recursive: true);
      }
      final datei = File('${ordner.path}/$name.png');
      datei.writeAsBytesSync(bytes);
      stdout.writeln('Gespeichert: ${datei.path} (${bytes.length} Bytes)');
      return true;
    },
  );
}
