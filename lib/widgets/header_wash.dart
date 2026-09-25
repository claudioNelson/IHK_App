// lib/widgets/header_wash.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Hellmodus: weicher Indigo-Verlauf hinter dem Kopfbereich eines Screens.
/// Der Verlauf hat eine FESTE Hoehe (240 px) und haengt nicht mehr an der
/// Hoehe des Kindes; vorher lief er im Hub ueber 480 px und in Pruefen nur
/// ueber 180 px, was wie ein Farbstich statt wie ein Kopf wirkte.
/// Im Dunkelmodus wird das Kind unveraendert durchgereicht.
class HeaderWash extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const HeaderWash({super.key, required this.isDark, required this.child});

  static const double hoehe = 240;

  @override
  Widget build(BuildContext context) {
    if (isDark) return child;
    return Stack(
      // passthrough: das Kind bekommt dieselben Masse wie ohne Stack,
      // sonst schrumpfen zentrierte Spalten (Profil-Kopf) und rutschen links.
      fit: StackFit.passthrough,
      children: [
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: hoehe,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.lightHeaderWash, Color(0x007C6DFF)],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
