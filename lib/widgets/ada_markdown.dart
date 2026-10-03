// lib/widgets/ada_markdown.dart
//
// Zeigt Antworten von Ada als Markdown statt als Rohtext.
//
// Ada (Claude Haiku) antwortet fast immer mit **fett**, Listen, `Code`
// und manchmal Tabellen. Vorher zeigten alle Chatfenster das als Rohtext
// mit Sternchen und Strichen an (Befund Test 03.10.2026). Ein gemeinsames
// Widget für Kurs-Ada, Level-Ada und Tutor-Chat, damit alle gleich aussehen.
// Nachrichten des Nutzers bleiben normaler Text.

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../theme/app_text_styles.dart';

class AdaMarkdown extends StatelessWidget {
  final String text;

  /// Schriftfarbe für den Fließtext.
  final Color farbe;

  /// Gedämpfte Farbe für Aufzählungszeichen und Zitate.
  final Color gedimmt;

  /// Farbe für Linien, Tabellenrahmen und Codeblöcke.
  final Color rahmen;

  final double schrift;

  const AdaMarkdown(
    this.text, {
    super.key,
    required this.farbe,
    required this.gedimmt,
    required this.rahmen,
    this.schrift = 14,
  });

  @override
  Widget build(BuildContext context) {
    final absatz = AppTextStyles.interTight(
      size: schrift,
      weight: FontWeight.w400,
      color: farbe,
      height: 1.5,
    );
    final fett = absatz.copyWith(fontWeight: FontWeight.w700);

    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: absatz,
        a: absatz.copyWith(decoration: TextDecoration.underline),
        strong: const TextStyle(fontWeight: FontWeight.w700),
        em: const TextStyle(fontStyle: FontStyle.italic),
        h1: fett.copyWith(fontSize: schrift + 3),
        h2: fett.copyWith(fontSize: schrift + 2),
        h3: fett.copyWith(fontSize: schrift + 1),
        h4: fett,
        h5: fett,
        h6: fett,
        h1Padding: const EdgeInsets.only(top: 6),
        h2Padding: const EdgeInsets.only(top: 6),
        h3Padding: const EdgeInsets.only(top: 4),
        blockSpacing: 8,
        listBullet: absatz.copyWith(color: gedimmt),
        code: AppTextStyles.mono(
          size: schrift - 1,
          color: farbe,
          letterSpacing: 0,
        ),
        codeblockPadding: const EdgeInsets.all(10),
        codeblockDecoration: BoxDecoration(
          color: rahmen.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: rahmen),
        ),
        blockquote: absatz.copyWith(color: gedimmt),
        blockquotePadding: const EdgeInsets.only(left: 10),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: rahmen, width: 3)),
        ),
        tableHead: fett.copyWith(fontSize: schrift - 1),
        tableBody: absatz.copyWith(fontSize: schrift - 1),
        tableBorder: TableBorder.all(color: rahmen),
        tableCellsPadding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: rahmen)),
        ),
      ),
    );
  }
}
