import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../../models/ihk_exam_model.dart';
import '../../widgets/photo_upload_widget.dart';
import '../../widgets/code_editor_widget.dart';

class IHKPruefungExamScreen extends StatefulWidget {
  final IHKExam exam;

  const IHKPruefungExamScreen({super.key, required this.exam});

  @override
  State<IHKPruefungExamScreen> createState() => _IHKPruefungExamScreenState();
}

class _IHKPruefungExamScreenState extends State<IHKPruefungExamScreen> {
  Map<String, String> answers = {}; // questionId -> answer (text or photo path)
  Map<String, bool> completed = {}; // questionId -> completed
  bool started = false;
  bool submitted = false;

  // Timer
  late int remainingSeconds;
  Timer? timer;

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

    if (started && !submitted) {
      _startTimer();
    }
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Prüfung zurücksetzen?'),
        content: const Text('Alle Antworten werden gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Zurücksetzen'),
          ),
        ],
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

  int _getCompletedCount() {
    return completed.values.where((v) => v == true).length;
  }

  int _getTotalQuestions() {
    return widget.exam.sections
        .expand((s) => s.questions)
        .where((q) => q.type != QuestionType.info)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      return _buildIntro();
    }

    if (submitted) {
      return _buildResult();
    }

    return _buildExam();
  }

  Widget _buildIntro() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prüfungsstart'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.timer, size: 64, color: Colors.blue.shade700),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bereit?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Die Prüfung dauert ${widget.exam.duration} Minuten.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Jetzt starten'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExam() {
    final progress = _getCompletedCount() / _getTotalQuestions();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _submitExam,
            icon: const Icon(Icons.check_circle),
            tooltip: 'Abgeben',
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer & Progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTimerColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getTimerColor()),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: _getTimerColor(), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(remainingSeconds),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getTimerColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_getCompletedCount()} / ${_getTotalQuestions()} erledigt',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(Colors.green.shade600),
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.exam.sections.length,
              itemBuilder: (ctx, i) => _buildSection(widget.exam.sections[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(ExamSection section) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...section.questions.map((q) => _buildQuestion(q)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(ExamQuestion question) {
    final isCompleted = completed[question.id] ?? false;

    if (question.type == QuestionType.info) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            question.description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              if (isCompleted) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.green.shade700 : Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${question.points} Pkt',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.description,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),

          // ANTWORT-WIDGET basierend auf Fragetyp
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (val) {
                answers[question.id] = val;
                _saveProgress();
              },
              controller: TextEditingController(
                text: answers[question.id] ?? '',
              ),
            ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  completed[question.id] = !isCompleted;
                });
                _saveProgress();
              },
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
              ),
              label: Text(isCompleted ? 'Erledigt' : 'Als erledigt markieren'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final completedCount = _getCompletedCount();
    final totalQuestions = _getTotalQuestions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergebnis'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Prüfung abgegeben!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '$completedCount / $totalQuestions',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Text('Aufgaben bearbeitet'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('Zur Übersicht'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetExam,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Prüfung zurücksetzen'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    final percent = remainingSeconds / (widget.exam.duration * 60);
    if (percent > 0.3) return Colors.green;
    if (percent > 0.1) return Colors.orange;
    return Colors.red;
  }
}
