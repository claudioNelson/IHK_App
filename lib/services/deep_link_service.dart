import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Empfängt eingehende Deep Links (z.B. aus Bestätigungs-Emails)
/// und übergibt sie an Supabase, damit eine Session erstellt wird.
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  bool _initialized = false;

  /// Beim App-Start aufrufen (genau einmal).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // 1. Falls die App durch einen Link erst gestartet wurde:
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        print('🔗 App durch Link gestartet: $initialUri');
        await _handleUri(initialUri);
      }
    } catch (e) {
      print('❌ Fehler beim Lesen des Initial-Links: $e');
    }

    // 2. Auf neue Links lauschen, während die App läuft:
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        print('🔗 Neuer Link empfangen: $uri');
        _handleUri(uri);
      },
      onError: (err) {
        print('❌ Link-Stream Fehler: $err');
      },
    );
  }

  Future<void> _handleUri(Uri uri) async {
    // Nur Links zu unserer Domain bearbeiten
    if (uri.host != 'lernarena.app') {
      print('⚠️ Fremde Domain ignoriert: ${uri.host}');
      return;
    }

    // Supabase Auth-Links enthalten Token im Query oder im Fragment.
    // Wir geben einfach den ganzen Link an Supabase weiter — die SDK parst selbst.
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
      print('✅ Session aus Link erstellt');
    } catch (e) {
      print('❌ Session aus Link konnte nicht erstellt werden: $e');
    }
  }

  void dispose() {
    _sub?.cancel();
    _initialized = false;
  }
}
