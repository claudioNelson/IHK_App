import 'package:flutter/material.dart';

class FillInTheBlankWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> blankData;
  final Function(bool isCorrect, Map<String, String>? userAnswers)
  onAnswerSubmitted;

  const FillInTheBlankWidget({
    Key? key,
    required this.questionText,
    required this.blankData,
    required this.onAnswerSubmitted,
  }) : super(key: key);

  @override
  State<FillInTheBlankWidget> createState() => _FillInTheBlankWidgetState();
}

class _FillInTheBlankWidgetState extends State<FillInTheBlankWidget> {
  Map<int, String?> selectedAnswers = {};
  bool _hasSubmitted = false;
  bool? _isCorrect;

  List<Map<String, dynamic>> get _blanks {
    final blanks = widget.blankData['blanks'] as List?;
    if (blanks == null) return [];
    return blanks.map((b) => b as Map<String, dynamic>).toList();
  }

  String get _explanation => widget.blankData['explanation'] ?? '';

  // Alle verfügbaren Optionen aus allen Lücken
  Set<String> get _allOptions {
    final options = <String>{};
    for (var blank in _blanks) {
      final blankOptions = (blank['options'] as List).cast<String>();
      options.addAll(blankOptions);
    }
    return options;
  }

  bool _isOptionSelected(String option) {
    return selectedAnswers.values.contains(option);
  }

  void _selectOption(String option, int blankIndex) {
    if (_hasSubmitted || _isOptionSelected(option)) return;

    setState(() {
      selectedAnswers[blankIndex] = option;
    });
  }

  void _clearBlank(int index) {
    if (_hasSubmitted) return;

    setState(() {
      selectedAnswers[index] = null;
    });
  }

  void _checkAnswer() {
    // Prüfe ob alle Lücken ausgefüllt sind
    if (selectedAnswers.length < _blanks.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte fülle alle Lücken aus!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Prüfe ob alle Antworten korrekt sind
    bool allCorrect = true;
    for (int i = 0; i < _blanks.length; i++) {
      final correctAnswer = _blanks[i]['correctAnswer'];
      final userAnswer = selectedAnswers[i];
      if (userAnswer != correctAnswer) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _hasSubmitted = true;
    });

    // Callback mit Ergebnis
    final userAnswersMap = selectedAnswers.map(
      (key, value) => MapEntry(key.toString(), value ?? ''),
    );
    widget.onAnswerSubmitted(allCorrect, userAnswersMap);
  }

  Color _getBlankColor(int index) {
    if (!_hasSubmitted) return Colors.white;
    final isCorrect = selectedAnswers[index] == _blanks[index]['correctAnswer'];
    return isCorrect ? Colors.green.shade50 : Colors.red.shade50;
  }

  Color _getBlankBorderColor(int index) {
    if (!_hasSubmitted) {
      return selectedAnswers[index] != null
          ? Colors.indigo.shade300
          : Colors.grey.shade300;
    }
    final isCorrect = selectedAnswers[index] == _blanks[index]['correctAnswer'];
    return isCorrect ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frage mit Lücken-Nummern
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade50, Colors.white],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.shade200, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.indigo.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.text_fields,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Fülle die Lücken aus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextWithBlanks(),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Lücken zum Befüllen
        ...List.generate(_blanks.length, (index) {
          final answer = selectedAnswers[index];
          final isEmpty = answer == null;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lücke ${index + 1}:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEmpty || _hasSubmitted
                        ? null
                        : () => _clearBlank(index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getBlankColor(index),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getBlankBorderColor(index),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isEmpty ? '__________' : answer,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isEmpty
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                                color: isEmpty
                                    ? Colors.grey.shade400
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (!isEmpty && !_hasSubmitted)
                            Icon(
                              Icons.close,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          if (_hasSubmitted && !isEmpty)
                            Icon(
                              selectedAnswers[index] ==
                                      _blanks[index]['correctAnswer']
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  selectedAnswers[index] ==
                                      _blanks[index]['correctAnswer']
                                  ? Colors.green
                                  : Colors.red,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_hasSubmitted &&
                    selectedAnswers[index] !=
                        _blanks[index]['correctAnswer']) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.green.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Richtig: ${_blanks[index]['correctAnswer']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade900,
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
          );
        }),

        const SizedBox(height: 24),

        // Auswahl-Bereich
        if (!_hasSubmitted) ...[
          Text(
            'Wähle aus:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allOptions.map((option) {
              final isSelected = _isOptionSelected(option);

              // Finde die nächste leere Lücke
              int? nextBlankIndex;
              if (!isSelected) {
                for (int i = 0; i < _blanks.length; i++) {
                  if (selectedAnswers[i] == null) {
                    nextBlankIndex = i;
                    break;
                  }
                }
              }

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isSelected || nextBlankIndex == null
                      ? null
                      : () => _selectOption(option, nextBlankIndex!),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade200
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.grey.shade400
                            : Colors.indigo.shade300,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.grey.shade500
                            : Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Submit Button
        if (!_hasSubmitted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Prüfen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

        // Feedback
        if (_hasSubmitted) ...[const SizedBox(height: 16), _buildFeedback()],
      ],
    );
  }

  Widget _buildTextWithBlanks() {
    final text = widget.questionText;
    final parts = text.split('_____');

    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      // Text vor der Lücke
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(parts[i], style: const TextStyle(fontSize: 16, height: 1.5)),
        );
      }

      // Lücken-Nummer (außer nach dem letzten Teil)
      if (i < parts.length - 1) {
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.indigo.shade300, width: 2),
            ),
            child: Text(
              '(${i + 1})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
            ),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }

  Widget _buildFeedback() {
    final isCorrect = _isCorrect == true;
    final color = isCorrect ? Colors.green : Colors.orange;
    final icon = isCorrect ? Icons.check_circle : Icons.info;
    final text = isCorrect ? 'Richtig!' : 'Nicht ganz richtig';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (_explanation.isNotEmpty) ...[
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
              _explanation,
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
}
