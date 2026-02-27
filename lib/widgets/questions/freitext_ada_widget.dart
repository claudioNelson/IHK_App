import 'package:flutter/material.dart';
import '../../../services/sound_service.dart';
import '../../../services/gemini_service.dart';
import '../../../services/progress_service.dart';
import '../../../screens/learning/ai_tutor_chat_screen.dart';
import 'dart:convert';

class FreitextAdaWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;
  final int? questionId;
  final int? moduleId;

  const FreitextAdaWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
    this.questionId,
    this.moduleId,
  });

  @override
  State<FreitextAdaWidget> createState() => _FreitextAdaWidgetState();
}

class _FreitextAdaWidgetState extends State<FreitextAdaWidget> {
  final _soundService = SoundService();
  final _aiService = GeminiService();
  final _progressService = ProgressService();
  final _answerController = TextEditingController();
  
  bool _isEvaluating = false;
  bool _hasEvaluated = false;
  Map<String, dynamic>? _evaluation;

  @override
  void initState() {
    super.initState();
    _soundService.init();
  }

  @override
  void didUpdateWidget(FreitextAdaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.questionText != widget.questionText) {
      _answerController.clear();
      setState(() {
        _hasEvaluated = false;
        _evaluation = null;
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxLength = widget.correctAnswers['max_length'] as int? ?? 500;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info-Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: Colors.purple.shade700, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Freitext-Aufgabe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ada bewertet deine Antwort',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purple.shade700,
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

            // Antwort-Feld
            TextField(
              controller: _answerController,
              maxLines: 8,
              maxLength: maxLength,
              enabled: !_hasEvaluated,
              decoration: InputDecoration(
                hintText: 'Schreibe deine Antwort hier...\n\nNimm dir Zeit und erkläre es in eigenen Worten.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: _hasEvaluated ? Colors.grey.shade100 : Colors.white,
                counterStyle: TextStyle(color: Colors.grey.shade600),
              ),
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 24),

            // Evaluation Result
            if (_evaluation != null) _buildEvaluationResult(),

            const SizedBox(height: 16),

            // Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationResult() {
    final score = _evaluation!['score'] as int;
    final feedback = _evaluation!['feedback'] as String;
    final isGood = score >= 70;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isGood ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGood ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGood ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isGood ? 'Gut gemacht! 🎉' : 'Noch verbesserbar 💪',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isGood ? Colors.green.shade900 : Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Adas Feedback:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
          if (widget.explanation != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Musterlösung:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.explanation!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Ada Chat Button (immer sichtbar)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openAiChat,
            icon: const Icon(Icons.chat, size: 20),
            label: const Text('Mit Ada besprechen'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Prüfen / Weiter Buttons
        if (!_hasEvaluated)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isEvaluating ? null : _evaluateAnswer,
              icon: _isEvaluating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.psychology),
              label: Text(_isEvaluating ? 'Ada denkt nach...' : 'Von Ada prüfen lassen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          )
        else if (widget.onAnswered != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => widget.onAnswered!(),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Weiter'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _evaluateAnswer() async {
    final answer = _answerController.text.trim();
    
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte schreibe eine Antwort!')),
      );
      return;
    }

    setState(() {
      _isEvaluating = true;
    });

    try {
      final evaluation = await _evaluateWithAda(answer);
      
      setState(() {
        _evaluation = evaluation;
        _hasEvaluated = true;
        _isEvaluating = false;
      });

      final score = evaluation['score'] as int;
      final isCorrect = score >= 70;

      // Sound abspielen
      if (isCorrect) {
        _soundService.playSound(SoundType.correct);
      } else {
        _soundService.playSound(SoundType.wrong);
      }

      // Progress speichern
      if (widget.questionId != null && widget.moduleId != null) {
        await _progressService.saveKernthemaAnswer(
          modulId: widget.moduleId!,
          frageId: widget.questionId!,
          isCorrect: isCorrect,
        );
      }
    } catch (e) {
      setState(() {
        _isEvaluating = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> _evaluateWithAda(String userAnswer) async {
    final criteria = List<String>.from(widget.correctAnswers['bewertungskriterien'] ?? []);
    
    final prompt = '''Du bist Ada, eine geduldige KI-Tutorin für IHK-Prüfungsvorbereitung.

**Aufgabe:** Bewerte die Antwort des Azubis auf diese Freitext-Frage.

**Frage:**
${widget.questionText}

**Antwort des Azubis:**
$userAnswer

**Musterlösung:**
${widget.explanation ?? 'Nicht verfügbar'}

**Bewertungskriterien:**
${criteria.map((c) => '- $c').join('\n')}

**Deine Aufgabe:**
1. Bewerte die Antwort objektiv
2. Gib einen Score von 0-100
3. Gib konstruktives Feedback (max. 150 Wörter)

**Antworte NUR im folgenden JSON-Format (KEIN Markdown, KEINE Backticks):**
{
  "score": 85,
  "feedback": "Dein Feedback hier..."
}''';

    final response = await _aiService.generateContent(prompt);
    
    // Parse JSON response
    try {
      final cleaned = response.trim().replaceAll('```json', '').replaceAll('```', '').trim();
      final parsed = Map<String, dynamic>.from(
        const JsonDecoder().convert(cleaned) as Map,
      );
      
      return {
        'score': parsed['score'] as int,
        'feedback': parsed['feedback'] as String,
      };
    } catch (e) {
      print('❌ JSON Parse Fehler: $e');
      print('Response: $response');
      
      // Fallback
      return {
        'score': 50,
        'feedback': 'Fehler beim Auswerten. Bitte versuche es nochmal oder sprich mit Ada im Chat.',
      };
    }
  }

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiTutorChatScreen(
          currentQuestion: widget.questionText,
          topic: 'IT-Sicherheit',
        ),
      ),
    );
  }
}