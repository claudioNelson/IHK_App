import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'legal_texts.dart';

/// Die drei rechtlichen Pflichtdokumente.
enum LegalDoc { impressum, datenschutz, agb }

/// Zeigt ein eingebettetes Rechtsdokument (Markdown) im Dark-Design der App.
/// Aufruf z. B.:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => const LegalDocumentScreen(doc: LegalDoc.impressum)));
class LegalDocumentScreen extends StatelessWidget {
  final LegalDoc doc;

  const LegalDocumentScreen({super.key, required this.doc});

  String get _appBarTitle {
    switch (doc) {
      case LegalDoc.impressum:
        return 'Impressum';
      case LegalDoc.datenschutz:
        return 'Datenschutz';
      case LegalDoc.agb:
        return 'AGB';
    }
  }

  String get _markdown {
    switch (doc) {
      case LegalDoc.impressum:
        return kImpressumMarkdown;
      case LegalDoc.datenschutz:
        return kDatenschutzMarkdown;
      case LegalDoc.agb:
        return kAgbMarkdown;
    }
  }

  Future<void> _openLink(String? href) async {
    if (href == null) return;
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── APPBAR ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      _appBarTitle.toUpperCase(),
                      style: AppTextStyles.monoLabel(textMid),
                    ),
                  ),
                ],
              ),
            ),
            // ─── INHALT ────────────────────────────────
            Expanded(
              child: Markdown(
                data: _markdown,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                onTapLink: (linkText, href, title) => _openLink(href),
                styleSheet: _styleSheet(text, textMid),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MarkdownStyleSheet _styleSheet(Color text, Color textMid) {
    return MarkdownStyleSheet(
      h1: AppTextStyles.instrumentSerif(
        size: 32,
        color: text,
        letterSpacing: -1.2,
      ),
      h1Padding: const EdgeInsets.only(bottom: 4),
      h2: AppTextStyles.instrumentSerif(
        size: 22,
        color: text,
        letterSpacing: -0.6,
      ),
      h2Padding: const EdgeInsets.only(top: 18, bottom: 4),
      h3: AppTextStyles.labelLarge(text),
      h3Padding: const EdgeInsets.only(top: 10, bottom: 2),
      p: AppTextStyles.bodyMedium(textMid),
      pPadding: const EdgeInsets.only(bottom: 4),
      strong: AppTextStyles.bodyMedium(
        text,
      ).copyWith(fontWeight: FontWeight.w700),
      em: AppTextStyles.bodyMedium(
        textMid,
      ).copyWith(fontStyle: FontStyle.italic),
      a: AppTextStyles.bodyMedium(AppColors.accent).copyWith(
        decoration: TextDecoration.underline,
        decorationColor: AppColors.accent,
      ),
      listBullet: AppTextStyles.bodyMedium(textMid),
      listIndent: 18,
      blockSpacing: 10,
    );
  }
}
