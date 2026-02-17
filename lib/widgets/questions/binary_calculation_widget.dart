import 'package:flutter/material.dart';
import '../../services/sound_service.dart';
import '../../services/gemini_service.dart';
import '../../services/progress_service.dart';
import '../../screens/learning/ai_tutor_chat_screen.dart';

class BinaryCalculationWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;
  final int? questionId;
  final int? moduleId;

  const BinaryCalculationWidget({
    Key? key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  }) : super(key: key);

  @override
  State<BinaryCalculationWidget> createState() =>
      _BinaryCalculationWidgetState();
}

class _BinaryCalculationWidgetState extends State<BinaryCalculationWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  final _scratchPadController = TextEditingController();

  String? _selectedAnswer;
  bool _hasAnswered = false;
  bool _loadingAiHelp = false;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _shuffleOptions();
  }

  @override
  void didUpdateWidget(BinaryCalculationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionText != widget.questionText) {
      _scratchPadController.clear();
      setState(() {
        _selectedAnswer = null;
        _hasAnswered = false;
      });
      _shuffleOptions();
    }
  }

  @override
  void dispose() {
    _scratchPadController.dispose();
    super.dispose();
  }

  void _shuffleOptions() {
    final options = List<String>.from(widget.correctAnswers['options'] ?? []);
    options.shuffle();
    _shuffledOptions = options;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200, width: 2),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: Colors.orange.shade700,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Binär & Hexadezimal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                        Text(
                          'Nutze das Scratch Pad zum Rechnen!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade700,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Scratch Pad
            _buildScratchPad(),

            const SizedBox(height: 24),

            // Antwort Optionen
            ..._buildOptions(),

            const SizedBox(height: 16),

            // Feedback
            if (_hasAnswered) _buildFeedback(),

            const SizedBox(height: 16),

            // Ada Buttons
            _buildAdaButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchPad() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.edit_note, size: 20, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Scratch Pad - Rechne hier!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          TextField(
            controller: _scratchPadController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'z.B.\n1010 = 1×8 + 0×4 + 1×2 + 0×1\n     = 8 + 2 = 10',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions() {
    final correctAnswer = widget.correctAnswers['correct_answer'] as String;

    return _shuffledOptions.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isSelected = _selectedAnswer == option;
      final isCorrect = option == correctAnswer;

      Color? cardColor;
      if (_hasAnswered && isSelected) {
        cardColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
      } else if (isSelected) {
        cardColor = Colors.orange.shade50;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: cardColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: isSelected ? 4 : 1,
          child: InkWell(
            onTap: _hasAnswered ? null : () => _selectAnswer(option),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasAnswered && isSelected
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
                      shape: BoxShape.circle,
                      color: _hasAnswered && isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : (isSelected ? Colors.orange : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: _hasAnswered && isSelected
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
                        fontFamily: 'monospace',
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
    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
    });

    final correctAnswer = widget.correctAnswers['correct_answer'] as String;
    final isCorrect = answer == correctAnswer;

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

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
    final isCorrect = _selectedAnswer == correctAnswer;

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
                isCorrect ? 'Richtig! 🎉' : 'Nicht ganz!',
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
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.5,
                fontFamily: 'monospace',
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
    return Row(
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
              side: BorderSide(color: Colors.orange.shade300),
              foregroundColor: Colors.orange.shade700,
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
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getAiHint() async {
    setState(() => _loadingAiHelp = true);

    try {
      final hint = await _aiService.getHint(
        question: widget.questionText,
        topic: 'Binär & Hexadezimal',
        currentAttempt: _scratchPadController.text.isNotEmpty
            ? 'Meine Rechnung:\n${_scratchPadController.text}'
            : 'Ich bin unsicher wie ich anfangen soll',
      );

      setState(() => _loadingAiHelp = false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.psychology, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text('Ada - Tipp'),
            ],
          ),
          content: SingleChildScrollView(child: Text(hint)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Verstanden'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _loadingAiHelp = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'Binär & Hexadezimal',
        ),
      ),
    );
  }
}
