// screens/exam_screens/exam_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../data/exam_data.dart';
import '../../widgets/question_widget_router.dart';
import 'result_screen.dart';

const _blue = Color(0xFF1D4ED8);
const _blueDark = Color(0xFF1E3A8A);
const _blueLight = Color(0xFF3B82F6);

class ExamScreen extends StatefulWidget {
  final String examId;
  const ExamScreen({super.key, required this.examId});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late List<ExamSection> sections;
  late List<Question> allQuestions;
  int currentQuestionIndex = 0;
  Map<String, dynamic> userAnswers = {};
  late Timer _timer;
  int remainingSeconds = 90 * 60;
  bool isTimerRunning = true;
  Set<int> answeredQuestions = {};

  @override
  void initState() {
    super.initState();
    _initializeExam();
    _startTimer();
  }

  void _initializeExam() {
    sections = ExamData.getExamById(widget.examId);
    allQuestions = [];
    for (var section in sections) {
      allQuestions.addAll(section.questions);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0 && isTimerRunning) {
        setState(() => remainingSeconds--);
        if (remainingSeconds == 10 * 60) _showTimeWarning('⏰ 10 Minuten verbleiben!');
        if (remainingSeconds == 5 * 60) _showTimeWarning('⚠️ Nur noch 5 Minuten!');
        if (remainingSeconds == 0) _submitExam();
      }
    });
  }

  void _showTimeWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.white),
        const SizedBox(width: 12),
        Text(message, style: const TextStyle(fontSize: 15)),
      ]),
      backgroundColor: Colors.orange.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (remainingSeconds > 10 * 60) return Colors.green;
    if (remainingSeconds > 5 * 60) return Colors.orange;
    return Colors.red;
  }

  void _onAnswerChanged(dynamic answer) {
    final questionId = allQuestions[currentQuestionIndex].id;
    setState(() {
      userAnswers[questionId] = answer;
      answeredQuestions.add(currentQuestionIndex);
    });
  }

  void _goToQuestion(int index) {
    setState(() => currentQuestionIndex = index);
    Navigator.pop(context);
  }

  void _showQuestionOverview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fragenübersicht',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${answeredQuestions.length} / ${allQuestions.length}',
                        style: const TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: allQuestions.length,
                  itemBuilder: (context, index) {
                    final question = allQuestions[index];
                    final isAnswered = answeredQuestions.contains(index);
                    final isCurrent = index == currentQuestionIndex;

                    return GestureDetector(
                      onTap: () => _goToQuestion(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? _blue.withOpacity(0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isCurrent
                                ? _blue.withOpacity(0.4)
                                : Colors.grey.shade100,
                            width: isCurrent ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isAnswered
                                    ? Colors.green.withOpacity(0.12)
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isAnswered
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: isAnswered
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.green, size: 18)
                                    : Text('${index + 1}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey.shade600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isCurrent
                                            ? FontWeight.bold
                                            : FontWeight.w500),
                                  ),
                                  Text('${question.points} Punkte',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                            if (isCurrent)
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: _blue, size: 14),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitExam() async {
    final shouldSubmit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: Colors.green, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Prüfung abgeben?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Du hast ${answeredQuestions.length} von ${allQuestions.length} Fragen beantwortet.',
              style: const TextStyle(fontSize: 14),
            ),
            if (answeredQuestions.length < allQuestions.length) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${allQuestions.length - answeredQuestions.length} Fragen noch offen!',
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: _blue),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Abgeben'),
          ),
        ],
      ),
    );

    if (shouldSubmit == true && mounted) {
      _timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            sections: sections,
            userAnswers: userAnswers,
            timeSpent: (90 * 60) - remainingSeconds,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = allQuestions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / allQuestions.length;
    final timerColor = _getTimerColor();
    final isLastQuestion =
        currentQuestionIndex >= allQuestions.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_blueDark, _blue, _blueLight],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: _blue.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: const Text('Prüfung beenden?'),
                              content: const Text(
                                  'Dein Fortschritt geht verloren.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx),
                                    child: const Text('Abbrechen')),
                                ElevatedButton(
                                  onPressed: () {
                                    _timer.cancel();
                                    Navigator.pop(ctx);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      elevation: 0),
                                  child: const Text('Beenden'),
                                ),
                              ],
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('IHK Abschlussprüfung',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                        // Timer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: timerColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: timerColor.withOpacity(0.6),
                                width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_rounded,
                                  color: timerColor, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _formatTime(remainingSeconds),
                                style: TextStyle(
                                    color: timerColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Progress
                    Row(
                      children: [
                        Text(
                          'Frage ${currentQuestionIndex + 1} / ${allQuestions.length}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          '${answeredQuestions.length} beantwortet',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── QUESTION ────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  // Übersicht Button
                  GestureDetector(
                    onTap: _showQuestionOverview,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _blue.withOpacity(0.15), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.grid_view_rounded,
                              color: _blue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Fragenübersicht',
                            style: const TextStyle(
                                color: _blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const Spacer(),
                          // Mini progress dots
                          ...List.generate(
                            allQuestions.length.clamp(0, 10),
                            (i) => Container(
                              width: 6,
                              height: 6,
                              margin:
                                  const EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == currentQuestionIndex
                                    ? _blue
                                    : answeredQuestions.contains(i)
                                        ? Colors.green
                                        : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          if (allQuestions.length > 10) ...[
                            const SizedBox(width: 4),
                            Text('…',
                                style: TextStyle(
                                    color: Colors.grey.shade400)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  QuestionWidgetRouter(
                    question: currentQuestion,
                    questionNumber: currentQuestionIndex + 1,
                    totalQuestions: allQuestions.length,
                    onAnswerChanged: _onAnswerChanged,
                    currentAnswer: userAnswers[currentQuestion.id],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── NAVIGATION ──────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(
                          () => currentQuestionIndex--),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: _blue.withOpacity(0.3),
                              width: 1.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios_rounded,
                                color: _blue, size: 16),
                            SizedBox(width: 4),
                            Text('Zurück',
                                style: TextStyle(
                                    color: _blue,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0)
                  const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: isLastQuestion
                        ? _submitExam
                        : () => setState(() => currentQuestionIndex++),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isLastQuestion
                              ? [
                                  Colors.green.shade700,
                                  Colors.green.shade500
                                ]
                              : const [_blueDark, _blueLight],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (isLastQuestion
                                    ? Colors.green
                                    : _blue)
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isLastQuestion
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLastQuestion ? 'Abgeben' : 'Weiter',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}