// lib/widgets/premium_lock.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

/// Wiederverwendbares Lock-Widget für Premium-Features.
class PremiumLock extends StatelessWidget {
  final String featureName;
  final String description;
  final IconData icon;
  final VoidCallback onUpgrade;
  final VoidCallback? onClose;

  const PremiumLock({
    super.key,
    required this.featureName,
    required this.description,
    required this.onUpgrade,
    this.icon = Icons.lock_outline_rounded,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ─────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onClose ?? () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      'PREMIUM FEATURE',
                      style: AppTextStyles.monoLabel(textMid),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT (scrollable) ───────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Label
                  Row(
                    children: [
                      Container(width: 16, height: 1, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Text(
                        'PREMIUM',
                        style: AppTextStyles.monoLabel(AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(icon, color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(height: 20),

                  // Headline
                  Text(
                    '$featureName ist\nPremium.',
                    style: AppTextStyles.instrumentSerif(
                      size: 32,
                      color: text,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(description, style: AppTextStyles.bodyMedium(textMid)),

                  const SizedBox(height: 24),

                  // Premium Benefits
                  _buildBenefits(surface, border, text, textMid, textDim),

                  const SizedBox(height: 16),

                  // Pricing Hint
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 14,
                          color: textMid,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ab 9,99€/M · 59€/J · 99€ Lifetime',
                            style: AppTextStyles.mono(
                              size: 11,
                              color: textMid,
                              weight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── BOTTOM BAR ──────────────────────
          Container(
            decoration: BoxDecoration(
              color: surface,
              border: Border(top: BorderSide(color: border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onUpgrade,
                    icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                    label: const Text('Premium aktivieren'),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MIT PREMIUM', style: AppTextStyles.monoSmall(textMid)),
          const SizedBox(height: 12),
          _benefit(
            Icons.assignment_outlined,
            'Alle IHK-Prüfungen',
            'Frühjahr & Herbst aller Jahre',
            text,
            textMid,
          ),
          const SizedBox(height: 10),
          _benefit(
            Icons.workspace_premium_outlined,
            'Alle Zertifikate',
            'AWS · Azure · GCP · SAP',
            text,
            textMid,
          ),
          const SizedBox(height: 10),
          _benefit(
            Icons.all_inclusive_rounded,
            'Unbegrenzte Fragen',
            'Kein Tageslimit mehr',
            text,
            textMid,
          ),
          const SizedBox(height: 10),
          _benefit(
            Icons.psychology_outlined,
            'AI-Tutor Ada',
            'Unbegrenzte Erklärungen',
            text,
            textMid,
          ),
        ],
      ),
    );
  }

  Widget _benefit(
    IconData icon,
    String title,
    String subtitle,
    Color text,
    Color textMid,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.interTight(
                  size: 14,
                  weight: FontWeight.w600,
                  color: text,
                ),
              ),
              Text(subtitle, style: AppTextStyles.bodySmall(textMid)),
            ],
          ),
        ),
      ],
    );
  }
}
