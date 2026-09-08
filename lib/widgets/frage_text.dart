// lib/widgets/frage_text.dart
//
// Fragetext mit Code-Darstellung. Autoren markieren Code im Fragetext
// wie in Markdown:
//   * Block:   ```  mehrere Zeilen  ```   -> eigener Kasten in Monospace
//   * Inline:  `int x = 5;`               -> Monospace im Fliesstext
// Alles andere wird im uebergebenen Stil (meist Instrument Serif) gesetzt.
// Texte ohne Markierung sehen exakt aus wie vorher.
//
// Genutzt fuer die Frage in Modul-, Level-, Arena- und Wiederholungs-
// Screens sowie fuer Antworttexte (Inline-Code, z. B. SQL-Anweisungen).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

class FrageText extends StatelessWidget {
  final String text;
  final TextStyle style;

  /// Schriftgroesse des Codes; Standard etwas kleiner als der Fliesstext.
  final double? codeSize;
  final TextAlign textAlign;

  const FrageText(
    this.text, {
    super.key,
    required this.style,
    this.codeSize,
    this.textAlign = TextAlign.start,
  });

  static bool hatCode(String s) => s.contains('`');

  @override
  Widget build(BuildContext context) {
    if (!hatCode(text)) {
      return Text(text, style: style, textAlign: textAlign);
    }

    final isDark = context.watch<ThemeProvider>().isDark;
    final codeBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final codeBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final codeColor = style.color ?? (isDark ? AppColors.darkText : AppColors.lightText);
    final groesse = codeSize ?? ((style.fontSize ?? 16) * 0.6).clamp(12.0, 16.0);
    final codeStyle = AppTextStyles.mono(
      size: groesse,
      color: codeColor,
      letterSpacing: 0,
    );

    final children = <Widget>[];
    // Bloecke zuerst: Text ``` code ``` Text ...
    final teile = text.split('```');
    for (var i = 0; i < teile.length; i++) {
      final teil = teile[i];
      final istCode = i.isOdd;
      if (istCode) {
        final code = teil.replaceAll('\r\n', '\n').trim();
        if (code.isEmpty) continue;
        children.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: codeBg,
              border: Border.all(color: codeBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(code, style: codeStyle.copyWith(height: 1.55)),
            ),
          ),
        );
      } else {
        final t = teil.trim();
        if (t.isEmpty) continue;
        children.add(_inline(t, codeStyle));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  /// Fliesstext mit `inline code`.
  Widget _inline(String t, TextStyle codeStyle) {
    if (!t.contains('`')) {
      return Text(t, style: style, textAlign: textAlign);
    }
    final spans = <InlineSpan>[];
    final teile = t.split('`');
    for (var i = 0; i < teile.length; i++) {
      if (teile[i].isEmpty) continue;
      spans.add(
        TextSpan(
          text: teile[i],
          style: i.isOdd ? codeStyle : style,
        ),
      );
    }
    return Text.rich(TextSpan(children: spans), textAlign: textAlign);
  }
}
