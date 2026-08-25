// lib/theme/modul_stil.dart
//
// Gemeinsamer Look fuer die Lernbereiche: Icon + Akzentfarbe je Modul
// (erkannt am Namen) und der kleine Fortschrittsring.
// Genutzt von modul_liste_screen und themen_liste_screen.

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Icon und Akzentfarbe je Modul. Gibt den Listen Gesichter statt
/// sechzehn identischer Kacheln. Neue Module bekommen automatisch
/// den Standard-Look.
({IconData icon, Color farbe}) modulStil(String name) {
  final n = name.toLowerCase();
  if (n.contains('netzwerk')) {
    return (icon: Icons.hub_outlined, farbe: AppColors.accentCyan);
  }
  if (n.contains('sicherheit') || n.contains('security')) {
    return (icon: Icons.shield_outlined, farbe: AppColors.error);
  }
  if (n.contains('datenbank') || n.contains('sql')) {
    return (icon: Icons.storage_rounded, farbe: AppColors.info);
  }
  if (n.contains('algorithm') || n.contains('datenstruktur')) {
    return (icon: Icons.account_tree_outlined, farbe: AppColors.warning);
  }
  if (n.contains('programmier')) {
    return (icon: Icons.code_rounded, farbe: AppColors.accent);
  }
  if (n.contains('linux') || n.contains('betriebssystem')) {
    return (icon: Icons.terminal_rounded, farbe: AppColors.success);
  }
  if (n.contains('hardware') || n.contains('it-grundlagen')) {
    return (icon: Icons.memory_rounded, farbe: AppColors.azureBlue);
  }
  if (n.contains('web')) {
    return (icon: Icons.public_rounded, farbe: AppColors.gcpBlue);
  }
  if (n.contains('cloud') || n.contains('devops')) {
    return (icon: Icons.cloud_outlined, farbe: AppColors.accentCyan);
  }
  if (n.contains('projekt')) {
    return (icon: Icons.assignment_outlined, farbe: AppColors.sapBlue);
  }
  if (n.contains('wiso') || n.contains('wirtschaft') || n.contains('recht')) {
    return (icon: Icons.gavel_rounded, farbe: AppColors.awsOrange);
  }
  if (n.contains('mathe') || n.contains('zahlensystem')) {
    return (icon: Icons.calculate_outlined, farbe: AppColors.warning);
  }
  return (icon: Icons.school_outlined, farbe: AppColors.accent);
}

/// Kleiner Kreisring mit Prozentzahl, bei Abschluss ein Haken.
class FortschrittsRing extends StatelessWidget {
  final double wert;
  final Color farbe;
  final Color hintergrund;
  final bool fertig;
  final Color textFarbe;
  final bool klein;

  const FortschrittsRing({
    super.key,
    required this.wert,
    required this.farbe,
    required this.hintergrund,
    required this.fertig,
    required this.textFarbe,
    this.klein = false,
  });

  @override
  Widget build(BuildContext context) {
    final groesse = klein ? 34.0 : 42.0;
    return SizedBox(
      width: groesse,
      height: groesse,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: wert.clamp(0.0, 1.0),
            strokeWidth: klein ? 3 : 3.5,
            backgroundColor: hintergrund,
            valueColor: AlwaysStoppedAnimation(farbe),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: fertig
                ? Icon(Icons.check_rounded, color: farbe, size: klein ? 15 : 18)
                : Text(
                    '${(wert * 100).round()}',
                    style: AppTextStyles.mono(
                      size: klein ? 9 : 11,
                      color: wert > 0 ? farbe : textFarbe,
                      weight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
