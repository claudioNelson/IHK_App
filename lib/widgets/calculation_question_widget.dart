import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

class CalculationQuestionWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> calculationData;
  final Function(bool isCorrect, String? userAnswer) onAnswerSubmitted;

  const CalculationQuestionWidget({
    super.key,
    required this.questionText,
    required this.calculationData,
    required this.onAnswerSubmitted,
  });

  @override
  State<CalculationQuestionWidget> createState() =>
      _CalculationQuestionWidgetState();
}

class _CalculationQuestionWidgetState extends State<CalculationQuestionWidget> {
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool? _isCorrect;
  bool _hasSubmitted = false;

  double get _correctAnswer =>
      (widget.calculationData['correctAnswer'] as num).toDouble();

  String get _unit => widget.calculationData['unit'] ?? '';

  double get _tolerance =>
      (widget.calculationData['tolerance'] as num?)?.toDouble() ?? 0.0;

  void _checkAnswer() {
    final userInput = _answerController.text.trim();
    final userAnswer = double.tryParse(userInput);

    if (userAnswer == null) {
      setState(() {
        _isCorrect = false;
        _hasSubmitted = true;
      });
      widget.onAnswerSubmitted(false, userInput);
      return;
    }

    final difference = (userAnswer - _correctAnswer).abs();
    final isCorrect = difference <= _tolerance;

    setState(() {
      _isCorrect = isCorrect;
      _hasSubmitted = true;
    });

    widget.onAnswerSubmitted(isCorrect, userInput);
  }

  @override
  void dispose() {
    _answerController.dispose();
    _notesController.dispose();
    super.dispose();
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

    Color inputBorderColor = border;
    if (_hasSubmitted) {
      inputBorderColor = _isCorrect == true
          ? AppColors.success
          : AppColors.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Label
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'BERECHNUNG',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Frage in Serif
        Text(
          widget.questionText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),

        // Hint
        if (widget.calculationData.containsKey('hint') && !_hasSubmitted) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.015, 0.015, 1.0],
                colors: [
                  AppColors.accentCyan,
                  AppColors.accentCyan,
                  surface,
                  surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.accentCyan,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TIPP',
                      style: AppTextStyles.monoLabel(AppColors.accentCyan),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.calculationData['hint'],
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Notizblock
        Text('NOTIZEN (OPTIONAL)', style: AppTextStyles.monoSmall(textDim)),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          enabled: !_hasSubmitted,
          style: AppTextStyles.mono(
            size: 13,
            color: text,
            weight: FontWeight.w500,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            hintText: 'Rechenschritte hier notieren...',
            hintStyle: AppTextStyles.bodyMedium(textDim),
            filled: true,
            fillColor: surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: border),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),

        const SizedBox(height: 20),

        // Antwort-Eingabe
        Text('DEINE ANTWORT', style: AppTextStyles.monoSmall(textDim)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _answerController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: AppTextStyles.mono(
                  size: 16,
                  color: text,
                  weight: FontWeight.w700,
                  letterSpacing: 0,
                ),
                enabled: !_hasSubmitted,
                onSubmitted: (_) => _checkAnswer(),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: AppTextStyles.mono(
                    size: 16,
                    color: textDim,
                    weight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                  suffixText: _unit.isNotEmpty ? _unit : null,
                  suffixStyle: AppTextStyles.mono(
                    size: 14,
                    color: textMid,
                    weight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  filled: true,
                  fillColor: surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _hasSubmitted ? null : _checkAnswer,
                icon: const Icon(Icons.check_rounded, size: 16),
                label: const Text('Prüfen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: text,
                  foregroundColor: bg,
                  disabledBackgroundColor: border,
                  disabledForegroundColor: textDim,
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge(bg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
              ),
            ),
          ],
        ),

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, color: AppColors.success, size: 13),
                  const SizedBox(width: 6),
                  Text(
                    'RICHTIG: ',
                    style: AppTextStyles.monoSmall(AppColors.success),
                  ),
                  Text(
                    '$_correctAnswer ${_unit}'.trim(),
                    style: AppTextStyles.mono(
                      size: 13,
                      color: text,
                      weight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.calculationData.containsKey('explanation')) ...[
            const SizedBox(height: 12),
            Text('ERKLÄRUNG', style: AppTextStyles.monoSmall(textMid)),
            const SizedBox(height: 6),
            Text(
              widget.calculationData['explanation'],
              style: AppTextStyles.bodyMedium(textMid),
            ),
          ],
        ],
      ),
    );
  }
}
