import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../../models/ihk_exam_model.dart';
import '../../widgets/photo_upload_widget.dart';
import '../../widgets/code_editor_widget.dart';
import '../../services/gemini_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class IHKPruefungExamScreen extends StatefulWidget {
  final IHKExam exam;

  const IHKPruefungExamScreen({super.key, required this.exam});

  @override
  State<IHKPruefungExamScreen> createState() => _IHKPruefungExamScreenState();
}

class _IHKPruefungExamScreenState extends State<IHKPruefungExamScreen> {
  Map<String, String> answers = {};
  Map<String, bool> completed = {};
  bool started = false;
  bool submitted = false;

  late int remainingSeconds;
  Timer? timer;

  final _geminiService = GeminiService();
  String? _kiKorrektur;
  bool _isLoadingKi = false;
  bool _showKiKorrektur = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.exam.duration * 60;
    _loadProgress();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final answersJson = prefs.getString('exam_${widget.exam.id}_answers');
    final completedJson = prefs.getString('exam_${widget.exam.id}_completed');
    final startedStr = prefs.getBool('exam_${widget.exam.id}_started');
    final submittedStr = prefs.getBool('exam_${widget.exam.id}_submitted');

    if (answersJson != null) {
      answers = Map<String, String>.from(json.decode(answersJson));
    }
    if (completedJson != null) {
      completed = Map<String, bool>.from(json.decode(completedJson));
    }

    setState(() {
      started = startedStr ?? false;
      submitted = submittedStr ?? false;
    });

