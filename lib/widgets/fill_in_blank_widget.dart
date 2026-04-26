import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

class FillInTheBlankWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> blankData;
  final Function(bool isCorrect, Map<String, String>? userAnswers)
  onAnswerSubmitted;

  const FillInTheBlankWidget({
    super.key,
    required this.questionText,
    required this.blankData,
    required this.onAnswerSubmitted,
  });

  @override
  State<FillInTheBlankWidget> createState() => _FillInTheBlankWidgetState();
}

class _FillInTheBlankWidgetState extends State<FillInTheBlankWidget> {
  Map<int, String?> selectedAnswers = {};
  bool _hasSubmitted = false;
  bool? _isCorrect;

  List<Map<String, dynamic>> get _blanks {
    if (widget.blankData.isEmpty) return [];
    final blanks = widget.blankData['blanks'];
    if (blanks == null || blanks is! List) return [];
    return blanks
        .where((b) => b != null && b is Map)
        .map((b) => Map<String, dynamic>.from(b as Map))
        .toList();
  }

  String get _explanation => widget.blankData['explanation'] ?? '';

  Set<String> get _allOptions {
    final options = <String>{};
    for (var blank in _blanks) {
      final blankOptions = (blank['options'] as List).cast<String>();
      options.addAll(blankOptions);
    }
    return options;
  }

  bool _isOptionSelected(String option) =>
      selectedAnswers.values.contains(option);

  void _selectOption(String option, int blankIndex) {
    if (_hasSubmitted || _isOptionSelected(option)) return;
    setState(() => selectedAnswers[blankIndex] = option);
  }

  void _clearBlank(int index) {
    if (_hasSubmitted) return;
    setState(() => selectedAnswers[index] = null);
  }

  void _checkAnswer() {
    if (selectedAnswers.length < _blanks.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bitte fülle alle Lücken aus'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool allCorrect = true;
    for (int i = 0; i < _blanks.length; i++) {
      final correctAnswer = _blanks[i]['correctAnswer'];
      final userAnswer = selectedAnswers[i];
      if (userAnswer != correctAnswer) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _hasSubmitted = true;
    });

    final userAnswersMap = selectedAnswers.map(
      (key, value) => MapEntry(key.toString(), value ?? ''),
    );
    widget.onAnswerSubmitted(allCorrect, userAnswersMap);
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
              'LÜCKENTEXT',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Frage mit Lücken-Markierung
        _buildTextWithBlanks(text, textMid),
        const SizedBox(height: 24),

        // Lücken
        ...List.generate(_blanks.length, (index) {
          final answer = selectedAnswers[index];
          final isEmpty = answer == null;
          final isSubmitted = _hasSubmitted;
          final correct =
              isSubmitted &&
              !isEmpty &&
              answer == _blanks[index]['correctAnswer'];
          final wrong =
              isSubmitted &&
              !isEmpty &&
              answer != _blanks[index]['correctAnswer'];

          Color slotColor = surface;
          Color slotBorder = border;

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
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'LÜCKE ${index + 1}',
                        style: AppTextStyles.mono(
                          size: 9,
                          color: AppColors.accent,
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: isEmpty || _hasSubmitted
                      ? null
                      : () => _clearBlank(index),
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
                            isEmpty ? '__________' : answer,
                            style: AppTextStyles.interTight(
                              size: 14,
                              weight: isEmpty
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                              color: isEmpty ? textDim : text,
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
                // Korrekte Antwort bei falsch
                if (wrong) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: AppColors.success,
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'RICHTIG: ',
                          style: AppTextStyles.monoSmall(AppColors.success),
                        ),
                        Text(
                          _blanks[index]['correctAnswer'],
                          style: AppTextStyles.mono(
                            size: 12,
                            color: text,
                            weight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 12),

        // Auswahl
        if (!_hasSubmitted) ...[
          Text('AUSWAHL', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _allOptions.map((option) {
              final isSelected = _isOptionSelected(option);
              int? nextBlankIndex;
              if (!isSelected) {
                for (int i = 0; i < _blanks.length; i++) {
                  if (selectedAnswers[i] == null) {
                    nextBlankIndex = i;
                    break;
                  }
                }
              }

              return GestureDetector(
                onTap: isSelected || nextBlankIndex == null
                    ? null
                    : () => _selectOption(option, nextBlankIndex!),
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
                    option,
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

          // Submit
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

  Widget _buildTextWithBlanks(Color text, Color textMid) {
    final txt = widget.questionText;
    final parts = txt.split('_____');

    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(
            parts[i],
            style: AppTextStyles.instrumentSerif(
              size: 22,
              color: text,
              letterSpacing: -0.6,
            ),
          ),
        );
      }
      if (i < parts.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Text(
                '${i + 1}',
                style: AppTextStyles.mono(
                  size: 12,
                  color: AppColors.accent,
                  weight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
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
          if (_explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(_explanation, style: AppTextStyles.bodyMedium(textMid)),
          ],
        ],
      ),
    );
  }
}
