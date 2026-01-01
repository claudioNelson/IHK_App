// screens/exam_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/question_model.dart';       // ✅ 2x hoch
import '../../data/exam_data.dart';              // ✅ 2x hoch
import '../../widgets/question_widget_router.dart';  // ✅ 2x hoch
import 'result_screen.dart';

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
  
  // Timer
  late Timer _timer;
  int remainingSeconds = 90 * 60; // 90 Minuten
  bool isTimerRunning = true;
  
  // Fortschritt
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
        setState(() {
          remainingSeconds--;
        });
        
        // Warnung bei 10 Minuten
        if (remainingSeconds == 10 * 60) {
          _showTimeWarning('10 Minuten verbleiben!');
        }
        
        // Warnung bei 5 Minuten
        if (remainingSeconds == 5 * 60) {
          _showTimeWarning('Nur noch 5 Minuten!');
        }
        
        // Zeit abgelaufen
        if (remainingSeconds == 0) {
          _submitExam();
        }
      }
    });
  }
  
  void _showTimeWarning(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.orange[700],
        duration: const Duration(seconds: 5),
      ),
    );
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
  
  void _goToNextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }
  
  void _goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }
  
  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
    Navigator.pop(context); // Schließe Übersicht
  }
  
  void _showQuestionOverview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fragenübersicht',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${answeredQuestions.length} / ${allQuestions.length} beantwortet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: allQuestions.length,
                itemBuilder: (context, index) {
                  final question = allQuestions[index];
                  final isAnswered = answeredQuestions.contains(index);
                  final isCurrent = index == currentQuestionIndex;
                  
                  return Card(
                    elevation: isCurrent ? 4 : 1,
                    color: isCurrent ? Colors.blue[50] : null,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isAnswered 
                            ? Colors.green[100] 
                            : Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAnswered 
                              ? Colors.green 
                              : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isAnswered
                            ? const Icon(Icons.check, color: Colors.green, size: 20)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),
                      title: Text(
                        question.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text('${question.points} Punkte'),
                      trailing: isCurrent 
                        ? Icon(Icons.arrow_forward, color: Colors.blue[700])
                        : null,
                      onTap: () => _goToQuestion(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _submitExam() async {
    final shouldSubmit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Prüfung abgeben?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sie haben ${answeredQuestions.length} von ${allQuestions.length} Fragen beantwortet.',
              style: const TextStyle(fontSize: 15),
            ),
            if (answeredQuestions.length < allQuestions.length) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${allQuestions.length - answeredQuestions.length} Fragen sind noch nicht beantwortet!',
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w500,
                        ),
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
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
            ),
            child: const Text('Prüfung abgeben'),
          ),
        ],
      ),
    );
    
    if (shouldSubmit == true && mounted) {
      _timer.cancel();
      
      // Navigiere zum Ergebnis-Screen
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
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 2,
        title: const Text(
          'IHK Abschlussprüfung',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getTimerColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getTimerColor(), width: 2),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: _getTimerColor(), size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatTime(remainingSeconds),
                  style: TextStyle(
                    color: _getTimerColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Fortschrittsanzeige
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Frage ${currentQuestionIndex + 1} von ${allQuestions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showQuestionOverview,
                      icon: const Icon(Icons.list, size: 20),
                      label: const Text('Übersicht'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          
          // Frage
          Expanded(
            child: SingleChildScrollView(
              child: QuestionWidgetRouter(
                question: currentQuestion,
                questionNumber: currentQuestionIndex + 1,
                totalQuestions: allQuestions.length,
                onAnswerChanged: _onAnswerChanged,
                currentAnswer: userAnswers[currentQuestion.id],
              ),
            ),
          ),
          
          // Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _goToPreviousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Zurück'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: currentQuestionIndex < allQuestions.length - 1
                      ? _goToNextQuestion
                      : _submitExam,
                    icon: Icon(
                      currentQuestionIndex < allQuestions.length - 1
                        ? Icons.arrow_forward
                        : Icons.check_circle,
                    ),
                    label: Text(
                      currentQuestionIndex < allQuestions.length - 1
                        ? 'Weiter'
                        : 'Prüfung abgeben',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentQuestionIndex < allQuestions.length - 1
                        ? Colors.blue[700]
                        : Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
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