    if (started && !submitted) _startTimer();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'exam_${widget.exam.id}_answers',
      json.encode(answers),
    );
    await prefs.setString(
      'exam_${widget.exam.id}_completed',
      json.encode(completed),
    );
    await prefs.setBool('exam_${widget.exam.id}_started', started);
    await prefs.setBool('exam_${widget.exam.id}_submitted', submitted);
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        t.cancel();
        _submitExam();
      }
    });
  }

  void _handleStart() {
    setState(() => started = true);
    _saveProgress();
    _startTimer();
  }

  void _submitExam() {
    setState(() => submitted = true);
    timer?.cancel();
    _saveProgress();
  }

  void _resetExam() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prüfung zurücksetzen?', style: AppTextStyles.h3(text)),
              const SizedBox(height: 8),
              Text(
                'Alle Antworten werden gelöscht.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMid,
                        side: BorderSide(color: border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Abbrechen'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Zurücksetzen'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('exam_${widget.exam.id}_answers');
      await prefs.remove('exam_${widget.exam.id}_completed');
      await prefs.remove('exam_${widget.exam.id}_started');
      await prefs.remove('exam_${widget.exam.id}_submitted');

      setState(() {
        answers.clear();
        completed.clear();
        started = false;
        submitted = false;
        remainingSeconds = widget.exam.duration * 60;
      });
    }
  }

  int _getCompletedCount() => completed.values.where((v) => v == true).length;

  int _getTotalQuestions() => widget.exam.sections
      .expand((s) => s.questions)
      .where((q) => q.type != QuestionType.info)
      .length;

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    final percent = remainingSeconds / (widget.exam.duration * 60);
    if (percent > 0.3) return AppColors.success;
    if (percent > 0.1) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    if (!started) return _buildIntro();
    if (submitted) return _buildResult();
    return _buildExam();
  }

  // ─── INTRO ───────────────────────────────
  Widget _buildIntro() {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Text(
                    'Prüfungsstart',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 1,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'BEREIT?',
                          style: AppTextStyles.monoLabel(AppColors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Timer startet\nsofort.',
                      style: AppTextStyles.instrumentSerif(
                        size: 42,
                        color: text,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: [
                          _introStat(
                            'DAUER',
                            '${widget.exam.duration} Minuten',
                            text,
                            textDim,
                          ),
                          Divider(height: 20, color: border),
                          _introStat(
                            'AUFGABEN',
                            '${_getTotalQuestions()} Fragen',
                            text,
                            textDim,
                          ),
                          Divider(height: 20, color: border),
                          _introStat(
                            'PUNKTE',
                            '${widget.exam.totalPoints} Punkte',
                            text,
                            textDim,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sobald du startest läuft der Timer. Keine Hilfsmittel erlaubt.',
                              style: AppTextStyles.bodySmall(AppColors.warning),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _handleStart,
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Jetzt starten'),
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
          ],
        ),
      ),
    );
  }

  Widget _introStat(String label, String value, Color text, Color textDim) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.monoSmall(textDim)),
        Text(value, style: AppTextStyles.labelLarge(text)),
      ],
    );
  }

  // ─── EXAM ────────────────────────────────
  Widget _buildExam() {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final progress = _getCompletedCount() / _getTotalQuestions();
    final timerColor = _getTimerColor();

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // AppBar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      widget.exam.title,
                      style: AppTextStyles.labelLarge(text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Submit Button
                  TextButton.icon(
                    onPressed: _submitExam,
                    icon: Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 16,
                    ),
                    label: Text(
                      'Abgeben',
                      style: AppTextStyles.labelMedium(AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Timer + Progress
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
            decoration: BoxDecoration(
              color: surface,
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Timer
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, color: timerColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(remainingSeconds),
                          style: AppTextStyles.mono(
                            size: 16,
                            color: timerColor,
                            weight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    // Progress Count
                    Text(
                      '${_getCompletedCount()} / ${_getTotalQuestions()} erledigt',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: border,
                    valueColor: AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              itemCount: widget.exam.sections.length,
              itemBuilder: (ctx, i) => _buildSection(
                widget.exam.sections[i],
                surface,
                border,
                text,
                textMid,
                textDim,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ExamSection section,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 16, height: 1, color: AppColors.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title.toUpperCase(),
                    style: AppTextStyles.monoLabel(AppColors.accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...section.questions.map(
              (q) => _buildQuestion(q, border, text, textMid, textDim),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(
    ExamQuestion question,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final isCompleted = completed[question.id] ?? false;

    if (question.type == QuestionType.info) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          question.description,
          style: AppTextStyles.bodySmall(textMid),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 2),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 16,
                  ),
                ),
              Expanded(
                child: Text(
                  question.title,
                  style: AppTextStyles.interTight(
                    size: 14,
                    weight: FontWeight.w600,
                    color: isCompleted ? AppColors.success : text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${question.points} Pkt',
                  style: AppTextStyles.mono(
                    size: 10,
                    color: AppColors.accent,
                    weight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(question.description, style: AppTextStyles.bodySmall(textMid)),
          const SizedBox(height: 12),

          // Answer Widget
          if (question.type == QuestionType.diagram)
            PhotoUploadWidget(
              questionId: question.id,
              initialPhotoPath: answers[question.id],
              onPhotoSelected: (path) {
                if (path != null) {
                  answers[question.id] = path;
                } else {
                  answers.remove(question.id);
                }
                _saveProgress();
              },
            )
          else if (question.type == QuestionType.code)
            CodeEditorWidget(
              questionId: question.id,
              initialCode: answers[question.id],
              isSql: question.description.toLowerCase().contains('sql'),
              hintText: 'Code oder SQL eingeben...',
              onCodeChanged: (code) {
                answers[question.id] = code;
                _saveProgress();
              },
            )
          else
            TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Antwort eingeben...',
                hintStyle: AppTextStyles.bodySmall(textMid),
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
                filled: true,
                fillColor: text.withOpacity(0.02),
                contentPadding: const EdgeInsets.all(14),
              ),
              style: AppTextStyles.bodyMedium(text),
              onChanged: (val) {
                answers[question.id] = val;
                _saveProgress();
              },
              controller: TextEditingController(
                text: answers[question.id] ?? '',
              ),
            ),

          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() => completed[question.id] = !isCompleted);
              _saveProgress();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 16,
                  color: isCompleted ? AppColors.success : textMid,
                ),
                const SizedBox(width: 6),
                Text(
                  isCompleted ? 'Erledigt' : 'Als erledigt markieren',
                  style: AppTextStyles.mono(
                    size: 11,
                    color: isCompleted ? AppColors.success : textMid,
                    weight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── RESULT ──────────────────────────────
  Widget _buildResult() {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final completedCount = _getCompletedCount();
    final totalQuestions = _getTotalQuestions();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Text(
                    'Ergebnis',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  // Header
                  Row(
                    children: [
                      Container(width: 16, height: 1, color: AppColors.success),
                      const SizedBox(width: 10),
                      Text(
                        'ABGEGEBEN',
                        style: AppTextStyles.monoLabel(AppColors.success),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Prüfung abgegeben.',
                    style: AppTextStyles.instrumentSerif(
                      size: 34,
                      color: text,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BEARBEITET',
                                style: AppTextStyles.monoSmall(textDim),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$completedCount',
                                      style: AppTextStyles.instrumentSerif(
                                        size: 36,
                                        color: text,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / $totalQuestions',
                                      style: AppTextStyles.bodyMedium(textMid),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 40,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // KI-Korrektur Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isLoadingKi ? null : _requestKiKorrektur,
                      icon: _isLoadingKi
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
                        _isLoadingKi
                            ? 'KI analysiert...'
                            : 'KI-Tutor Korrektur',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: AppTextStyles.labelLarge(Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // KI-Ergebnis
                  if (_showKiKorrektur && _kiKorrektur != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.015, 0.015, 1.0],
                          colors: [
                            AppColors.accent,
                            AppColors.accent,
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
                              Container(
                                width: 16,
                                height: 1,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'KI-TUTOR FEEDBACK',
                                style: AppTextStyles.monoLabel(
                                  AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SelectableText(
                            _kiKorrektur!,
                            style: AppTextStyles.bodyMedium(text),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Zur Übersicht'),
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
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _resetExam,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Prüfung zurücksetzen'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMid,
                        side: BorderSide(color: border),
                        textStyle: AppTextStyles.labelLarge(textMid),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestKiKorrektur() async {
    setState(() => _isLoadingKi = true);
    try {
      final buffer = StringBuffer();
      buffer.writeln(
        'Du bist ein strenger aber fairer IHK-Prüfer für Fachinformatiker.',
      );
      buffer.writeln(
        'Bewerte diese Prüfung und vergib Punkte für jede Antwort.',
      );
      buffer.writeln('');
      buffer.writeln('=== PRÜFUNGSDATEN ===');
      buffer.writeln('Prüfung: ${widget.exam.title}');
      buffer.writeln('Gesamtpunkte: ${widget.exam.totalPoints}');
      buffer.writeln('Szenario: ${widget.exam.scenario}');
      buffer.writeln('');
      buffer.writeln('=== ANTWORTEN ===');
      for (var section in widget.exam.sections) {
        buffer.writeln('--- ${section.title} ---');
        for (var q in section.questions) {
          if (q.type == QuestionType.info) continue;
          buffer.writeln('Aufgabe (${q.points} Pkt): ${q.title}');
          buffer.writeln('Antwort: ${answers[q.id] ?? "NICHT BEANTWORTET"}');
          buffer.writeln('');
        }
      }
      buffer.writeln(
        'Bewerte jede Aufgabe mit Punkten und Feedback. Antworte auf Deutsch.',
      );

      final response = await _geminiService.generateContent(buffer.toString());
      setState(() {
        _kiKorrektur = response;
        _showKiKorrektur = true;
        _isLoadingKi = false;
      });
    } catch (e) {
      setState(() => _isLoadingKi = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
