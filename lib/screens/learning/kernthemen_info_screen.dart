// lib/screens/learning/kernthemen_info_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class KernthemenInfoScreen extends StatefulWidget {
  const KernthemenInfoScreen({super.key});

  @override
  State<KernthemenInfoScreen> createState() => _KernthemenInfoScreenState();
}

class _KernthemenInfoScreenState extends State<KernthemenInfoScreen> {
  bool _nichtMehrAnzeigen = false;

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
          // ─── APPBAR ───────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Kernthemen',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ──────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              physics: const BouncingScrollPhysics(),
              children: [
                // Intro
                _buildIntro(text, textMid, textDim),

                const SizedBox(height: 28),

                // Info Cards
                _buildInfoCard(
                  number: '01',
                  title: 'Warum sind Kernthemen so wichtig?',
                  content:
                      'Die IHK-Abschlussprüfung besteht aus mehreren Teilen – und in fast jedem davon tauchen diese Kernthemen auf. Themen wie IP-Subnetting, RAID-Systeme, das OSI-Modell oder IT-Sicherheit sind keine Zufallsfragen: Sie gehören zum absoluten Pflichtprogramm jedes IT-Fachinformatikers.\n\nWer diese Themen sicher beherrscht, legt ein starkes Fundament für die gesamte Prüfung.',
                  surface: surface,
                  border: border,
                  text: text,
                  textMid: textMid,
                  textDim: textDim,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  number: '02',
                  title: 'Was dich hier erwartet',
                  content:
                      'Jedes Kernthema enthält eine Mischung aus verschiedenen Aufgabentypen – genau wie in der echten Prüfung:\n\n• Berechnungsaufgaben (z. B. Subnetzmasken, RAID-Kapazitäten)\n• Multiple-Choice-Fragen zum schnellen Wiederholen\n• Freitext-Aufgaben, bei denen du Konzepte erklärst\n\nDie Fragen werden jedes Mal in zufälliger Reihenfolge angezeigt, damit du wirklich lernst – und nicht nur die Reihenfolge auswendig kennst.',
                  surface: surface,
                  border: border,
                  text: text,
                  textMid: textMid,
                  textDim: textDim,
                ),
                const SizedBox(height: 12),

                // Ada Card (accent)
                _buildAdaCard(surface, border, text, textMid, textDim),
                const SizedBox(height: 12),

                _buildInfoCard(
                  number: '03',
                  title: 'Tipps für deine Vorbereitung',
                  content:
                      '📝 Nutze das Scratch Pad bei Rechenaufgaben – genau wie in der echten Prüfung hast du dort Platz für deine Zwischenrechnungen.\n\n🔁 Wiederhole jedes Thema mehrmals – beim ersten Durchgang geht es ums Verstehen, danach ums Festigen.\n\n💬 Scheue dich nicht, Ada zu fragen – sie erklärt Konzepte geduldig und geht auf deine Fragen ein.\n\n🎯 Fokussiere dich besonders auf Themen, bei denen dein Fortschritt noch niedrig ist.',
                  surface: surface,
                  border: border,
                  text: text,
                  textMid: textMid,
                  textDim: textDim,
                ),

                const SizedBox(height: 24),

                // Checkbox
                GestureDetector(
                  onTap: () =>
                      setState(() => _nichtMehrAnzeigen = !_nichtMehrAnzeigen),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _nichtMehrAnzeigen
                              ? AppColors.accent
                              : Colors.transparent,
                          border: Border.all(
                            color: _nichtMehrAnzeigen
                                ? AppColors.accent
                                : border,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _nichtMehrAnzeigen
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Diesen Hinweis nicht mehr anzeigen',
                          style: AppTextStyles.bodyMedium(textMid),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_nichtMehrAnzeigen) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('kernthemen_info_shown', true);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Los geht\'s'),
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
                const SizedBox(height: 10),

                // Secondary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiTutorChatScreen(
                          currentQuestion: null,
                          topic: 'Kernthemen Allgemein',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text('Ada fragen'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: text,
                      side: BorderSide(color: border),
                      textStyle: AppTextStyles.labelLarge(text),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── INTRO ────────────────────────────────
  Widget _buildIntro(Color text, Color textMid, Color textDim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'WILLKOMMEN',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Kernthemen.',
          style: AppTextStyles.instrumentSerif(
            size: 34,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bevor du loslegst — das solltest du wissen.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
      ],
    );
  }

  // ─── INFO CARD ────────────────────────────
  Widget _buildInfoCard({
    required String number,
    required String title,
    required String content,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                number,
                style: AppTextStyles.mono(
                  size: 11,
                  color: AppColors.accent,
                  weight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 24, height: 1, color: border),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: AppTextStyles.h3(text))),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }

  // ─── ADA CARD ─────────────────────────────
  Widget _buildAdaCard(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
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
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: AppColors.accent,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KI-TUTOR',
                      style: AppTextStyles.monoSmall(AppColors.accent),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ada hilft dir.',
                      style: AppTextStyles.instrumentSerif(
                        size: 22,
                        color: text,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Ada ist benannt nach Ada Lovelace – der ersten Programmiererin der Geschichte.',
            style: AppTextStyles.bodyMedium(textMid),
          ),
          const SizedBox(height: 14),
          _adaFeature('💡', 'Gezielte Tipps ohne die Lösung zu verraten', text),
          _adaFeature('💬', 'Ausführliche Erklärungen im Chat', text),
          _adaFeature('✅', 'Bewertet deine Freitext-Antworten', text),
          _adaFeature(
            '📚',
            'Arbeitet ein Thema von Grund auf mit dir durch',
            text,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _adaFeature(
    String emoji,
    String label,
    Color text, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall(text))),
        ],
      ),
    );
  }
}
