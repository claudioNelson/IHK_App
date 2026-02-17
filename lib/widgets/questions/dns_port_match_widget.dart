import 'package:flutter/material.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';
import '../../services/progress_service.dart';

class DnsPortMatchWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;
  final int? questionId; // ← NEU
  final int? moduleId;

  const DnsPortMatchWidget({
    Key? key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId, // ← NEU
    this.moduleId, // ← NEU
  }) : super(key: key);

  @override
  State<DnsPortMatchWidget> createState() => _DnsPortMatchWidgetState();
}

class _DnsPortMatchWidgetState extends State<DnsPortMatchWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();

  String? selectedAnswer;
  bool hasAnswered = false;
  bool _loadingAiHelp = false;
  String? _aiResponse;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _shuffleOptions();
  }

  void _shuffleOptions() {
    final options = List<String>.from(widget.correctAnswers['options'] ?? []);
    options.shuffle();
    _shuffledOptions = options;
  }

  @override
  void didUpdateWidget(DnsPortMatchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.questionText != widget.questionText) {
      setState(() {
        selectedAnswer = null;
        hasAnswered = false;
        _aiResponse = null;
      });
      _shuffleOptions(); // ← NEU
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.correctAnswers['type'] as String?;
    final displayInfo = _getDisplayInfo(type);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info-Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [displayInfo['color'].shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: displayInfo['color'].shade200,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: displayInfo['color'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      displayInfo['icon'],
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayInfo['label'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: displayInfo['color'].shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayInfo['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: displayInfo['color'].shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Frage
            Text(
              widget.questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Antwort-Optionen
            ...(_buildOptions()),

            const SizedBox(height: 24),

            // Feedback (wenn beantwortet)
            if (hasAnswered) _buildFeedback(),

            const SizedBox(height: 16),

            // Ada Buttons
            _buildAdaButtons(),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getDisplayInfo(String? type) {
    if (type == 'port_to_service') {
      return {
        'icon': Icons.router,
        'label': 'Port ${widget.correctAnswers['port']}',
        'subtitle': 'Welcher Dienst?',
        'color': Colors.blue,
      };
    } else {
      return {
        'icon': Icons.dns,
        'label': widget.correctAnswers['record_type'] ?? 'DNS-Record',
        'subtitle': 'Wofür wird er verwendet?',
        'color': Colors.green,
      };
    }
  }

  List<Widget> _buildOptions() {
    final options = _shuffledOptions;
    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isSelected = selectedAnswer == option;
      final correctAnswer = widget.correctAnswers['correct_answer'] as String;
      final isCorrect = option == correctAnswer;

      Color? cardColor;
      if (hasAnswered && isSelected) {
        cardColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
      } else if (isSelected) {
        cardColor = Colors.blue.shade50;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: cardColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: isSelected ? 4 : 1,
          child: InkWell(
            onTap: hasAnswered ? null : () => _selectAnswer(option),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasAnswered && isSelected
                      ? (isCorrect ? Colors.green : Colors.red)
                      : (isSelected ? Colors.blue : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasAnswered && isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : (isSelected ? Colors.blue : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: hasAnswered && isSelected
                          ? Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _selectAnswer(String answer) async {
    // ← async hinzufügen!
    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;
    });

    final correctAnswer = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = answer == correctAnswer;

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    // Progress speichern  ← NEU
    if (widget.questionId != null && widget.moduleId != null) {
      await _progressService.saveKernthemaAnswer(
        modulId: widget.moduleId!,
        frageId: widget.questionId!,
        isCorrect: isCorrect,
      );
    }
  }

  Widget _buildFeedback() {
    final correctAnswer = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = selectedAnswer == correctAnswer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.info,
                color: isCorrect
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Richtig!' : 'Nicht ganz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? Colors.green.shade900
                      : Colors.orange.shade900,
                ),
              ),
            ],
          ),
          if (widget.explanation != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.explanation!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onAnswered != null
                  ? () => widget.onAnswered!()
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: Text(isCorrect ? 'Weiter' : 'Nächste Frage'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? Colors.green : Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loadingAiHelp ? null : _getAiHint,
                icon: _loadingAiHelp
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.tips_and_updates, size: 20),
                label: Text(
                  _loadingAiHelp ? 'Lädt...' : 'Tipp',
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.blue.shade300),
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openAiChat,
                icon: const Icon(Icons.chat, size: 20),
                label: const Text('Ada Chat', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _getAiHint() async {
    setState(() {
      _loadingAiHelp = true;
      _aiResponse = null;
    });

    try {
      final type = widget.correctAnswers['type'] as String;
      final contextInfo = type == 'port_to_service'
          ? 'Port ${widget.correctAnswers['port']}'
          : widget.correctAnswers['record_type'];

      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'DNS & Ports',
        currentAttempt: selectedAnswer != null
            ? 'Meine Antwort: $selectedAnswer'
            : 'Ich bin mir unsicher bei: $contextInfo',
      );

      setState(() {
        _aiResponse = hint;
        _loadingAiHelp = false;
      });

      _showAiDialog();
    } catch (e) {
      setState(() {
        _aiResponse = 'Fehler: $e';
        _loadingAiHelp = false;
      });
      _showAiDialog();
    }
  }

  void _showAiDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Ada - Tipp'),
          ],
        ),
        content: SingleChildScrollView(child: Text(_aiResponse ?? 'Lädt...')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'DNS & Ports',
        ),
      ),
    );
  }
}
