// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.forward();
    _animController.repeat(reverse: true, period: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final accentSoft =
        isDark ? AppColors.darkAccentSoft : AppColors.lightAccentSoft;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // ─── Radial Glow hinter Logo ─────────────────────
          Align(
            alignment: const Alignment(0, -0.15),
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.15 * _pulseAnim.value),
                        accentSoft.withOpacity(0.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── Hauptinhalt ────────────────────────────────
          FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo-Dot (wie im Landingpage-Nav)
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.6),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // "Lernarena" mit Instrument Serif italic
                    Text(
                      'Lernarena',
                      style: AppTextStyles.instrumentSerif(
                        size: 54,
                        color: text,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle in Inter Tight
                    Text(
                      'Deine Prüfungsvorbereitung',
                      style: AppTextStyles.bodyMedium(textMid),
                    ),
                    const SizedBox(height: 80),

                    // Mono-Label "INITIALIZING" mit Pulse-Dot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, _) {
                            return Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentCyan
                                    .withOpacity(_pulseAnim.value),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentCyan
                                        .withOpacity(0.5 * _pulseAnim.value),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'INITIALIZING',
                          style: AppTextStyles.monoLabel(textDim),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Version-Tag unten ──────────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0 · BUILD 2026.04',
                style: AppTextStyles.monoSmall(textDim),
              ),
            ),
          ),
        ],
      ),
    );
  }
}