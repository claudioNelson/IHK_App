// lib/screens/zertifikate/certificate_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/flashcard_service.dart';
import '../../services/sound_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../services/question_validator.dart';

class CertificatePracticeScreen extends StatefulWidget {
  final int zertifikatId;
  final String certName;

  const CertificatePracticeScreen({
    super.key,
    required this.zertifikatId,
    required this.certName,
  });

  @override
  State<CertificatePracticeScreen> createState() =>
      _CertificatePracticeScreenState();
}

class _CertificatePracticeScreenState extends State<CertificatePracticeScreen> {
  final _supabase = Supabase.instance.client;
  final _flashcardService = FlashcardService();
  final _soundService = SoundService();

  List<Map<String, dynamic>> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;

  // Vendor Akzentfarbe (subtil — nur als Top-Border)
  Color get _vendorColor {
    final name = widget.certName;
    if (name.contains('AWS') || name.contains('Amazon'))
      return AppColors.warning;
    if (name.contains('Azure') || name.contains('Microsoft'))
      return AppColors.accentCyan;
    if (name.contains('Google')) return AppColors.accent;
    if (name.contains('SAP')) return AppColors.accentCyan;
    return AppColors.accent;
  }

  String get _vendorLabel {
    final name = widget.certName;
    if (name.contains('AWS') || name.contains('Amazon')) return 'AWS';
    if (name.contains('Azure') || name.contains('Microsoft')) return 'AZURE';
    if (name.contains('Google')) return 'GCP';
    if (name.contains('SAP')) return 'SAP';
    return 'ZERTIFIKAT';
  }

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final result = await _supabase
          .from('fragen')
          .select(
            'id, frage, question_type, erklaerung, antworten(id, text, ist_richtig, erklaerung)',
          )
          .eq('zertifikat_id', widget.zertifikatId)
          .eq('question_type', 'multiple_choice');

      if (!mounted) return;

      final list = List<Map<String, dynamic>>.from(result);
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

      QuestionValidator().validateQuestions(
        questions: list,
        contextName: widget.certName,
        contextType: 'zertifikat',
      );
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

  void _checkAnswer(int answerId) async {
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
      // Flashcard erstellen
      final richtige = antworten.firstWhere(
        (a) => a['ist_richtig'] == true,
        orElse: () => null,
      );
      if (richtige != null) {
        await _flashcardService.createFromWrongAnswer(
          frageId: q['id'],
          frageText: q['frage'],
          richtigeAntwort: richtige['text'] ?? '',
          modulName: widget.certName,
          themaName: null,
        );
      }
    }
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

  void _showDoneDialog() {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

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
                '${_questions.length} Fragen aus ${widget.certName}.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentIndex = 0;
                      _selectedAnswer = null;
                      _hasAnswered = false;
                    });
                    _loadQuestions();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Nochmal'),
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
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 14,
                    color: textMid,
                  ),
                  label: Text(
                    'Zurück zur Übersicht',
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
                          widget.certName,
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
                  // Vendor Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _vendorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _vendorColor.withOpacity(0.25)),
                    ),
                    child: Text(
                      _vendorLabel,
                      style: AppTextStyles.mono(
                        size: 9,
                        color: _vendorColor,
                        weight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
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
              valueColor: AlwaysStoppedAnimation(_vendorColor),
              minHeight: 2,
            ),

          // ─── CONTENT ────────────────────────
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: _vendorColor))
                : _questions.isEmpty
                ? _buildEmpty(textMid, textDim)
                : _buildQuestion(surface, border, text, textMid, textDim, bg),
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
          Text('Noch keine Fragen verfügbar', style: AppTextStyles.h3(textMid)),
          const SizedBox(height: 6),
          Text(
            'Schau später nochmal vorbei',
            style: AppTextStyles.bodyMedium(textDim),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_currentIndex];
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
              Container(width: 16, height: 1, color: _vendorColor),
              const SizedBox(width: 10),
              Text('FRAGE', style: AppTextStyles.monoLabel(_vendorColor)),
            ],
          ),
          const SizedBox(height: 14),

          // Frage in Serif
          Text(
            q['frage'] ?? '',
            style: AppTextStyles.instrumentSerif(
              size: 22,
              color: text,
              letterSpacing: -0.6,
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
              borderColor = _vendorColor;
              letterColor = Colors.white;
              letterBg = _vendorColor;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: _hasAnswered ? null : () => _checkAnswer(answerId),
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

          if (_hasAnswered) ...[
            const SizedBox(height: 12),
            _buildExplanation(q, surface, border, text, textMid),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: Icon(
                  _currentIndex < _questions.length - 1
                      ? Icons.arrow_forward_rounded
                      : Icons.check_rounded,
                  size: 18,
                ),
                label: Text(
                  _currentIndex < _questions.length - 1
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
          ],
        ],
      ),
    );
  }

  Widget _buildExplanation(
    Map<String, dynamic> q,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
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
