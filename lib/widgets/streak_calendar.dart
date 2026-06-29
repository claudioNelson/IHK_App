import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 12-Wochen-Heatmap der Lern-Aktivität (GitHub-Stil).
/// Erwartet eine Map: lokaler Tag (Mitternacht) -> Anzahl beantworteter Fragen.
class StreakCalendar extends StatelessWidget {
  const StreakCalendar({
    super.key,
    required this.dayCounts,
    required this.surface,
    required this.border,
    required this.text,
    required this.textDim,
  });

  final Map<DateTime, int> dayCounts;
  final Color surface;
  final Color border;
  final Color text;
  final Color textDim;

  static const int _weeks = 12;

  /// Farbe je nach Anzahl Fragen an dem Tag (4 Intensitätsstufen).
  Color _cellColor(int count) {
    if (count <= 0) return border.withOpacity(0.45); // inaktiv
    if (count < 5) return AppColors.accent.withOpacity(0.35);
    if (count < 10) return AppColors.accent.withOpacity(0.65);
    return AppColors.accent; // Tagesziel (10+) erreicht -> voll
  }

  @override
  Widget build(BuildContext context) {
    // Heute auf lokalen Tag normalisieren.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Das Raster endet in der aktuellen Woche. Wir richten Spalten an
    // Wochen aus (Mo–So). Finde den Montag der aktuellen Woche.
    final mondayThisWeek = today.subtract(Duration(days: today.weekday - 1));
    // Startmontag = 11 Wochen vor dieser Woche (insgesamt 12 Spalten).
    final startMonday = mondayThisWeek.subtract(
      Duration(days: (_weeks - 1) * 7),
    );

    const weekdayLabels = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Raster: links Wochentags-Labels, rechts 12 Wochen-Spalten
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wochentags-Labels (nur Mo/Mi/Fr, sonst zu eng)
              Column(
                children: List.generate(7, (row) {
                  final showLabel = row == 0 || row == 2 || row == 4;
                  return SizedBox(
                    height: 16,
                    child: Text(
                      showLabel ? weekdayLabels[row] : '',
                      style: AppTextStyles.mono(
                        size: 8,
                        color: textDim,
                        weight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 6),

              // Wochen-Spalten
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Zellgröße aus verfügbarer Breite ableiten (12 Spalten + Lücken).
                    const gap = 3.0;
                    final cell =
                        (constraints.maxWidth - gap * (_weeks - 1)) / _weeks;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_weeks, (col) {
                        return Column(
                          children: List.generate(7, (row) {
                            final date = startMonday.add(
                              Duration(days: col * 7 + row),
                            );
                            final isFuture = date.isAfter(today);
                            final count = dayCounts[date] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: gap),
                              child: Container(
                                width: cell,
                                height: cell,
                                decoration: BoxDecoration(
                                  color: isFuture
                                      ? Colors.transparent
                                      : _cellColor(count),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Legende: weniger -> mehr
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Weniger',
                style: AppTextStyles.mono(
                  size: 9,
                  color: textDim,
                  weight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 6),
              _legendCell(border.withOpacity(0.45)),
              _legendCell(AppColors.accent.withOpacity(0.35)),
              _legendCell(AppColors.accent.withOpacity(0.65)),
              _legendCell(AppColors.accent),
              const SizedBox(width: 6),
              Text(
                'Mehr',
                style: AppTextStyles.mono(
                  size: 9,
                  color: textDim,
                  weight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendCell(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
