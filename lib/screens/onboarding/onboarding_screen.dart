// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      code: '01',
      tag: 'FRAGEN',
      accentColor: AppColors.accent,
      title: 'Echte Prüfungsfragen.',
      titleAccent: '600+',
      description:
          'Über 600 Fragen aus allen IHK-Themenbereichen — so wie sie in der echten Abschlussprüfung vorkommen.',
    ),
    _OnboardingData(
      code: '02',
      tag: 'SIMULATION',
      accentColor: AppColors.accentCyan,
      title: 'Prüfungsbedingungen.',
      titleAccent: 'Echt.',
      description:
          'Simuliere die echte Abschlussprüfung mit Timer, Fragenübersicht und realistischen Bedingungen — für Fachinformatiker AE und SI.',
    ),
    _OnboardingData(
      code: '03',
      tag: 'KI-TUTOR',
      accentColor: AppColors.accent,
      title: 'Ada erklärt dir,',
      titleAccent: 'was du nicht verstehst.',
      description:
          'Deine persönliche KI-Assistentin erklärt Lösungen, gibt Feedback und hilft dir gezielt bei Schwächen.',
    ),
    _OnboardingData(
      code: '04',
      tag: 'MULTIPLAYER',
      accentColor: AppColors.accentCyan,
      title: 'Tritt gegen andere an.',
      titleAccent: 'AsyncMatch.',
      description:
          'Fordere andere Azubis im asynchronen Quiz-Modus heraus und klettere in der Rangliste nach oben.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderStrong =
        isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final isLast = _currentPage == _pages.length - 1;
    final progress = (_currentPage + 1) / _pages.length;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Subtle Glow je nach Page
          AnimatedAlign(
            duration: const Duration(milliseconds: 600),
            alignment: Alignment(
              (_currentPage - 1.5) * 0.4,
              -0.5,
            ),
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _pages[_currentPage].accentColor.withOpacity(0.12),
                    _pages[_currentPage].accentColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Top Bar ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Lernarena',
                            style: AppTextStyles.instrumentSerif(
                              size: 22,
                              color: text,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),

                      // Right side: Theme Toggle + Skip
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => themeProvider.toggleTheme(),
                            icon: Icon(
                              isDark
                                  ? Icons.wb_sunny_outlined
                                  : Icons.nightlight_outlined,
                              color: textMid,
                              size: 18,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: surface,
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(36, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: border),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _finishOnboarding,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            child: Text(
                              'Überspringen',
                              style: AppTextStyles.labelSmall(textMid),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Progress Bar ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        '${(_currentPage + 1).toString().padLeft(2, '0')} / ${_pages.length.toString().padLeft(2, '0')}',
                        style: AppTextStyles.monoSmall(textDim),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: border,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 350),
                              widthFactor: progress,
                              curve: Curves.easeInOut,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.accent,
                                      AppColors.accentCyan,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Slides ───────────────────────────────────
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) => _OnboardingSlide(
                      data: _pages[i],
                      isDark: isDark,
                      text: text,
                      textMid: textMid,
                      textDim: textDim,
                      surface: surface,
                      border: border,
                    ),
                  ),
                ),

                // ─── Navigation Buttons ───────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Row(
                    children: [
                      // Back Button (ab Seite 2)
                      if (_currentPage > 0) ...[
                        SizedBox(
                          height: 52,
                          width: 52,
                          child: OutlinedButton(
                            onPressed: () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: text,
                              side: BorderSide(color: borderStrong),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: text,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],

                      // Primary Button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!isLast) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _finishOnboarding();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: text,
                              foregroundColor: bg,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLast ? 'Jetzt starten' : 'Weiter',
                                  style: AppTextStyles.labelLarge(bg),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: bg,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ────────────────────────────────────────
class _OnboardingData {
  final String code;
  final String tag;
  final Color accentColor;
  final String title;
  final String titleAccent; // wird in Instrument Serif italic dargestellt
  final String description;

  const _OnboardingData({
    required this.code,
    required this.tag,
    required this.accentColor,
    required this.title,
    required this.titleAccent,
    required this.description,
  });
}

// ─── Slide Widget ──────────────────────────────────────
class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  final bool isDark;
  final Color text;
  final Color textMid;
  final Color textDim;
  final Color surface;
  final Color border;

  const _OnboardingSlide({
    required this.data,
    required this.isDark,
    required this.text,
    required this.textMid,
    required this.textDim,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Code + Tag
          Row(
            children: [
              Text(
                data.code,
                style: AppTextStyles.mono(
                  size: 13,
                  color: data.accentColor,
                  weight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 1,
                width: 30,
                color: border,
              ),
              const SizedBox(width: 12),
              Text(
                data.tag,
                style: AppTextStyles.monoSmall(textDim),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Title with Serif Accent
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${data.title}\n',
                  style: AppTextStyles.interTight(
                    size: 38,
                    weight: FontWeight.w600,
                    color: text,
                    letterSpacing: -1.2,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: data.titleAccent,
                  style: AppTextStyles.instrumentSerif(
                    size: 42,
                    color: data.accentColor,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: AppTextStyles.bodyLarge(textMid),
          ),

          const SizedBox(height: 40),

          // Feature-Preview-Badge (subtile Feature-Liste)
          _buildFeatureRow(),
        ],
      ),
    );
  }

  Widget _buildFeatureRow() {
    // Zeigt je nach Page ein anderes Mini-Detail
    final features = _getFeaturesForTag();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: features
            .map(
              (f) => Padding(
                padding: EdgeInsets.only(
                  bottom: f == features.last ? 0 : 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        f,
                        style: AppTextStyles.bodySmall(text),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<String> _getFeaturesForTag() {
    switch (data.tag) {
      case 'FRAGEN':
        return [
          'Alle 17 Lernmodule abgedeckt',
          'Real-Data aus IHK-Prüfungen',
          'Multiple Choice, Drag & Drop, Freitext',
        ];
      case 'SIMULATION':
        return [
          '90-Minuten-Timer wie in der echten Prüfung',
          'Fragen flaggen und später reviewen',
          'Sofortige Auswertung mit Punktzahl',
        ];
      case 'KI-TUTOR':
        return [
          'Benannt nach Ada Lovelace',
          'Erklärt Konzepte auf deinem Level',
          'Verfügbar 24/7 als Chat',
        ];
      case 'MULTIPLAYER':
        return [
          'ELO-Rating-System',
          'Wöchentliche Ranglisten',
          'Async — spiele in deinem Tempo',
        ];
      default:
        return [];
    }
  }
}