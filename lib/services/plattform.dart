// lib/services/plattform.dart
//
// Name der Plattform, auf der die App laeuft - fuer profiles.plattform und
// die Signup-Metadaten (Migration 20260920030000). Damit laesst sich in der
// DB auswerten, wie viele Nutzer ueber Google Play, den App Store oder das
// Web kommen. Werte: android, ios, macos, windows, linux, web.

import 'package:flutter/foundation.dart';

String get plattformName {
  if (kIsWeb) return 'web';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'android';
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.macOS:
      return 'macos';
    case TargetPlatform.windows:
      return 'windows';
    case TargetPlatform.linux:
      return 'linux';
    case TargetPlatform.fuchsia:
      return 'fuchsia';
  }
}
