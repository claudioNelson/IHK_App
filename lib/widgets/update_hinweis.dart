// lib/widgets/update_hinweis.dart
//
// Fenster fuer den Hinweis auf eine neue App-Version (ab 1.8.0).
// Den Stand liefert UpdateService().pruefen().
//
// pflicht:   nicht schliessbares Fenster, „Jetzt aktualisieren“ oeffnet auf
//            Android das Update-Fenster von Google Play (sofort), sonst den
//            Store. Das Fenster bleibt offen, bis die neue Version laeuft.
// empfohlen: Android: Google Play laedt im Hintergrund (flexibel), danach
//            eine Leiste „Neu starten“. Meldet Play kein Update (z. B. weil
//            die gestaffelte Einfuehrung den Nutzer noch nicht erreicht
//            hat), erscheint nichts. Ist Play nicht nutzbar (App nicht aus
//            Google Play installiert), das eigene Fenster mit Store-Link.
//            iOS: eigenes Fenster mit Link zum App Store.
//            Hoechstens einmal je Version und 7 Tage (UpdateService).

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/update_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Zeigt je nach Stand das passende Fenster.
/// Liefert true, wenn etwas erschienen ist (dann in dieser Sitzung keine
/// Bewertungsabfrage mehr).
Future<bool> updateHinweisZeigen(BuildContext context, UpdateStand stand) async {
  switch (stand.stufe) {
    case UpdateStufe.keins:
      return false;

    case UpdateStufe.pflicht:
      await _pflichtFenster(context, stand);
      return true;

    case UpdateStufe.empfohlen:
      if (!await UpdateService().hinweisFaellig(stand.aktuell)) return false;
      await UpdateService().hinweisGezeigt(stand.aktuell);
      if (!context.mounted) return false;

      if (!kDebugMode && Platform.isAndroid) {
        final play = await _playFlexibel(context);
        if (play != null) return play;
      }

      if (!context.mounted) return false;
      await _empfohlenFenster(context, stand);
      return true;
  }
}

/// Google Play, flexibles Update.
/// true: Play hat sein Fenster gezeigt. false: Play meldet kein Update.
/// null: Play ist nicht nutzbar, eigenes Fenster zeigen.
Future<bool?> _playFlexibel(BuildContext context) async {
  // Vor dem ersten await holen, danach ist der context nicht mehr sicher.
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    final info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability != UpdateAvailability.updateAvailable) {
      return false;
    }
    if (!info.flexibleUpdateAllowed) return null;

    final ergebnis = await InAppUpdate.startFlexibleUpdate();
    if (ergebnis == AppUpdateResult.success) {
      messenger?.showSnackBar(
        SnackBar(
          content: const Text('Die neue Version ist geladen.'),
          duration: const Duration(hours: 1),
          action: SnackBarAction(
            label: 'Neu starten',
            onPressed: () => InAppUpdate.completeFlexibleUpdate(),
          ),
        ),
      );
    }
    return true;
  } catch (e) {
    debugPrint('🔄 Google-Play-Update nicht nutzbar: $e');
    return null;
  }
}

/// Oeffnet das Update: auf Android zuerst das Sofort-Fenster von Google
/// Play, sonst (und auf iOS) die Store-Seite.
Future<void> _aktualisieren(UpdateStand stand) async {
  if (!kDebugMode && Platform.isAndroid) {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (e) {
      debugPrint('🔄 Google-Play-Sofortupdate nicht nutzbar: $e');
    }
  }
  try {
    await launchUrl(
      Uri.parse(stand.storeUrl),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('🔄 Store-Link nicht geoeffnet: $e');
  }
}

({Color surface, Color text, Color textMid}) _farben(BuildContext context) {
  final dunkel = Theme.of(context).brightness == Brightness.dark;
  return (
    surface: dunkel ? AppColors.darkSurface : AppColors.lightSurface,
    text: dunkel ? AppColors.darkText : AppColors.lightText,
    textMid: dunkel ? AppColors.darkTextMid : AppColors.lightTextMid,
  );
}

Widget _inhalt(
  ({Color surface, Color text, Color textMid}) f,
  String satz,
  String? hinweis,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(satz, style: AppTextStyles.bodyMedium(f.text)),
      if (hinweis != null && hinweis.trim().isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(hinweis, style: AppTextStyles.bodyMedium(f.textMid)),
      ],
    ],
  );
}

ButtonStyle get _hauptKnopf => ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentFill,
      foregroundColor: Colors.white,
    );

Future<void> _empfohlenFenster(BuildContext context, UpdateStand stand) {
  final f = _farben(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: f.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Neue Version verfügbar', style: AppTextStyles.h2(f.text)),
      content: _inhalt(
        f,
        'Lernarena ${stand.aktuell} ist da. Du hast noch ${stand.installiert}.',
        stand.hinweis,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Später'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            _aktualisieren(stand);
          },
          style: _hauptKnopf,
          child: const Text('Aktualisieren'),
        ),
      ],
    ),
  );
}

Future<void> _pflichtFenster(BuildContext context, UpdateStand stand) {
  final f = _farben(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: f.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Bitte aktualisieren', style: AppTextStyles.h2(f.text)),
        content: _inhalt(
          f,
          'Diese Version von Lernarena wird nicht mehr unterstützt. '
          'Mit der neuen Version ${stand.aktuell} geht es sofort weiter.',
          stand.hinweis,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _aktualisieren(stand),
            style: _hauptKnopf,
            child: const Text('Jetzt aktualisieren'),
          ),
        ],
      ),
    ),
  );
}
