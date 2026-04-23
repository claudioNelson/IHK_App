// lib/screens/learning/generic_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/dns_port_match_widget.dart';
import '../../widgets/questions/freitext_ada_widget.dart';
import '../../services/flashcard_service.dart';
import '../../services/progress_service.dart';
import '../../services/sound_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class GenericPracticeScreen extends StatefulWidget {
  final int moduleId;
  final String moduleName;

  const GenericPracticeScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<GenericPracticeScreen> createState() => _GenericPracticeScreenState();
}

class _GenericPracticeScreenState extends State<GenericPracticeScreen> {
  final _supabase = Supabase.instance.client;
  final _flashcardService = FlashcardService();
  final _progressService = ProgressService();
  final _soundService = SoundService();

  List<Map<String, dynamic>> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await _supabase
          .from('fragen')
          .select(
            'id, frage, question_type, calculation_data, erklaerung, antworten(id, text, ist_richtig, erklaerung)',
          )
          .eq('modul_id', widget.moduleId)
          .order('id');

      if (!mounted) return;
      final list = List<Map<String, dynamic>>.from(data);
      list.shuffle();
      for (final q in list) {
        if (q['antworten'] != null) {
          final antworten = List<dynamic>.from(q['antworten']);
          antworten.shuffle();
          q['antworten'] = antworten;
        }
      }
      setState(() {
        _questions = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onAnswered(bool isCorrect) async {
    if (!isCorrect) {
      final q = _questions[_currentIndex];
      final type = q['question_type'] as String?;
      String richtigeAntwort = '';
      if (type == 'multiple_choice') {
        final antworten = q['antworten'] as List?;
        final richtige = antworten?.firstWhere(
          (a) => a['ist_richtig'] == true,
          orElse: () => null,
        );
        richtigeAntwort = richtige?['text'] ?? '';
      } else if (type == 'dns_port_match') {
        richtigeAntwort = q['calculation_data']?['correct_answer'] ?? '';
      }
      await _flashcardService.createFromWrongAnswer(
        frageId: q['id'],
        frageText: q['frage'],
        richtigeAntwort: richtigeAntwort,
        modulName: widget.moduleName,
        themaName: null,
      );
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    } else {
      _showDoneDialog();
    }
  }

  void _checkMCAnswer(int answerId) async {
    if (_hasAnswered) return;
    final q = _questions[_currentIndex];
    final antworten = q['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;
    setState(() {
      _selectedAnswer = answerId;
      _hasAnswered = true;
    });
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _progressService.saveKernthemaAnswer(
      modulId: widget.moduleId,
      frageId: q['id'],
      isCorrect: isCorrect,
    );
  }

  void _showDoneDialog() {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

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
                  Container(width: 16, height: 1, color: AppColors.success),
                  const SizedBox(width: 10),
                  Text(
                    'GESCHAFFT',
                    style: AppTextStyles.monoLabel(AppColors.success),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Alle Fragen\ndurchgearbeitet.',
                style: AppTextStyles.instrumentSerif(
                  size: 28,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_questions.length} Fragen aus ${widget.moduleName}.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Zurück zur Übersicht'),
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
                          widget.moduleName,
                          style: AppTextStyles.labelMedium(textMid),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!_loading && _questions.isNotEmpty)
                          Text(
                            'FRAGE ${(_currentIndex + 1).toString().padLeft(2, '0')} / ${_questions.length.toString().padLeft(2, '0')}',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── PROGRESS BAR ───────────────────
          if (!_loading && _questions.isNotEmpty)
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 2,
            ),

          // ─── CONTENT ────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _questions.isEmpty
                ? _buildEmpty(textMid, textDim)
                : _buildQuestionWidget(
                    surface,
                    border,
                    text,
                    textMid,
                    textDim,
                    bg,
                  ),
          ),
        ],
      ),
    );
  }

  // ─── EMPTY ────────────────────────────────
  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Noch keine Fragen verfügbar', style: AppTextStyles.h3(textMid)),
        ],
      ),
    );
  }

  // ─── QUESTION ROUTER ──────────────────────
  Widget _buildQuestionWidget(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_currentIndex];
    final type = q['question_type'] as String?;

    if (type == 'dns_port_match') {
      return DnsPortMatchWidget(
        questionText: q['frage'],
        correctAnswers: Map<String, dynamic>.from(q['calculation_data'] ?? {}),
        explanation: q['erklaerung'],
        onAnswered: _onAnswered,
        questionId: q['id'],
        moduleId: widget.moduleId,
      );
    } else if (type == 'freitext_ada') {
      return FreitextAdaWidget(
        questionText: q['frage'],
        correctAnswers: Map<String, dynamic>.from(q['calculation_data'] ?? {}),
        explanation: q['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: q['id'],
        moduleId: widget.moduleId,
      );
    } else if (type == 'multiple_choice') {
      return _buildMCQuestion(q, surface, border, text, textMid, textDim, bg);
    }

    return Center(
      child: Text(
        'Unbekannter Fragentyp: $type',
        style: AppTextStyles.bodyMedium(textMid),
      ),
    );
  }

  // ─── MULTIPLE CHOICE ──────────────────────
  Widget _buildMCQuestion(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final antworten = q['antworten'] as List? ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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

          // Frage in Serif
          Text(
            q['frage'] ?? '',
            style: AppTextStyles.instrumentSerif(
              size: 24,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 28),

          // Antworten
          ...antworten.asMap().entries.map((entry) {
            final index = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = _selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
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
                onTap: _hasAnswered ? null : () => _checkMCAnswer(answerId),
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

          // Weiter Button
          if (_hasAnswered) ...[
            const SizedBox(height: 12),
            // Erklärung (falls vorhanden)
            _buildExplanation(q, surface, border, text, textMid),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final antworten = q['antworten'] as List;
                  final selected = antworten.firstWhere(
                    (a) => a['id'] == _selectedAnswer,
                  );
                  _onAnswered(selected['ist_richtig'] == true);
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
        ],
      ),
    );
  }

  // ─── EXPLANATION ──────────────────────────
  Widget _buildExplanation(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    // Erklärung der ausgewählten Antwort
    final antworten = q['antworten'] as List? ?? [];
    final selected = antworten.firstWhere(
      (a) => a['id'] == _selectedAnswer,
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
                style: AppTextStyles.mono(
                  size: 10,
                  color: accentColor,
                  weight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
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
