// lib/screens/levels/level_result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/level_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'level_play_screen.dart';

class LevelResultScreen extends StatefulWidget {
  final Level level;
  final int score; // 0–100
  final int correctCount;
  final int totalCount;
  final int newSterne; // 0–3 (Best-Sterne nach diesem Versuch)

  const LevelResultScreen({
    super.key,
    required this.level,
    required this.score,
    required this.correctCount,
    required this.totalCount,
    required this.newSterne,
  });

  @override
  State<LevelResultScreen> createState() => _LevelResultScreenState();
}

class _LevelResultScreenState extends State<LevelResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _scoreController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Score-Animation startet sofort, Sterne danach
    _scoreController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _starController.forward();
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  bool get _passed => widget.score >= widget.level.schwelle;

  void _retry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelPlayScreen(
          level: widget.level,
          modulName: '', // wird im Header eh nicht mehr genutzt
        ),
      ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final accentColor = _passed ? AppColors.success : AppColors.warning;
    final headline = _passed ? 'Geschafft!' : 'Knapp daneben.';
    final headlineLabel = _passed ? 'LEVEL ABGESCHLOSSEN' : 'NICHT BESTANDEN';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER ──────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _back,
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      'Level ${widget.level.nummer.toString().padLeft(2, '0')} · ${widget.level.titel}',
                      style: AppTextStyles.labelMedium(textMid),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // ─── CONTENT ─────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status-Pill
                    Row(
                      children: [
                        Container(width: 16, height: 1, color: accentColor),
                        const SizedBox(width: 10),
                        Text(
                          headlineLabel,
                          style: AppTextStyles.monoLabel(accentColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      headline,
                      style: AppTextStyles.instrumentSerif(
                        size: 42,
                        color: text,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _passed
                          ? 'Du hast die Schwelle erreicht.'
                          : 'Du brauchst mindestens ${widget.level.schwelle}% — Versuch es nochmal.',
                      style: AppTextStyles.bodyMedium(textMid),
                    ),

                    const SizedBox(height: 32),

                    // Sterne-Banner
                    _buildSterneBanner(
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                      accentColor,
                    ),

                    const SizedBox(height: 16),

                    // Score-Banner
                    _buildScoreBanner(
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                      accentColor,
                    ),

                    const SizedBox(height: 32),

                    // Buttons
                    _buildButtons(text, bg, surface, border, textMid),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSterneBanner(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.warning, AppColors.warning, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.warning),
              const SizedBox(width: 10),
              Text('STERNE', style: AppTextStyles.monoLabel(AppColors.warning)),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final filled = i < widget.newSterne;
                // Staggered Animation
                final start = i * 0.25;
                final end = start + 0.5;
                final anim = CurvedAnimation(
                  parent: _starController,
                  curve: Interval(
                    start,
                    end.clamp(0.0, 1.0),
                    curve: Curves.elasticOut,
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ScaleTransition(
                    scale: filled
                        ? anim
                        : const AlwaysStoppedAnimation<double>(1.0),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: filled ? AppColors.warning : textDim,
                      size: 56,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _sterneText(widget.newSterne),
              style: AppTextStyles.bodyMedium(textMid),
            ),
          ),
        ],
      ),
    );
  }

  String _sterneText(int sterne) {
    switch (sterne) {
      case 3:
        return 'Perfekt — alle Antworten richtig!';
      case 2:
        return 'Stark — fast alles korrekt.';
      case 1:
        return 'Solide — nochmal üben für mehr Sterne.';
      default:
        return 'Versuch es nochmal — du schaffst das!';
    }
  }

  Widget _buildScoreBanner(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color accentColor,
  ) {
    return AnimatedBuilder(
      animation: _scoreController,
      builder: (_, __) {
        final animatedScore = (widget.score * _scoreController.value).round();
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: accentColor),
                  const SizedBox(width: 10),
                  Text('ERGEBNIS', style: AppTextStyles.monoLabel(accentColor)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$animatedScore',
                    style: AppTextStyles.instrumentSerif(
                      size: 48,
                      color: text,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '%',
                      style: AppTextStyles.instrumentSerif(
                        size: 28,
                        color: textMid,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.correctCount} / ${widget.totalCount}',
                        style: AppTextStyles.instrumentSerif(
                          size: 24,
                          color: text,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text('RICHTIG', style: AppTextStyles.monoSmall(textDim)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: _scoreController.value * (widget.score / 100),
                  backgroundColor: border,
                  valueColor: AlwaysStoppedAnimation(accentColor),
                  minHeight: 3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Schwelle ${widget.level.schwelle}%',
                    style: AppTextStyles.monoSmall(textDim),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtons(
    Color text,
    Color bg,
    Color surface,
    Color border,
    Color textMid,
  ) {
    if (_passed) {
      // Bestanden: primär "Zurück zum Pfad", sekundär "Wiederholen"
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _back,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Weiter zum Pfad'),
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
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Nochmal — für mehr Sterne'),
            ),
          ),
        ],
      );
    } else {
      // Nicht bestanden: primär "Wiederholen", sekundär "Zurück"
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Nochmal versuchen'),
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
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Zurück zum Pfad'),
            ),
          ),
        ],
      );
    }
  }
}
