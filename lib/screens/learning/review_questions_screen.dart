// lib/screens/learning/review_questions_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/sound_service.dart';
import '../../widgets/calculation_question_widget.dart';
import '../../widgets/fill_in_blank_widget.dart';
import '../../widgets/sequence_question_widget.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../services/question_validator.dart';
import '../../services/usage_tracker.dart';
import '../../widgets/limit_reached_dialog.dart';

class ReviewQuestionsScreen extends StatefulWidget {
  final List<int> frageIds;
  final List<Map<String, dynamic>> dueQuestions;

  const ReviewQuestionsScreen({
    super.key,
    required this.frageIds,
    required this.dueQuestions,
  });

  @override
  State<ReviewQuestionsScreen> createState() => _ReviewQuestionsScreenState();
}

class _ReviewQuestionsScreenState extends State<ReviewQuestionsScreen> {
  final supabase = Supabase.instance.client;
  final _srsService = SpacedRepetitionService();
  final _soundService = SoundService();

  List<dynamic> fragen = [];
  int currentIndex = 0;
  bool loading = true;
  int? selectedAnswer;
  bool hasAnswered = false;
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _loadFragen();
  }

  Future<void> _loadFragen() async {
    // ─── LIMIT-CHECK für Free-User ─────────────────
    final canUse = await UsageTracker().canUse(
      feature: UsageFeature.flashcards,
    );
    if (!canUse && mounted) {
      setState(() => loading = false);
      LimitReachedDialog.show(
        context,
        featureName: 'Wiederholungen',
        limit: UsageTracker.limitFlashcards,
        icon: Icons.refresh_rounded,
        onUpgrade: () {
          // TODO: später zur Pricing-Page
        },
      ).then((_) {
        if (mounted) Navigator.pop(context);
      });
      return;
    }

    try {
      final res = await supabase
          .from('fragen')
          .select(
            'id, frage, question_type, calculation_data, antworten(id, text, ist_richtig, erklaerung)',
          )
          .in_('id', widget.frageIds);
      if (!mounted) return;
      final list = List<dynamic>.from(res);
      for (final frage in list) {
        if (frage['antworten'] != null) {
          final antworten = List<dynamic>.from(frage['antworten']);
          antworten.shuffle();
          frage['antworten'] = antworten;
        }
      }
      setState(() {
        fragen = list;
        loading = false;
      });

      QuestionValidator().validateQuestions(
        questions: list,
        contextName: 'Wiederholung',
        contextType: 'review',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _checkAnswer(int answerId) async {
    if (hasAnswered) return;

    // Counter erhöhen für Free-User
    await UsageTracker().increment(feature: UsageFeature.flashcards);

    setState(() {
      selectedAnswer = answerId;
      hasAnswered = true;
    });
    final frage = fragen[currentIndex];
    final antworten = frage['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
      correctCount++;
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _srsService.recordAnswer(frageId: frage['id'], isCorrect: isCorrect);
  }

  void _handleSpecialAnswer(bool isCorrect, int frageId) async {
    if (hasAnswered) return;

    // Counter erhöhen für Free-User
    await UsageTracker().increment(feature: UsageFeature.flashcards);

    setState(() => hasAnswered = true);
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
      correctCount++;
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _srsService.recordAnswer(frageId: frageId, isCorrect: isCorrect);
  }

  void _nextQuestion() {
    if (currentIndex < fragen.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        hasAnswered = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final percent = ((correctCount / fragen.length) * 100).toInt();
    final passed = percent >= 70;

    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    final accentColor = passed ? AppColors.success : AppColors.warning;
    final statusLabel = passed ? 'GUT GEMACHT' : 'WEITER ÜBEN';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: accentColor),
                  const SizedBox(width: 10),
                  Text(
                    statusLabel,
                    style: AppTextStyles.monoLabel(accentColor),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Score in groß
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$percent',
                    style: AppTextStyles.instrumentSerif(
                      size: 64,
                      color: text,
                      letterSpacing: -2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '%',
                      style: AppTextStyles.instrumentSerif(
                        size: 28,
                        color: textMid,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$correctCount von ${fragen.length} richtig',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Fertig'),
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

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ─────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WIEDERHOLUNG',
                          style: AppTextStyles.monoLabel(textMid),
                        ),
                        if (!loading && fragen.isNotEmpty)
                          Text(
                            'FRAGE ${(currentIndex + 1).toString().padLeft(2, '0')} / ${fragen.length.toString().padLeft(2, '0')}',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                      ],
                    ),
                  ),
                  // Score Tag
                  if (!loading && fragen.isNotEmpty && hasAnswered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        '$correctCount / ${currentIndex + 1}',
                        style: AppTextStyles.mono(
                          size: 10,
                          color: AppColors.success,
                          weight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ─── PROGRESS BAR ───────────────────
          if (!loading && fragen.isNotEmpty)
            LinearProgressIndicator(
              value: (currentIndex + 1) / fragen.length,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.warning),
              minHeight: 2,
            ),

          // ─── CONTENT ────────────────────────
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.warning),
                  )
                : fragen.isEmpty
                ? _buildEmpty(textMid, textDim)
                : _buildQuestionContent(
                    surface,
                    border,
                    text,
                    textMid,
                    textDim,
                    bg,
                  ),
          ),

          // ─── WEITER BUTTON ──────────────────
          if (hasAnswered && !loading && fragen.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _nextQuestion,
                      icon: Icon(
                        currentIndex < fragen.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        size: 18,
                      ),
                      label: Text(
                        currentIndex < fragen.length - 1
                            ? 'Weiter'
                            : 'Abschließen',
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
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Keine Fragen verfügbar', style: AppTextStyles.h3(textMid)),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final frage = fragen[currentIndex];
    final questionType = frage['question_type'] as String?;

    if (questionType == 'fill_blank') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FillInTheBlankWidget(
          key: ValueKey('fillblank_$currentIndex'),
          questionText: frage['frage'] ?? '',
          blankData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: (isCorrect, _) =>
              _handleSpecialAnswer(isCorrect, frage['id']),
        ),
      );
    }

    if (questionType == 'calculation') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: CalculationQuestionWidget(
          key: ValueKey('calc_$currentIndex'),
          questionText: frage['frage'] ?? '',
          calculationData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: (isCorrect, _) =>
              _handleSpecialAnswer(isCorrect, frage['id']),
        ),
      );
    }

    if (questionType == 'sequence') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SequenceQuestionWidget(
          key: ValueKey('sequence_$currentIndex'),
          questionText: frage['frage'] ?? '',
          sequenceData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: (isCorrect, _) =>
              _handleSpecialAnswer(isCorrect, frage['id']),
        ),
      );
    }

    // Multiple Choice
    final antworten = frage['antworten'] as List? ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.warning),
              const SizedBox(width: 10),
              Text(
                'WIEDERHOLUNGSFRAGE',
                style: AppTextStyles.monoLabel(AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Frage
          Text(
            frage['frage'] ?? '',
            style: AppTextStyles.instrumentSerif(
              size: 24,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 28),

          // Antworten
          ...antworten.asMap().entries.map((entry) {
            final i = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
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
              borderColor = AppColors.warning;
              letterColor = Colors.white;
              letterBg = AppColors.warning;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: hasAnswered ? null : () => _checkAnswer(answerId),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  isCorrect
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: letterColor,
                                  size: 16,
                                )
                              : showCorrect
                              ? Icon(
                                  Icons.check_rounded,
                                  color: letterColor,
                                  size: 16,
                                )
                              : Text(
                                  String.fromCharCode(65 + i),
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            antwort['text'] ?? '',
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Erklärung der Antwort
          if (hasAnswered) ...[
            const SizedBox(height: 12),
            _buildExplanation(frage, surface, border, text, textMid),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanation(
    dynamic frage,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    final antworten = frage['antworten'] as List? ?? [];
    final selected = antworten.firstWhere(
      (a) => a['id'] == selectedAnswer,
      orElse: () => null,
    );
    if (selected == null) return const SizedBox.shrink();

    final isCorrect = selected['ist_richtig'] == true;
    final erklaerung = selected['erklaerung'] as String?;
    final accentColor = isCorrect ? AppColors.success : AppColors.warning;

    if (erklaerung == null || erklaerung.trim().isEmpty) {
      return const SizedBox.shrink();
    }

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
          const SizedBox(height: 10),
          Text(erklaerung, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }
}
