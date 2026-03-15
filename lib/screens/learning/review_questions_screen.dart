// lib/screens/learning/review_questions_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/sound_service.dart';
import '../../widgets/calculation_question_widget.dart';
import '../../widgets/fill_in_blank_widget.dart';
import '../../widgets/sequence_question_widget.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);
const _orange = Color(0xFFEA580C);

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
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  Future<void> _loadFragen() async {
    try {
      final res = await supabase
          .from('fragen')
          .select(
              'id, frage, question_type, calculation_data, antworten(id, text, ist_richtig, erklaerung)')
          .in_('id', widget.frageIds);
      if (!mounted) return;
      setState(() {
        fragen = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
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
    await _srsService.recordAnswer(frageId: frage['id'], isCorrect: isCorrect);
  }

  void _handleSpecialAnswer(bool isCorrect, int frageId) async {
    if (hasAnswered) return;
    setState(() => hasAnswered = true);
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
      correctCount++;
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _srsService.recordAnswer(frageId: frageId, isCorrect: isCorrect);
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
    final passed = percent >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (passed ? Colors.green : _orange).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  passed ? '🎉' : '💪',
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                passed ? 'Super gemacht!' : 'Weiter üben!',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: passed ? Colors.green : _orange,
                ),
              ),
              Text(
                '$correctCount von ${fragen.length} richtig',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Fertig',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC2410C), _orange, Color(0xFFFB923C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.replay_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Wiederholung',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${fragen.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    if (!loading && fragen.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (currentIndex + 1) / fragen.length,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 7,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: _orange))
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildQuestionContent(),
                  ),
          ),

          // Weiter Button
          if (hasAnswered)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: Icon(
                      currentIndex < fragen.length - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.check_circle_rounded,
                      size: 20,
                    ),
                    label: Text(
                      currentIndex < fragen.length - 1
                          ? 'Weiter'
                          : 'Abschließen',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    final frage = fragen[currentIndex];
    final questionType = frage['question_type'] as String?;

    if (questionType == 'fill_blank') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
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
    final antworten = frage['antworten'] as List;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frage Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _orange.withOpacity(0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: _orange.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.replay_rounded,
                          color: _orange, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text('Wiederholungsfrage',
                        style: TextStyle(
                            color: _orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  frage['frage'] ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Antworten
          ...antworten.asMap().entries.map((entry) {
            final i = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
            final showResult = hasAnswered && isSelected;
            final showCorrect = hasAnswered && isCorrect && !isSelected;

            Color borderColor = Colors.grey.shade200;
            Color bgColor = Colors.white;
            if (showResult) {
              borderColor = isCorrect ? Colors.green : Colors.red;
              bgColor = isCorrect
                  ? Colors.green.withOpacity(0.05)
                  : Colors.red.withOpacity(0.05);
            } else if (showCorrect) {
              borderColor = Colors.green.withOpacity(0.5);
              bgColor = Colors.green.withOpacity(0.03);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: hasAnswered ? null : () => _checkAnswer(answerId),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: showResult
                                ? (isCorrect ? Colors.green : Colors.red)
                                : showCorrect
                                    ? Colors.green.withOpacity(0.2)
                                    : _orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: showResult
                                ? Icon(
                                    isCorrect ? Icons.check : Icons.close,
                                    color: Colors.white,
                                    size: 18)
                                : Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      color: showCorrect
                                          ? Colors.green
                                          : _orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(antwort['text'] ?? '',
                              style: const TextStyle(
                                  fontSize: 15, height: 1.4)),
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
}