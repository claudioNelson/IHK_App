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
    // Erlaubte Links:
    // - https://lernarena.app/... (App Links - für später)
    // - app.lernarena://...        (Custom Scheme - aktuell)
    final isHttpsLink = uri.scheme == 'https' && uri.host == 'lernarena.app';
    final isCustomScheme = uri.scheme == 'app.lernarena';

    if (!isHttpsLink && !isCustomScheme) {
      print('⚠️ Fremder Link ignoriert: $uri');
      return;
    }

    // Token aus URL extrahieren
    final tokenHash = uri.queryParameters['token_hash'];
    final type = uri.queryParameters['type'];

    if (tokenHash == null || type == null) {
      print('⚠️ Kein token_hash oder type in URL gefunden');
      return;
    }

    print('🔑 Verifiziere Token (type: $type)');

    try {
      // OTP-Token verifizieren → erstellt Session automatisch
      await Supabase.instance.client.auth.verifyOTP(
        token: tokenHash,
        type: _parseOtpType(type),
      );
      print('✅ Session erfolgreich erstellt - User ist eingeloggt!');
    } catch (e) {
      print('❌ Verifizierung fehlgeschlagen: $e');
    }
  }

  OtpType _parseOtpType(String type) {
    switch (type) {
      case 'signup':
        return OtpType.signup;
      case 'recovery':
        return OtpType.recovery;
      case 'email_change':
        return OtpType.emailChange;
      case 'invite':
        return OtpType.invite;
      case 'magiclink':
        return OtpType.magiclink;
      default:
        return OtpType.signup;
    }
  }

  void dispose() {
    _sub?.cancel();
    _initialized = false;
  }
}
