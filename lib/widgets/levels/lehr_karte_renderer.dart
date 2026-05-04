// lib/widgets/levels/lehr_karte_renderer.dart
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

/// Rendert den Inhalt einer Lehr-Karte.
///
/// Nimmt entweder:
/// - blocks: strukturierte Blöcke aus calculation_data['blocks']
/// - fallbackText: Plain-Text aus erklaerung (für alte Karten)
class LehrKarteRenderer extends StatelessWidget {
  final List<dynamic>? blocks;
  final String? fallbackText;

  const LehrKarteRenderer({super.key, this.blocks, this.fallbackText});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    // Fallback: alte Karten ohne Blocks
    if (blocks == null || blocks!.isEmpty) {
      return _buildText(fallbackText ?? '', text);
    }

    // Block-basiertes Rendering
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks!.map<Widget>((b) {
        final block = b as Map<String, dynamic>;
        final type = block['type'] as String? ?? 'text';
        switch (type) {
          case 'text':
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildRichText(
                block['content'] as String? ?? '',
                text,
                textMid,
              ),
            );
          case 'code':
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildCodeBlock(
                block['content'] as String? ?? '',
                language: block['language'] as String? ?? 'sql',
                isDark: isDark,
              ),
            );
          case 'tip':
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildCallout(
                content: block['content'] as String? ?? '',
                color: AppColors.accentCyan,
                icon: Icons.lightbulb_outline_rounded,
                label: 'TIPP',
                isDark: isDark,
              ),
            );
          case 'warning':
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildCallout(
                content: block['content'] as String? ?? '',
                color: AppColors.warning,
                icon: Icons.warning_amber_rounded,
                label: 'ACHTUNG',
                isDark: isDark,
              ),
            );
          case 'success':
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildCallout(
                content: block['content'] as String? ?? '',
                color: AppColors.success,
                icon: Icons.check_circle_outline_rounded,
                label: 'MERKE',
                isDark: isDark,
              ),
            );
          case 'heading':
            return Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                block['content'] as String? ?? '',
                style: AppTextStyles.h3(text),
              ),
            );
          case 'divider':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Container(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            );
          default:
            return _buildText('Unbekannter Block-Typ: $type', textMid);
        }
      }).toList(),
    );
  }

  Widget _buildText(String content, Color color) {
    return Text(content, style: AppTextStyles.bodyLarge(color));
  }

  /// Rich-Text mit minimalem Markdown:
  /// **fett** → fett
  /// `code` → inline code
  Widget _buildRichText(String content, Color text, Color textMid) {
    final spans = <TextSpan>[];
    // Regex für **fett** und `code`
    final pattern = RegExp(r'(\*\*[^*]+\*\*|`[^`]+`)');
    int lastEnd = 0;

    for (final match in pattern.allMatches(content)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }
      final m = match.group(0)!;
      if (m.startsWith('**')) {
        spans.add(
          TextSpan(
            text: m.substring(2, m.length - 2),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        );
      } else if (m.startsWith('`')) {
        spans.add(
          TextSpan(
            text: m.substring(1, m.length - 1),
            style: AppTextStyles.mono(
              size: 14,
              color: AppColors.accent,
              weight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        );
      }
      lastEnd = match.end;
    }
    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(style: AppTextStyles.bodyLarge(text), children: spans),
    );
  }

  Widget _buildCodeBlock(
    String code, {
    required String language,
    required bool isDark,
  }) {
    final bg = isDark ? const Color(0xFF1F1F2E) : const Color(0xFFF7F7F4);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini-Header mit Sprache
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  language.toUpperCase(),
                  style: AppTextStyles.monoSmall(
                    isDark ? AppColors.darkTextDim : AppColors.lightTextDim,
                  ),
                ),
              ],
            ),
          ),
          // Code mit Highlighting
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: HighlightView(
              code,
              language: language,
              theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
              padding: const EdgeInsets.all(8),
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallout({
    required String content,
    required Color color,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.monoLabel(color)),
            ],
          ),
          const SizedBox(height: 8),
          _buildRichText(content, text, textMid),
        ],
      ),
    );
  }
}
