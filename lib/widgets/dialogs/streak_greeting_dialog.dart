import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

/// Zeigt den Begrüßungs-Dialog mit dem aktuellen Streak.
Future<bool?> showStreakGreetingDialog(
  BuildContext context,
  int streakDays,
  int dueCount,
  int answeredYesterday,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _StreakGreetingDialog(
      streakDays: streakDays,
      dueCount: dueCount,
      answeredYesterday: answeredYesterday,
    ),
  );
}

class _StreakGreetingDialog extends StatefulWidget {
  const _StreakGreetingDialog({
    required this.streakDays,
    required this.dueCount,
    required this.answeredYesterday,
  });

  final int streakDays;
  final int dueCount;
  final int answeredYesterday;

  @override
  State<_StreakGreetingDialog> createState() => _StreakGreetingDialogState();
}

class _StreakGreetingDialogState extends State<_StreakGreetingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Meilenstein-Tage, die einen besonderen Dialog auslösen.
  static const _milestoneDays = {7, 14, 30, 50, 100, 365};

  /// true, wenn der heutige Streak exakt einen Meilenstein erreicht.
  bool get _isMilestone => _milestoneDays.contains(widget.streakDays);

  /// Motivierender Spruch, gestaffelt nach Streak-Länge.
  /// Meilensteine bekommen einen eigenen, stärkeren Spruch.
  String get _message {
    final streakDays = widget.streakDays;
    if (_isMilestone) {
      if (streakDays >= 365) return 'Ein ganzes Jahr! Wahnsinn.';
      if (streakDays >= 100) return '100 Tage. Du bist nicht zu stoppen!';
      if (streakDays >= 50) return '50 Tage am Stück – absolute Spitze!';
      if (streakDays >= 30) return 'Ein ganzer Monat. Eiserne Disziplin!';
      if (streakDays >= 14) return 'Zwei Wochen geknackt. Stark!';
      return 'Eine ganze Woche – Meilenstein erreicht!';
    }
    if (streakDays >= 30) return 'Eiserne Disziplin – weiter so!';
    if (streakDays >= 14) return 'Zwei Wochen am Stück. Stark!';
    if (streakDays >= 7) return 'Eine ganze Woche dabei. Respekt!';
    if (streakDays >= 3) return 'Dranbleiben zahlt sich aus!';
    return 'Schön, dass du wieder da bist!';
  }

  String get _dayLabel =>
      widget.streakDays == 1 ? 'Tag in Folge' : 'Tage in Folge';

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Dialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Meilenstein-Banner (nur bei 7/14/30/50/100/365 Tagen)
                if (_isMilestone) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppColors.accentCyan.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      'MEILENSTEIN',
                      style: AppTextStyles.mono(
                        size: 10,
                        color: AppColors.accentCyan,
                        weight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Flammen-Icon mit Brand-Verlauf (Violett → Cyan) + Glühen
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.32),
                        AppColors.accent.withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withOpacity(0.12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.40),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (rect) => const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.accent, // unten: Indigo-Violett
                              AppColors.accentCyan, // oben: Cyan
                            ],
                          ).createShader(rect),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            size: 46,
                            color: Colors.white, // wird vom Shader eingefärbt
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Streak-Zahl (zählt beim Erscheinen hoch)
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: widget.streakDays),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: AppTextStyles.instrumentSerif(
                        size: 56,
                        color: AppColors.accentCyan,
                        letterSpacing: -1.5,
                      ),
                    );
                  },
                ),
                Text(_dayLabel, style: AppTextStyles.labelLarge(text)),
                const SizedBox(height: 12),

                // Spruch
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(textMid),
                ),

                // Fällige Wiederholungen (nur wenn welche anstehen)
                if (widget.dueCount > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.dueCount == 1
                              ? '1 Karte heute fällig'
                              : '${widget.dueCount} Karten heute fällig',
                          style: AppTextStyles.labelMedium(text),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Buttons
                if (widget.dueCount > 0) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Jetzt wiederholen'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Später',
                        style: AppTextStyles.labelLarge(textMid),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Los geht\'s!'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
