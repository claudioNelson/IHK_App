import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/sound_service.dart';
import '../../../services/gemini_service.dart';
import '../../../services/progress_service.dart';
import '../../../screens/learning/ai_tutor_chat_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'dart:convert';

class FreitextAdaWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final void Function(bool)? onAnswered;
  final int? questionId;
  final int? moduleId;

  const FreitextAdaWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<FreitextAdaWidget> createState() => _FreitextAdaWidgetState();
}

class _FreitextAdaWidgetState extends State<FreitextAdaWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  final _answerController = TextEditingController();

  bool _isEvaluating = false;
  bool _hasEvaluated = false;
  Map<String, dynamic>? _evaluation;

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

  @override
  void didUpdateWidget(FreitextAdaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      _answerController.clear();
      setState(() {
        _hasEvaluated = false;
        _evaluation = null;
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _evaluateAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bitte schreibe eine Antwort'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isEvaluating = true);

    try {
      final evaluation = await _evaluateWithAda(answer);
      setState(() {
        _evaluation = evaluation;
        _hasEvaluated = true;
        _isEvaluating = false;
      });

      final score = evaluation['score'] as int;
      final isCorrect = score >= 70;

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
    } catch (e) {
      setState(() => _isEvaluating = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _evaluateWithAda(String userAnswer) async {
    final criteria = List<String>.from(
      widget.correctAnswers['bewertungskriterien'] ?? [],
    );

    final prompt =
        '''Du bist Ada, eine geduldige KI-Tutorin für IHK-Prüfungsvorbereitung.

**Aufgabe:** Bewerte die Antwort des Azubis auf diese Freitext-Frage.

**Frage:**
${widget.questionText}

**Antwort des Azubis:**
$userAnswer

**Musterlösung:**
${widget.explanation ?? 'Nicht verfügbar'}

**Bewertungskriterien:**
${criteria.map((c) => '- $c').join('\n')}

**Deine Aufgabe:**
1. Bewerte die Antwort objektiv
2. Gib einen Score von 0-100
3. Gib konstruktives Feedback (max. 150 Wörter)

**Antworte NUR im folgenden JSON-Format (KEIN Markdown, KEINE Backticks):**
{
  "score": 85,
  "feedback": "Dein Feedback hier..."
}''';

    final response = await _aiService.generateContent(prompt);

    try {
      final cleaned = response
          .trim()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final parsed = Map<String, dynamic>.from(
        const JsonDecoder().convert(cleaned) as Map,
      );
      return {
        'score': parsed['score'] as int,
        'feedback': parsed['feedback'] as String,
      };
    } catch (e) {
      return {
        'score': 50,
        'feedback':
            'Fehler beim Auswerten. Bitte versuche es nochmal oder sprich mit Ada im Chat.',
      };
    }
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'Freitext',
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

    final maxLength = widget.correctAnswers['max_length'] as int? ?? 500;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'FREITEXT · ADA BEWERTET',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
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
          const SizedBox(height: 24),

          // Antwort-Feld
          Text('DEINE ANTWORT', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          TextField(
            controller: _answerController,
            maxLines: 8,
            maxLength: maxLength,
            enabled: !_hasEvaluated,
            style: AppTextStyles.bodyMedium(text),
            decoration: InputDecoration(
              hintText: 'Schreibe deine Antwort in eigenen Worten...',
              hintStyle: AppTextStyles.bodyMedium(textDim),
              filled: true,
              fillColor: _hasEvaluated ? bg : surface,
              counterStyle: AppTextStyles.monoSmall(textDim),
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
                borderSide: BorderSide(color: AppColors.accent),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 20),

          // Evaluation
          if (_evaluation != null) ...[
            _buildEvaluation(surface, border, text, textMid),
            const SizedBox(height: 16),
          ],

          // Action Buttons
          if (!_hasEvaluated) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isEvaluating ? null : _evaluateAnswer,
                icon: _isEvaluating
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: bg,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(
                  _isEvaluating ? 'Ada denkt nach...' : 'Von Ada prüfen lassen',
                ),
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
                onPressed: _openAiChat,
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: textMid,
                ),
                label: Text(
                  'Mit Ada besprechen',
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
          ] else if (widget.onAnswered != null)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final score = _evaluation!['score'] as int;
                  widget.onAnswered!(score >= 70);
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
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

  Widget _buildEvaluation(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    final score = _evaluation!['score'] as int;
    final feedback = _evaluation!['feedback'] as String;
    final isGood = score >= 70;
    final accentColor = isGood ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(18),
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
              Container(width: 16, height: 1, color: accentColor),
              const SizedBox(width: 10),
              Text(
                isGood ? 'GUT GEMACHT' : 'VERBESSERBAR',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.instrumentSerif(
                  size: 48,
                  color: text,
                  letterSpacing: -1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(' / 100', style: AppTextStyles.bodyMedium(textMid)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'ADAS FEEDBACK',
            style: AppTextStyles.monoSmall(AppColors.accent),
          ),
          const SizedBox(height: 6),
          Text(feedback, style: AppTextStyles.bodyMedium(text)),
          if (widget.explanation != null) ...[
            const SizedBox(height: 14),
            Text('MUSTERLÖSUNG', style: AppTextStyles.monoSmall(textMid)),
            const SizedBox(height: 6),
            Text(widget.explanation!, style: AppTextStyles.bodySmall(textMid)),
          ],
        ],
      ),
    );
  }
}
