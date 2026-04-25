import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../services/progress_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class BinaryCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final void Function(bool)? onAnswered;
  final int? questionId;
  final int? moduleId;

  const BinaryCalculationWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<BinaryCalculationWidget> createState() =>
      _BinaryCalculationWidgetState();
}

class _BinaryCalculationWidgetState extends State<BinaryCalculationWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  final _scratchPadController = TextEditingController();

  String? _selectedAnswer;
  bool _hasAnswered = false;
  bool _loadingHint = false;
  String? _hintText;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _shuffleOptions();
  }

  @override
  void didUpdateWidget(BinaryCalculationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      _scratchPadController.clear();
      setState(() {
        _selectedAnswer = null;
        _hasAnswered = false;
        _hintText = null;
      });
      _shuffleOptions();
    }
  }

  @override
  void dispose() {
    _scratchPadController.dispose();
    super.dispose();
  }

  void _shuffleOptions() {
    final options = List<String>.from(widget.correctAnswers['options'] ?? []);
    options.shuffle();
    _shuffledOptions = options;
  }

  void _selectAnswer(String answer) async {
    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
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
      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'Binär & Hexadezimal',
        currentAttempt: _scratchPadController.text.isNotEmpty
            ? 'Meine Rechnung:\n${_scratchPadController.text}'
            : 'Ich bin unsicher wie ich anfangen soll',
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
          topic: 'Binär & Hexadezimal',
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
          // Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'BINÄR · HEX',
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
          const SizedBox(height: 20),

          // Scratch Pad
          _buildScratchPad(surface, border, text, textMid, textDim),
          const SizedBox(height: 20),

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
            _buildHintBox(surface, textMid),
          ],

          // Feedback
          if (_hasAnswered) ...[
            const SizedBox(height: 16),
            _buildFeedback(surface, text, textMid, bg),
          ],

          // Ada Buttons
          const SizedBox(height: 16),
          _buildAdaButtons(textMid, border),
        ],
      ),
    );
  }

  Widget _buildScratchPad(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, size: 14, color: textMid),
                const SizedBox(width: 6),
                Text('SCRATCH PAD', style: AppTextStyles.monoSmall(textMid)),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          TextField(
            controller: _scratchPadController,
            maxLines: 4,
            style: AppTextStyles.mono(
              size: 13,
              color: text,
              weight: FontWeight.w500,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              hintText: 'z.B.  1010 = 1×8 + 0×4 + 1×2 + 0×1 = 10',
              hintStyle: AppTextStyles.mono(
                size: 12,
                color: textDim,
                weight: FontWeight.w400,
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
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
    final isSelected = _selectedAnswer == option;
    final correct = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = option == correct;
    final showResult = _hasAnswered && isSelected;
    final showCorrect = _hasAnswered && !isSelected && isCorrect;

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
        onTap: _hasAnswered ? null : () => _selectAnswer(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
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
                  style: AppTextStyles.mono(
                    size: 14,
                    color: text,
                    weight: isSelected || showCorrect
                        ? FontWeight.w700
                        : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintBox(Color surface, Color textMid) {
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
                size: 14,
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

  Widget _buildFeedback(Color surface, Color text, Color textMid, Color bg) {
    final correct = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = _selectedAnswer == correct;
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
                size: 14,
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
            Text(
              widget.explanation!,
              style: AppTextStyles.mono(
                size: 13,
                color: textMid,
                weight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
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

  Widget _buildAdaButtons(Color textMid, Color border) {
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
