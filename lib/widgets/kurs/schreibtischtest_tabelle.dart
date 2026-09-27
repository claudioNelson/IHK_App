// lib/widgets/kurs/schreibtischtest_tabelle.dart
//
// Zeigt einen Schreibtischtest (Wertetabelle, englisch Trace): jede Zeile
// ist ein Zeitpunkt im Ablauf, jede Spalte eine Variable. Gegenstück zu
// TraceTabelle im Web-Kurs (web/app/struktogramm-kurs/_components).
//
// Für Einsteiger wichtig: Werte, die sich gegenüber der Zeile darüber
// geändert haben, sind hervorgehoben. So sieht man sofort, was ein
// Schritt bewirkt hat, ohne jede Zahl vergleichen zu müssen.
//
// Farben wie StruktogrammAnsicht, damit beides zusammen wie aus einem
// Guss wirkt. Keine Interaktion, keine eigenen Zustände.

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'struktogramm_ansicht.dart' show SeitlichSchiebbar;

class SchreibtischtestTabelle extends StatelessWidget {
  /// Spaltenköpfe, z. B. ["Schritt", "i", "summe", "Ausgabe"].
  /// Die erste Spalte beschriftet die Zeile und wird nie hervorgehoben.
  final List<String> spalten;

  /// Werte je Zeile als Text. Leerer Text heißt: noch kein Wert.
  final List<List<String>> zeilen;

  /// Bildunterschrift unter der Tabelle.
  final String? unterschrift;

  /// Geänderte Werte hervorheben.
  final bool aenderungenMarkieren;

  const SchreibtischtestTabelle({
    super.key,
    required this.spalten,
    required this.zeilen,
    this.unterschrift,
    this.aenderungenMarkieren = true,
  });

  /// Hat sich der Wert in Zeile [z], Spalte [s] gegenüber der Zeile
  /// darüber geändert? Leere Zellen gelten nie als Änderung.
  bool _geaendert(int z, int s) {
    if (!aenderungenMarkieren || s == 0) return false;
    final wert = _wert(z, s);
    if (wert.isEmpty) return false;
    if (z == 0) return true;
    return wert != _wert(z - 1, s);
  }

  String _wert(int z, int s) =>
      s < zeilen[z].length ? zeilen[z][s].trim() : '';

  @override
  Widget build(BuildContext context) {
    final dunkel = Theme.of(context).brightness == Brightness.dark;
    final linie = dunkel ? AppColors.darkTextDim : AppColors.lightTextDim;
    final flaeche = dunkel ? AppColors.darkSurface : AppColors.lightSurface;
    final kopfFlaeche = dunkel ? AppColors.darkBgMuted : AppColors.lightBgMuted;
    final text = dunkel ? AppColors.darkText : AppColors.lightText;
    final textMid = dunkel ? AppColors.darkTextMid : AppColors.lightTextMid;
    final akzent = dunkel ? AppColors.accent : AppColors.lightAccentInk;
    final markiert = AppColors.accent.withValues(alpha: dunkel ? 0.18 : 0.12);

    final kopfStil = AppTextStyles.interTight(
      size: 12.5,
      weight: FontWeight.w700,
      color: textMid,
    );
    final beschriftung = AppTextStyles.interTight(
      size: 13,
      weight: FontWeight.w500,
      color: textMid,
    );
    final wertStil = AppTextStyles.mono(
      size: 13.5,
      weight: FontWeight.w400,
      color: text,
      letterSpacing: 0,
    );

    Widget zelle(Widget kind, {Color? farbe}) => Container(
          color: farbe,
          constraints: const BoxConstraints(minHeight: 38, minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          alignment: Alignment.centerLeft,
          child: kind,
        );

    final tabelle = Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: linie, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: kopfFlaeche),
          children: [
            for (final kopf in spalten) zelle(Text(kopf, style: kopfStil)),
          ],
        ),
        for (var z = 0; z < zeilen.length; z++)
          TableRow(
            decoration: BoxDecoration(color: flaeche),
            children: [
              for (var s = 0; s < spalten.length; s++)
                if (s == 0)
                  zelle(Text(_wert(z, s), style: beschriftung))
                else if (_geaendert(z, s))
                  zelle(
                    Text(
                      _wert(z, s),
                      style: wertStil.copyWith(
                        color: akzent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    farbe: markiert,
                  )
                else
                  zelle(Text(_wert(z, s), style: wertStil)),
            ],
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'Schreibtischtest mit den Spalten ${spalten.join(', ')}',
            child: SeitlichSchiebbar(child: tabelle),
          ),
          if (unterschrift != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                unterschrift!,
                style: AppTextStyles.interTight(
                  size: 13.5,
                  color: textMid,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
