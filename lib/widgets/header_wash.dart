// lib/widgets/header_wash.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Hellmodus (Variante D): weicher Indigo-Verlauf hinter dem Kopfbereich
/// eines Screens, laeuft nach unten in den Hintergrund aus. Im Dunkelmodus
/// wird das Kind unveraendert durchgereicht (dort tragen die Glows).
class HeaderWash extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const HeaderWash({super.key, required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    if (isDark) return child;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.lightHeaderWash, Color(0x007C6DFF)],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
