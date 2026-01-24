import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationQuestionWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> calculationData;
  final Function(bool isCorrect, String? userAnswer) onAnswerSubmitted;

  const CalculationQuestionWidget({
    super.key,
    required this.questionText,
    required this.calculationData,
    required this.onAnswerSubmitted,
  });

  @override
  State<CalculationQuestionWidget> createState() =>
      _CalculationQuestionWidgetState();
}

class _CalculationQuestionWidgetState
    extends State<CalculationQuestionWidget> {
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController(); // NEU
  bool? _isCorrect;
  bool _hasSubmitted = false;

  double get _correctAnswer =>
      (widget.calculationData['correctAnswer'] as num).toDouble();

  String get _unit => widget.calculationData['unit'] ?? '';

  double get _tolerance =>
      (widget.calculationData['tolerance'] as num?)?.toDouble() ?? 0.0;

  void _checkAnswer() {
    final userInput = _answerController.text.trim();
    final userAnswer = double.tryParse(userInput);

    if (userAnswer == null) {
      setState(() {
        _isCorrect = false;
        _hasSubmitted = true;
      });
      widget.onAnswerSubmitted(false, userInput);
      return;
    }

    final difference = (userAnswer - _correctAnswer).abs();
    final isCorrect = difference <= _tolerance;

    setState(() {
      _isCorrect = isCorrect;
      _hasSubmitted = true;
    });

    widget.onAnswerSubmitted(isCorrect, userInput);
  }

  Color _getBorderColor() {
    if (!_hasSubmitted) return Colors.grey;
    return _isCorrect == true ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frage
        Text(
          widget.questionText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 24),

        // NEU: Notizblock
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Notizen (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Rechenschritte hier notieren...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.amber.shade400, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Eingabefeld
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _answerController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  hintText: 'Deine Antwort',
                  suffixText: _unit.isNotEmpty ? _unit : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _getBorderColor(), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _getBorderColor(), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _getBorderColor(), width: 2),
                  ),
                ),
                enabled: !_hasSubmitted,
                onSubmitted: (_) => _checkAnswer(),
              ),
            ),

            const SizedBox(width: 12),

            // Submit Button
            ElevatedButton(
              onPressed: _hasSubmitted ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('Prüfen'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Feedback
        if (_hasSubmitted) ...[
          _buildFeedback(),
        ],

        // Hint (optional, wenn vorhanden)
        if (widget.calculationData.containsKey('hint') &&
            !_hasSubmitted) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.calculationData['hint'],
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeedback() {
    final isCorrect = _isCorrect == true;
    final color = isCorrect ? Colors.green : Colors.red;
    final icon = isCorrect ? Icons.check_circle : Icons.cancel;
    final text = isCorrect ? 'Richtig!' : 'Leider falsch';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (!isCorrect) ...[
            const SizedBox(height: 12),
            Text(
              'Richtige Antwort: $_correctAnswer $_unit',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          if (widget.calculationData.containsKey('explanation')) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Erklärung:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.calculationData['explanation'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    _notesController.dispose(); // NEU
    super.dispose();
  }
}