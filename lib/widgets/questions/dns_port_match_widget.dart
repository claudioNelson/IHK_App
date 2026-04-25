import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/progress_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class DnsPortMatchWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final void Function(bool)? onAnswered;
  final int? questionId;
  final int? moduleId;

  const DnsPortMatchWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<DnsPortMatchWidget> createState() => _DnsPortMatchWidgetState();
}

class _DnsPortMatchWidgetState extends State<DnsPortMatchWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();

  String? selectedAnswer;
  bool hasAnswered = false;
  bool _loadingHint = false;
  String? _hintText;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _shuffleOptions();
  }

  void _shuffleOptions() {
    final options = List<String>.from(widget.correctAnswers['options'] ?? []);
    options.shuffle();
    _shuffledOptions = options;
  }

  @override
  void didUpdateWidget(DnsPortMatchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      setState(() {
        selectedAnswer = null;
        hasAnswered = false;
        _hintText = null;
      });
      _shuffleOptions();
    }
  }

  void _selectAnswer(String answer) async {
    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;
    });

    final correct = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = answer == correct;

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    if (widget.questionId != null && widget.moduleId != null) {
      await _progressService.saveKernthemaAnswer(
        modulId: widget.moduleId!,
        frageId: widget.questionId!,
        isCorrect: isCorrect,
      );
    }
  }

  Future<void> _getHint() async {
    setState(() {
      _loadingHint = true;
      _hintText = null;
    });

    try {
      final type = widget.correctAnswers['type'] as String? ?? '';
      final contextInfo = type == 'port_to_service'
          ? 'Port ${widget.correctAnswers['port']}'
          : widget.correctAnswers['record_type'] ?? widget.questionText;

      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'DNS & Ports',
        currentAttempt: selectedAnswer != null
            ? 'Meine Antwort: $selectedAnswer'
            : 'Ich bin mir unsicher bei: $contextInfo',
      );

      setState(() {
        _hintText = hint;
        _loadingHint = false;
      });
    } catch (e) {
      setState(() {
        _hintText = 'Fehler: $e';
        _loadingHint = false;
      });
    }
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'DNS & Ports',
        ),
      ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text('FRAGE', style: AppTextStyles.monoLabel(AppColors.accent)),
            ],
          ),
          const SizedBox(height: 14),

          // Frage
          Text(
            widget.questionText,
            style: AppTextStyles.instrumentSerif(
              size: 24,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 28),

          // Options
          ..._shuffledOptions.asMap().entries.map((entry) {
            return _buildOption(
              entry.key,
              entry.value,
              surface,
              border,
              text,
              textMid,
            );
          }),

          // Hint
          if (_hintText != null) ...[
            const SizedBox(height: 16),
            _buildHintBox(surface, border, text, textMid),
          ],

          // Feedback
          if (hasAnswered) ...[
            const SizedBox(height: 16),
            _buildFeedback(surface, border, text, textMid, bg),
          ],

          // Ada Buttons
          const SizedBox(height: 16),
          _buildAdaButtons(text, textMid, border),
        ],
      ),
    );
  }

  Widget _buildOption(
    int index,
    String option,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    final isSelected = selectedAnswer == option;
    final correct = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = option == correct;
    final showResult = hasAnswered && isSelected;
    final showCorrect = hasAnswered && !isSelected && isCorrect;

    Color borderColor = border;
    Color bgColor = surface;
    Color letterColor = textMid;
    Color letterBg = border;

    if (showResult) {
      if (isCorrect) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.05);
        letterColor = Colors.white;
        letterBg = AppColors.success;
      } else {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.05);
        letterColor = Colors.white;
        letterBg = AppColors.error;
      }
    } else if (showCorrect) {
      borderColor = AppColors.success.withOpacity(0.5);
      letterColor = AppColors.success;
      letterBg = AppColors.success.withOpacity(0.15);
    } else if (isSelected) {
      borderColor = AppColors.accent;
      letterColor = Colors.white;
      letterBg = AppColors.accent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: hasAnswered ? null : () => _selectAnswer(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: letterBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: showResult
                      ? Icon(
                          isCorrect ? Icons.check_rounded : Icons.close_rounded,
                          color: letterColor,
                          size: 16,
                        )
                      : showCorrect
                      ? Icon(Icons.check_rounded, color: letterColor, size: 16)
                      : Text(
                          String.fromCharCode(65 + index),
                          style: AppTextStyles.mono(
                            size: 12,
                            color: letterColor,
                            weight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.interTight(
                    size: 15,
                    weight: isSelected || showCorrect
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: text,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintBox(Color surface, Color border, Color text, Color textMid) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'TIPP VON ADA',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_hintText!, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }

  Widget _buildFeedback(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color bg,
  ) {
    final correct = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = selectedAnswer == correct;
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
                isCorrect ? 'RICHTIG' : 'ERKLÄRUNG',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          if (widget.explanation != null) ...[
            const SizedBox(height: 10),
            Text(widget.explanation!, style: AppTextStyles.bodyMedium(textMid)),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: widget.onAnswered != null
                  ? () => widget.onAnswered!(isCorrect)
                  : null,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Weiter'),
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
      ),
    );
  }

  Widget _buildAdaButtons(Color text, Color textMid, Color border) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _loadingHint ? null : _getHint,
              icon: _loadingHint
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    )
                  : Icon(
                      Icons.tips_and_updates_outlined,
                      size: 14,
                      color: AppColors.accent,
                    ),
              label: Text(
                _loadingHint ? 'Lädt...' : 'Tipp',
                style: AppTextStyles.mono(
                  size: 11,
                  color: AppColors.accent,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _openAiChat,
              icon: Icon(Icons.auto_awesome_outlined, size: 14, color: textMid),
              label: Text(
                'Ada Chat',
                style: AppTextStyles.mono(
                  size: 11,
                  color: textMid,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
