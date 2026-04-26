import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

class SequenceQuestionWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> sequenceData;
  final Function(bool isCorrect, List<String>? userOrder) onAnswerSubmitted;

  const SequenceQuestionWidget({
    super.key,
    required this.questionText,
    required this.sequenceData,
    required this.onAnswerSubmitted,
  });

  @override
  State<SequenceQuestionWidget> createState() => _SequenceQuestionWidgetState();
}

class _SequenceQuestionWidgetState extends State<SequenceQuestionWidget> {
  List<String?> selectedSlots = [];
  bool _hasSubmitted = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    final items = (widget.sequenceData['items'] as List).cast<String>();
    selectedSlots = List<String?>.filled(items.length, null);
  }

  List<String> get _availableItems =>
      (widget.sequenceData['items'] as List).cast<String>();

  List<String> get _correctOrder =>
      (widget.sequenceData['correctOrder'] as List).cast<String>();

  String get _explanation => widget.sequenceData['explanation'] ?? '';

  bool _isItemSelected(String item) => selectedSlots.contains(item);

  void _selectItem(String item) {
    if (_hasSubmitted || _isItemSelected(item)) return;
    setState(() {
      final emptyIndex = selectedSlots.indexOf(null);
      if (emptyIndex != -1) {
        selectedSlots[emptyIndex] = item;
      }
    });
  }

  void _clearSlot(int index) {
    if (_hasSubmitted) return;
    setState(() => selectedSlots[index] = null);
  }

  void _checkAnswer() {
    if (selectedSlots.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bitte fülle alle Felder aus'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool isCorrect = true;
    for (int i = 0; i < selectedSlots.length; i++) {
      if (selectedSlots[i] != _correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = isCorrect;
      _hasSubmitted = true;
    });

    widget.onAnswerSubmitted(
      isCorrect,
      selectedSlots.whereType<String>().toList(),
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
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Label
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'REIHENFOLGE',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Frage
        Text(
          widget.questionText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bringe in die richtige Reihenfolge.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
        const SizedBox(height: 24),

        // Slots
        ...List.generate(selectedSlots.length, (index) {
          final item = selectedSlots[index];
          final isEmpty = item == null;
          final isSubmitted = _hasSubmitted;
          final correct =
              isSubmitted &&
              !isEmpty &&
              selectedSlots[index] == _correctOrder[index];
          final wrong =
              isSubmitted &&
              !isEmpty &&
              selectedSlots[index] != _correctOrder[index];

          Color slotColor = surface;
          Color slotBorder = border;
          Color contentColor = text;

          if (correct) {
            slotColor = AppColors.success.withOpacity(0.05);
            slotBorder = AppColors.success.withOpacity(0.5);
          } else if (wrong) {
            slotColor = AppColors.error.withOpacity(0.05);
            slotBorder = AppColors.error.withOpacity(0.5);
          } else if (!isEmpty) {
            slotColor = AppColors.accent.withOpacity(0.05);
            slotBorder = AppColors.accent.withOpacity(0.4);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                // Position
                Container(
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.mono(
                        size: 14,
                        color: AppColors.accent,
                        weight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Slot
                Expanded(
                  child: GestureDetector(
                    onTap: isEmpty || _hasSubmitted
                        ? null
                        : () => _clearSlot(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: slotColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: slotBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isEmpty ? '__________' : item,
                              style: AppTextStyles.interTight(
                                size: 14,
                                weight: isEmpty
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: isEmpty ? textDim : contentColor,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (!isEmpty && !_hasSubmitted)
                            Icon(Icons.close_rounded, color: textMid, size: 14),
                          if (correct)
                            const Icon(
                              Icons.check_rounded,
                              color: AppColors.success,
                              size: 16,
                            ),
                          if (wrong)
                            const Icon(
                              Icons.close_rounded,
                              color: AppColors.error,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // Auswahl
        if (!_hasSubmitted) ...[
          Text('AUSWAHL', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _availableItems.map((item) {
              final isSelected = _isItemSelected(item);
              return GestureDetector(
                onTap: isSelected ? null : () => _selectItem(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? bg : surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? border
                          : AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    item,
                    style: AppTextStyles.interTight(
                      size: 13,
                      weight: FontWeight.w600,
                      color: isSelected ? textDim : text,
                      height: 1.3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _checkAnswer,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Prüfen'),
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
        ],

        // Feedback
        if (_hasSubmitted) ...[
          const SizedBox(height: 16),
          _buildFeedback(surface, border, text, textMid),
        ],
      ],
    );
  }

  Widget _buildFeedback(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    final isCorrect = _isCorrect == true;
    final accentColor = isCorrect ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [accentColor, accentColor, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_outline_rounded
                    : Icons.lightbulb_outline_rounded,
                color: accentColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'RICHTIG' : 'NICHT GANZ',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 12),
            Text(
              'RICHTIGE REIHENFOLGE',
              style: AppTextStyles.monoSmall(AppColors.success),
            ),
            const SizedBox(height: 8),
            ...List.generate(_correctOrder.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.mono(
                            size: 10,
                            color: AppColors.success,
                            weight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _correctOrder[index],
                        style: AppTextStyles.bodyMedium(text),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (_explanation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('ERKLÄRUNG', style: AppTextStyles.monoSmall(textMid)),
            const SizedBox(height: 6),
            Text(_explanation, style: AppTextStyles.bodyMedium(textMid)),
          ],
        ],
      ),
    );
  }
}
