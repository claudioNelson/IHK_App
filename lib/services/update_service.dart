// lib/services/update_service.dart
//
// Hinweis auf eine neue App-Version (ab 1.8.0, Plan in
// claude/update-hinweis-plan.md).
//
// Die Tabelle public.app_versionen hat je Plattform eine Zeile mit
// aktuelle_version und mindest_version. Verglichen wird NUR die
// Versionsnummer (1.8.0), nie die Build-Nummer, weil Codemagic die
// iOS-Build-Nummer selbst vergibt.
//
//   installiert < mindest_version  -> pflicht   (nur fuer Notfaelle)
//   installiert < aktuelle_version -> empfohlen
//   sonst                          -> keins
//
// Fehler (kein Netz, Tabelle fehlt, Timeout) werden still ignoriert:
// dann erscheint einfach kein Hinweis.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Testschalter fuer den Debug-Build. Im Store-Build (Release) wirkungslos.
///
/// aus:       im Debug-Build wird nichts geprueft und nichts angezeigt.
/// empfohlen: zeigt den Hinweis „Neue Version verfügbar“ mit Testwerten.
/// pflicht:   zeigt das nicht schliessbare Pflicht-Fenster mit Testwerten.
enum UpdateTest { aus, empfohlen, pflicht }

const UpdateTest updateHinweisTest = UpdateTest.aus;

enum UpdateStufe { keins, empfohlen, pflicht }

class UpdateStand {
  final UpdateStufe stufe;
  final String installiert;
  final String aktuell;
  final String? hinweis;
  final String storeUrl;

  const UpdateStand({
    required this.stufe,
    required this.installiert,
    required this.aktuell,
    required this.hinweis,
    required this.storeUrl,
  });
}

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  /// Nach so vielen Tagen erscheint der Hinweis zur selben Version erneut,
  /// falls der Nutzer „Später“ gewaehlt hat.
  static const int _erinnerungNachTagen = 7;
  static const String _keyPrefix = 'update_hinweis_';

  /// Liefert den Stand fuer diese Plattform oder null (Web, Windows,
  /// Debug ohne Testschalter, Fehler).
  Future<UpdateStand?> pruefen() async {
    try {
      if (kIsWeb) return null;
      final String plattform;
      if (Platform.isAndroid) {
        plattform = 'android';
      } else if (Platform.isIOS) {
        plattform = 'ios';
      } else {
        return null;
      }

      if (kDebugMode) {
        if (updateHinweisTest == UpdateTest.aus) return null;
        return UpdateStand(
          stufe: updateHinweisTest == UpdateTest.pflicht
              ? UpdateStufe.pflicht
              : UpdateStufe.empfohlen,
          installiert: '1.8.0',
          aktuell: '9.9.9',
          hinweis: 'Testhinweis: neue Kurse und kleine Verbesserungen.',
          storeUrl: plattform == 'android'
              ? 'https://play.google.com/store/apps/details?id=app.lernarena'
              : 'https://apps.apple.com/app/id6802045311',
        );
      }

      final info = await PackageInfo.fromPlatform();
      final installiert = info.version;

      final zeile = await Supabase.instance.client
          .from('app_versionen')
          .select('aktuelle_version, mindest_version, hinweis, store_url')
          .eq('plattform', plattform)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));
      if (zeile == null) return null;

      final aktuell = zeile['aktuelle_version'] as String;
      final mindest = zeile['mindest_version'] as String;

      final UpdateStufe stufe;
      if (vergleiche(installiert, mindest) < 0) {
        stufe = UpdateStufe.pflicht;
      } else if (vergleiche(installiert, aktuell) < 0) {
        stufe = UpdateStufe.empfohlen;
      } else {
        stufe = UpdateStufe.keins;
      }

      debugPrint('🔄 Update-Pruefung: $installiert, aktuell $aktuell, '
          'mindestens $mindest -> ${stufe.name}');

      return UpdateStand(
        stufe: stufe,
        installiert: installiert,
        aktuell: aktuell,
        hinweis: zeile['hinweis'] as String?,
        storeUrl: zeile['store_url'] as String,
      );
    } catch (e) {
      debugPrint('🔄 Update-Pruefung uebersprungen: $e');
      return null;
    }
  }

  /// Vergleicht zwei Versionsnummern teilweise numerisch.
  /// Ergebnis < 0: a ist aelter, 0: gleich, > 0: a ist neuer.
  /// Build-Nummer (+28) und Zusaetze (-beta) werden ignoriert,
  /// fehlende Teile zaehlen als 0 (1.8 == 1.8.0), 1.10.0 > 1.9.0.
  static int vergleiche(String a, String b) {
    List<int> teile(String v) => v
        .split('+')
        .first
        .split('-')
        .first
        .trim()
        .split('.')
        .map((t) => int.tryParse(t) ?? 0)
        .toList();
    final x = teile(a);
    final y = teile(b);
    final n = x.length > y.length ? x.length : y.length;
    for (var i = 0; i < n; i++) {
      final xi = i < x.length ? x[i] : 0;
      final yi = i < y.length ? y[i] : 0;
      if (xi != yi) return xi.compareTo(yi);
    }
    return 0;
  }

  /// Darf der Hinweis „Neue Version verfügbar“ fuer diese Version jetzt
  /// erscheinen? Nein, wenn er in den letzten 7 Tagen schon kam.
  Future<bool> hinweisFaellig(String version) async {
    if (kDebugMode && updateHinweisTest != UpdateTest.aus) return true;
    final prefs = await SharedPreferences.getInstance();
    final zuletztMs = prefs.getInt('$_keyPrefix$version');
    if (zuletztMs == null) return true;
    final zuletzt = DateTime.fromMillisecondsSinceEpoch(zuletztMs);
    return DateTime.now().difference(zuletzt).inDays >= _erinnerungNachTagen;
  }

  Future<void> hinweisGezeigt(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '$_keyPrefix$version',
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
