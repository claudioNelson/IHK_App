import 'package:flutter/material.dart';

class SequenceQuestionWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> sequenceData;
  final Function(bool isCorrect, List<String>? userOrder) onAnswerSubmitted;

  const SequenceQuestionWidget({
    super.key,
    required this.questionText,
    required this.sequenceData,
    required this.onAnswerSubmitted,
  });

  @override
  State<SequenceQuestionWidget> createState() => _SequenceQuestionWidgetState();
}

class _SequenceQuestionWidgetState extends State<SequenceQuestionWidget> {
  List<String?> selectedSlots = [];
  bool _hasSubmitted = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    final items = (widget.sequenceData['items'] as List).cast<String>();
    selectedSlots = List<String?>.filled(items.length, null);
  }

  List<String> get _availableItems =>
      (widget.sequenceData['items'] as List).cast<String>();

  List<String> get _correctOrder =>
      (widget.sequenceData['correctOrder'] as List).cast<String>();

  String get _explanation => widget.sequenceData['explanation'] ?? '';

  bool _isItemSelected(String item) {
    return selectedSlots.contains(item);
  }

  void _selectItem(String item) {
    if (_hasSubmitted || _isItemSelected(item)) return;

    setState(() {
      // Finde ersten leeren Slot
      final emptyIndex = selectedSlots.indexOf(null);
      if (emptyIndex != -1) {
        selectedSlots[emptyIndex] = item;
      }
    });
  }

  void _clearSlot(int index) {
    if (_hasSubmitted) return;

    setState(() {
      selectedSlots[index] = null;
    });
  }

  void _checkAnswer() {
    // Prüfe ob alle Slots gefüllt sind
    if (selectedSlots.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte fülle alle Felder aus!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Prüfe Reihenfolge
    bool isCorrect = true;
    for (int i = 0; i < selectedSlots.length; i++) {
      if (selectedSlots[i] != _correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = isCorrect;
      _hasSubmitted = true;
    });

    widget.onAnswerSubmitted(
      isCorrect,
      selectedSlots.whereType<String>().toList(),
    );
  }

  Color _getSlotColor(int index) {
    if (!_hasSubmitted) return Colors.white;
    return selectedSlots[index] == _correctOrder[index]
        ? Colors.green.shade50
        : Colors.red.shade50;
  }

  Color _getSlotBorderColor(int index) {
    if (!_hasSubmitted) {
      return selectedSlots[index] != null
          ? Colors.indigo.shade300
          : Colors.grey.shade300;
    }
    return selectedSlots[index] == _correctOrder[index]
        ? Colors.green
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frage
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
                      Icons.format_list_numbered,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Bringe in die richtige Reihenfolge',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.questionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Slots zum Befüllen
        ...List.generate(selectedSlots.length, (index) {
          final item = selectedSlots[index];
          final isEmpty = item == null;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Positions-Nummer
                Container(
                  width: 40,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Slot
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isEmpty || _hasSubmitted
                          ? null
                          : () => _clearSlot(index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getSlotColor(index),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getSlotBorderColor(index),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isEmpty ? '__________' : item,
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
                                selectedSlots[index] == _correctOrder[index]
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    selectedSlots[index] == _correctOrder[index]
                                    ? Colors.green
                                    : Colors.red,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 32),

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
            children: _availableItems.map((item) {
              final isSelected = _isItemSelected(item);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isSelected ? null : () => _selectItem(item),
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
                      item,
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
          if (!isCorrect) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Richtige Reihenfolge:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(_correctOrder.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _correctOrder[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
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
