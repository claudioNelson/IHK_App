// lib/widgets/limit_reached_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

/// Dialog der angezeigt wird wenn ein Free-User sein Tageslimit erreicht hat.
class LimitReachedDialog extends StatelessWidget {
  final String featureName;
  final int limit;
  final IconData icon;
  final VoidCallback onUpgrade;

  const LimitReachedDialog({
    super.key,
    required this.featureName,
    required this.limit,
    required this.onUpgrade,
    this.icon = Icons.lock_outline_rounded,
  });

  /// Zeigt den Dialog.
  static Future<void> show(
    BuildContext context, {
    required String featureName,
    required int limit,
    IconData icon = Icons.lock_outline_rounded,
    required VoidCallback onUpgrade,
  }) {
    return showDialog(
      context: context,
      builder: (_) => LimitReachedDialog(
        featureName: featureName,
        limit: limit,
        icon: icon,
        onUpgrade: onUpgrade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Label
            Row(
              children: [
                Container(width: 16, height: 1, color: AppColors.warning),
                const SizedBox(width: 10),
                Text(
                  'TAGESLIMIT ERREICHT',
                  style: AppTextStyles.monoLabel(AppColors.warning),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Icon(icon, color: AppColors.warning, size: 24),
            ),
            const SizedBox(height: 16),

            // Headline
            Text(
              'Limit erreicht.',
              style: AppTextStyles.instrumentSerif(
                size: 28,
                color: text,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              'Du hast dein tägliches Limit von $limit $featureName erreicht. Upgrade auf Premium für unbegrenzten Zugang.',
              style: AppTextStyles.bodyMedium(textMid),
            ),

            const SizedBox(height: 20),

            // Mini Benefits
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MIT PREMIUM', style: AppTextStyles.monoSmall(textMid)),
                  const SizedBox(height: 8),
                  _benefit('Unbegrenzte Fragen', text),
                  const SizedBox(height: 4),
                  _benefit('Alle IHK-Prüfungen', text),
                  const SizedBox(height: 4),
                  _benefit('Alle Zertifikate', text),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Später',
                        style: AppTextStyles.mono(
                          size: 11,
                          color: textMid,
                          weight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onUpgrade();
                      },
                      icon: const Icon(
                        Icons.workspace_premium_rounded,
                        size: 16,
                      ),
                      label: const Text('Premium'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: text,
                        foregroundColor: bg,
                        elevation: 0,
                        textStyle: AppTextStyles.labelLarge(bg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(String label, Color text) {
    return Row(
      children: [
        Icon(Icons.check_rounded, size: 14, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodySmall(text)),
      ],
    );
  }
}
