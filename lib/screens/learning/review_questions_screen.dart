import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/sound_service.dart';
import '../../widgets/calculation_question_widget.dart';
import '../../widgets/fill_in_blank_widget.dart';
import '../../widgets/sequence_question_widget.dart';

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

class _ReviewQuestionsScreenState extends State<ReviewQuestionsScreen>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  final _srsService = SpacedRepetitionService();
  final _soundService = SoundService();

  List<dynamic> fragen = [];
  int currentIndex = 0;
  bool loading = true;
  int? selectedAnswer;
  bool hasAnswered = false;
  int correctCount = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _setupAnimations();
    _loadFragen();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  Future<void> _loadFragen() async {
    try {
      final res = await supabase
          .from('fragen')
          .select(
            'id, frage, question_type, calculation_data, antworten(id, text, ist_richtig, erklaerung)',
          )
          .in_('id', widget.frageIds);

      if (!mounted) return;

      setState(() {
        fragen = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  void _checkAnswer(int answerId) async {
    if (hasAnswered) return;

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

    // Spaced Repetition aktualisieren
    await _srsService.recordAnswer(frageId: frage['id'], isCorrect: isCorrect);
  }

  void _nextQuestion() async {
    if (currentIndex < fragen.length - 1) {
      await _fadeController.reverse();
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        hasAnswered = false;
      });
      await _fadeController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final percent = ((correctCount / fragen.length) * 100).toInt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.celebration, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Wiederholung abgeschlossen!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            Text('$correctCount von ${fragen.length} richtig'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Dialog
              Navigator.pop(context); // Screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wiederholung ${currentIndex + 1}/${fragen.length}'),
        backgroundColor: Colors.orange,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: _buildQuestionContent(),
            ),
      bottomNavigationBar: hasAnswered
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    currentIndex < fragen.length - 1 ? 'Weiter' : 'Abschließen',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildQuestionContent() {
  final frage = fragen[currentIndex];
  final questionType = frage['question_type'] as String?;

  // ⭐ NEU: Spezielle Fragetypen
  if (questionType == 'fill_blank') {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: FillInTheBlankWidget(
        key: ValueKey('fillblank_$currentIndex'),
        questionText: frage['frage'] ?? '',
        blankData: frage['calculation_data'] ?? {},
        onAnswerSubmitted: (isCorrect, userAnswers) {
          _handleSpecialAnswer(isCorrect, frage['id']);
        },
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
        onAnswerSubmitted: (isCorrect, userAnswer) {
          _handleSpecialAnswer(isCorrect, frage['id']);
        },
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
        onAnswerSubmitted: (isCorrect, userOrder) {
          _handleSpecialAnswer(isCorrect, frage['id']);
        },
      ),
    );
  }

  // Standard Multiple Choice
  final antworten = frage['antworten'] as List;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Frage
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            frage['frage'] ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 24),

        // Antworten
        ...antworten.asMap().entries.map((entry) {
          final index = entry.key;
          final antwort = entry.value;
          final answerId = antwort['id'] as int;
          final isSelected = selectedAnswer == answerId;
          final isCorrect = antwort['ist_richtig'] == true;
          final showResult = hasAnswered && isSelected;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: showResult
                  ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: hasAnswered ? null : () => _checkAnswer(answerId),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: showResult
                          ? (isCorrect ? Colors.green : Colors.red)
                          : (isSelected ? Colors.orange : Colors.grey.shade300),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: showResult
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isSelected ? Colors.orange : Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: showResult
                              ? Icon(
                                  isCorrect ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          antwort['text'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );
}

  // ⭐ NEU: Handler für spezielle Fragetypen
  void _handleSpecialAnswer(bool isCorrect, int frageId) async {
    if (hasAnswered) return;

    setState(() {
      hasAnswered = true;
    });

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
      correctCount++;
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    // Spaced Repetition
    await _srsService.recordAnswer(
      frageId: frageId,
      isCorrect: isCorrect,
    );
  }
}